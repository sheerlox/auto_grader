defmodule AutoGrader.TestUnit do
  @moduledoc """
  A behavior for defining test units.

  The `run/2` callback is called to run the test unit, and must return a
  `{score, max_score}` tuple.

  The potential context generated from setup units will be passed as a second
  argument.

  A `coefficient/0` callback *can* be defined to modify the coefficient of the
  test unit (defaults to `1`).

  A `bonus?/0` callback *can* be defined to treat the test unit as a bonus
  exercice (defaults to `false`).
  """

  @optional_callbacks coefficient: 0, bonus?: 0

  @doc """
  Runs the test unit.

  Returns a `{score, max_score}` tuple.
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
end
