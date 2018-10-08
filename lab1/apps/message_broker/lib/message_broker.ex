defmodule MessageBroker do
  @moduledoc """
  Documentation for MessageBroker.
  """

  @port 60660
  @ip 'localhost'

  def init do
    socket = MessageLib.Client.init(@port)

    MessageBroker.ReceiversRegistry.start_link()

    IO.puts("Broker running...")

    try do
      loop(socket)
    rescue
      _ in RuntimeError ->
        :gen_udp.close(socket)
        IO.puts("Restarting the service...")
    end

    MessageBroker.init
  end

  defp loop(socket) do
    {msg, remote_config} = MessageLib.Client.receive()
    {_, port} = remote_config
    IO.puts("The Broker received [#{msg}] from #{port}")

    case msg do
      "subscribe" -> IO.inspect(MessageBroker.ReceiversRegistry.add(remote_config))
      "shutdown_broker" -> :gen_udp.close socket
                           exit 0
      _ -> MessageBroker.ReceiversRegistry.get
           |> IO.inspect()
           |> Enum.each(&MessageLib.Client.send(socket, msg, &1))

           IO.puts("Messages sent to all subscribers")
    end

    loop(socket)
  end
end
