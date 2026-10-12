(in-package #:dodge-the-creeps)

;;; The Player scene's code, from "Coding the player"

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
                     :return-type gdext-ffi:+variant-type-int+)
  (gdext:bind-method "Player" "set_speed"
                     (lambda (player speed) (setf (player-speed player) speed))
                     :arguments `(("speed" ,gdext-ffi:+variant-type-int+)))
  (gdext:bind-property "Player" "speed" gdext-ffi:+variant-type-int+ "get_speed" "set_speed")
  (gdext:bind-signal "Player" "hit")
  (gdext:bind-method "Player" "start" #'player-start
                     :arguments `(("pos" ,gdext-ffi:+variant-type-vector2+)))
  (gdext:bind-method "Player" "_on_body_entered" #'player-on-body-entered
                     :arguments `(("body" ,gdext-ffi:+variant-type-object+)))
  (gdext:bind-virtual "Player" "_ready" #'player-ready)
  (gdext:bind-virtual "Player" "_process" #'player-process
                      :arguments `(("delta" ,gdext-ffi:+variant-type-float+))))

(defun player-ready (player)
  (setf (player-screen-size player)
        (gdext:rect2-size (get-viewport-rect (player-object player)))
        (player-animated-sprite player)
        (get-node (player-object player) (gdext:npath "AnimatedSprite2D"))
        (player-collision-shape player)
        (get-node (player-object player) (gdext:npath "CollisionShape2D")))
  (hide (player-object player)))

(defun action-pressed-p (action)
  (is-action-pressed (gdext:singleton "Input") action))

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
           (animated-sprite-2d-set-animation sprite (gdext:sname "walk"))
           (animated-sprite-2d-set-flip-v sprite nil)
           (animated-sprite-2d-set-flip-h sprite (< (gdext:vector2-x velocity) 0)))
          ((/= (gdext:vector2-y velocity) 0)
           (animated-sprite-2d-set-animation sprite (gdext:sname "up"))
           (animated-sprite-2d-set-flip-v sprite (> (gdext:vector2-y velocity) 0))))))

(defun player-on-body-entered (player body)
  (declare (ignore body))
  (let ((object (player-object player)))
    (hide object)                       ; Player disappears after being hit.
    (emit-signal object (gdext:sname "hit"))
    ;; Must be deferred as we can't change physics properties on a physics callback.
    (set-deferred (player-collision-shape player) (gdext:sname "disabled") t)))

(defun player-start (player pos)
  (let ((object (player-object player)))
    (set-position object pos)
    (show object)
    (collision-shape-2d-set-disabled (player-collision-shape player) nil)))
