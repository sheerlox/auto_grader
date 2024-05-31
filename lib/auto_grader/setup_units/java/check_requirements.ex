defmodule AutoGrader.SetupUnits.Java.CheckRequirements do
  @behaviour AutoGrader.SetupUnit

  @impl true
  def run(submission_path) do
    case File.stat(Path.join([submission_path, "pom.xml"]), time: :posix) do
      {:ok, _} -> :ok
      {:error, _} -> {:error, "missing pom.xml file"}
    end
  end

  @impl true
  def timeout(), do: 1000
end
