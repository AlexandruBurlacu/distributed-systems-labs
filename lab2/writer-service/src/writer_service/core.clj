(ns writer-service.core
  (:gen-class))

(require '[qbits.alia :as alia])
(require '[clojure.core.async :as async])

(defmulti write-to-db :table)
;; The `data` should be a dict
;; with top-level pair :table {:actors, :movies, :studios}

(defmethod write-to-db :actors [data]
  (def session (:sess data))
  (def prepared-statement
    (alia/prepare session "INSERT INTO porndb.actors
                           (actor_id, name, is_female, age)
                           VALUES (uuid(), :name, :is_female, :age);"))
  (alia/execute session prepared-statement {:values (:content data)}))

(defmethod write-to-db :studios [data]
  (def session (:sess data))
  (def prepared-statement
    (alia/prepare session "INSERT INTO porndb.studios
                           (studio_id, name, movies, actors)
                           VALUES (uuid(), :name, :movies, :actors);"))
  (alia/execute session prepared-statement {:values (:content data)}))

(defmethod write-to-db :movies [data]
  (def session (:sess data))
  (def prepared-statement
    (alia/prepare session "INSERT INTO porndb.movies
                           (movie_id, name, link, length, tags, actors, studio)
                           VALUES (uuid(), :name, :link, :length, :tags, :actors, :studio);"))
  (alia/execute session prepared-statement {:values (:content data)}))

(defn -main
  [& args]
  (def cluster (alia/cluster {:contact-points ["lab2_scylladb1_1"]}))
  (def session (alia/connect cluster))
  (println "All is done")
  (alia/shutdown session)
  (alia/shutdown cluster)
  (println "Good bye"))
