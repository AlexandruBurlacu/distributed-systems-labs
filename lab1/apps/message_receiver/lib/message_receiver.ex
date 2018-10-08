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

  @doc """
  TODO: Implement unsubscribing on broker side
  """
  def unsubscribe(socket) do
    MessageLib.Client.send(socket, "unsubscribe", {@broker_ip, @broker_port})
  end

  def receive(socket) do
    {msg, _} = MessageLib.Client.receive()

    if msg == "shutdown_receivers" do
      Logger.info "Shuting down the receiver..."
      unsubscribe(socket)
      :gen_udp.close socket
      Logger.info "Done"
    end

    Logger.info(msg)
  end
end
