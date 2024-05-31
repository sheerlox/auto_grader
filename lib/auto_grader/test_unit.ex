defmodule AutoGrader.TestUnit do
  @doc "Runs the test unit"
  @callback run(submission_path :: binary()) :: :pass | :fail
end
