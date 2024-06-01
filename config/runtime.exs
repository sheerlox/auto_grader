import Config

config :auto_grader,
  batch_size: System.schedulers() * 4
