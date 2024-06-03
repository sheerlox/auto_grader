defmodule TestSuites.PortfolioManager.Tests.Java.CheckRemoveStockQuantityStockNotOwnedTest do
  @behaviour AutoGrader.TestUnit

  import TestSuites.PortfolioManager.Utils

  def run(submission_path) do
    content =
      load_test_file_content(submission_path)
      |> get_test_function_content("testRemoveStockQuantityStockNotOwned")

    checks = [
      not Regex.match?(
        ~r/when\(stockStorage.get\(.+?\.thenReturn\(/,
        content
      ),
      Regex.match?(
        ~r/assertThrows\(NotEnoughStockQuantityException\.class,.+?stockPortfolio\.removeStockQuantity\(/,
        content
      )
    ]

    get_checks_score(checks)
  end
end
