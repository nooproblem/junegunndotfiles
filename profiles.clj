;; https://github.com/technomancy/leiningen/blob/master/doc/PROFILES.md
{:user {:plugins [[cider/cider-nrepl "0.14.0"]
                  [lein-auto "0.1.3"] [lein-kibit "0.1.3"]     ; lein auto kibit
                  [lein-marginalia "0.9.0"]                    ; lein marg
                  [codox "0.8.13"]                             ; lein doc
                  [com.jakemccrary/lein-test-refresh "0.18.1"] ; lein test-refresh
                  [lein-ancient "0.6.10"]
                  [lein-pprint "1.1.2"]
                  [lein-exec "0.3.5"]
                  [lein-licenses "0.2.1"]
                  [lein-try "0.4.3"]
                  [jonase/eastwood "0.2.1"]
                  [lein-cljfmt "0.5.6"]]
        :dependencies [[slamhound "1.5.5"]
                       [cljfmt "0.5.6"]
                       [com.cemerick/pomegranate "0.3.1"]
                       [org.clojure/java.classpath "0.2.3"]]
        :aliases {"slamhound" ["run" "-m" "slam.hound"]}
        :source-paths [#=(str #=(java.lang.System/getProperty "user.home")
                              "/.lein/src")]
        :injections [(require 'jg)]
        :repl-options {:init
                       (do (require 'clojure.java.javadoc)
                           (doseq [[prefix javadoc-url]
                                   {"java" "https://docs.oracle.com/javase/8/docs/api/"
                                    "org.apache.kafka" "https://kafka.apache.org/0101/javadoc/"}]
                             (clojure.java.javadoc/add-remote-javadoc
                               prefix javadoc-url)))}
        :global-vars {*warn-on-reflection* true
                      ;*unchecked-math* :warn-on-boxed
                      *print-meta* false}
        :signing {:gpg-key "FEF9C627"}}}
