defmodule TestSuites.PortfolioManager.Tests.Java.CheckGetTotalPortfolioValueWithZeroQuantityStocksTest do
  @behaviour AutoGrader.TestUnit

  import TestSuites.PortfolioManager.Utils

  def bonus?, do: true

  def run(submission_path) do
    content =
      load_test_file_content(submission_path)
      |> get_test_function_content(
        "test[gG]etTotalPortfolioValueWithZeroQuantityStocks"
      )

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
      String.contains?(content, "assertEquals(0.0")
    ]

    get_checks_score(checks)
  end
end
