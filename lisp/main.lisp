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
                       :property-class-name "PackedScene")
  (gdext:bind-method "Main" "game_over" #'main-game-over)
  (gdext:bind-method "Main" "new_game" #'main-new-game)
  (gdext:bind-method "Main" "_on_score_timer_timeout" #'main-on-score-timer-timeout)
  (gdext:bind-method "Main" "_on_start_timer_timeout" #'main-on-start-timer-timeout))

(defun set-main-mob-scene (main mob-scene)
  (let ((old (main-mob-scene main)))
    (setf (main-mob-scene main) (gdext:add-reference mob-scene))
    (gdext:release-reference old)))

(defun main-game-over (main)
  (let ((object (main-object main)))
    (timer-stop (get-node object (gdext:npath "ScoreTimer")))
    (timer-stop (get-node object (gdext:npath "MobTimer")))))

(defun main-new-game (main)
  (let ((object (main-object main)))
    (setf (main-score main) 0)
    (player-start (gdext:lisp-object (get-node object (gdext:npath "Player")))
                  (get-position (get-node object (gdext:npath "StartPosition"))))
    (timer-start (get-node object (gdext:npath "StartTimer")))))

(defun main-on-score-timer-timeout (main)
  (incf (main-score main)))

(defun main-on-start-timer-timeout (main)
  (let ((object (main-object main)))
    (timer-start (get-node object (gdext:npath "MobTimer")))
    (timer-start (get-node object (gdext:npath "ScoreTimer")))))
