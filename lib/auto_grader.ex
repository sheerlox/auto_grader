defmodule AutoGrader do
  use GenServer

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
    students = ["student_a", "student_b", "student_c"]

    state =
      Enum.reduce(
        students,
        {%{}, %{}},
        fn student_id, {results, pids} ->
          {:ok, pid} =
            DynamicSupervisor.start_child(
              AutoGrader.SubmissionRunnerSupervisor,
              {AutoGrader.SubmissionRunner, parent: self()}
            )

          ref = Process.monitor(pid)

          results = Map.put(results, student_id, nil)
          pids = Map.put(pids, pid, {student_id, ref})

          Logger.info("Processing submission for student \"#{student_id}\"")
          {results, pids}
        end
      )

    {:noreply, state}
  end

  @impl true
  def handle_info({ref, answer}, {results, pids}) do
    {{student_id, ref}, pids} = Map.pop(pids, ref)
    results = Map.put(results, student_id, answer)

    Process.demonitor(ref, [:flush])

    maybe_handle_completion({results, pids})
  end

  defp maybe_handle_completion({results, pids} = state) when map_size(pids) == 0 do
    Logger.info(
      "================= RESULTS ==================\n\n#{inspect(results, pretty: true, limit: :infinity)}"
    )

    # Logger.info(inspect(results, pretty: true, limit: :infinity))

    # stop the whole application once we displayed the results
    :init.stop()

    {:stop, :normal, state}
  end

  defp maybe_handle_completion(state) do
    {:noreply, state}
  end
end
