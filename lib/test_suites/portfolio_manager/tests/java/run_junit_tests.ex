defmodule TestSuites.PortfolioManager.Tests.Java.RunJunitTests do
  @behaviour AutoGrader.TestUnit

  @test_output_regex ~r/Tests run: (\d+), Failures: (\d+), Errors: (\d+), Skipped: (\d+)/

  def run(submission_path) do
    {output, _} = System.cmd("mvn", ["test"], cd: submission_path)

    if not Regex.match?(@test_output_regex, output),
      do: throw("Failed to run JUnit tests")

    result = parse_test_output(output)

    score = result.passing
    max_score = result.total

    {score, max_score}
  end

  def parse_test_output(output) do
    [_, total, failures, errors, skipped] =
      Regex.run(
        @test_output_regex,
        output
      )

    [total, failures, errors, skipped] =
      Enum.map([total, failures, errors, skipped], &String.to_integer(&1))

    passing = total - failures - errors - skipped

    %{
      total: total,
      passing: passing,
      failures: failures,
      errors: errors,
      skipped: skipped
    }
  end
end
