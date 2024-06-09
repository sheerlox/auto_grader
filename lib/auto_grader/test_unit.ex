defmodule AutoGrader.TestUnit do
  @doc """
  Runs the test unit.

  Returns a {score, max_score} tuple.
  """
  @callback run(submission_path :: binary(), context :: map()) ::
              {number(), number()}

  @doc """
  The coefficient to apply to this test unit.
  """
  @callback coefficient() :: number()

  def coefficient, do: 1

  @doc """
  Whether or not this test unit is a bonus one.
  """
  @callback bonus?() :: boolean()

  def bonus?, do: false

  @optional_callbacks coefficient: 0, bonus?: 0
end
