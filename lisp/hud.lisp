(in-package #:dodge-the-creeps)

;;; The HUD scene's code, from "Heads up display"

;; extends CanvasLayer
;;
;; # Notifies `Main` node that the button has been pressed
;; signal start_game

;;; A HUD has no state of its own, so its Lisp object is a plain
;;; GDEXT:GODOT-OBJECT (the default constructor of REGISTER-CLASS).

(defun register-hud ()
  (gdext:register-class "HUD" "CanvasLayer")
  ;; Notifies `Main` node that the button has been pressed
  (gdext:bind-signal "HUD" "start_game")
  (gdext:bind-method "HUD" "show_message" #'hud-show-message
                     :arguments '(("text" :string)))
  (gdext:bind-method "HUD" "show_game_over" #'hud-show-game-over)
  (gdext:bind-method "HUD" "update_score" #'hud-update-score
                     :arguments '(("score" :int)))
  (gdext:bind-method "HUD" "_on_start_button_pressed" #'hud-on-start-button-pressed)
  (gdext:bind-method "HUD" "_on_message_timer_timeout" #'hud-on-message-timer-timeout))

;; func show_message(text):
;;     $Message.text = text
;;     $Message.show()
;;     $MessageTimer.start()
(defun hud-show-message (hud text)
  (let ((message (get-node hud "Message")))
    (label-set-text message text)
    (show message)
    (timer-start (get-node hud "MessageTimer"))))

;; func show_game_over():
;;     show_message("Game Over")
;;     # Wait until the MessageTimer has counted down.
;;     await $MessageTimer.timeout
;;
;;     $Message.text = "Dodge the Creeps!"
;;     $Message.show()
;;     # Make a one-shot timer and wait for it to finish.
;;     await get_tree().create_timer(1.0).timeout
;;     $StartButton.show()
(defun hud-show-game-over (hud)
  (hud-show-message hud "Game Over")
  ;; Wait until the MessageTimer has counted down.
  (gdext:after-signal ((get-node hud "MessageTimer") "timeout"
                       :target hud)
    (let ((message (get-node hud "Message")))
      (label-set-text message "Dodge the Creeps!")
      (show message))
    ;; Make a one-shot timer and wait for it to finish.
    (gdext:with-reference (timer (scene-tree-create-timer (get-tree hud) 1.0))
      (gdext:after-signal (timer "timeout" :target hud)
        (show (get-node hud "StartButton"))))))

;; func update_score(score):
;;     $ScoreLabel.text = str(score)
(defun hud-update-score (hud score)
  (label-set-text (get-node hud "ScoreLabel") (princ-to-string score)))

;; func _on_start_button_pressed():
;;     $StartButton.hide()
;;     start_game.emit()
(defun hud-on-start-button-pressed (hud)
  (hide (get-node hud "StartButton"))
  (emit-signal hud "start_game"))

;; func _on_message_timer_timeout():
;;     $Message.hide()
(defun hud-on-message-timer-timeout (hud)
  (hide (get-node hud "Message")))
