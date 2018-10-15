defmodule MessageLib.Message.Subscribe do
    defstruct topic: "any"
end

defimpl MessageLib.Message.Serialize.JSON, for: MessageLib.Message.Subscribe do

    def serialize(msg) do
        payload = "{\"topic\": \"#{msg.topic}\"}"
        "{\"type\": \"subscribe\", \"payload\": #{payload}}"
    end
    
end
