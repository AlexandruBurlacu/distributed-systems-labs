defmodule ProxyServer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  defp cowboy_port, do: Application.get_env(:example, :cowboy_port, 8080)

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      {Plug.Cowboy, scheme: :http, plug: ProxyServer.Router, options: [port: cowboy_port()]}
    ]

    opts = [strategy: :one_for_one, name: ProxyServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
