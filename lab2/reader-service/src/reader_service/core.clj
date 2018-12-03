(ns reader-service.core
  (:gen-class)
  (:use compojure.core
        ring.middleware.json-params
        ring.middleware.params)
  (:require [clj-json.core :as json]))

; (def cluster (alia/cluster {:contact-points ["scylladb1", "scylladb2", "scylladb3"]}))

(defn json-response [data & [status]]
  {:status (or status 200)
   :headers {"Content-Type" "application/json"}
   :body (json/generate-string data)})

(defroutes handler
  (GET "/actors" req
    (let [
      name (get (:query-params req) "name")
    ]
    (json-response {"qs" name})))

  (GET "/movies" req
    (let [
      name (get (:query-params req) "name")
    ]
    (json-response {"qs" name})))
    
  (GET "/movies" req
    (let [
      tags (get (:query-params req) "tags")
    ]
    (json-response {"qs" tags})))
    
  (GET "/movies" req
    (let [
      length (get (:query-params req) "length")
    ]
    (json-response {"qs" length}))))

(def app
  (-> handler
    wrap-params
    wrap-json-params))
