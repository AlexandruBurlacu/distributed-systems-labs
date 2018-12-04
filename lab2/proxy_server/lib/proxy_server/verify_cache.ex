defmodule ProxyServer.VerifyCache do
  def get(ets_table_name, keyword, ttl) do
    case lookup(ets_table_name, keyword) do
      [{_, [body, time]}] ->
        cond do
          time + ttl > :os.system_time(:seconds) ->
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

  def lookup(ets_table_name, keyword) do
    :ets.lookup(ets_table_name, keyword)
  end
end
