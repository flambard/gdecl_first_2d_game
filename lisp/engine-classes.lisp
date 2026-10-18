(in-package #:dodge-the-creeps)

;;; Functions for the methods of the engine classes the game uses, besides those
;;; gdecl defines, named <class>-<method>, e.g. ANIMATED-SPRITE-2D-PLAY. They're
;;; generated from gdecl/extension_api.json when the code is compiled, and added
;;; to the package GODOT. Each class also gets a struct, named like it, that the
;;; game's CLOS classes inherit from, e.g. CANVAS-LAYER for HUD.

(define-engine-class "CanvasLayer")
(define-engine-class "Area2D")
(define-engine-class "AnimatedSprite2D")
(define-engine-class "SpriteFrames")
(define-engine-class "CollisionShape2D")
(define-engine-class "PathFollow2D")
(define-engine-class "RigidBody2D")
(define-engine-class "Label")
(define-engine-class "AudioStreamPlayer")
