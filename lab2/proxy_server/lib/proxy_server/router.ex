defmodule ProxyServer.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/actors" do
    query = "readerservice:8080" <> conn.request_path <> "?" <> conn.query_string

    IO.inspect(query)
    # case HTTPoison.get(query) do
    case HTTPoison.get("http://httparrot.herokuapp.com/get") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        # IO.inspect(body)

        :ets.insert_new(:user_lookup, {query, body})

        send_resp(conn, 200, body)

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        send_resp(conn, 404, "Not found.")

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason)
    end
  end

  get "/movies" do
    query = "readerservice:8080" <> conn.request_path <> "?" <> conn.query_string

    IO.inspect(query)
    # case HTTPoison.get(query) do
    case HTTPoison.get("http://httparrot.herokuapp.com/get") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        IO.inspect(body)

        :ets.insert_new(:user_lookup, {query, body})

        send_resp(conn, 200, body)

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        send_resp(conn, 404, "Not found.")

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason)
    end
  end

  post "/actors" do
    query = "readerservice:8080" <> conn.request_path <> "?" <> conn.query_string

    IO.inspect(query)
    # case HTTPoison.post(query) do
    case HTTPoison.post("http://httparrot.herokuapp.com/post", "{\"body\": \"test\"}", [
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
    query = "readerservice:8080" <> conn.request_path <> "?" <> conn.query_string

    IO.inspect(query)
    # case HTTPoison.post(query) do
    case HTTPoison.post("http://httparrot.herokuapp.com/post", "{\"body\": \"test\"}", [
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
    query = "readerservice:8080" <> conn.request_path <> "?" <> conn.query_string

    IO.inspect(query)
    # case HTTPoison.post(query) do
    case HTTPoison.post("http://httparrot.herokuapp.com/post", "{\"body\": \"test\"}", [
           {"Content-Type", "application/json"}
         ]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        IO.inspect(body)

        :ets.insert_new(
          :user_lookup,
          {conn.host, conn.method, conn.request_path, conn.query_string}
        )

        send_resp(conn, 200, body)

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason)
    end
  end

  match(_, do: send_resp(conn, 404, "Oops!\n"))
end
