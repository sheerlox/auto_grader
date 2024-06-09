import Config

config :auto_grader,
  submissions_path: "./examples/portfolio_manager",
  max_score: 20,
  # the init setup unit runs once, before starting to process submissions
  init_setup_unit: TestSuites.PortfolioManager.Setup.Init,
  # setup units run in the declared order on each submission
  setup_units: [
    TestSuites.PortfolioManager.Setup.Java.CheckRequirements,
    TestSuites.PortfolioManager.Setup.Java.InstallDependencies
  ],
  # test units are run concurrently on each submission
  test_units: [
    TestSuites.PortfolioManager.Tests.Java.RunJunitTests,
    TestSuites.PortfolioManager.Tests.Java.CheckAddNewStockTest,
    TestSuites.PortfolioManager.Tests.Java.CheckAddStockQuantityTest,
    TestSuites.PortfolioManager.Tests.Java.CheckAddNegativeStockQuantityTest,
    TestSuites.PortfolioManager.Tests.Java.CheckRemoveStockQuantityTest,
    TestSuites.PortfolioManager.Tests.Java.CheckRemoveNegativeStockQuantityTest,
    TestSuites.PortfolioManager.Tests.Java.CheckRemoveTooMuchStockQuantityTest,
    TestSuites.PortfolioManager.Tests.Java.CheckRemoveStockQuantityStockNotOwnedTest,
    TestSuites.PortfolioManager.Tests.Java.CheckGetStockPortfolioValueTest,
    TestSuites.PortfolioManager.Tests.Java.CheckGetStockPortfolioValueStockNotFoundTest,
    TestSuites.PortfolioManager.Tests.Java.CheckGetEmptyPortfolioValueTest,
    TestSuites.PortfolioManager.Tests.Java.CheckGetTotalPortfolioValueTest,
    TestSuites.PortfolioManager.Tests.Java.CheckGetTotalPortfolioValueWithZeroQuantityStocksTest
  ]

config :logger, :default_formatter, truncate: :infinity
