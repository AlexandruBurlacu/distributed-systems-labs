defmodule MessageLib.Message.Unsubscribe do
    defstruct topic: "any"
end

defimpl MessageLib.Message.Serialize.JSON, for: MessageLib.Message.Unsubscribe do

    def serialize(msg) do
        {:unsubscribe, "{\"topic\": \"#{msg.topic}\"}"}
    end
    
end
