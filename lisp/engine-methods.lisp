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
