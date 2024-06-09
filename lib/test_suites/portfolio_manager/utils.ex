defmodule TestSuites.PortfolioManager.Utils do
  @moduledoc false

  @test_file_path "src/test/java/fr/amu/iut/stock/StockPortfolioTest.java"

  @doc """
  Loads the JUnit test file content from a given PortfolioManager submission.
  """
  @spec load_test_file_content(binary()) :: binary()
  def load_test_file_content(submission_path) do
    submission_path
    |> Path.join(@test_file_path)
    |> File.read!()
  end

  @doc """
  Gets the content of a JUnit test function by its name.
  """
  @spec get_test_function_content(binary(), binary()) :: binary()
  def get_test_function_content(test_file_content, test_function_name) do
    [_, content] =
      Regex.run(
        ~r/#{test_function_name}\(\).*?{(.+?)}.+?(?:@Test|$)/s,
        test_file_content
      )

    content
  end

  @doc """
  Calculates the score from a list of boolean.

  Returns a {score, max_score} tuple.
  """
  @spec get_checks_score(list(boolean())) :: {integer(), integer()}
  def get_checks_score(checks) do
    score =
      Enum.reduce(checks, 0, fn check, acc ->
        acc +
          case check do
            true -> 1
            false -> 0
          end
      end)

    max_score = length(checks)

    {score, max_score}
  end
end
