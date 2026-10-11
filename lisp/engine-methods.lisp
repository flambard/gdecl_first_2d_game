(in-package #:dodge-the-creeps)

;;; The Godot methods the game calls. Hashes from gdecl/extension_api.json.

(gdext:define-engine-method get-viewport-rect ("CanvasItem" "get_viewport_rect" 1639390495)
  :return-type gdext-ffi:+variant-type-rect2+)
