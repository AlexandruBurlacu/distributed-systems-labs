defprotocol Serialize.JSON do

    @doc """
    Serializes a message into JSON string
    """
    def serialize(msg)

    # @doc """
    # Deserializes a message from a JSON string to a struct
    # """
    # def deserialize(str_msg)

end