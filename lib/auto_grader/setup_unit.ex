defmodule AutoGrader.SetupUnit do
  @moduledoc """
  A behavior for defining setup units.

  ## Submission setup unit

  Setup units run sequentially in each submissions before running test units.

  As their name suggest, they are used to run setup actions before running the
  test suites, like installing dependencies.

  They receive and return a `context` map, which will be passed to every test
  unit, so they can also be used to load/generate data that a lot of tests are
  going to use, like parsing the Git log history.

  Because setup units run sequentially, they receive the `context` map returned
  by the previous setup unit.

  If a setup unit fails, the whole submission will fail.

  ## Init setup unit

  An `init_setup_unit` can also be provided in the config. This setup unit will
  be run only once on startup, before starting to process submissions.

  The `context` map it returns is then passed down to the first regular setup
  unit, or directly to the test units if no regular setup units are defined.
  """

  @doc "Runs the setup unit"
  @callback run(submission_path :: binary(), context :: map()) ::
              {:ok, map()} | {:error, term()}

  @doc """
  The timeout (ms) after which to kill the setup unit if it hasn't completed
  """
  @callback timeout() :: integer()
end
