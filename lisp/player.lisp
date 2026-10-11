(in-package #:dodge-the-creeps)

;;; The Player scene's code, from "Coding the player"

(defun register-player ()
  (gdext:register-class "Player" "Area2D"))
