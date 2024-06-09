defmodule AutoGrader.SetupUnit do
  @doc "Runs the setup unit"
  @callback run(submission_path :: binary(), context :: map()) ::
              {:ok, map()} | {:error, term()}

  @doc "The timeout (ms) after which to kill the setup unit"
  @callback timeout() :: integer()
end
