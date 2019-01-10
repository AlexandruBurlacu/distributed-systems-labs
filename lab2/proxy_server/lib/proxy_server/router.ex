defmodule ProxyServer.Router do
  use Plug.Router

  @writerservice_url "writerservice:8080"

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Poison
  )

  plug(:dispatch)

  defp get_data(query, conn) do
    case HTTPoison.get(query) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        ProxyServer.Cache.put(query, body)
        body

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        send_resp(conn, 404, "Not found.")

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason)
    end
  end

  defp verify_cache(query, conn) do
    case ProxyServer.Cache.get(query, 10) do
      [] ->
        IO.inspect("Creating new entry for this query.")
        get_data(query, conn)

      data ->
        IO.inspect("Sending data from cache.")
        IO.inspect(data)
        data
    end
  end

  defp return_data(body, conn) do

    IO.inspect("headers")
    IO.inspect(conn.req_headers)

    case List.keyfind(conn.req_headers, "accept", 0) do
      {"accept", "application/xml"} ->
        IO.inspect(body)
        send_resp(conn, 200, JsonToXml.convert!(body))

      _ -> # {"accept", "application/json"}
        send_resp(conn, 200, body)
    end
  end

  defp post_data(query, conn) do
    data = conn.body_params

    case HTTPoison.post(query, Poison.encode!(data), [
           {"Content-Type", "application/json"}
         ]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        send_resp(conn, 200, body)

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason)
    end
  end

  get "/actors" do
    readerservice_url = ProxyServer.LoadBalancer.get_readerservice_url
    query = readerservice_url <> conn.request_path <> "?" <> conn.query_string

    IO.inspect(query)
    body = verify_cache(query, conn)
    return_data(body, conn)
  end

  get "/movies" do
    readerservice_url = ProxyServer.LoadBalancer.get_readerservice_url
    query = readerservice_url <> conn.request_path <> "?" <> conn.query_string

    IO.inspect(query)
    return_data(query, conn)
  end

  post "/actors" do
    query = @writerservice_url <> conn.request_path
    post_data(query, conn)
  end

  post "/movies" do
    query = @writerservice_url <> conn.request_path
    post_data(query, conn)
  end

  post "/studio" do
    query = @writerservice_url <> conn.request_path
    post_data(query, conn)
  end

  match(_, do: send_resp(conn, 404, "Oops!\n"))
end
