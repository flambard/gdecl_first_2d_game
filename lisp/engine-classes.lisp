(in-package #:dodge-the-creeps)

;;; Functions for the methods of the engine classes the game uses, besides those
;;; gdecl defines, named <class>-<method>, e.g. ANIMATED-SPRITE-2D-PLAY. They're
;;; generated from gdecl/extension_api.json when the code is compiled, and added
;;; to the package GODOT. Each class also gets a struct, named like it, that the
;;; game's CLOS classes inherit from, e.g. CANVAS-LAYER for HUD.

(gdext:define-engine-class "CanvasLayer")
(gdext:define-engine-class "Area2D")
(gdext:define-engine-class "AnimatedSprite2D")
(gdext:define-engine-class "SpriteFrames")
(gdext:define-engine-class "CollisionShape2D")
(gdext:define-engine-class "PathFollow2D")
(gdext:define-engine-class "RigidBody2D")
(gdext:define-engine-class "Label")
(gdext:define-engine-class "AudioStreamPlayer")
