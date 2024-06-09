defmodule TestSuites.PortfolioManager.Setup.Init do
  @moduledoc false

  @behaviour AutoGrader.SetupUnit

  require Logger

  @impl true
  def run(_, context) do
    Logger.info("[INIT] Checking required executables are present ...")

    if :os.find_executable(~c"java") == false,
      do: raise("Java executable (\"java\") not found in path")

    if :os.find_executable(~c"mvn") == false,
      do: raise("Maven executable (\"mvn\") not found in path")

    # Install Maven dependencies from first project, without this Maven would
    # download the same dependencies in parallel for every project.

    submissions_path = Application.get_env(:auto_grader, :submissions_path)

    first_submission_path =
      File.ls!(submissions_path)
      |> Enum.map(&Path.join(submissions_path, &1))
      |> Enum.filter(&File.dir?(&1))
      |> List.first()

    Logger.info("[INIT] Installing Maven dependencies ...")

    {result, status} =
      System.cmd("mvn", ["dependency:resolve"], cd: first_submission_path)

    case status do
      0 ->
        Logger.info("[INIT] Done.")
        {:ok, context}

      _ ->
        Logger.error(result)
        {:error, result}
    end
  end

  @impl true
  def timeout(), do: -1
end
