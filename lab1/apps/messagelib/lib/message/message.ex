defmodule MessageLib.Message.GenericMessage do
    @enforce_keys [:message]
    defstruct [:message, created_at: DateTime.utc_now]
end

defimpl Serialize.JSON, for: MessageLib.Message.GenericMessage do

    def serialize(msg) do
        "{\"message\": \"#{msg.message}\", \"created_at\": \"#{msg.created_at}\"}"
    end

    def deserialize(msg) do
        %MessageLib.Message.GenericMessage{message: "", created_at: ""} # DateTime.from_iso8601
    end
    
end
