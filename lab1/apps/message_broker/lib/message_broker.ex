defmodule MessageBroker do
  @moduledoc """
  Documentation for MessageBroker.
  """

  require Logger

  @port 60660
  @ip 'localhost'

  def init do
    socket = MessageLib.Client.init(@port)

    MessageBroker.ReceiversRegistry.start_link()

    Logger.info "Broker running..."

    try do
      loop(socket)
    rescue
      _ in RuntimeError ->
        :gen_udp.close(socket)
        Logger.info "Restarting the service..."
    end

    MessageBroker.init
  end

  defp loop(socket) do
    {msg, remote_config} = MessageLib.Client.receive()
    {_, port} = remote_config
    Logger.info "The Broker received [#{msg}] from #{port}"

    case msg do
      "subscribe" -> IO.inspect(MessageBroker.ReceiversRegistry.add(remote_config))
      "shutdown_broker" -> :gen_udp.close socket
                           exit 0
      _ -> MessageBroker.ReceiversRegistry.get
           |> IO.inspect()
           |> Enum.each(&MessageLib.Client.send(socket, msg, &1))

           Logger.info "Messages sent to all subscribers"
    end

    loop(socket)
  end
end
