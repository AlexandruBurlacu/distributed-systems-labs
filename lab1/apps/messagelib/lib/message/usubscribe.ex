defmodule MessageLib.Message.Unsubscribe do
    defstruct topic: "any"
end

defimpl MessageLib.Message.Serialize.JSON, for: MessageLib.Message.Unsubscribe do

    def serialize(msg) do
        payload = "{\"topic\": \"#{msg.topic}\"}"
        "{\"type\": \"unsubscribe\", \"payload\": #{payload}}"
    end
    
end
