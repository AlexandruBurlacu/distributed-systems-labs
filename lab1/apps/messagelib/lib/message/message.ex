defmodule MessageLib.Message.GenericMessage do
    @enforce_keys [:message]
    defstruct [:message, created_at: DateTime.utc_now]
end
