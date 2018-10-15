defmodule MessageLib.Message.StopReceiver do
    defstruct message: "shutdown_receivers"
end

defimpl MessageLib.Message.Serialize.JSON, for: MessageLib.Message.StopReceiver do

    def serialize(_msg) do
        payload = "{\"message\": \"shutdown_receivers\"}"
        "{\"type\": \"stop_receiver\", \"payload\": #{payload}}"
    end
    
end
