(in-package #:dodge-the-creeps)

;;; The HUD scene's code, from "Heads up display"

;; extends CanvasLayer
;;
;; # Notifies `Main` node that the button has been pressed
;; signal start_game

;;; A HUD has no state of its own, so its Lisp object, a HUD, has no slots.

(gdext:define-class hud ("HUD" "CanvasLayer")
  ()
  ;; Notifies `Main` node that the button has been pressed
  (:signal "start_game")
  (:method "show_message" hud-show-message :arguments (("text" :string)))
  (:method "show_game_over" hud-show-game-over)
  (:method "update_score" hud-update-score :arguments (("score" :int)))
  (:method "_on_start_button_pressed" hud-on-start-button-pressed)
  (:method "_on_message_timer_timeout" hud-on-message-timer-timeout))

;; func show_message(text):
;;     $Message.text = text
;;     $Message.show()
;;     $MessageTimer.start()
(defun hud-show-message (hud text)
  (let ((message (node-get-node hud "Message")))
    (label-set-text message text)
    (canvas-item-show message)
    (timer-start (node-get-node hud "MessageTimer"))))

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
  (gdext:after-signal ((node-get-node hud "MessageTimer") "timeout" :target hud)
    (let ((message (node-get-node hud "Message")))
      (label-set-text message "Dodge the Creeps!")
      (canvas-item-show message))
    ;; Make a one-shot timer and wait for it to finish.
    (gdext:after-signal ((scene-tree-create-timer (node-get-tree hud) 1.0) "timeout" :target hud)
      (canvas-item-show (node-get-node hud "StartButton")))))

;; func update_score(score):
;;     $ScoreLabel.text = str(score)
(defun hud-update-score (hud score)
  (label-set-text (node-get-node hud "ScoreLabel") (princ-to-string score)))

;; func _on_start_button_pressed():
;;     $StartButton.hide()
;;     start_game.emit()
(defun hud-on-start-button-pressed (hud)
  (canvas-item-hide (node-get-node hud "StartButton"))
  (object-emit-signal hud "start_game"))

;; func _on_message_timer_timeout():
;;     $Message.hide()
(defun hud-on-message-timer-timeout (hud)
  (canvas-item-hide (node-get-node hud "Message")))
