;; https://github.com/technomancy/leiningen/blob/master/doc/PROFILES.md
{:user {:plugins [[lein-kibit "0.0.8"]
                  [lein-licenses "0.1.1"]
                  [lein-marginalia "0.8.0"]                    ; lein marg
                  [codox "0.8.13"]                             ; lein doc
                  [com.jakemccrary/lein-test-refresh "0.10.0"] ; lein test-refresh
                  [jonase/eastwood "0.2.1"]]
        :dependencies [[slamhound "1.5.5"]]
        :aliases {"slamhound" ["run" "-m" "slam.hound"]}}}
