defmodule AutoGrader.SetupUnits.Java.InstallDependencies do
  @behaviour AutoGrader.SetupUnit

  @impl true
  def run(submission_path) do
    {result, status} =
      System.cmd("mvn", ["dependency:resolve"], cd: submission_path)

    case status do
      0 -> :ok
      _ -> {:error, result}
    end
  end

  @impl true
  def timeout(), do: 60000
end
