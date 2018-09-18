defmodule Lab1MessageBroker.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: Lab1MessageBroker.Worker.start_link(arg)
      # {Lab1MessageBroker.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Lab1MessageBroker.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
