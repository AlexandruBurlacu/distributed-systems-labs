defmodule MessageSender do
  @broker_ip 'localhost'
  @broker_port 60660

  require Logger

  def init(port) do
    Logger.info "Initializing a connection at port #{port}"
    MessageLib.Client.init(port)
    Logger.info "Done"
  end

  def send(socket, data) do
    Logger.info "Sending data"
    MessageLib.Client.send(socket, data, {@broker_ip, @broker_port})
  end

  def close(socket) do
    Logger.info "Closing the sender"
    :gen_udp.close socket
    Logger.info "Done"
  end
end
