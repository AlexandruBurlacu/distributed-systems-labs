defmodule MessageLib.Message.Subscribe do
    defstruct topic: "any"
end

defimpl Serialize.JSON, for: MessageLib.Message.Subscribe do

    def serialize(msg) do
        "{\"topic\": \"#{msg.topic}\"}"
    end

    # def deserialize(msg) do
        
    # end
    
end
