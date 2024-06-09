defmodule TestSuites.PortfolioManager.Tests.Java.CheckGetStockPortfolioValueStockNotFoundTest do
  @moduledoc false

  @behaviour AutoGrader.TestUnit

  import TestSuites.PortfolioManager.Utils

  @impl true
  def run(submission_path, _context) do
    content =
      load_test_file_content(submission_path)
      |> get_test_function_content(
        "test[gG]etStockPortfolioValueStockNotFound"
      )

    checks = [
      Regex.match?(
        ~r/when\(stockAPI\.getStockPrice\(.+?\.thenThrow\(/,
        content
      ),
      Regex.match?(
        ~r/assertThrows\(StockNotFoundException\.class,.+?stockPortfolio\.getStockPortfolioValue\(/,
        content
      )
    ]

    get_checks_score(checks)
  end
end
