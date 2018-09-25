defmodule MessageBroker do
  @moduledoc """
  Documentation for MessageBroker.
  """

    @port 60660
    @ip 'localhost'

    def init do
        socket = MessageLib.Client.init @port

        MessageBroker.ReceiversRegistry.start_link

        IO.puts "Broker running..."

        try do
            loop socket
        rescue
            _ in RuntimeError -> 
                :gen_udp.close socket
                IO.puts "Restart the service"
        end
    end

    defp loop(socket) do
        {msg, remote_config} = MessageLib.Client.receive
        {_, port} = remote_config
        IO.puts "The Broker received [#{msg}] from #{port}"

        if msg == "subscribe" do
            IO.inspect MessageBroker.ReceiversRegistry.add remote_config
        else
            MessageBroker.ReceiversRegistry.get
            |> IO.inspect
            |> Enum.each &MessageLib.Client.send(socket, msg, &1)
            IO.puts "Messages sent to all subscribers"
        end

        loop socket
    end
end
