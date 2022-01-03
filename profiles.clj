;; https://github.com/technomancy/leiningen/blob/master/doc/PROFILES.md
{:user {:plugins [[cider/cider-nrepl "0.27.2"]
                  [lein-auto "0.1.3"] [lein-kibit "0.1.8"]     ; lein auto kibit
                  [lein-marginalia "0.9.1"]                    ; lein marg
                  [codox "0.10.8"]                             ; lein doc
                  [com.jakemccrary/lein-test-refresh "0.25.0"] ; lein test-refresh
                  [lein-ancient "0.7.0"]                       ; lein ancient check-profiles
                  [lein-cloverage "1.2.2"]
                  [lein-pprint "1.3.2"]
                  [lein-exec "0.3.7"]
                  [lein-licenses "0.2.2"]
                  [lein-try "0.4.3"]
                  [jonase/eastwood "0.9.9"]
                  [lein-cljfmt "0.8.0"]]
        :dependencies [[slamhound "1.5.5"]
                       [cljfmt "0.8.0"]
                       [org.clojure/java.classpath "1.0.0"]
                       [junegunn/inspector "0.2.0"]]
        :aliases {"slamhound" ["run" "-m" "slam.hound"]}
        :injections [(require 'inspector.core)]
        :repl-options {:init
                       (do (require 'clojure.java.javadoc)
                           (doseq [[prefix javadoc-url]
                                   {"java" "https://docs.oracle.com/javase/8/docs/api/"
                                    "org.apache.kafka" "https://kafka.apache.org/10/javadoc/"}]
                             (clojure.java.javadoc/add-remote-javadoc
                               prefix javadoc-url)))}
        :global-vars {*warn-on-reflection* true
                      ;*unchecked-math* :warn-on-boxed
                      *print-meta* false}
        :signing {:gpg-key "FEF9C627"}}}
