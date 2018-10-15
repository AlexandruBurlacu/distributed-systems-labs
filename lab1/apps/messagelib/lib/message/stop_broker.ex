defmodule MessageLib.Message.StopBroker do
    defstruct message: "shutdown_broker"
end

defimpl Serialize.JSON, for: MessageLib.Message.StopBroker do

    def serialize(_msg) do
        "{\"message\": \"shutdown_broker\"}"
    end

    # def deserialize(_str_msg) do
    #     %MessageLib.Message.StopBroker{}
    # end
    
end
