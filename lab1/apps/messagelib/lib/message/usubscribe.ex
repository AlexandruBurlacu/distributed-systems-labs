defmodule MessageLib.Message.Unsubscribe do
    defstruct topic: "any"
end

defimpl Serialize.JSON, for: MessageLib.Message.Unsubscribe do

    def serialize(msg) do
        "{\"topic\": \"#{msg.topic}\"}"
    end

    # def deserialize(msg) do
        
    # end
    
end
