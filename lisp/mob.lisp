(in-package #:dodge-the-creeps)

;;; The Mob scene's code, from "Creating the enemy"

;;; A Mob has no state of its own, so its Lisp object is the Godot object (the
;;; default constructor of REGISTER-CLASS).

(defun register-mob ()
  (gdext:register-class "Mob" "RigidBody2D")
  (gdext:bind-method "Mob" "_on_visible_on_screen_notifier_2d_screen_exited"
                     #'mob-on-visible-on-screen-notifier-2d-screen-exited))

(defun mob-on-visible-on-screen-notifier-2d-screen-exited (mob)
  (queue-free mob))
