# Lab2: Data Warehouse Services

For this laboratory work we were asked to develop a data warehouse (DW). The requirements are the following:
- It should be resilient -> at least 2 replicas for the data warehouse related services (Reader and Writer in our case)
- It should be able to return information in both XML and JSON
- It has to have a partition tolerant (preferably NoSQL) database as it's backbone

Given the above requirments, we are developing:
- A Proxy service, that will do caching, connection pooling and reuse, load balancing, and will ensure transparent access to the Reader and Writer services. Also it will be responsible for XML/JSON formating, done in Elixir. For caching will be used either ETS (Erlang Term Storage) or Redis.
- A Reader service, only HTTP GET requests, will read from the database, done in Clojure.
- A Writer service, only HTTP POST requests, will write to the database, done in Clojure.
- As the underlying database, the ScyllaDB was selected, as a much more resource efficient alternative to Cassandra. A cluser of 3 ScyllaDB nodes is used.

P.S. The DW will deliver porn-related reports :smile:

# Links
[rest](https://mmcgrana.github.io/2010/08/clojure-rest-api.html)
[alia](https://github.com/mpenet/alia)
[debugging](https://stackoverflow.com/questions/2352020/debugging-in-clojure)
