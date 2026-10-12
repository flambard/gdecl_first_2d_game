(in-package #:dodge-the-creeps)

(defun start ()
  ;; Like GDScript's random functions, give different results in each run
  (setf *random-state* (make-random-state t))
  (format t "Dodge the Creeps: Lisp code loaded~%")
  (finish-output))

(gdext:add-initialize-hook 'start)
