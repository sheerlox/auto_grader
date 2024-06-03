defmodule TestSuites.PortfolioManager.Tests.Java.CheckGetEmptyPortfolioValueTest do
  @behaviour AutoGrader.TestUnit

  import TestSuites.PortfolioManager.Utils

  def run(submission_path) do
    content =
      load_test_file_content(submission_path)
      |> get_test_function_content("test[gG]etEmptyPortfolioValue")

    checks = [
      Regex.match?(
        ~r/when\(stockStorage\.listSymbols\(.+?\.thenReturn\(/,
        content
      ),
      String.contains?(content, "stockPortfolio.getTotalPortfolioValue"),
      String.contains?(content, "assertEquals")
    ]

    get_checks_score(checks)
  end
end
