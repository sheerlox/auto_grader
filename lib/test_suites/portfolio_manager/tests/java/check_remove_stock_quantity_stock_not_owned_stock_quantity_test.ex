defmodule TestSuites.PortfolioManager.Tests.Java.CheckRemoveStockQuantityStockNotOwnedTest do
  @moduledoc false

  @behaviour AutoGrader.TestUnit

  import TestSuites.PortfolioManager.Utils

  @impl true
  def bonus?, do: true

  @impl true
  def run(submission_path, _context) do
    content =
      load_test_file_content(submission_path)
      |> get_test_function_content("testRemoveStockQuantityStockNotOwned")

    checks = [
      Regex.match?(
        ~r/assertThrows\(NotEnoughStockQuantityException\.class,.+?stockPortfolio\.removeStockQuantity\(/,
        content
      )
    ]

    get_checks_score(checks)
  end
end
