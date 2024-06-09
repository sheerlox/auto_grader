defmodule TestSuites.PortfolioManager.Tests.Java.CheckGetTotalPortfolioValueTest do
  @moduledoc false

  @behaviour AutoGrader.TestUnit

  import TestSuites.PortfolioManager.Utils

  @impl true
  def run(submission_path, _context) do
    content =
      load_test_file_content(submission_path)
      |> get_test_function_content("test[gG]etTotalPortfolioValue")

    checks = [
      Regex.match?(
        ~r/when\(stockStorage\.listSymbols\(.+?\.thenReturn\(/,
        content
      ),
      Regex.scan(
        ~r/when\(stockStorage\.get\(.+?\.thenReturn\(/,
        content
      )
      |> length == 2,
      Regex.scan(
        ~r/when\(stockAPI\.getStockPrice\(.+?\.thenReturn\(/,
        content
      )
      |> length == 2,
      String.contains?(content, "stockPortfolio.getTotalPortfolioValue"),
      String.contains?(content, "assertEquals")
    ]

    get_checks_score(checks)
  end
end
