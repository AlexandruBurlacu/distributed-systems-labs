(ns reader-service.core
  (:gen-class))

; (require '[qbits.alia :as alia])
; (require '[clojure.core.async :as async])

; (defn -main
;   "I don't do a whole lot ... yet."
;   [& args]
;   (def cluster (alia/cluster {:contact-points ["lab2_scylladb1_1"]}))
;   (def session (alia/connect cluster))
;   (println "All is done")
;   (alia/shutdown session)
;   (alia/shutdown cluster)
;   (println "Good bye"))

(use compojure.core)
(use ring.middleware.json-params)
(require '[clj-json.core :as json])

(defn json-response [data & [status]]
  {:status (or status 200)
   :headers {"Content-Type" "application/json"}
   :body (json/generate-string data)})

(defroutes handler
  (GET "/" []
    (json-response {"hello" "world"}))

  (PUT "/" [name]
    (json-response {"hello" name})))

(def app
  (-> handler
    wrap-json-params))
