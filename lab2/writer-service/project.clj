(defproject writer-service "0.1.0"
  :description "Reader REST service. Component of the Data Warehouse System"
  :url "http://example.com/FIXME"
  :license {:name "Eclipse Public License"
            :url "http://www.eclipse.org/legal/epl-v10.html"}
  :dependencies [
                 [org.clojure/clojure "1.8.0"]
                 [org.clojure/core.async "0.4.474"]
                 [cc.qbits/alia "4.3.0"]
                 [ring/ring-jetty-adapter "0.2.5"]
                 [ring-json-params "0.1.0"]
                 [compojure "0.4.0"]
                 [clj-json "0.2.0"]
                 ]
  :main ^:skip-aot writer-service.core
  :target-path "target/%s"
  :profiles {:uberjar {:aot :all}})