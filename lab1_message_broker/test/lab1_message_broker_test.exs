defmodule Lab1MessageBrokerTest do
  use ExUnit.Case
  doctest Lab1MessageBroker

  test "greets the world" do
    assert Lab1MessageBroker.hello() == :world
  end
end
