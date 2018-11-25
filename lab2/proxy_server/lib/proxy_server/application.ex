defmodule ProxyServer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      {Plug.Cowboy, scheme: :http, plug: ProxyServer.Router, options: [port: 8080]}
    ]

    opts = [strategy: :one_for_one, name: ProxyServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
