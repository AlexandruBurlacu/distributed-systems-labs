defmodule MessageLib.Message.GenericMessage do
    @enforce_keys [:message]
    defstruct [:message, created_at: DateTime.utc_now]
end

defimpl Serialize.JSON, for: MessageLib.Message.GenericMessage do

    def serialize(msg) do
        "{\"message\": \"#{msg.message}\", \"created_at\": \"#{msg.created_at}\"}"
    end

    # def deserialize(str_msg) do
    #     parsed_msg = Poison.decode! msg
    #     {_status, date_time, _} = DateTime.from_iso8601 parsed_msg["created_at"]
    #     %MessageLib.Message.GenericMessage{message: parsed_msg["message"],
    #                                        created_at: date_time}
    # end
    
end
