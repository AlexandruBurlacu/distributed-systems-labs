# Distributed Systems Lab1: Message Broker

For this laboratory work we had to implement a message broker from scratch. We chose to use UDP as the underlying protocol of our implementation.

Under the `apps/` directory you can find a number of Elixir apps/services, all under the same umbrella project.

To run the `benchmark.exs` file, first open 3 terminal windows in the `lab1/` directory.
Then, in first window, run `iex -S mix` and then `MessageBroker.init`.
In the second one, again `iex -S mix` and `MessageReceiver.init(30304) |> MessageReceiver.subscribe |> MessageReceiver.receive`.
Finally, in the 3rd window, `iex -S mix` and `Code.eval_file "benchmark.exs"`.

On my machine, without optimizing the Erlang VM, I got 10000 messages sent in a bit more than 5 seconds.

