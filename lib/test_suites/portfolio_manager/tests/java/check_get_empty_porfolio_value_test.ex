defmodule TestSuites.PortfolioManager.Tests.Java.CheckGetEmptyPortfolioValueTest do
  @moduledoc false

  @behaviour AutoGrader.TestUnit

  import TestSuites.PortfolioManager.Utils

  @impl true
  def bonus?, do: true

  @impl true
  def run(submission_path, _context) do
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
