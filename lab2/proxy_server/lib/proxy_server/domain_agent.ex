defmodule DomainAgent do
  use Agent

  def start_link() do
    Agent.start_link(
      fn -> ["readerservice1:8080", "readerservice2:8080", "readerservice3:8080"] end,
      name: __MODULE__
    )
  end

  def current_item() do
    Agent.get(__MODULE__, fn list ->
      List.first(list)
    end)
  end

  def next() do
    Agent.update(__MODULE__, fn [head | tail] ->
      tail ++ [head]
    end)
  end

  def get_domain() do
    name = current_item()
    next()
    name
  end
end
