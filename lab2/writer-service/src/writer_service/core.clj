(ns writer-service.core
  (:gen-class)
  (:use compojure.core
        ring.middleware.json-params)
  (:require [qbits.alia :as alia]
            [clojure.tools.logging :as log]
            [writer-service.dbutils :as dbutils]
            [clj-json.core :as json]))

(def cluster (alia/cluster {:contact-points ["scylladb1", "scylladb2", "scylladb3"]}))

(defn json-response [data & [status]]
  {:status (or status 200)
   :headers {"Content-Type" "application/json"}
   :body (json/generate-string data)})

(defroutes handler
  (POST "/actors" [name gender age]
    (def session (alia/connect cluster))
    (def actor_id (or (->> [name (dbutils/female? gender) age]
                  (dbutils/make-data :mock session)
                  (dbutils/write-to-db) nil))
    (alia/shutdown session))
    (json-response {"actor_id" actor_id}))

  (POST "/studios" [name movies actors]
    (def session (alia/connect cluster))
    (def studio_id (or (->> [name movies actors]
                    (dbutils/make-data :studios session)
                    (dbutils/write-to-db)) nil))
    (alia/shutdown session)
    (json-response {"studio_id" studio_id}))

  (POST "/movies" [name link length tags actors studio]
    (def session (alia/connect cluster))
    (def movie_id (or (->> [name link length tags actors studio]
                    (dbutils/make-data :movies session)
                    (dbutils/write-to-db)) nil))
    (alia/shutdown session)
    (json-response {"movie_id" movie_id})))

(def app
  (-> handler
    wrap-json-params))

