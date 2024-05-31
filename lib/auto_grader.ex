defmodule AutoGrader do
  use GenServer, restart: :temporary

  require Logger

  @impl true
  def init(_args) do
    # start processing submissions after initialization
    GenServer.cast(self(), :run)

    results = %{}
    pids = %{}
    {:ok, {results, pids}}
  end

  def start_link(_args, _opts \\ []) do
    GenServer.start_link(__MODULE__, name: __MODULE__)
  end

  @impl true
  def handle_cast(:run, _state) do
    submissions_path = Application.get_env(:auto_grader, :submissions_path)

    submissions =
      File.ls!(submissions_path)
      |> Enum.map(&Path.join(submissions_path, &1))
      |> Enum.filter(&File.dir?(&1))

    state =
      Enum.reduce(
        submissions,
        {%{}, %{}},
        fn submission_path, {results, pids} ->
          {:ok, pid} =
            DynamicSupervisor.start_child(
              AutoGrader.SubmissionRunnerSupervisor,
              {
                AutoGrader.SubmissionRunner,
                [parent: self(), submission_path: submission_path]
              }
            )

          ref = Process.monitor(pid)

          results = Map.put(results, submission_path, nil)
          pids = Map.put(pids, pid, {submission_path, ref})

          {results, pids}
        end
      )

    {:noreply, state}
  end

  @impl true
  def handle_info({ref, answer}, {results, pids}) do
    {{submission_path, ref}, pids} = Map.pop(pids, ref)
    results = Map.put(results, submission_path, answer)

    Process.demonitor(ref, [:flush])

    maybe_handle_completion({results, pids})
  end

  defp maybe_handle_completion({results, pids} = state)
       when map_size(pids) == 0 do
    Logger.info("""
    ================= RESULTS ==================

    #{inspect(results, pretty: true, limit: :infinity)}
    """)

    # stop the whole application once we displayed the results
    # :init.stop()

    {:stop, :normal, state}
  end

  defp maybe_handle_completion(state) do
    {:noreply, state}
  end
end
