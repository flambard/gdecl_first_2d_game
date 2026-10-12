(in-package #:dodge-the-creeps)

;;; The Godot methods the game calls. Their hashes and signatures are looked up
;;; in gdecl/extension_api.json when the code is compiled.

(gdext:define-engine-method get-viewport-rect ("CanvasItem" "get_viewport_rect"))

(gdext:define-engine-method get-position ("Node2D" "get_position"))

(gdext:define-engine-method set-position ("Node2D" "set_position"))

(gdext:define-engine-method is-action-pressed ("Input" "is_action_pressed"))

(gdext:define-engine-method get-node ("Node" "get_node"))

(gdext:define-engine-method animated-sprite-2d-play ("AnimatedSprite2D" "play"))

(gdext:define-engine-method animated-sprite-2d-stop ("AnimatedSprite2D" "stop"))

(gdext:define-engine-method animated-sprite-2d-set-animation ("AnimatedSprite2D" "set_animation"))

(gdext:define-engine-method animated-sprite-2d-set-flip-h ("AnimatedSprite2D" "set_flip_h"))

(gdext:define-engine-method animated-sprite-2d-set-flip-v ("AnimatedSprite2D" "set_flip_v"))

(gdext:define-engine-method emit-signal ("Object" "emit_signal"))

(gdext:define-engine-method hide ("CanvasItem" "hide"))

(gdext:define-engine-method set-deferred ("Object" "set_deferred"))

(gdext:define-engine-method show ("CanvasItem" "show"))

(gdext:define-engine-method collision-shape-2d-set-disabled ("CollisionShape2D" "set_disabled"))

(gdext:define-engine-method queue-free ("Node" "queue_free"))

(gdext:define-engine-method animated-sprite-2d-get-sprite-frames ("AnimatedSprite2D" "get_sprite_frames"))

(gdext:define-engine-method sprite-frames-get-animation-names ("SpriteFrames" "get_animation_names"))

(gdext:define-engine-method timer-start ("Timer" "start"))

(gdext:define-engine-method timer-stop ("Timer" "stop"))

(gdext:define-engine-method packed-scene-instantiate ("PackedScene" "instantiate"))

(gdext:define-engine-method path-follow-2d-set-progress-ratio ("PathFollow2D" "set_progress_ratio"))

(gdext:define-engine-method get-rotation ("Node2D" "get_rotation"))

(gdext:define-engine-method set-rotation ("Node2D" "set_rotation"))

(gdext:define-engine-method rigid-body-2d-set-linear-velocity ("RigidBody2D" "set_linear_velocity"))

(gdext:define-engine-method add-child ("Node" "add_child"))

(gdext:define-engine-method label-set-text ("Label" "set_text"))

(gdext:define-engine-method get-tree ("Node" "get_tree"))

(gdext:define-engine-method scene-tree-create-timer ("SceneTree" "create_timer"))

(gdext:define-engine-method scene-tree-call-group ("SceneTree" "call_group"))

(gdext:define-engine-method audio-stream-player-play ("AudioStreamPlayer" "play"))

(gdext:define-engine-method audio-stream-player-stop ("AudioStreamPlayer" "stop"))
