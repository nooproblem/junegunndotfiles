;; https://github.com/technomancy/leiningen/blob/master/doc/PROFILES.md
{:user {:plugins [[cider/cider-nrepl "0.9.1"]
                  [lein-kibit "0.0.8"]
                  [lein-licenses "0.1.1"]
                  [lein-marginalia "0.8.0"]                    ; lein marg
                  [codox "0.8.13"]                             ; lein doc
                  [com.jakemccrary/lein-test-refresh "0.10.0"] ; lein test-refresh
                  [lein-pprint "1.1.2"]
                  [lein-exec "0.3.5"]
                  [lein-licenses "0.2.0"]
                  [lein-try "0.4.3"]
                  [jonase/eastwood "0.2.1"]]
        :dependencies [[slamhound "1.5.5"]
                       [spyscope "0.1.5"]]
        :aliases {"slamhound" ["run" "-m" "slam.hound"]}
        :source-paths [#=(str #=(java.lang.System/getProperty "user.home")
                              "/.lein/src")]
        :injections [(require 'jg)
                     (require 'spyscope.core)
                     (refer-clojure)]
        :global-vars {*warn-on-reflection* true
                      ;*unchecked-math* :warn-on-boxed
                      *print-meta* false}
        :signing {:gpg-key "FEF9C627"}}}
