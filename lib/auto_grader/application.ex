defmodule AutoGrader.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {DynamicSupervisor, name: AutoGrader.SubmissionRunnerSupervisor},
      {Task.Supervisor, name: AutoGrader.TestUnitSupervisor},
      {Task.Supervisor, name: AutoGrader.SetupUnitSupervisor},
      AutoGrader
    ]

    opts = [strategy: :one_for_one, name: AutoGrader.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
