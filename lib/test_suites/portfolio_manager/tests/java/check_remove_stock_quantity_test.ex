defmodule TestSuites.PortfolioManager.Tests.Java.CheckRemoveStockQuantityTest do
  @behaviour AutoGrader.TestUnit

  import TestSuites.PortfolioManager.Utils

  def run(submission_path) do
    content =
      load_test_file_content(submission_path)
      |> get_test_function_content("testRemoveStockQuantity")

    checks = [
      Regex.match?(~r/when\(stockStorage.get\(.+?\.thenReturn\(/, content),
      String.contains?(content, "stockPortfolio.removeStockQuantity"),
      Regex.match?(~r/verify\(stockStorage.+?\.get/, content),
      Regex.match?(~r/verify\(stockStorage.+?\.put/, content)
    ]

    get_checks_score(checks)
  end
end