(ns writer-service.core
  (:gen-class)
  (:use compojure.core
        ring.middleware.json-params)
  (:require [qbits.alia :as alia]
            [writer-service.dbutils :as dbutils]
            [clj-json.core :as json]))

(defn json-response [data & [status]]
  {:status (or status 200)
   :headers {"Content-Type" "application/json"}
   :body (json/generate-string data)})

(defn handler-factory [session]
  (defroutes handler
    (POST "/actors" [name gender age]
      (def actor_id (->> [name (dbutils/female? gender) age]
                      (dbutils/make-data :actors session)))
      ;                 (dbutils/write-to-db)))
      (json-response {"actor_id" actor_id}))

    (POST "/studios" [name movies actors]
      (def studio_id (->> [name movies actors]
                      (dbutils/make-data :studios session)))
      ;                 (dbutils/write-to-db)))
      (json-response {"studio_id" studio_id}))

    (POST "/movies" [name link length tags actors studio]
      (def movie_id (->> [name link length tags actors studio]
                      (dbutils/make-data :movies session)))
      ;                 (dbutils/write-to-db)))
      (json-response {"movie_id" movie_id}))))

; (def shutdown-cluster
;   (delay
;     (do
;       (alia/shutdown session)
;       (alia/shutdown cluster))))

(defn app-factory []
  (Thread/sleep 3000)
  (def cluster (alia/cluster {:contact-points ["scylladb1"]}))
  (def session (alia/connect cluster))
  (def app
    (-> (handler-factory session)
      wrap-json-params)))
