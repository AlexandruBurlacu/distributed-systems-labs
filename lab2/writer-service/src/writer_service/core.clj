(ns writer-service.core
  (:gen-class))

(require '[qbits.alia :as alia])
(require '[clojure.core.async :as async])

(defn -main
  "I don't do a whole lot ... yet."
  [& args]
  (def cluster (alia/cluster {:contact-points ["lab2_scylladb1_1"]}))
  (def session (alia/connect cluster))
  (alia/execute session "CREATE KEYSPACE alia
                         WITH replication = {'class': 'SimpleStrategy',
                                             'replication_factor' : 3};")
  (println "All is done")
  (alia/shutdown session)
  (alia/shutdown cluster)
  (println "Good bye"))
