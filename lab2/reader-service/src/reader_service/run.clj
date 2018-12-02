(use 'ring.adapter.jetty)
(require '[reader-service.core :as service])

(run-jetty #'service/app {:port 8080}))
