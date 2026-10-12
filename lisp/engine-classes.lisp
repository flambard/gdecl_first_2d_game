(in-package #:dodge-the-creeps)

;;; Functions for the methods of the engine classes the game uses, besides those
;;; gdecl defines, named <class>-<method>, e.g. ANIMATED-SPRITE-2D-PLAY. They're
;;; generated from gdecl/extension_api.json when the code is compiled, and added
;;; to the package GODOT.

(gdext:define-engine-class "AnimatedSprite2D")
(gdext:define-engine-class "SpriteFrames")
(gdext:define-engine-class "CollisionShape2D")
(gdext:define-engine-class "PathFollow2D")
(gdext:define-engine-class "RigidBody2D")
(gdext:define-engine-class "Label")
(gdext:define-engine-class "AudioStreamPlayer")
