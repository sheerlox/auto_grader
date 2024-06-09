defmodule TestSuites.PortfolioManager.Tests.Java.CheckAddNegativeStockQuantityTest do
  @behaviour AutoGrader.TestUnit

  import TestSuites.PortfolioManager.Utils

  @impl true
  def run(submission_path, _context) do
    content =
      load_test_file_content(submission_path)
      |> get_test_function_content("testAddNegativeStockQuantity")

    checks = [
      Regex.match?(
        ~r/assertThrows\(IllegalArgumentException\.class,.+?stockPortfolio\.addStockQuantity\(/,
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
