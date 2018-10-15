defmodule MessageLib.Message.Deserialize.JSON do

    @moduledoc """
    Deserializes a message from a JSON string to a struct
    """

    def deserialize(str_msg) do
        parsed_msg = Poison.decode! str_msg
        {String.to_atom(parsed_msg["type"]), parsed_msg["payload"]}
        |> materialize
    end

    defp materialize({:stop_broker, _msg}) do
        %MessageLib.Message.StopBroker{}
    end

    defp materialize({:stop_receiver, msg}) do
        %MessageLib.Message.StopReceiver{topic: msg["topic"]}
    end

    defp materialize({:message, msg}) do
        {_status, date_time, _} = DateTime.from_iso8601 msg["created_at"]
        %MessageLib.Message.GenericMessage{message: msg["message"],
                                           topic: msg["topic"],
                                           created_at: date_time}
    end
    
    defp materialize({:subscribe, msg}) do
        %MessageLib.Message.Subscribe{topic: msg["topic"]}
    end

    defp materialize({:unsubscribe, msg}) do
        %MessageLib.Message.Unsubscribe{topic: msg["topic"]}
    end

end