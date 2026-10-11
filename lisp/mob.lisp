(in-package #:dodge-the-creeps)

;;; The Mob scene's code, from "Creating the enemy"

;;; A Mob has no state of its own, so its Lisp object is the Godot object (the
;;; default constructor of REGISTER-CLASS).

(defun register-mob ()
  (gdext:register-class "Mob" "RigidBody2D")
  (gdext:bind-method "Mob" "_on_visible_on_screen_notifier_2d_screen_exited"
                     #'mob-on-visible-on-screen-notifier-2d-screen-exited)
  (gdext:bind-virtual "Mob" "_ready" #'mob-ready))

(defun pick-random (list)
  (elt list (random (length list))))

(defun mob-ready (mob)
  (let ((sprite (get-node mob (gdext:npath "AnimatedSprite2D"))))
    (gdext:with-reference (sprite-frames (animated-sprite-2d-get-sprite-frames sprite))
      (let ((mob-types (sprite-frames-get-animation-names sprite-frames)))
        (gdext:with-string-name (animation (pick-random mob-types))
          (animated-sprite-2d-set-animation sprite animation))))
    (animated-sprite-2d-play sprite)))

(defun mob-on-visible-on-screen-notifier-2d-screen-exited (mob)
  (queue-free mob))
