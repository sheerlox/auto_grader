defmodule TestSuites.PortfolioManager.Setup.Java.InstallDependencies do
  @moduledoc false

  @behaviour AutoGrader.SetupUnit

  @impl true
  def run(submission_path, context) do
    {result, status} =
      System.cmd("mvn", ["dependency:resolve"], cd: submission_path)

    case status do
      0 -> {:ok, context}
      _ -> {:error, result}
    end
  end

  @impl true
  def timeout(), do: 300_000
end
