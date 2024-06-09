import Config

config :auto_grader,
  # setting batch_size to :infinity, 0 or -1 will process all submissions
  # at once
  batch_size: System.schedulers() * 4
