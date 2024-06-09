defmodule TestSuites.PortfolioManager.Tests.Example do
  @moduledoc false

  @behaviour AutoGrader.TestUnit

  @impl true
  def run(_submission_path, _context) do
    sleep_time = :rand.uniform(5) * 1000
    Process.sleep(sleep_time)

    fail? = sleep_time >= 4000
    error? = :rand.uniform(10) >= 8

    cond do
      fail? and error? -> raise("An error occured in the test unit")
      fail? -> {0, 1}
      true -> {1, 1}
    end
  end
end
