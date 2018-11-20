(ns reader-service.run
  (:gen-class))

(use 'ring.adapter.jetty)
(require '[reader-service.core :as service])

(defn -main
  [& args]
  (run-jetty #'service/app {:port 8080}))
