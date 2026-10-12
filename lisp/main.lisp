(in-package #:dodge-the-creeps)

;;; The Main scene's code, from "The main game scene"

;; extends Node
;;
;; @export var mob_scene: PackedScene
;; var score

;; The Lisp object of a Main is a MAIN
(gdext:define-class main ("Main" "Node")
  (;; The Mob scene. A PackedScene is RefCounted, so Main keeps a reference to it.
   (mob-scene nil :export :object :class "PackedScene")
   score)
  (:method "game_over" main-game-over)
  (:method "new_game" main-new-game)
  (:method "_on_score_timer_timeout" main-on-score-timer-timeout)
  (:method "_on_start_timer_timeout" main-on-start-timer-timeout)
  (:method "_on_mob_timer_timeout" main-on-mob-timer-timeout))

;; func game_over():
;;     $ScoreTimer.stop()
;;     $MobTimer.stop()
;;     $HUD.show_game_over()
;;     $Music.stop()
;;     $DeathSound.play()
(defun main-game-over (main)
  (timer-stop (node-get-node main "ScoreTimer"))
  (timer-stop (node-get-node main "MobTimer"))
  (hud-show-game-over (node-get-node main "HUD"))
  (audio-stream-player-stop (node-get-node main "Music"))
  (audio-stream-player-play (node-get-node main "DeathSound")))

;; func new_game():
;;     score = 0
;;     $Player.start($StartPosition.position)
;;     $StartTimer.start()
;;     $HUD.update_score(score)
;;     $HUD.show_message("Get Ready")
;;     get_tree().call_group("mobs", "queue_free")
;;     $Music.play()
(defun main-new-game (main)
  (setf (main-score main) 0)
  (player-start (node-get-node main "Player")
                (node-2d-get-position (node-get-node main "StartPosition")))
  (timer-start (node-get-node main "StartTimer"))
  (let ((hud (node-get-node main "HUD")))
    (hud-update-score hud (main-score main))
    (hud-show-message hud "Get Ready"))
  (scene-tree-call-group (node-get-tree main) "mobs" "queue_free")
  (audio-stream-player-play (node-get-node main "Music")))

;; func _on_score_timer_timeout():
;;     score += 1
;;     $HUD.update_score(score)
(defun main-on-score-timer-timeout (main)
  (incf (main-score main))
  (hud-update-score (node-get-node main "HUD") (main-score main)))

;; func _on_start_timer_timeout():
;;     $MobTimer.start()
;;     $ScoreTimer.start()
(defun main-on-start-timer-timeout (main)
  (timer-start (node-get-node main "MobTimer"))
  (timer-start (node-get-node main "ScoreTimer")))

(defun randf-range (from to)
  "A random float between FROM and TO, like randf_range() in GDScript."
  (+ from (random (float (- to from) 1d0))))

;; func _on_mob_timer_timeout():
;;     # Create a new instance of the Mob scene.
;;     var mob = mob_scene.instantiate()
;;
;;     # Choose a random location on Path2D.
;;     var mob_spawn_location = $MobPath/MobSpawnLocation
;;     mob_spawn_location.progress_ratio = randf()
;;
;;     # Set the mob's position to the random location.
;;     mob.position = mob_spawn_location.position
;;
;;     # Set the mob's direction perpendicular to the path direction.
;;     var direction = mob_spawn_location.rotation + PI / 2
;;
;;     # Add some randomness to the direction.
;;     direction += randf_range(-PI / 4, PI / 4)
;;     mob.rotation = direction
;;
;;     # Choose the velocity for the mob.
;;     var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
;;     mob.linear_velocity = velocity.rotated(direction)
;;
;;     # Spawn the mob by adding it to the Main scene.
;;     add_child(mob)
(defun main-on-mob-timer-timeout (main)
  (let (;; Create a new instance of the Mob scene.
        (mob (packed-scene-instantiate (main-mob-scene main)))
        (mob-spawn-location (node-get-node main "MobPath/MobSpawnLocation")))
    ;; Choose a random location on Path2D.
    (path-follow-2d-set-progress-ratio mob-spawn-location (random 1d0))
    ;; Set the mob's position to the random location.
    (node-2d-set-position mob (node-2d-get-position mob-spawn-location))
    ;; Set the mob's direction perpendicular to the path direction.
    (let ((direction (+ (node-2d-get-rotation mob-spawn-location) (/ pi 2))))
      ;; Add some randomness to the direction.
      (incf direction (randf-range (- (/ pi 4)) (/ pi 4)))
      (node-2d-set-rotation mob direction)
      ;; Choose the velocity for the mob.
      (let ((velocity (vector2 (float (randf-range 150 250) 1.0) 0.0)))
        (rigid-body-2d-set-linear-velocity mob (vector2-rotated velocity direction))))
    ;; Spawn the mob by adding it to the Main scene.
    (node-add-child main mob)))
