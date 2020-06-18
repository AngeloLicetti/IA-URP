;;* A function that may be used instead of write when printing instances.
;;* This function checks to see if anything to be printed is a standard
;;* instance (std-instance-p obj) and then calls the generic function
;;* to print that object. Try - (write (list (find-class 't)
;;*					   (find-class 'standard-object)) t)

(movd 'write 'write-ori)

(defun write (obj sink)
   ((atom obj)
     (write-ori obj sink)
     nil )
   ((std-instance-p obj)			; is this a std-instance?
     (print-object obj sink)
     nil )
   (write-string \( sink)
   (loop					; print list of objects
     (write (pop obj) sink)
     ((null obj)
       (write-string \) sink)
       nil )
     ((atom obj)
       (write-string " . " sink)
       (write-ori obj sink)
       (write-string \) sink)
       nil )
     (write-string " " sink)
     ((std-instance-p obj)
       (print-object obj sink)
       (write-string \) sink)
       nil )
     ) )

(defun prin1 (obj sink
    *print-escape*)
  (setq *print-escape* t)
  (write obj sink)
  obj )

(defun print (obj sink)
  (prin1 obj sink)
  (terpri 1 sink)
  obj )

(if (getd 'new-code-space) (new-code-space) )

;;;
;;;	Bootstrap
;;;
(terpri 1)
(princ "Beginning to bootstrap muLISP CLOS...")
(terpri 1)

(progn ; Extends to end-of-file (to avoid printing intermediate results).
(forget-all-classes)
(forget-all-generic-functions)
;; How to create the class hierarchy in 10 easy steps
;; 1.  Figure out standard-class's slots.
(setq *the-slots-of-standard-class*
      (mapcar '(lambda (slotd)
		(make-slot-definition
		   :name (car slotd)
		   :initargs
		      (let ((a (getf* (cdr slotd) ':initarg)))
			 (if a (list a) ()))
		   :initform (getf* (cdr slotd) ':initform)
		   :initfunction
		      (let ((a (getf* (cdr slotd) ':initform))
			    (a-pos (position ':initform (cdr slotd))))
			 (if a-pos (list 'lambda () a) nil))
		   :allocation ':instance))
	       (nth 3 *the-defclass-standard-class*)))
;; 2.  Create the standard-class metaobject by hand.
(setq *the-class-standard-class*
      (allocate-std-instance
	'tba
	(make-list (length *the-slots-of-standard-class*) ;* no make-array
		    *secret-unbound-value*)))
;; 3.  Install standard-class's (circular) class-of link.
(setf (std-instance-class *the-class-standard-class*)
      *the-class-standard-class*)
;; (It's now okay to use class-... accessor).
;; 4.  Fill in standard-class's class-slots.
(setf-class-slots *the-slots-of-standard-class* *the-class-standard-class*)
;; (Skeleton built; it's now okay to call make-instance-standard-class.)
;; 5. Hand build the class t so that it has no direct superclasses.
(setf-find-class
  (let ((class (std-allocate-instance *the-class-standard-class*)))
       (setf-class-name 't class)
       (setf-class-direct-subclasses () class)
       (setf-class-direct-superclasses () class)
       (setf-class-direct-methods () class)
       (setf-class-direct-slots () class)
       (setf-class-precedence-list (list class) class)
       (setf-class-slots () class)
      class) 't)
;; (It's now okay to define subclasses of t.)
;; 6.  Create the other superclass of standard-class (standard-object).
(defclass standard-object (t) ())
;; 7.  Create the full-blown version of standard-class.
(setq *the-class-standard-class* (eval *the-defclass-standard-class*))
;; 8.  Replace all (3) existing pointers to the skeleton with the real one.
(setf (std-instance-class (find-class 't)) *the-class-standard-class*)
(setf (std-instance-class (find-class 'standard-object))
      *the-class-standard-class*)
(setf (std-instance-class *the-class-standard-class*)
      *the-class-standard-class*)
;; (Clear sailing from here on in).
;; 9.  Define the other built-in classes.
;;* this list is somewhat pared down from the original Closette
(defclass symbol (t) ())
(defclass number (t) ())
(defclass cons (t) ())
(defclass null (symbol) ())
(defclass integer (number) ())
;; 10. Define the other standard metaobject classes.
(setq *the-class-standard-gf* (eval *the-defclass-standard-generic-function*))
(setq *the-class-standard-method* (eval *the-defclass-standard-method*))

;; Voila! The class hierarchy is in place.
(princ "Class hierarchy created.")
(terpri 1)
;; (It's now okay to define generic functions and methods.)

(defgeneric print-object (instance stream))
(defmethod print-object ((instance standard-object) stream)
   (princ (pack* "#<" (class-name (class-of instance))
		 " "  (location instance) ">")
	   stream)
   nil)

;;; Slot access

(defgeneric slot-value-using-class (class instance slot-name))
(defmethod slot-value-using-class
	   ((class standard-class) instance slot-name)
   (std-slot-value instance slot-name))

(defgeneric setf-slot-value-using-class (new-value class instance slot-name))
(defmethod setf-slot-value-using-class
	   (new-value (class standard-class) instance slot-name)
   (setf-std-slot-value new-value instance slot-name))

;;; N.B. To avoid making a foward reference to a (setf xxx) generic function:
;;* a function named SETF-SLOT-VALUE-USING-CLASS was also defined here -
;;*this is omitted because of the way setf  is implemented (i.e., appending
;;* it onto the front of the method) (e.g., "setf-") and because muLISP
;;*doesn't care if there's a reference to a generic function in the
;;*function SETF-SLOT-VALUE

(defgeneric slot-exists-p-using-class (class instance slot-name))
(defmethod slot-exists-p-using-class ((class standard-class) instance slot-name)
   (std-slot-exists-p instance slot-name))

(defgeneric slot-boundp-using-class (class instance slot-name))
(defmethod slot-boundp-using-class ((class standard-class) instance slot-name)
   (std-slot-boundp instance slot-name))

(defgeneric slot-makunbound-using-class (class instance slot-name))
(defmethod slot-makunbound-using-class ((class standard-class) instance slot-name)
   (std-slot-makunbound instance slot-name))

;;; Instance creation and initialization

(defgeneric allocate-instance (class))
(defmethod allocate-instance ((class standard-class))
   (std-allocate-instance class))

(defgeneric make-instance (class &rest))
(defmethod make-instance ((class standard-class) &rest initargs)
   (let ((instance (allocate-instance class)))
      (apply 'initialize-instance instance initargs)
     instance))

(defmethod make-instance ((class symbol) &rest initargs)
   (apply 'make-instance (find-class class) initargs))

(defgeneric initialize-instance (instance &rest))
(defmethod initialize-instance ((instance standard-object) &rest initargs)
   (apply 'shared-initialize instance t initargs))

(defgeneric reinitialize-instance (instance &rest))
(defmethod reinitialize-instance ((instance standard-object) &rest initargs)
   (apply 'shared-initialize instance () initargs))

(defgeneric shared-initialize (instance slot-names &rest))
(defmethod shared-initialize ((instance standard-object) slot-names &rest
			      all-keys)
   (dolist (slot (class-slots (class-of instance)))
      (let ((slot-name (slot-definition-name slot))
	    (value-found (get-properties* all-keys
					  (slot-definition-initargs slot))))
	    ;;* value-found is a list of two elements, the first is the
	    ;;* value of the slot initarg if found and then second is a flag
	    ;;* indicating whether the slot was found.
	  (if (cadr value-found)
	      (setf-slot-value (car value-found) instance slot-name)
	      (if (and (not (slot-boundp instance slot-name))
		       (not (null (slot-definition-initfunction slot)))
			    (or (eq slot-names t)
				(member slot-name slot-names)))
		   (setf-slot-value
			(funcall (slot-definition-initfunction slot))
			instance slot-name)))))
	 instance)

(princ "Instance creation and initialization methods defined.")
(terpri)

;;;
;;;	Methods having to do with class metaobjects
;;;

;;* Here in original Closette, definitions for changing the class of an instance are
;;* defined.  These have been omitted in this version.

(defmethod print-object ((class standard-class) stream)
   (princ (pack* "#<" (class-name (class-of class)) " ") stream)
   (princ (class-name class) stream)
   (princ (pack*  " "  (location class) ">") stream)
   nil)

(defmethod initialize-instance :after ((class standard-class) &rest args)
   (apply 'std-after-initialization-for-classes class args))

;;; Finalize-inheritance

(defgeneric finalize-inheritance (class))
(defmethod finalize-inheritance ((class standard-class))
   (std-finalize-inheritance class)
   nil)

;;; Class precedence lists

(defgeneric compute-class-precedence-list (class))
(defmethod compute-class-precedence-list ((class standard-class))
   (std-compute-class-precedence-list class))

;;; Slot inheritance

(defgeneric compute-slots (class))
(defmethod compute-slots ((class standard-class)) (std-compute-slots class))

(defgeneric compute-effective-slot-definition (class direct-slots))
(defmethod compute-effective-slot-definition ((class standard-class) direct-slots)
   (std-compute-effective-slot-definition class direct-slots))

(princ "Class metaobject methods defined.")
(terpri 1)

;;;
;;; Methods having to do with generic function metaobjects
;;;

(defmethod print-object ((gf standard-generic-function) stream)
   (princ (pack* "#<" (class-name (class-of gf))
		 " "  (generic-function-name gf) ;* assume this is an atom
		 " "  (location gf) ">")
	   stream)
   nil)

(defmethod initialize-instance :after ((gf standard-generic-function))
   (finalize-generic-function gf))

(princ "Generic function metaobject methods defined.")
(terpri 1)

;;;
;;;	Methods having to do with method metaobjects.
;;;

(defmethod print-object ((method standard-method) stream)
   (princ (pack* "#<" (class-name (class-of method)) ; assume this is an atom
		 " "  (and (method-generic-function method)
			   (generic-function-name
				    (method-generic-function method)))
		 " ") stream)
   (princ  (method-qualifiers method) stream)
   (spaces 1 stream)
   (princ  (mapcar 'class-name
		   (method-specializers method)) stream)
   (princ (pack* " "  (location method) ">") stream)
   nil)

(defmethod initialize-instance :after ((method standard-method))
   ;;* we're storing the function in a symbol first
   (setf-method-function (putd (pack* 'method- (incq *method-count*))
			       (compute-method-function method))
			 method))

(princ "Method metaobject methods defined.")
(terpri)

;;;
;;;	Methods having to do with generic function invocation
;;;

(defgeneric compute-discriminating-function (gf))
(defmethod compute-discriminating-function ((gf standard-generic-function))
   (std-compute-discriminating-function gf))

(defgeneric method-more-specific-p (gf method1 method2 required-classes))
(defmethod method-more-specific-p
	   ((gf standard-generic-function) method1 method2 required-classes)
   (std-method-more-specific-p gf method1 method2 required-classes))

(defgeneric compute-effective-method-function (gf methods))
(defmethod compute-effective-method-function ((gf standard-generic-function) methods)
   (std-compute-effective-method-function gf methods))

(defgeneric compute-method-function (method))
(defmethod compute-method-function ((method standard-method))
   (std-compute-method-function method))

(princ "Methods for generic function invocation defined.")
(terpri 1)

;;;	describe-object is a handy tool for enquiring minds:

(defgeneric describe-object (object stream))
(defmethod describe-object ((object standard-object) stream)
   (princ "A muLISP CLOS object ...." stream)
   (terpri 1 stream)
   (princ "Printed representation: " stream)
   (print-object object stream)
   (terpri 1 stream)
   (princ "Class: " stream)
   (print-object (class-of object) stream)
   (dolist (sn (mapcar 'slot-definition-name
		       (class-slots (class-of object))))
      (terpri 1 stream)
      (princ (pack* sn " <- : ") stream)
      (if (slot-boundp object sn)
	  (write (slot-value object sn) stream)
	  (write-string "not bound" stream)))
   (terpri 1 stream)
   nil)

(defmethod describe-object ((object t) stream)
  (break (pack* "Class of object -> " (class-name (class-of object)))
	  "Invalid object") )

(princ "... done")
nil
) ; end progn
