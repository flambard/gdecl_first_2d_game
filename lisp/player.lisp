(in-package #:dodge-the-creeps)

;;; The Player scene's code, from "Coding the player"

;; extends Area2D
;;
;; signal hit
;;
;; @export var speed = 400 # How fast the player will move (pixels/sec).
;; var screen_size # Size of the game window.

;; The Lisp object of a Player
(defstruct player
  ;; The Godot object
  object
  ;; How fast the player will move (pixels/sec). Exported as the property speed.
  (speed 400)
  ;; Size of the game window
  screen-size
  ;; The child nodes AnimatedSprite2D and CollisionShape2D, set in _ready like
  ;; @onready vars
  animated-sprite
  collision-shape)

(defun register-player ()
  (gdext:register-class "Player" "Area2D"
                        :constructor (lambda (object) (make-player :object object)))
  (gdext:bind-method "Player" "get_speed" #'player-speed
                     :return-type :int)
  (gdext:bind-method "Player" "set_speed"
                     (lambda (player speed) (setf (player-speed player) speed))
                     :arguments '(("speed" :int)))
  (gdext:bind-property "Player" "speed" :int "get_speed" "set_speed")
  (gdext:bind-signal "Player" "hit")
  (gdext:bind-method "Player" "start" #'player-start
                     :arguments '(("pos" :vector2)))
  (gdext:bind-method "Player" "_on_body_entered" #'player-on-body-entered
                     :arguments '(("body" :object)))
  (gdext:bind-virtual "Player" "_ready" #'player-ready)
  (gdext:bind-virtual "Player" "_process" #'player-process))

;; func _ready():
;;     screen_size = get_viewport_rect().size
;;     hide()
(defun player-ready (player)
  (setf (player-screen-size player)
        (gdext:rect2-size (get-viewport-rect (player-object player)))
        (player-animated-sprite player)
        (get-node (player-object player) "AnimatedSprite2D")
        (player-collision-shape player)
        (get-node (player-object player) "CollisionShape2D"))
  (hide (player-object player)))

(defun action-pressed-p (action)
  (is-action-pressed (gdext:singleton "Input") action))

;; func _process(delta):
;;     var velocity = Vector2.ZERO # The player's movement vector.
;;     if Input.is_action_pressed("move_right"):
;;         velocity.x += 1
;;     if Input.is_action_pressed("move_left"):
;;         velocity.x -= 1
;;     if Input.is_action_pressed("move_down"):
;;         velocity.y += 1
;;     if Input.is_action_pressed("move_up"):
;;         velocity.y -= 1
;;
;;     if velocity.length() > 0:
;;         velocity = velocity.normalized() * speed
;;         $AnimatedSprite2D.play()
;;     else:
;;         $AnimatedSprite2D.stop()
;;
;;     position += velocity * delta
;;     position = position.clamp(Vector2.ZERO, screen_size)
;;
;;     if velocity.x != 0:
;;         $AnimatedSprite2D.animation = "walk"
;;         $AnimatedSprite2D.flip_v = false
;;         # See the note below about the following boolean assignment.
;;         $AnimatedSprite2D.flip_h = velocity.x < 0
;;     elif velocity.y != 0:
;;         $AnimatedSprite2D.animation = "up"
;;         $AnimatedSprite2D.flip_v = velocity.y > 0
(defun player-process (player delta)
  (let ((velocity (gdext:vector2))      ; The player's movement vector
        (object (player-object player))
        (sprite (player-animated-sprite player)))
    (when (action-pressed-p (gdext:sname "move_right"))
      (incf (gdext:vector2-x velocity)))
    (when (action-pressed-p (gdext:sname "move_left"))
      (decf (gdext:vector2-x velocity)))
    (when (action-pressed-p (gdext:sname "move_down"))
      (incf (gdext:vector2-y velocity)))
    (when (action-pressed-p (gdext:sname "move_up"))
      (decf (gdext:vector2-y velocity)))
    (cond ((> (gdext:vector2-length velocity) 0)
           (setf velocity (gdext:vector2* (gdext:vector2-normalized velocity)
                                          (player-speed player)))
           (animated-sprite-2d-play sprite))
          (t
           (animated-sprite-2d-stop sprite)))
    (set-position object (gdext:vector2-clamp (gdext:vector2+ (get-position object)
                                                              (gdext:vector2* velocity delta))
                                              (gdext:vector2)
                                              (player-screen-size player)))
    (cond ((/= (gdext:vector2-x velocity) 0)
           (animated-sprite-2d-set-animation sprite "walk")
           (animated-sprite-2d-set-flip-v sprite nil)
           (animated-sprite-2d-set-flip-h sprite (< (gdext:vector2-x velocity) 0)))
          ((/= (gdext:vector2-y velocity) 0)
           (animated-sprite-2d-set-animation sprite "up")
           (animated-sprite-2d-set-flip-v sprite (> (gdext:vector2-y velocity) 0))))))

;; func _on_body_entered(_body):
;;     hide() # Player disappears after being hit.
;;     hit.emit()
;;     # Must be deferred as we can't change physics properties on a physics callback.
;;     $CollisionShape2D.set_deferred("disabled", true)
(defun player-on-body-entered (player body)
  (declare (ignore body))
  (let ((object (player-object player)))
    (hide object)                       ; Player disappears after being hit.
    (emit-signal object "hit")
    ;; Must be deferred as we can't change physics properties on a physics callback.
    (set-deferred (player-collision-shape player) "disabled" t)))

;; func start(pos):
;;     position = pos
;;     show()
;;     $CollisionShape2D.disabled = false
(defun player-start (player pos)
  (let ((object (player-object player)))
    (set-position object pos)
    (show object)
    (collision-shape-2d-set-disabled (player-collision-shape player) nil)))
