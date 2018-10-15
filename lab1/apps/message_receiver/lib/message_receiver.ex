defmodule MessageReceiver do
  @broker_ip 'localhost'
  @broker_port 60660

  require Logger

  def init(port) do
    MessageLib.Client.init(port)
  end

  def subscribe(socket, topic_name) do
    data = %MessageLib.Message.Subscribe{topic: topic_name}
    json_data = MessageLib.Message.Serialize.JSON.serialize data
    MessageLib.Client.send(socket, json_data, {@broker_ip, @broker_port})
    socket
  end

  @doc """
  TODO: Implement unsubscribing on broker side
  """
  def unsubscribe(socket) do
    data = %MessageLib.Message.Unsubscribe{topic: "*"}
    json_data = MessageLib.Message.Serialize.JSON.serialize data
    MessageLib.Client.send(socket, json_data, {@broker_ip, @broker_port})
    socket
  end

  def receive(socket) do
    {json_msg, _} = MessageLib.Client.receive()
    msg = MessageLib.Message.Deserialize.JSON.deserialize json_msg


    if msg == %MessageLib.Message.StopReceiver{} do
      Logger.info "Shuting down the receiver..."
      unsubscribe(socket)
      :gen_udp.close socket
      Logger.info "Done"
      exit 0
    end

    Logger.info(json_msg)

    MessageReceiver.receive(socket)
  end
end
