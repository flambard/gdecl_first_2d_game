(in-package #:dodge-the-creeps)

(defun start ()
  (godot-print "Dodge the Creeps: Lisp code loaded"))

(gdext:add-initialize-hook 'start)
