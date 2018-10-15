defmodule MessageLib.Message.GenericMessage do
    @enforce_keys [:message]
    defstruct [:message, created_at: DateTime.utc_now]
end

defimpl MessageLib.Message.Serialize.JSON, for: MessageLib.Message.GenericMessage do

    def serialize(msg) do
        payload = "{\"message\": \"#{msg.message}\", \"created_at\": \"#{msg.created_at}\"}"
        "{\"type\": \"message\", \"payload\": #{payload}}"
    end

end
