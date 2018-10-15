defmodule MessageLib.Message.StopReceiver do
    defstruct message: "shutdown_receiver"
end

defimpl MessageLib.Message.Serialize.JSON, for: MessageLib.Message.StopReceiver do

    def serialize(_msg) do
        {:stop_receiver, "{\"message\": \"shutdown_receiver\"}"}
    end
    
end
