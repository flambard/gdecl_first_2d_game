(in-package #:dodge-the-creeps)

;;; The Player scene's code, from "Coding the player"

;; extends Area2D
;;
;; signal hit
;;
;; @export var speed = 400 # How fast the player will move (pixels/sec).
;; var screen_size # Size of the game window.

;; Player is a CLOS class, defined with GODOT-CLOS: its Lisp objects are
;; instances of PLAYER, and what Godot calls are generic functions
(defclass player (area-2d)
  (;; How fast the player will move (pixels/sec).
   (speed :initform 400 :export :int :reader player-speed)
   ;; Size of the game window
   (screen-size :accessor player-screen-size)
   ;; The child nodes AnimatedSprite2D and CollisionShape2D
   (animated-sprite :onready "AnimatedSprite2D" :reader player-animated-sprite)
   (collision-shape :onready "CollisionShape2D" :reader player-collision-shape))
  (:metaclass godot-class)
  (:signals (hit)))

(define-godot-generic start (self (pos :vector2)))

;; Connected to the signal body_entered in player.tscn
(define-godot-generic on-body-entered (self (body :object))
  (:godot-name "_on_body_entered"))

;; func _ready():
;;     screen_size = get_viewport_rect().size
;;     hide()
(defmethod ready ((player player))
  (setf (player-screen-size player) (rect2-size (canvas-item-get-viewport-rect player)))
  (canvas-item-hide player))

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
(defmethod process ((player player) delta)
  (let ((velocity (vector2))            ; The player's movement vector
        (sprite (player-animated-sprite player)))
    (when (input-is-action-pressed "move_right")
      (incf (vector2-x velocity)))
    (when (input-is-action-pressed "move_left")
      (decf (vector2-x velocity)))
    (when (input-is-action-pressed "move_down")
      (incf (vector2-y velocity)))
    (when (input-is-action-pressed "move_up")
      (decf (vector2-y velocity)))
    (cond ((> (vector2-length velocity) 0)
           (setf velocity (vector2* (vector2-normalized velocity) (player-speed player)))
           (animated-sprite-2d-play sprite))
          (t
           (animated-sprite-2d-stop sprite)))
    (node-2d-set-position player
                          (vector2-clamp (vector2+ (node-2d-get-position player)
                                                   (vector2* velocity delta))
                                         (vector2)
                                         (player-screen-size player)))
    (cond ((/= (vector2-x velocity) 0)
           (animated-sprite-2d-set-animation sprite "walk")
           (animated-sprite-2d-set-flip-v sprite nil)
           (animated-sprite-2d-set-flip-h sprite (< (vector2-x velocity) 0)))
          ((/= (vector2-y velocity) 0)
           (animated-sprite-2d-set-animation sprite "up")
           (animated-sprite-2d-set-flip-v sprite (> (vector2-y velocity) 0))))))

;; func _on_body_entered(_body):
;;     hide() # Player disappears after being hit.
;;     hit.emit()
;;     # Must be deferred as we can't change physics properties on a physics callback.
;;     $CollisionShape2D.set_deferred("disabled", true)
(defmethod on-body-entered ((player player) body)
  (declare (ignore body))
  (canvas-item-hide player)             ; Player disappears after being hit.
  (object-emit-signal player "hit")
  ;; Must be deferred as we can't change physics properties on a physics callback.
  (object-set-deferred (player-collision-shape player) "disabled" t))

;; func start(pos):
;;     position = pos
;;     show()
;;     $CollisionShape2D.disabled = false
(defmethod start ((player player) pos)
  (node-2d-set-position player pos)
  (canvas-item-show player)
  (collision-shape-2d-set-disabled (player-collision-shape player) nil))
