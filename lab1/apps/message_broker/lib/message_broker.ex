defmodule MessageBroker do
  @moduledoc """
  Documentation for MessageBroker.
  """

    @port 60660
    @ip 'localhost'

    @doc """
        A test method for the MessageLib.Client within MessageBroker
    """
    def magic do
        sock1 = MessageLib.Client.init 12321
        sock2 = MessageLib.Client.init 32123

        MessageLib.Client.send sock1, "My Message", {@ip, 32123}

        {msg1, config} = MessageLib.Client.receive # sock2

        MessageLib.Client.send sock2, "My New Message", config

        {msg2, _} = MessageLib.Client.receive # sock1

        IO.inspect {msg1, msg2}
    end

    def init do
        socket = MessageLib.Client.init @port

        MessageBroker.ReceiversRegistry.start_link

        IO.puts "Broker running..."

        loop socket
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
