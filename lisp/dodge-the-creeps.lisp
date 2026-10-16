(in-package #:dodge-the-creeps)

(defun announce-loaded ()
  (godot-print "Dodge the Creeps: Lisp code loaded"))

(gdext:add-initialize-hook 'announce-loaded)
