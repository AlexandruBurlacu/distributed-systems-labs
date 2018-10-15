defmodule MessageLib.Message.Deserialize.JSON do

    @moduledoc """
    Deserializes a message from a JSON string to a struct
    """

    def deserialize({:stop_broker, _str_msg}) do
        %MessageLib.Message.StopBroker{}
    end

    def deserialize({:stop_receiver, _str_msg}) do
        %MessageLib.Message.StopReceiver{}
    end

    def deserialize({:message, str_msg}) do
        parsed_msg = Poison.decode! str_msg
        {_status, date_time, _} = DateTime.from_iso8601 parsed_msg["created_at"]
        %MessageLib.Message.GenericMessage{message: parsed_msg["message"],
                                           created_at: date_time}
    end
    
    def deserialize({:subscribe, str_msg}) do
        parsed_msg = Poison.decode! str_msg
        %MessageLib.Message.Subscribe{topic: parsed_msg["topic"]}
    end

    def deserialize({:unsubscribe, str_msg}) do
        parsed_msg = Poison.decode! str_msg
        %MessageLib.Message.Unsubscribe{topic: parsed_msg["topic"]}
    end

end