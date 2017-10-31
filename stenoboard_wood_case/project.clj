(defproject stenoboard_wood_case "0.1.0-SNAPSHOT"
  :description "A 3D model of an alternative case for the Stenoboard Free Hardware stenography keyboard"
  :url "https://github.com/hoijui/stenoboard_wood_case"
  :license {:name "GNU General Public License"
            :url "https://www.gnu.org/licenses/gpl-3.0.en.html"}
  :dependencies [
    [org.clojure/clojure "1.8.0"]
    [scad-clj "0.5.2"]
    ]
  :main ^:skip-aot stenoboard-wood-case.core
  :target-path "target/%s"
  :profiles {:uberjar {:aot :all}})

