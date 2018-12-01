(use 'ring.adapter.jetty)
(require '[writer-service.core :as service])

(run-jetty #'service/app {:port 8080})
