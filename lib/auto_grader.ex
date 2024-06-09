defmodule AutoGrader do
  @moduledoc """
  An automatic and concurrent assignments grading program.

  ## Lifecycle

  1. INIT - `AutoGrader`:
    - runs the potential init `AutoGrader.SetupUnit`
    - list submissions from specified directory
    - starts one supervised `AutoGrader.SubmissionRunner` per submission

  2. PROCESSING - `AutoGrader.SubmissionRunner` (for each submission)
    - runs the `AutoGrader.SetupUnit`s sequentially (in supervised tasks)
    - runs all `AutoGrader.TestUnit`s concurrently (in supervised tasks)
    - handles `AutoGrader.TestUnit`s completion messages as they arrive
    - waits for all processes to complete, crash or time out
    - calculates the submission's score
    - sends back the final score and detailed results to `AutoGrader`

  3. COMPLETING - `AutoGrader`
    - waits for all `AutoGrader.SubmissionRunner` processes to complete
    - displays final score and detailed results for all submissions
  """

  use GenServer, restart: :temporary

  require Logger

  def start_link(_args, _opts \\ []) do
    GenServer.start_link(__MODULE__, name: __MODULE__)
  end

  @impl true
  def init(_args) do
    # automatically start processing submissions after initialization
    GenServer.cast(self(), :run)

    queue = []
    pids = %{}
    results = %{}
    context = %{}
    {:ok, {queue, pids, results, context}}
  end

  @impl true
  def handle_cast(:run, {_, pids, results, context}) do
    init_setup_unit = Application.get_env(:auto_grader, :init_setup_unit)

    context =
      case init_setup_unit do
        nil ->
          %{}

        _ ->
          {:ok, context} = init_setup_unit.run(nil, context)
          context
      end

    submissions_path = Application.get_env(:auto_grader, :submissions_path)

    queue =
      File.ls!(submissions_path)
      |> Enum.map(&Path.join(submissions_path, &1))
      |> Enum.filter(&File.dir?(&1))

    GenServer.cast(self(), :process_batch)

    {:noreply, {queue, pids, results, context}}
  end

  @impl true
  def handle_cast(:process_batch, {queue, pids, results, context}) do
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
                [
                  parent: self(),
                  submission_path: submission_path,
                  context: context
                ]
              }
            )

          ref = Process.monitor(pid)

          Map.put(pids, pid, {submission_path, ref})
        end
      )

    {:noreply, {queue, pids, results, context}}
  end

  @impl true
  def handle_info({ref, answer}, {queue, pids, results, context}) do
    {{submission_path, ref}, pids} = Map.pop(pids, ref)
    results = Map.put(results, submission_path, answer)

    Process.demonitor(ref, [:flush])

    maybe_handle_completion({queue, pids, results, context})
  end

  defp maybe_handle_completion({queue, pids, results, _} = state)
       when length(queue) == 0 and map_size(pids) == 0 do
    Logger.info("""
    ================= RESULTS ==================

    Number of submissions processed: #{map_size(results)}

    #{inspect(results, pretty: true, limit: :infinity)}
    """)

    # stop the whole application once we displayed the results
    :init.stop()

    {:stop, :normal, state}
  end

  defp maybe_handle_completion({_, pids, _, _} = state)
       when map_size(pids) == 0 do
    GenServer.cast(self(), :process_batch)

    {:noreply, state}
  end

  defp maybe_handle_completion(state) do
    {:noreply, state}
  end
end
