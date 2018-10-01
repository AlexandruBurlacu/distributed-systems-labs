defmodule MessageReceiver do
  @broker_ip 'localhost'
  @broker_port 60660

  require Logger

  def init(port) do
    MessageLib.Client.init(port)
  end

  def subscribe(socket) do
    MessageLib.Client.send(socket, "subscribe", {@broker_ip, @broker_port})
  end

  def receive do
    {msg, _} = MessageLib.Client.receive()
    Logger.info(msg)
  end
end
