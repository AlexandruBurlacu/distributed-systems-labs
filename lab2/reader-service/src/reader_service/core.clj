(ns reader-service.core
  (:gen-class)
  (:use compojure.core
        ring.middleware.json-params
        ring.middleware.params)
  (:require [qbits.alia :as alia]
            [clj-json.core :as json]))

(def cluster (alia/cluster {:contact-points ["scylladb1", "scylladb2", "scylladb3"]}))

(defn json-response [data & [status]]
  {:status (or status 200)
   :headers {"Content-Type" "application/json"}
   :body (json/generate-string data)})

(defroutes handler
  (GET "/actors" req
    (let [
      name (get (:query-params req) "name")
    ]
    (def session (alia/connect cluster))
    (println name)
    (def resp
      (cond
        (some? name) (do
                       (def prepared-statement
                         (alia/prepare session "SELECT * FROM porndb.actors
                                           WHERE name=? ALLOW FILTERING ;"))
                       (alia/execute session prepared-statement {:values name}))
        :else (alia/execute session "SELECT * FROM porndb.actors ;")))
    (alia/shutdown session)
    (json-response {"resp" resp})))

  (GET "/movies" req
    (let [
      name (get (:query-params req) "name")
      length (get (:query-params req) "length")
    ]
    (def session (alia/connect cluster))
    (println name)
    (println length)
    (def resp
      (cond
        (some? name) (do
                       (def prepared-statement
                         (alia/prepare session "SELECT * FROM porndb.movies
                                                WHERE name=? ALLOW FILTERING ;"))
                       (alia/execute session prepared-statement {:values name}))
        (some? length) (do
                         (def prepared-statement
                           (alia/prepare session "SELECT * FROM porndb.movies
                                                  WHERE length=? ALLOW FILTERING ;"))
                         (alia/execute session prepared-statement {:values length}))
        :else (alia/execute session "SELECT * FROM porndb.movies ;")))
    (alia/shutdown session)
    (json-response {"resp" resp}))))

(def app
  (-> handler
    wrap-params
    wrap-json-params))
