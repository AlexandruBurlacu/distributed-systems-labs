defmodule MessageBroker do
  @moduledoc """
  Documentation for MessageBroker.
  """

    @port 60660
    @ip 'localhost'
    @receivers []

    @doc """
        A test method for the MessageLib.Client within MessageBroker
    """
    def magic do
        sock1 = MessageLib.Client.init 12321
        sock2 = MessageLib.Client.init 32123

        MessageLib.Client.send sock1, "My Message", {'localhost', 32123}

        {msg1, config} = MessageLib.Client.receive # sock2

        MessageLib.Client.send sock2, "My New Message", config

        {msg2, _} = MessageLib.Client.receive # sock1

        IO.inspect {msg1, msg2}
    end

    def init do
        socket = MessageLib.Client.init @port

        IO.puts "Broker running..."

        loop socket
    end

    defp loop(socket) do
        {msg, remote_config} = MessageLib.Client.receive

        IO.inspect {"Received", msg, remote_config}

        IO.inspect @receivers
        IO.inspect remote_config
        @receivers = [remote_config | @receivers]
        IO.inspect @receivers

        if msg == "subscribe" do
            @receivers = [remote_config | @receivers]
        end

        @receivers
        |> Enum.each &MessageLib.Client.send(socket, msg, &1)

        loop socket
    end
end
