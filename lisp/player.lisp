(in-package #:dodge-the-creeps)

;;; The Player scene's code, from "Coding the player"

;; The Lisp object of a Player
(defstruct player
  ;; The Godot object
  object
  ;; How fast the player will move (pixels/sec). Exported as the property speed.
  (speed 400)
  ;; Size of the game window
  screen-size)

(defun register-player ()
  (gdext:register-class "Player" "Area2D"
                        :constructor (lambda (object) (make-player :object object)))
  (gdext:bind-method "Player" "get_speed" #'player-speed
                     :return-type gdext-ffi:+variant-type-int+)
  (gdext:bind-method "Player" "set_speed"
                     (lambda (player speed) (setf (player-speed player) speed))
                     :arguments `(("speed" ,gdext-ffi:+variant-type-int+)))
  (gdext:bind-property "Player" "speed" gdext-ffi:+variant-type-int+ "get_speed" "set_speed"))
