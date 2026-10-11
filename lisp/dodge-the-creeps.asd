(defsystem "dodge-the-creeps"
    :description "Godot's \"Your first 2D game\" tutorial in Common Lisp"
    :author "Markus Flambard"
    :license "MIT"
    :depends-on ("gdecl")
    :components ((:file "packages")
                 (:file "player" :depends-on ("packages"))
                 (:file "dodge-the-creeps" :depends-on ("packages" "player"))))
