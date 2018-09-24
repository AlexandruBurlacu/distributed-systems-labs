defmodule MessageBroker.ReceiversRegistry do
    def start_link do
        Agent.start_link(fn -> [] end, name: __MODULE__)
    end

    def add(input) do
        Agent.get_and_update(__MODULE__, fn x -> {
            [x | input], [x | input]
        } end)
    end
end
