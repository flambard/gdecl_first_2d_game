(defsystem "dodge-the-creeps"
    :description "Godot's \"Your first 2D game\" tutorial in Common Lisp"
    :author "Markus Flambard"
    :license "MIT"
    :depends-on ("gdecl")
    :components ((:file "packages")
                 (:file "engine-methods" :depends-on ("packages"))
                 (:file "player" :depends-on ("packages" "engine-methods"))
                 (:file "mob" :depends-on ("packages" "engine-methods"))
                 (:file "hud" :depends-on ("packages" "engine-methods"))
                 (:file "main" :depends-on ("packages" "engine-methods"))
                 (:file "dodge-the-creeps" :depends-on ("packages" "player" "mob" "hud" "main"))))
