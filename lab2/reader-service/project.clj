(defproject reader-service "0.1.0"
  :description "Reader REST service. Component of the Data Warehouse System"
  :url "http://example.com/FIXME"
  :license {:name "Eclipse Public License"
            :url "http://www.eclipse.org/legal/epl-v10.html"}
  :dependencies [
                 [org.clojure/clojure "1.8.0"]
                 [org.clojure/core.async "0.4.474"]
                 [cc.qbits/alia "4.3.0"]
                 [ring "1.7.1"]
                 [compojure "1.6.0"]
                 [clj-json "0.2.0"]
                 ]
  :main ^:skip-aot reader-service.core
  :target-path "target/%s"
  :profiles {:uberjar {:aot :all}})