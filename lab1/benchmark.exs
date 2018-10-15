sock = MessageSender.init 30303

experiment = fn ->
  start = :os.system_time(:micro_seconds)
  1..10000
  |> Enum.map(&Task.async(fn ->
                    MessageSender.send(sock,
                            %MessageLib.Message.GenericMessage{message: "Msg no. #{&1}"})
               end))
  |> Enum.map(&Task.await(&1))
  IO.puts :os.system_time(:micro_seconds) - start
end

experiment.()

MessageSender.send(sock, %MessageLib.Message.StopReceiver{})
MessageSender.send(sock, %MessageLib.Message.StopBroker{})

MessageSender.close sock

