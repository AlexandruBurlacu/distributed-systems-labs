defmodule MessageLib.Message.StopReceiver do
    defstruct message: "shutdown_receiver"
end

defimpl Serialize.JSON, for: MessageLib.Message.StopReceiver do

    def serialize(_msg) do
        "{\"message\": \"shutdown_receiver\"}"
    end

    # def deserialize(_str_msg) do
    #     %MessageLib.Message.StopReceiver{}
    # end
    
end
