defmodule AutoGrader.TestUnit do
  @doc """
  Runs the test unit.

  Returns a {score, max_score} tuple.
  """
  @callback run(submission_path :: binary()) :: {integer(), integer()}
end
