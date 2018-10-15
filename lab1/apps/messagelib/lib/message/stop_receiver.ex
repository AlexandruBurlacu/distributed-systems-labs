defmodule MessageLib.Message.StopReceiver do
    defstruct message: "shutdown_receivers", topic: "*"
end

defimpl MessageLib.Message.Serialize.JSON, for: MessageLib.Message.StopReceiver do

    def serialize(msg) do
        payload = "{\"message\": \"shutdown_receivers\", \"topic\": \"#{msg.topic}\"}"
        "{\"type\": \"stop_receiver\", \"payload\": #{payload}}"
    end
    
end
