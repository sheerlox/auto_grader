defmodule AutoGrader.SubmissionRunner do
  use GenServer, restart: :temporary

  require Logger

  def start_link(args, opts \\ []) do
    GenServer.start_link(__MODULE__, args, opts)
  end

  @impl true
  def init(args) do
    # automatically start processing submissions after initialization
    GenServer.cast(self(), :run)

    results = %{}
    refs = %{}
    parent = Keyword.get(args, :parent)
    submission_path = Keyword.get(args, :submission_path)
    context = Keyword.get(args, :context)
    {:ok, {results, refs, parent, submission_path, context}}
  end

  @impl true
  def handle_cast(:run, {_, refs, parent, submission_path, context} = state) do
    Logger.info("Processing submission \"#{submission_path}\"")

    case setup(submission_path, context) do
      {:ok, context} ->
        test_units = Application.get_env(:auto_grader, :test_units)

        state =
          Enum.reduce(
            test_units,
            state,
            fn test_unit, {results, refs, parent, submission_path, _} ->
              %{ref: ref} =
                Task.Supervisor.async_nolink(
                  AutoGrader.TestUnitSupervisor,
                  fn -> test_unit.run(submission_path, context) end
                )

              results = Map.put(results, test_unit, nil)
              refs = Map.put(refs, ref, test_unit)

              {results, refs, parent, submission_path, context}
            end
          )

        {:noreply, state}

      {:error, setup_unit, error} ->
        maybe_handle_completion({
          {:error, setup_unit, error},
          refs,
          parent,
          submission_path,
          context
        })
    end
  end

  @impl true
  def handle_info(
        {ref, answer},
        {results, refs, parent, submission_path, context}
      ) do
    Process.demonitor(ref, [:flush])

    {test_unit, refs} = Map.pop(refs, ref)
    results = Map.put(results, test_unit, answer)

    maybe_handle_completion({results, refs, parent, submission_path, context})
  end

  @impl true
  def handle_info(
        {:DOWN, ref, :process, _pid, error},
        {results, refs, parent, submission_path, context}
      ) do
    error =
      case error do
        {{:nocatch, error}, _} -> error
        {error, _} -> error
        error -> error
      end

    {test_unit, refs} = Map.pop(refs, ref)
    results = Map.put(results, test_unit, {:error, error})

    maybe_handle_completion({results, refs, parent, submission_path, context})
  end

  @spec setup(binary(), map()) ::
          {:ok, map()}
          | {:error, :atom, term()}
          | {:error, :atom, :timeout}
  defp setup(submission_path, context) do
    setup_units = Application.get_env(:auto_grader, :setup_units)

    Enum.reduce_while(
      setup_units,
      {:ok, context},
      fn setup_unit, {:ok, context} ->
        task =
          Task.Supervisor.async_nolink(
            AutoGrader.SetupUnitSupervisor,
            fn -> setup_unit.run(submission_path, context) end
          )

        case Task.yield(task, setup_unit.timeout()) || Task.shutdown(task) do
          {:ok, {:ok, context}} -> {:cont, {:ok, context}}
          {:ok, {:error, error}} -> {:halt, {:error, setup_unit, error}}
          {:exit, {error, _}} -> {:halt, {:error, setup_unit, error}}
          nil -> {:halt, {:error, setup_unit, :timeout}}
        end
      end
    )
  end

  defp maybe_handle_completion({results, refs, parent, _, _} = state)
       when map_size(refs) == 0 do
    score = calculate_score(results)

    send(parent, {self(), score})

    {:stop, :normal, state}
  end

  defp maybe_handle_completion(state) do
    {:noreply, state}
  end

  defp calculate_score(results) do
    {total_score, total_coefficient} =
      Enum.reduce(results, {0, 0}, fn {test_unit, result},
                                      {total_score, total_coefficient} ->
        coefficient =
          case function_exported?(test_unit, :coefficient, 0) do
            true -> test_unit.coefficient()
            false -> AutoGrader.TestUnit.coefficient()
          end

        bonus? =
          case function_exported?(test_unit, :bonus?, 0) do
            true -> test_unit.bonus?()
            false -> AutoGrader.TestUnit.bonus?()
          end

        score =
          case result do
            {:error, _} -> 0
            {score, max_score} -> score / max_score * coefficient
          end

        coefficient = if bonus?, do: 0, else: coefficient

        {total_score + score, total_coefficient + coefficient}
      end)

    Float.round(
      total_score / total_coefficient *
        Application.get_env(:auto_grader, :max_score),
      2
    )
  end
end
