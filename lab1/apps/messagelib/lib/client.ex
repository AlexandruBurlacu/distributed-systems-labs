defmodule MessageLib.Client do
    @moduledoc """
    Documentation for MessageLib.IClient
    """

    def init(port) do
        {:ok, sock} = :gen_udp.open port, [:binary, active: true]
        sock
    end

    def send(sock, msg, {host, port}) do
        :gen_udp.send sock, host, port, String.to_charlist(msg) |> :erlang.term_to_binary
    end

    def receive(sock) do
        value = receive do
            {:udp, socket, host, port, bin} ->
                # IO.inspect {socket, host, port}
                ret = :erlang.binary_to_term(bin)
                       |> String.Chars.to_string

                {ret, {host, port}}
        end

        value
    end
end
