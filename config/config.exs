import Config

config :auto_grader,
  submissions_path: "../REPOSITORIES/TP_PORTFOLIO_MANAGER",
  test_units: [
    AutoGrader.TestUnits.Example,
    AutoGrader.TestUnits.Java.RunJunitTests
  ]

config :logger, :default_formatter, truncate: :infinity
