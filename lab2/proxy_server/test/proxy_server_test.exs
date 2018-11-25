defmodule ProxyServerTest do
  use ExUnit.Case
  doctest ProxyServer

  test "greets the world" do
    assert ProxyServer.hello() == :world
  end
end
