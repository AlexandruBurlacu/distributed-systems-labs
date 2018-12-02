(ns writer-service.dbutils
  (:gen-class)
  (:require [qbits.alia :as alia]))

(defn female? [gender]
  (if (= gender "male") false true))

(defn make-data [type session values-list]
  {:table type :sess session :content values-list})

(defmulti write-to-db :table)
;; The `data` should be a dict
;; with top-level pair :table {:actors, :movies, :studios}

(defmethod write-to-db :actors [data]
  (def session (:sess data))
  (def prepared-statement
    (alia/prepare session "INSERT INTO porndb.actors
                           (actor_id, name, is_female, age)
                           VALUES (uuid(), ?, ?, ?);"))
  (alia/execute session prepared-statement {:values (:content data)}))

(defmethod write-to-db :studios [data]
  (def session (:sess data))
  (def prepared-statement
    (alia/prepare session "INSERT INTO porndb.studios
                           (studio_id, name, movies, actors)
                           VALUES (uuid(), ?, ?, ?);"))
  (alia/execute session prepared-statement {:values (:content data)}))

(defmethod write-to-db :movies [data]
  (def session (:sess data))
  (def prepared-statement
    (alia/prepare session "INSERT INTO porndb.movies
                           (movie_id, name, link, length, tags, actors, studio)
                           VALUES (uuid(), ?, ?, ?, ?, ?, ?);"))
  (alia/execute session prepared-statement {:values (:content data)}))

