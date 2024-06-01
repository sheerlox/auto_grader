defmodule AutoGrader do
  use GenServer, restart: :temporary

  require Logger

  @impl true
  def init(_args) do
    # start processing submissions after initialization
    GenServer.cast(self(), :run)

    queue = []
    pids = %{}
    results = %{}
    {:ok, {queue, pids, results}}
  end

  def start_link(_args, _opts \\ []) do
    GenServer.start_link(__MODULE__, name: __MODULE__)
  end

  @impl true
  def handle_cast(:run, {_, pids, results}) do
    init_module = Application.get_env(:auto_grader, :init_module)
    :ok = init_module.run(nil)

    submissions_path = Application.get_env(:auto_grader, :submissions_path)

    queue =
      File.ls!(submissions_path)
      |> Enum.map(&Path.join(submissions_path, &1))
      |> Enum.filter(&File.dir?(&1))

    GenServer.cast(self(), :process_batch)

    {:noreply, {queue, pids, results}}
  end

  @impl true
  def handle_cast(:process_batch, {queue, pids, results}) do
    {batch, queue} =
      case Application.get_env(:auto_grader, :batch_size, :infinity) do
        n when n in [:infinity, 0, -1] ->
          Logger.info("[MAIN] Processing all #{length(queue)} submissions")
          {queue, []}

        batch_size ->
          remaining = min(batch_size, length(queue))
          Logger.info("[MAIN] Processing batch of #{remaining} submissions")

          Enum.split(queue, batch_size)
      end

    pids =
      Enum.reduce(
        batch,
        pids,
        fn submission_path, pids ->
          {:ok, pid} =
            DynamicSupervisor.start_child(
              AutoGrader.SubmissionRunnerSupervisor,
              {
                AutoGrader.SubmissionRunner,
                [parent: self(), submission_path: submission_path]
              }
            )

          ref = Process.monitor(pid)

          Map.put(pids, pid, {submission_path, ref})
        end
      )

    {:noreply, {queue, pids, results}}
  end

  @impl true
  def handle_info({ref, answer}, {queue, pids, results}) do
    {{submission_path, ref}, pids} = Map.pop(pids, ref)
    results = Map.put(results, submission_path, answer)

    Process.demonitor(ref, [:flush])

    maybe_handle_completion({queue, pids, results})
  end

  defp maybe_handle_completion({queue, pids, results} = state)
       when length(queue) == 0 and map_size(pids) == 0 do
    Logger.info("""
    ================= RESULTS ==================

    #{inspect(results, pretty: true, limit: :infinity)}
    """)

    # stop the whole application once we displayed the results
    # :init.stop()

    {:stop, :normal, state}
  end

  defp maybe_handle_completion({_, pids, _} = state)
       when map_size(pids) == 0 do
    GenServer.cast(self(), :process_batch)

    {:noreply, state}
  end

  defp maybe_handle_completion(state) do
    {:noreply, state}
  end
end
