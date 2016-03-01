(require '[clojure.java.io])
(require '[clojure.reflect])
(require '[clojure.pprint :refer [pprint print-table]])

(defmacro with-filter
  [command & forms]
  `(let [sh#  (or (System/getenv "SHELL") "sh")
         pb#  (doto (ProcessBuilder. [sh# "-c" ~command])
                (.redirectError
                  (java.lang.ProcessBuilder$Redirect/to (clojure.java.io/file "/dev/tty"))))
         p#   (.start pb#)
         in#  (clojure.java.io/reader (.getInputStream p#))
         out# (clojure.java.io/writer (.getOutputStream p#))]
     (binding [*out* out#]
       (try ~@forms (.close out#) (catch Exception e#)))
     (take-while identity (repeatedly #(.readLine in#)))))

(defmacro do-pprint
  [& body]
  `(do
     ~@(map (fn [form]
              `(let [result# ~form]
                 (pprint (list (symbol "=") '~form result#))
                 result#))
            body)))

(defn print-members
  [obj]
  (print-table (->> obj
                    clojure.reflect/reflect
                    :members
                    (filter (every-pred :exception-types :return-type))
                    (sort-by :name)
                    (map #(select-keys % [:name :parameter-types :return-type])))))

(defn fns
  []
  (if-let [selected
           (first (with-filter "fzf-tmux +m"
                    (doseq [n (->> (all-ns) (map #(.getName %)) sort)]
                      (println n))))]
    (in-ns (symbol selected))))
