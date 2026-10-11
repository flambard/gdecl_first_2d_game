(in-package #:dodge-the-creeps)

(defun start ()
  (register-player)
  (register-mob)
  (format t "Dodge the Creeps: Lisp code loaded~%")
  (finish-output))

(gdext:add-initialize-hook 'start)
