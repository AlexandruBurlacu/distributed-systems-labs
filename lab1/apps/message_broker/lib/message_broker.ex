defmodule MessageBroker do
  @moduledoc """
  Documentation for MessageBroker.
  """

  @port 60666
  @ip 'localhost'

    def magic do
        @doc """
            A test method for the MessageLib.Client within MessageBroker
        """
        sock1 = MessageLib.Client.init 12321
        sock2 = MessageLib.Client.init 32123

        MessageLib.Client.send sock1, "My Message", {'localhost', 32123}

        {msg1, config} = MessageLib.Client.receive sock2

        MessageLib.Client.send sock2, "My New Message", config

        {msg2, _} = MessageLib.Client.receive sock1

        IO.inspect {msg1, msg2}
    end
end
