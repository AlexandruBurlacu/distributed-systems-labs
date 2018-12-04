defmodule ProxyServer.Router do
  use Plug.Router

  @readerservice_url "readerservice:8080"
  @writerservice_url "writerservice:8080"


  @doc """
  TODO: Make the round robin load balancer.
  As an alternative you can use Agents

  Use in get requests insteat of @readerservice_url
  """
  defp get_readerservice_url do
    get_readerservice_url(:version1)
  end

  defp get_readerservice_url(:version1) do
    "readerservice1:8080"
  end

  defp get_readerservice_url(:version2) do
    "readerservice2:8080"
  end

  defp get_readerservice_url(:version3) do
    "readerservice3:8080"
  end

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Poison
  )

  plug(:dispatch)

  get "/actors" do
    # "http://httparrot.herokuapp.com/get"
    query = @readerservice_url <> conn.request_path <> "?" <> conn.query_string

    IO.inspect(query)

    case ProxyServer.VerifyCache.get(:user_lookup, query, 10) do
      [] ->
        IO.inspect("Creating new entry for this query.")

        resp = HTTPoison.get(query)

        IO.inspect(resp)

        case resp do
          {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
            IO.inspect(body)

            :ets.insert(:user_lookup, {query, [body, :os.system_time(:seconds)]})

            send_resp(conn, 200, body)

          {:ok, %HTTPoison.Response{status_code: 404}} ->
            send_resp(conn, 404, "Not found.")

          {:error, %HTTPoison.Error{reason: reason}} ->
            IO.inspect(reason)
        end

      data ->
        IO.inspect("Sending data from cache.")
        IO.inspect(data)
        send_resp(conn, 200, data)
    end
  end

  get "/movies" do
    query = @readerservice_url <> conn.request_path <> "?" <> conn.query_string

    IO.inspect(query)

    case ProxyServer.VerifyCache.get(:user_lookup, query, 10) do
      [] ->
        IO.inspect("Creating new entry for this query.")

        case HTTPoison.get(query) do
          {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
            IO.inspect(body)

            :ets.insert(:user_lookup, {query, [body, :os.system_time(:seconds)]})

            send_resp(conn, 200, body)

          {:ok, %HTTPoison.Response{status_code: 404}} ->
            send_resp(conn, 404, "Not found.")

          {:error, %HTTPoison.Error{reason: reason}} ->
            IO.inspect(reason)
        end

      data ->
        IO.inspect("Sending data from cache.")
        IO.inspect(data)
        send_resp(conn, 200, data)
    end
  end

  post "/actors" do
    query = @writerservice_url <> conn.request_path
    data = conn.body_params

    case HTTPoison.post(query, Poison.encode!(data), [
           {"Content-Type", "application/json"}
         ]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        IO.inspect(body)
        send_resp(conn, 200, body)

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason)
    end
  end

  post "/movies" do
    query = @writerservice_url <> conn.request_path
    data = conn.body_params

    case HTTPoison.post(query, Poison.encode!(data), [
           {"Content-Type", "application/json"}
         ]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        IO.inspect(body)
        send_resp(conn, 200, body)

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason)
    end
  end

  post "/studio" do
    query = @writerservice_url <> conn.request_path
    data = conn.body_params

    case HTTPoison.post(query, Poison.encode!(data), [
           {"Content-Type", "application/json"}
         ]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        IO.inspect(body)

        send_resp(conn, 200, body)

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason)
    end
  end

  match(_, do: send_resp(conn, 404, "Oops!\n"))
end
