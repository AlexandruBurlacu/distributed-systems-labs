(use 'ring.adapter.jetty)
(require '[writer-service.core :as service])

(def app (service/app-factory))

(run-jetty #'app {:port 8080})
