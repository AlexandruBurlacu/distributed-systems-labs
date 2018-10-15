defmodule MessageLib.Message.Unsubscribe do
    defstruct topic: "any"
end

defimpl Serialize.JSON, for: MessageLib.Message.Unsubscribe do

    def serialize(msg) do
        "{\"topic\": \"#{msg.topic}\"}"
    end

    # def deserialize(str_msg) do
    #     parsed_msg = Poison.decode! msg
    #     %MessageLib.Message.Unsubscribe{topic: parsed_msg["topic"]}
    # end
    
end
