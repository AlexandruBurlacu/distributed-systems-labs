defmodule MessagelibTest do
  use ExUnit.Case
  doctest Messagelib

  test "greets the world" do
    assert Messagelib.hello() == :world
  end
end
