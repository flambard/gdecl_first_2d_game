(in-package #:dodge-the-creeps)

;;; The Godot methods the game calls. Hashes from gdecl/extension_api.json.

(gdext:define-engine-method get-viewport-rect ("CanvasItem" "get_viewport_rect" 1639390495)
  :return-type gdext-ffi:+variant-type-rect2+)

(gdext:define-engine-method get-position ("Node2D" "get_position" 3341600327)
  :return-type gdext-ffi:+variant-type-vector2+)

(gdext:define-engine-method set-position ("Node2D" "set_position" 743155724)
  :arguments ((position gdext-ffi:+variant-type-vector2+)))

(gdext:define-engine-method is-action-pressed ("Input" "is_action_pressed" 1558498928)
  :arguments ((action gdext-ffi:+variant-type-string-name+)
              (exact-match gdext-ffi:+variant-type-bool+ nil))
  :return-type gdext-ffi:+variant-type-bool+)

(gdext:define-engine-method get-node ("Node" "get_node" 2734337346)
  :arguments ((path gdext-ffi:+variant-type-node-path+))
  :return-type gdext-ffi:+variant-type-object+)

(gdext:define-engine-method animated-sprite-2d-play ("AnimatedSprite2D" "play" 3269405555)
  :arguments ((name gdext-ffi:+variant-type-string-name+ (gdext:sname ""))
              (custom-speed gdext-ffi:+variant-type-float+ 1.0)
              (from-end gdext-ffi:+variant-type-bool+ nil)))

(gdext:define-engine-method animated-sprite-2d-stop ("AnimatedSprite2D" "stop" 3218959716))

(gdext:define-engine-method animated-sprite-2d-set-animation ("AnimatedSprite2D" "set_animation" 3304788590)
  :arguments ((name gdext-ffi:+variant-type-string-name+)))

(gdext:define-engine-method animated-sprite-2d-set-flip-h ("AnimatedSprite2D" "set_flip_h" 2586408642)
  :arguments ((flip-h gdext-ffi:+variant-type-bool+)))

(gdext:define-engine-method animated-sprite-2d-set-flip-v ("AnimatedSprite2D" "set_flip_v" 2586408642)
  :arguments ((flip-v gdext-ffi:+variant-type-bool+)))

(gdext:define-engine-vararg-method emit-signal ("Object" "emit_signal" 4047867050)
  :arguments ((signal-name gdext-ffi:+variant-type-string-name+))
  :return-type gdext-ffi:+variant-type-int+) ; Error

(gdext:define-engine-method hide ("CanvasItem" "hide" 3218959716))

(gdext:define-engine-method set-deferred ("Object" "set_deferred" 3776071444)
  :arguments ((property gdext-ffi:+variant-type-string-name+)
              (value :variant)))

(gdext:define-engine-method show ("CanvasItem" "show" 3218959716))

(gdext:define-engine-method collision-shape-2d-set-disabled ("CollisionShape2D" "set_disabled" 2586408642)
  :arguments ((disabled gdext-ffi:+variant-type-bool+)))

(gdext:define-engine-method queue-free ("Node" "queue_free" 3218959716))

(gdext:define-engine-method animated-sprite-2d-get-sprite-frames ("AnimatedSprite2D" "get_sprite_frames" 3804851214)
  :return-type gdext-ffi:+variant-type-object+) ; SpriteFrames, a RefCounted

(gdext:define-engine-method sprite-frames-get-animation-names ("SpriteFrames" "get_animation_names" 1139954409)
  :return-type gdext-ffi:+variant-type-packed-string-array+)

(gdext:define-engine-method timer-start ("Timer" "start" 1392008558)
  :arguments ((time-sec gdext-ffi:+variant-type-float+ -1.0)))

(gdext:define-engine-method timer-stop ("Timer" "stop" 3218959716))

(gdext:define-engine-method packed-scene-instantiate ("PackedScene" "instantiate" 2628778455)
  :arguments ((edit-state gdext-ffi:+variant-type-int+ 0)) ; PackedScene.GenEditState
  :return-type gdext-ffi:+variant-type-object+)

(gdext:define-engine-method path-follow-2d-set-progress-ratio ("PathFollow2D" "set_progress_ratio" 373806689)
  :arguments ((ratio gdext-ffi:+variant-type-float+)))

(gdext:define-engine-method get-rotation ("Node2D" "get_rotation" 1740695150)
  :return-type gdext-ffi:+variant-type-float+)

(gdext:define-engine-method set-rotation ("Node2D" "set_rotation" 373806689)
  :arguments ((radians gdext-ffi:+variant-type-float+)))

(gdext:define-engine-method rigid-body-2d-set-linear-velocity ("RigidBody2D" "set_linear_velocity" 743155724)
  :arguments ((linear-velocity gdext-ffi:+variant-type-vector2+)))

(gdext:define-engine-method add-child ("Node" "add_child" 3863233950)
  :arguments ((node gdext-ffi:+variant-type-object+)
              (force-readable-name gdext-ffi:+variant-type-bool+ nil)
              (internal gdext-ffi:+variant-type-int+ 0))) ; Node.InternalMode

(gdext:define-engine-method label-set-text ("Label" "set_text" 83702148)
  :arguments ((text gdext-ffi:+variant-type-string+)))

(gdext:define-engine-method get-tree ("Node" "get_tree" 2958820483)
  :return-type gdext-ffi:+variant-type-object+)

(gdext:define-engine-method scene-tree-create-timer ("SceneTree" "create_timer" 2709170273)
  :arguments ((time-sec gdext-ffi:+variant-type-float+)
              (process-always gdext-ffi:+variant-type-bool+ t)
              (process-in-physics gdext-ffi:+variant-type-bool+ nil)
              (ignore-time-scale gdext-ffi:+variant-type-bool+ nil))
  :return-type gdext-ffi:+variant-type-object+) ; SceneTreeTimer, a RefCounted

(gdext:define-engine-vararg-method scene-tree-call-group ("SceneTree" "call_group" 1257962832)
  :arguments ((group gdext-ffi:+variant-type-string-name+)
              (method gdext-ffi:+variant-type-string-name+)))
