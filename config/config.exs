import Config

config :auto_grader,
  submissions_path: "../REPOSITORIES/TP_PORTFOLIO_MANAGER",
  max_score: 20,
  init_module: TestSuites.PortfolioManager.Setup.Init,
  # setup units are run in order!
  setup_units: [
    # TestSuites.PortfolioManager.Setup.Java.CheckRequirements,
    # TestSuites.PortfolioManager.Setup.Java.InstallDependencies
  ],
  test_units: [
    TestSuites.PortfolioManager.Tests.Java.RunJunitTests
  ]

config :logger, :default_formatter, truncate: :infinity
