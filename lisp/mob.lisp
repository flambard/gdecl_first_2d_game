(in-package #:dodge-the-creeps)

;;; The Mob scene's code, from "Creating the enemy"

;; extends RigidBody2D

;; Mob is a CLOS class, like Player. A Mob has no state of its own, so it has no
;; slots.
(defclass mob (rigid-body-2d)
  ()
  (:metaclass godot-class))

;; Connected to the signal screen_exited of VisibleOnScreenNotifier2D in mob.tscn
(define-godot-generic on-visible-on-screen-notifier-2d-screen-exited (self)
  (:godot-name "_on_visible_on_screen_notifier_2d_screen_exited"))

(defun pick-random (sequence)
  "A random element of SEQUENCE, like pick_random() of an Array in GDScript."
  (elt sequence (randi-range 0 (1- (length sequence)))))

;; func _ready():
;;     var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
;;     $AnimatedSprite2D.animation = mob_types.pick_random()
;;     $AnimatedSprite2D.play()
(defmethod ready ((mob mob))
  (let ((sprite (node-get-node mob "AnimatedSprite2D")))
    (let ((mob-types (sprite-frames-get-animation-names
                      (animated-sprite-2d-get-sprite-frames sprite))))
      (animated-sprite-2d-set-animation sprite (pick-random mob-types)))
    (animated-sprite-2d-play sprite)))

;; func _on_visible_on_screen_notifier_2d_screen_exited():
;;     queue_free()
(defmethod on-visible-on-screen-notifier-2d-screen-exited ((mob mob))
  (node-queue-free mob))
