(ns writer-service.core
  (:gen-class)
  (:use compojure.core
        ring.middleware.json-params)
  (:require [qbits.alia :as alia]
            [clojure.tools.logging :as log]
            [writer-service.dbutils :as dbutils]
            [clj-json.core :as json]))

(defn json-response [data & [status]]
  {:status (or status 200)
   :headers {"Content-Type" "application/json"}
   :body (json/generate-string data)})

(defn handler-factory [session]
  (defroutes handler
    (POST "/actors" [name gender age]
      (log/info [name gender age])
      (def actor_id (->> [name (dbutils/female? gender) age]
                      (dbutils/make-data :actors session)))
      ;                 (dbutils/write-to-db)))
      (log/info actor_id)
      (json-response {"actor_id" actor_id}))

    (POST "/studios" [name movies actors]
      (log/info [name movies actors])
      (def studio_id (->> [name movies actors]
                      (dbutils/make-data :studios session)))
      ;                 (dbutils/write-to-db)))
      (log/info studio_id)
      (json-response {"studio_id" studio_id}))

    (POST "/movies" [name link length tags actors studio]
      (log/info [name link length tags actors studio])
      (def movie_id (->> [name link length tags actors studio]
                      (dbutils/make-data :movies session)))
      ;                 (dbutils/write-to-db)))
      (log/info movie_id)
      (json-response {"movie_id" movie_id}))))

; (def shutdown-cluster
;   (delay
;     (do
;       (alia/shutdown session)
;       (alia/shutdown cluster))))

(defn app-factory []
  (def cluster (alia/cluster {:contact-points ["scylladb1"]}))
  (def session (alia/connect cluster))
  (def app
    (-> (handler-factory session)
      wrap-json-params)))

(defn -main [& args]
  (def cluster (alia/cluster {:contact-points ["lab2_scylladb1_1"]}))
  (def session (alia/connect cluster))
  (print "Everything fuckin works now...")
  (alia/shutdown session)
  (alia/shutdown cluster))
