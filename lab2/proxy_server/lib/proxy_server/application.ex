defmodule ProxyServer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  defp cowboy_port, do: Application.get_env(:example, :cowboy_port, 8085)

  def start(_type, _args) do
    # List all child processes to be supervised
    HTTPoison.start()

    :ets.new(:user_lookup, [:set, :public, :named_table])

    :ets.new(:cache_table, [:named_table, :public, read_concurrency: true])

    DomainAgent.start_link()

    children = [
      {Plug.Cowboy, scheme: :http, plug: ProxyServer.Router, options: [port: cowboy_port()]}
    ]

    opts = [strategy: :one_for_one, name: ProxyServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
