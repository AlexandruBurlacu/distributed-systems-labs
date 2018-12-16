defmodule ProxyServer.LoadBalancer do
  # @readerservice_urls ["readerservice1:8080", "readerservice2:8080", "readerservice3:8080"]
  @readerservice_urls ["readerservice:8080"]
  @num_of_urls 1

  def init do
    Agent.start_link(fn -> {@readerservice_urls, 0} end, name: :ProxyServerLoadBalancer)
    IO.puts "Load Balancer is up and running..."
  end

  def get_readerservice_url do
    Agent.get_and_update(:ProxyServerLoadBalancer, fn {urls, counter} -> {
      Enum.at(urls, (rem counter, @num_of_urls)), {urls, counter + 1}
    } end)
  end
end
