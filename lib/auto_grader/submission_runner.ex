defmodule AutoGrader.SubmissionRunner do
  use GenServer, restart: :temporary

  def start_link(args, opts \\ []) do
    GenServer.start_link(__MODULE__, args, opts)
  end

  @impl true
  def init(args) do
    # start processing submissions after initialization
    GenServer.cast(self(), :run)

    parent = Keyword.get(args, :parent)
    results = %{}
    refs = %{}
    {:ok, {results, refs, parent}}
  end

  @impl true
  def handle_cast(:run, state) do
    tasks = 1..10//1

    state =
      Enum.reduce(
        tasks,
        state,
        fn task_id, {results, refs, parent} ->
          %{ref: ref} =
            Task.Supervisor.async_nolink(
              AutoGrader.TestUnitRunnerSupervisor,
              fn -> AutoGrader.TestUnit.run(task_id) end
            )

          results = Map.put(results, task_id, nil)
          refs = Map.put(refs, ref, task_id)

          {results, refs, parent}
        end
      )

    {:noreply, state}
  end

  @impl true
  def handle_info({ref, answer}, {results, refs, parent}) do
    Process.demonitor(ref, [:flush])

    {task_id, refs} = Map.pop(refs, ref)
    results = Map.put(results, task_id, answer)

    maybe_handle_completion({results, refs, parent})
  end

  @impl true
  def handle_info({:DOWN, ref, :process, _pid, {error, _}}, {results, refs, parent}) do
    {task_id, refs} = Map.pop(refs, ref)
    results = Map.put(results, task_id, {:error, error})

    maybe_handle_completion({results, refs, parent})
  end

  defp maybe_handle_completion({results, refs, parent} = state) when map_size(refs) == 0 do
    send(parent, {self(), results})
    {:stop, :normal, state}
  end

  defp maybe_handle_completion(state) do
    {:noreply, state}
  end
end
