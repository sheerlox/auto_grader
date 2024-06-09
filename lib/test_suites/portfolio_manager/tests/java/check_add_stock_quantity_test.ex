defmodule TestSuites.PortfolioManager.Tests.Java.CheckAddStockQuantityTest do
  @moduledoc false

  @behaviour AutoGrader.TestUnit

  import TestSuites.PortfolioManager.Utils

  @impl true
  def run(submission_path, _context) do
    content =
      load_test_file_content(submission_path)
      |> get_test_function_content("testAddStockQuantity")

    checks = [
      Regex.match?(~r/when\(stockStorage.get\(.+?\.thenReturn\(/, content),
      String.contains?(content, "stockPortfolio.addStockQuantity"),
      Regex.match?(~r/verify\(stockStorage.+?\.get/, content),
      Regex.match?(~r/verify\(stockStorage.+?\.put/, content)
    ]

    get_checks_score(checks)
  end
end
