defmodule TestSuites.PortfolioManager.Tests.Example do
  @behaviour AutoGrader.TestUnit

  def run(_submission_path) do
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
