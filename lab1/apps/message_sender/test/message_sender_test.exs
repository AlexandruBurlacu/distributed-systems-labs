defmodule MessageSenderTest do
  use ExUnit.Case
  doctest MessageSender

  test "greets the world" do
    assert MessageSender.hello() == :world
  end
end
