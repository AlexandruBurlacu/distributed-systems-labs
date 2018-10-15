defmodule MessageBroker.ReceiversRegistry do
    def start_link do
        Agent.start_link(fn -> %{} end, name: __MODULE__)
    end

    def add(topic, host_port) do
        Agent.get_and_update(__MODULE__, fn map -> {
            update_registry(map, topic, host_port), update_registry(map, topic, host_port)
        } end)
    end

    def get(topic) do
        Agent.get(__MODULE__, fn map -> map[topic] end)
    end

    def remove(topic, host_port) do
        Agent.get_and_update(__MODULE__, fn map -> {
            remove_from_registry(map, topic, host_port), remove_from_registry(map, topic, host_port)
        } end)
    end

    defp update_registry(map, topic, host_port) do
        status = Map.has_key? map, topic
        if status do
            Map.put map, topic, [host_port | map[topic]]
        else
            Map.put map, topic, [host_port]
        end
    end

    defp remove_from_registry(map, topic, host_port) do
        Map.put(map, topic, List.delete(map[topic], host_port))
    end

end
