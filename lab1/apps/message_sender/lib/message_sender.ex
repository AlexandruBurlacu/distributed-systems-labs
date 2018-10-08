defmodule MessageSender do
  @broker_ip 'localhost'
  @broker_port 60660

  require Logger

  def init(port) do
    MessageLib.Client.init(port)
  end

  def send(socket, data) do
    MessageLib.Client.send(socket, data, {@broker_ip, @broker_port})
  end
end
