(in-package #:dodge-the-creeps)

;;; The game's singleton, registered in Godot as the engine singleton
;;; DodgeTheCreeps. Its one instance is made when Godot loads the extension,
;;; after the game's other classes are registered, so it's the place for what
;;; the game does once at startup.

(defclass dodge-the-creeps (object)
  ()
  (:metaclass godot-class)
  (:singleton t))

(defmethod initialize-instance :after ((game dodge-the-creeps) &key)
  (godot-print "Dodge the Creeps: Lisp code loaded"))
