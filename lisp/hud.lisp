(in-package #:dodge-the-creeps)

;;; The HUD scene's code, from "Heads up display"

;; extends CanvasLayer
;;
;; # Notifies `Main` node that the button has been pressed
;; signal start_game

;; HUD is a CLOS class, like Player. A HUD has no state of its own, so it has no
;; slots.
(defclass hud (canvas-layer)
  ()
  (:metaclass godot-class)
  (:godot-name "HUD")
  ;; Notifies `Main` node that the button has been pressed
  (:signals (start-game)))

(define-godot-generic show-message (self (text :string)))

(define-godot-generic show-game-over (self))

(define-godot-generic update-score (self (score :int)))

;; Connected to the signal pressed of StartButton in hud.tscn
(define-godot-generic on-start-button-pressed (self)
  (:godot-name "_on_start_button_pressed"))

;; Connected to the signal timeout of MessageTimer in hud.tscn
(define-godot-generic on-message-timer-timeout (self)
  (:godot-name "_on_message_timer_timeout"))

;; func show_message(text):
;;     $Message.text = text
;;     $Message.show()
;;     $MessageTimer.start()
(defmethod show-message ((hud hud) text)
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
(defmethod show-game-over ((hud hud))
  (show-message hud "Game Over")
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
(defmethod update-score ((hud hud) score)
  (label-set-text (node-get-node hud "ScoreLabel") (princ-to-string score)))

;; func _on_start_button_pressed():
;;     $StartButton.hide()
;;     start_game.emit()
(defmethod on-start-button-pressed ((hud hud))
  (canvas-item-hide (node-get-node hud "StartButton"))
  (object-emit-signal hud "start_game"))

;; func _on_message_timer_timeout():
;;     $Message.hide()
(defmethod on-message-timer-timeout ((hud hud))
  (canvas-item-hide (node-get-node hud "Message")))
