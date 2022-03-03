(in-package :cl-user)

(defpackage :perme
  (:use :cl)
  (:export #:memoise #:forget))

(in-package :perme)

(defvar *memoised* (make-hash-table :test #'eq))

(defvar *cache-dir*
  (ensure-directories-exist
    (merge-pathnames "cache/"
                     (asdf:system-source-directory (asdf:find-system :perme)))))

(defun origin (name) (gethash name *memoised*))

(defun (setf origin) (new name) (setf (gethash name *memoised*) new))

(defun get-memo (fun args)
  (let ((cache
         (let ((*package* (find-package :cl-user)))
           (merge-pathnames (format nil "~A/~A" (name fun) (sxhash args))
                            *cache-dir*))))
    (if (probe-file cache)
        (values (cl-store:restore cache) t)
        (values nil nil))))

(defun (setf get-memo) (new fun args)
  (cl-store:store new
                  (ensure-directories-exist
                    (let ((*package* (find-package :cl-user)))
                      (merge-pathnames
                        (format nil "~A/~A" (name fun) (sxhash args))
                        *cache-dir*))))
  new)

(defclass memo () ((name :initarg :name :reader name))
  (:metaclass c2mop:funcallable-standard-class))

(defmethod initialize-instance :after ((this memo) &key)
  (c2mop:set-funcallable-instance-function
   this
   (lambda (&rest args)
     (multiple-value-bind (value exist?)
         (get-memo this args)
       (if exist?
           value
           (setf (get-memo this args) (apply (origin (name this)) args)))))))

(defmacro memoise (function-name)
  ;; Trivial syntax-check.
  (check-type function-name symbol)
  `(progn
    (setf (origin ',function-name) (fdefinition ',function-name)
          (fdefinition ',function-name)
            (make-instance 'memo :name ',function-name))
    ',function-name))

(defmacro forget (function-name)
  `(if (typep (fdefinition ',function-name) 'memo)
       (progn
        (uiop:delete-directory-tree
          (let ((*package* (find-package :cl-user)))
            (merge-pathnames (format nil "~A/" (name #',function-name))
                             *cache-dir*))
          :if-does-not-exist :ignore
          :validate t)
        (setf (fdefinition ',function-name) (origin ',function-name)))
       nil))

(defun test (arg) arg)