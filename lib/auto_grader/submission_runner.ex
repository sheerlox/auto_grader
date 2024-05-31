defmodule AutoGrader.SubmissionRunner do
  use GenServer, restart: :temporary

  require Logger

  def start_link(args, opts \\ []) do
    GenServer.start_link(__MODULE__, args, opts)
  end

  @impl true
  def init(args) do
    # start processing submissions after initialization
    GenServer.cast(self(), :run)

    parent = Keyword.get(args, :parent)
    submission_path = Keyword.get(args, :submission_path)
    results = %{}
    refs = %{}
    {:ok, {results, refs, parent, submission_path}}
  end

  @impl true
  def handle_cast(:run, {_, _, _, submission_path} = state) do
    Logger.info("Processing submission \"#{submission_path}\"")

    test_units = Application.get_env(:auto_grader, :test_units)

    state =
      Enum.reduce(
        test_units,
        state,
        fn test_unit, {results, refs, parent, submission_path} ->
          %{ref: ref} =
            Task.Supervisor.async_nolink(
              AutoGrader.TestUnitRunnerSupervisor,
              fn -> test_unit.run(submission_path) end
            )

          results = Map.put(results, test_unit, nil)
          refs = Map.put(refs, ref, test_unit)

          {results, refs, parent, submission_path}
        end
      )

    {:noreply, state}
  end

  @impl true
  def handle_info({ref, answer}, {results, refs, parent, submission_path}) do
    Process.demonitor(ref, [:flush])

    {test_unit, refs} = Map.pop(refs, ref)
    results = Map.put(results, test_unit, answer)

    maybe_handle_completion({results, refs, parent, submission_path})
  end

  @impl true
  def handle_info(
        {:DOWN, ref, :process, _pid, {error, _}},
        {results, refs, parent, submission_path}
      ) do
    {test_unit, refs} = Map.pop(refs, ref)
    results = Map.put(results, test_unit, {:error, error})

    maybe_handle_completion({results, refs, parent, submission_path})
  end

  defp maybe_handle_completion({results, refs, parent, _} = state)
       when map_size(refs) == 0 do
    send(parent, {self(), results})
    {:stop, :normal, state}
  end

  defp maybe_handle_completion(state) do
    {:noreply, state}
  end
end
