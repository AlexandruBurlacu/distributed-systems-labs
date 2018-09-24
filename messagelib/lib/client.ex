defmodule MessageLib.IClient do
    @moduledoc """
    Documentation for MessageLib.IClient
    """

    def init(port) do
        {:ok, sock} = :gen_udp.open port, [:binary, active: true]
        sock
    end

    def send(sock, msg, {broker_host = 'localhost', broker_port}) do
        :gen_udp.send sock, broker_host, broker_port, String.to_charlist(msg) |> :erlang.term_to_binary
    end

    def receive(sock) do
        value = receive do
            {:udp, socket, host, port, bin} ->
                # IO.inspect {socket, host, port}
                :erlang.binary_to_term(bin)
        end

        value
    end
end
