defmodule TestSuites.PortfolioManager.Setup.Java.CheckRequirements do
  @behaviour AutoGrader.SetupUnit

  @impl true
  def run(submission_path, context) do
    case File.stat(Path.join([submission_path, "pom.xml"]), time: :posix) do
      {:ok, _} -> {:ok, context}
      {:error, _} -> {:error, "missing pom.xml file"}
    end
  end

  @impl true
  def timeout(), do: 1000
end
