(in-package #:dodge-the-creeps)

;;; The HUD scene's code, from "Heads up display"

;;; A HUD has no state of its own, so its Lisp object is the Godot object (the
;;; default constructor of REGISTER-CLASS).

(defun register-hud ()
  (gdext:register-class "HUD" "CanvasLayer")
  ;; Notifies `Main` node that the button has been pressed
  (gdext:bind-signal "HUD" "start_game")
  (gdext:bind-method "HUD" "show_message" #'hud-show-message
                     :arguments `(("text" ,gdext-ffi:+variant-type-string+)))
  (gdext:bind-method "HUD" "update_score" #'hud-update-score
                     :arguments `(("score" ,gdext-ffi:+variant-type-int+)))
  (gdext:bind-method "HUD" "_on_start_button_pressed" #'hud-on-start-button-pressed)
  (gdext:bind-method "HUD" "_on_message_timer_timeout" #'hud-on-message-timer-timeout))

(defun hud-show-message (hud text)
  (let ((message (get-node hud (gdext:npath "Message"))))
    (label-set-text message text)
    (show message)
    (timer-start (get-node hud (gdext:npath "MessageTimer")))))

(defun hud-update-score (hud score)
  (label-set-text (get-node hud (gdext:npath "ScoreLabel")) (princ-to-string score)))

(defun hud-on-start-button-pressed (hud)
  (hide (get-node hud (gdext:npath "StartButton")))
  (emit-signal hud (gdext:sname "start_game")))

(defun hud-on-message-timer-timeout (hud)
  (hide (get-node hud (gdext:npath "Message"))))
