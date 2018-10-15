defmodule MessageLib.Message.Subscribe do
    defstruct topic: "any"
end

defimpl MessageLib.Message.Serialize.JSON, for: MessageLib.Message.Subscribe do

    def serialize(msg) do
        {:subscribe, "{\"topic\": \"#{msg.topic}\"}"}
    end
    
end
