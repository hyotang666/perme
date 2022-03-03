; vim: ft=lisp et
(in-package :asdf)
(defsystem "perme.test"
  :version
  "0.0.0"
  :depends-on
  (:jingoh "perme")
  :components
  ((:file "perme"))
  :perform
  (test-op (o c) (declare (special args))
   (apply #'symbol-call :jingoh :examine :perme args)))