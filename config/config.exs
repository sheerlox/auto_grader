import Config

config :auto_grader,
  submissions_path: "../REPOSITORIES/TP_PORTFOLIO_MANAGER",
  init_module: AutoGrader.SetupUnits.Init,
  # setup units are run in order!
  setup_units: [
    AutoGrader.SetupUnits.Java.CheckRequirements,
    AutoGrader.SetupUnits.Java.InstallDependencies
  ],
  test_units: [
    AutoGrader.TestUnits.Example,
    AutoGrader.TestUnits.Java.RunJunitTests
  ]

config :logger, :default_formatter, truncate: :infinity
