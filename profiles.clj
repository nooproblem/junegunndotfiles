;; https://github.com/technomancy/leiningen/blob/master/doc/PROFILES.md
{:user {:plugins [[lein-kibit "0.0.8"]
                  [lein-licenses "0.1.1"]]
        :dependencies [[slamhound "1.5.5"]]
        :aliases {"slamhound" ["run" "-m" "slam.hound"]}}}
