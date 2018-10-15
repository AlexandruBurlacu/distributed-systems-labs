defmodule MessageLib.Message.StopBroker do
    defstruct message: "shutdown_broker"
end

defimpl MessageLib.Message.Serialize.JSON, for: MessageLib.Message.StopBroker do

    def serialize(_msg) do
        payload = "{\"message\": \"shutdown_broker\"}"
        "{\"type\": \"stop_broker\", \"payload\": #{payload}}"
    end
    
end
