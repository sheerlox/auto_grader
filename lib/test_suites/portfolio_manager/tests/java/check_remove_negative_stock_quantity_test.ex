defmodule TestSuites.PortfolioManager.Tests.Java.CheckRemoveNegativeStockQuantityTest do
  @behaviour AutoGrader.TestUnit

  import TestSuites.PortfolioManager.Utils

  def run(submission_path) do
    content =
      load_test_file_content(submission_path)
      |> get_test_function_content("testRemoveNegativeStockQuantity")

    checks = [
      Regex.match?(
        ~r/assertThrows\(IllegalArgumentException\.class,.+?stockPortfolio\.removeStockQuantity\(/,
        content
      ),
      Regex.match?(
        ~r/verify\(stockStorage, (?:never\(\)|0)\)\.put\(/,
        content
      )
    ]

    get_checks_score(checks)
  end
end