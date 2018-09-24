defmodule MessageLib.Client do
    @moduledoc """
    Documentation for MessageLib.IClient
    """

    def init(port) do
        {:ok, socket} = :gen_udp.open port, [:binary, active: true]
        socket
    end

    def send(socket, message, {host, port}) do
        message
        |> String.to_charlist
        |> :erlang.term_to_binary
        |> (fn msg -> :gen_udp.send(socket, host, port, msg) end).()
    end

    def receive do
        value = receive do
            {:udp, _socket, host, port, bin} ->
                ret = :erlang.binary_to_term(bin)
                       |> String.Chars.to_string

                {ret, {host, port}}
        end

        value
    end
end
