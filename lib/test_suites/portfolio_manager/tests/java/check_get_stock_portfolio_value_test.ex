defmodule TestSuites.PortfolioManager.Tests.Java.CheckGetStockPortfolioValueTest do
  @behaviour AutoGrader.TestUnit

  import TestSuites.PortfolioManager.Utils

  @impl true
  def run(submission_path, _context) do
    content =
      load_test_file_content(submission_path)
      |> get_test_function_content("test[gG]etStockPortfolioValue")

    checks = [
      Regex.match?(
        ~r/when\(stockAPI\.getStockPrice\(.+?\.thenReturn\(/,
        content
      ),
      Regex.match?(~r/when\(stockStorage.get\(.+?\.thenReturn\(/, content),
      String.contains?(content, "stockPortfolio.getStockPortfolioValue"),
      String.contains?(content, "assertEquals")
    ]

    get_checks_score(checks)
  end
end
