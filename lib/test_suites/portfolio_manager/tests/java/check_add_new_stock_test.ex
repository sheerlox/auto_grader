defmodule TestSuites.PortfolioManager.Tests.Java.CheckAddNewStockTest do
  @behaviour AutoGrader.TestUnit

  import TestSuites.PortfolioManager.Utils

  def run(submission_path) do
    content =
      load_test_file_content(submission_path)
      |> get_test_function_content("testAddNewStock")

    checks = [
      String.contains?(content, "stockPortfolio.addStockQuantity"),
      Regex.match?(~r/verify\(stockStorage.+?\.put/, content)
    ]

    get_checks_score(checks)
  end
end
