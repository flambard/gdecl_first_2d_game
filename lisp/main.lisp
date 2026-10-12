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
  (gdext:bind-method "Main" "_on_start_timer_timeout" #'main-on-start-timer-timeout)
  (gdext:bind-method "Main" "_on_mob_timer_timeout" #'main-on-mob-timer-timeout))

;;; The HUD's Lisp object is its Godot object, so the HUD functions are called
;;; with the node itself.

(defun set-main-mob-scene (main mob-scene)
  (let ((old (main-mob-scene main)))
    (setf (main-mob-scene main) (gdext:add-reference mob-scene))
    (gdext:release-reference old)))

(defun main-game-over (main)
  (let ((object (main-object main)))
    (timer-stop (get-node object (gdext:npath "ScoreTimer")))
    (timer-stop (get-node object (gdext:npath "MobTimer")))
    (hud-show-game-over (get-node object (gdext:npath "HUD")))))

(defun main-new-game (main)
  (let ((object (main-object main)))
    (setf (main-score main) 0)
    (player-start (gdext:lisp-object (get-node object (gdext:npath "Player")))
                  (get-position (get-node object (gdext:npath "StartPosition"))))
    (timer-start (get-node object (gdext:npath "StartTimer")))
    (let ((hud (get-node object (gdext:npath "HUD"))))
      (hud-update-score hud (main-score main))
      (hud-show-message hud "Get Ready"))))

(defun main-on-score-timer-timeout (main)
  (incf (main-score main))
  (hud-update-score (get-node (main-object main) (gdext:npath "HUD")) (main-score main)))

(defun main-on-start-timer-timeout (main)
  (let ((object (main-object main)))
    (timer-start (get-node object (gdext:npath "MobTimer")))
    (timer-start (get-node object (gdext:npath "ScoreTimer")))))

(defun randf-range (from to)
  "A random float between FROM and TO, like randf_range() in GDScript."
  (+ from (random (float (- to from) 1d0))))

(defun main-on-mob-timer-timeout (main)
  (let* ((object (main-object main))
         ;; Create a new instance of the Mob scene.
         (mob (packed-scene-instantiate (main-mob-scene main)))
         (mob-spawn-location (get-node object (gdext:npath "MobPath/MobSpawnLocation"))))
    ;; Choose a random location on Path2D.
    (path-follow-2d-set-progress-ratio mob-spawn-location (random 1d0))
    ;; Set the mob's position to the random location.
    (set-position mob (get-position mob-spawn-location))
    ;; Set the mob's direction perpendicular to the path direction.
    (let ((direction (+ (get-rotation mob-spawn-location) (/ pi 2))))
      ;; Add some randomness to the direction.
      (incf direction (randf-range (- (/ pi 4)) (/ pi 4)))
      (set-rotation mob direction)
      ;; Choose the velocity for the mob.
      (let ((velocity (gdext:vector2 (float (randf-range 150 250) 1.0) 0.0)))
        (rigid-body-2d-set-linear-velocity mob (gdext:vector2-rotated velocity direction))))
    ;; Spawn the mob by adding it to the Main scene.
    (add-child object mob)))
