(in-package #:dodge-the-creeps)

;;; The Main scene's code, from "The main game scene"

;; The Lisp object of a Main
(defstruct main
  ;; The Godot object
  object
  ;; The Mob scene, a PackedScene, exported as the property mob_scene. A
  ;; RefCounted object, so Main holds a reference to it while it's here.
  (mob-scene (ffi:make-null-pointer :void))
  score)

(defun register-main ()
  (gdext:register-class "Main" "Node"
                        :constructor (lambda (object) (make-main :object object))
                        :destructor (lambda (main) (gdext:release-reference (main-mob-scene main))))
  (gdext:bind-method "Main" "get_mob_scene" #'main-mob-scene
                     :return-type gdext-ffi:+variant-type-object+)
  (gdext:bind-method "Main" "set_mob_scene" #'set-main-mob-scene
                     :arguments `(("mob_scene" ,gdext-ffi:+variant-type-object+)))
  (gdext:bind-property "Main" "mob_scene" gdext-ffi:+variant-type-object+
                       "get_mob_scene" "set_mob_scene"
                       :hint gdext-ffi:+property-hint-resource-type+
                       :hint-string "PackedScene"
                       :property-class-name "PackedScene"))

(defun set-main-mob-scene (main mob-scene)
  (let ((old (main-mob-scene main)))
    (setf (main-mob-scene main) (gdext:add-reference mob-scene))
    (gdext:release-reference old)))
