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

    Logger.info("Broker running...")

    try do
      loop(socket)
    rescue
      _ in RuntimeError ->
        :gen_udp.close(socket)
        Logger.info("Restarting the service...")
    end

    MessageBroker.init()
  end

  defp loop(socket) do
    {json_msg, remote_config} = MessageLib.Client.receive()
    {_, port} = remote_config
    Logger.info("The Broker received [#{json_msg}] from #{port}")

    msg = MessageLib.Message.Deserialize.JSON.deserialize(json_msg)

    case msg do
      %MessageLib.Message.Subscribe{topic: topic_name} ->
        IO.inspect(MessageBroker.ReceiversRegistry.add(topic_name, remote_config))

      %MessageLib.Message.Unsubscribe{topic: topic_name} ->
        IO.inspect(MessageBroker.ReceiversRegistry.remove(topic_name, remote_config))

      %MessageLib.Message.StopBroker{} ->
        :gen_udp.close(socket)
        exit(0)

      _ ->
        IO.inspect(msg.topic)

        MessageBroker.ReceiversRegistry.get(msg.topic)
        |> IO.inspect()
        |> Enum.each(
          &MessageLib.Client.send(socket, MessageLib.Message.Serialize.JSON.serialize(msg), &1)
        )

        Logger.info("Messages sent to all subscribers")
    end

    loop(socket)
  end
end
