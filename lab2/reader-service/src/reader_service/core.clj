(ns reader-service.core
  (:use compojure.core)
  (:use ring.middleware.json-params)
  (:require [compojure.api.sweet :refer :all])
  (:require [clj-json.core :as json]))

(defn json-response [data & [status]]
  {:status (or status 200)
   :headers {"Content-Type" "application/json"}
   :body (json/generate-string data)})

(defroutes handler
  (GET "/actors" req ;; {params :params}
    (json-response {"qs" req}))

  (GET "/movies" [] :query-params [
                                {name :- String ""}
                                {tags :- list []}
                                {tags :- symbol :small}
                               ]
    (json-response {"qs" req})))

(def app
  (-> handler
    wrap-json-params))
