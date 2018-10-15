defprotocol MessageLib.Message.Serialize.JSON do

    @doc """
    Serializes a message into JSON string
    """
    def serialize(msg)

end
