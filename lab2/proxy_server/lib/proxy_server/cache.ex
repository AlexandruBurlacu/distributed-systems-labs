defmodule ProxyServer.Cache do
  def get(query, ttl) do
    case :ets.lookup(:readerservice_cache, query) do
      [{_, [body, time]}] ->
        cond do
          time + ttl > :os.system_time(:seconds) ->
            update(query, body) # to update the timestamp
            body

          true ->
            IO.inspect("TTL expired.")
            []
        end

      _ ->
        IO.inspect("No entries.")
        []
    end
  end

  def put(query, body) do
    IO.inspect("Creating new entry for this query.")
    :ets.insert(:readerservice_cache, {query, [body, :os.system_time(:seconds)]})
  end

  def update(query, body) do
    IO.inspect("Updating the entry timestamp for this query.")
    :ets.insert(:readerservice_cache, {query, [body, :os.system_time(:seconds)]})
  end

  def start do
    :ets.new(:readerservice_cache, [:set, :public, :named_table, read_concurrency: true])
  end
end
