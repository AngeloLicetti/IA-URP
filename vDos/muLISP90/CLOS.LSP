;; Load the muLISP CLOS utilities file
(load closutil)

;;;			muLISP CLOS - the core stuff

;;;
;;; Standard instances
;;;
;;; This implementation uses structures for instances.

(defstruct (std-instance (:constructor allocate-std-instance (class slots))
			 (:predicate std-instance-p)
			 ;* not here! '(:print-function print-std-instance)
			 )
  class
  slots)

;;; Standard instance allocation
(setq *secret-unbound-value* (list "slot unbound"))

(defun instance-slot-p (slot)
   (eq (slot-definition-allocation slot) ':instance))

(defun not-instance-slot-p (slot)
  (null (instance-slot-p slot)) )

(defun std-allocate-instance (class)
   (allocate-std-instance
      class
      (allocate-slot-storage (count-if 'instance-slot-p (class-slots class))
			     *secret-unbound-value*)))

;;* Simple lists instead of arrays are used for slot storage.
(defun allocate-slot-storage (size initial-value)
   (make-list size initial-value))

;;; Standard instance slot access

;;; The location of the effective-slots slots in the class metaobject
;;; for standard-class must be determined without making any further slot
;;; references.

(defun slot-location (class slot-name
    slot)
  ((and (eq slot-name 'effective-slots)
	(eq class *the-class-standard-class*))
    4)
  ((position slot-name (remove-if 'not-instance-slot-p (class-slots class))
		       'eq-slot-definition-name) )
  ((find slot-name (class-slots class)
		   'eq-slot-definition-name)
    (break (pack* "SLOT-> " slot-name ", CLASS-> " (class-name class))
	   "Non-instance Slot") )
  (break (pack* "SLOT-> " slot-name ", CLASS-> " (class-name class))
	 "Missing Slot") )

(defun slot-contents (slots location)
  (nth location slots) )

(defun setf-slot-contents (new-value slots location)
  (setf (nth location slots) new-value) )

(defun std-slot-value (instance slot-name
    val)
  (setq val (slot-contents (std-instance-slots instance)
			   (slot-location (class-of instance) slot-name)))
  ((equal *secret-unbound-value* val)
    (break (pack* "SLOT-> " slot-name) "Unbound Slot") )
  val )

(defun slot-value (object slot-name)
  ((standard-class-p object)
    (std-slot-value object slot-name) )
  (slot-value-using-class (class-of object) object slot-name) )

(defun setf-std-slot-value (new-value instance slot-name)
  (setf-slot-contents new-value
		      (std-instance-slots instance)
		      (slot-location (class-of instance) slot-name)) )

(defun setf-slot-value (new-value object slot-name)
  ((standard-class-p object)
    (setf-std-slot-value new-value object slot-name) )
  (setf-slot-value-using-class new-value (class-of object) object slot-name) )

(defun std-slot-boundp (instance slot-name)
  (not (equal *secret-unbound-value*
	      (slot-contents (std-instance-slots instance)
			     (slot-location (class-of instance) slot-name)))) )

(defun slot-boundp (object slot-name)
  ((standard-class-p object)
    (std-slot-boundp object slot-name) )
  (slot-boundp-using-class (class-of object) object slot-name) )

(defun std-slot-makunbound (instance slot-name)
  (setf-slot-contents *secret-unbound-value*
		      (std-instance-slots instance)
		      (slot-location (class-of instance) slot-name)) )

(defun slot-makunbound (object slot-name)
  ((standard-class-p object)
    (std-slot-makunbound object slot-name) )
  (slot-makunbound-using-class (class-of object) object slot-name) )

(defun std-slot-exists-p (instance slot-name)
  (not (null (find slot-name (class-slots (class-of instance))
				   'eq-slot-definition-name) ) ) )

(defun slot-exists-p (object slot-name)
  ((standard-class-p object)
    (std-slot-exists-p object slot-name) )
  (slot-exists-p-using-class (class-of object) object slot-name) )

;;; class-of

(defun class-of (x)
  ((std-instance-p x)
    (std-instance-class x) )
  (built-in-class-of x) )

(defun standard-class-p (x)
;;; Used to check if the object is a standard-class.
  (eq (class-of (class-of x)) *the-class-standard-class*) )

;;; built-in-class-of finds the class instance for an object by checking what kind of
;;; object it is. If an object is a built in class, that class will be returned, otherwise the
;;; class of t will be the default. This definition differs from original
;;* Closette in that the number of built in classes are fewer and the original
;;* Closette uses the form 'typecase to determine an objects' type.

(defun built-in-class-of (x)
  (find-class (progn ((null x) 'null)
		     ((symbolp x) 'symbol)
		     ((integerp x) 'integer)
		     ((numberp x) 'number)
		     ((consp x) 'cons)
		     't)
	      t) )

;;; subclassp and sub-specializer-p

(defun subclassp (c1 c2)
  (find c2 (class-precedence-list c1)) )

(defun sub-specializer-p (c1 c2 c-arg)
  (find c2 (cdr (member c1 (class-precedence-list c-arg)))) )

;;* This function returns the set consisting of a given class, all its
;;* direct subclasses, all their direct subclasses, and so on.

(defun subclasses* (class)
  (remove-duplicates
    (cons class
	  (mapappend 'subclasses* (class-direct-subclasses class)))) )

;;;
;;; Class metaobjects and standard-class
;;;

(setq *the-class-standard-class*)	  : standard class's class metaobject

(setq *the-defclass-standard-class*
   '(defclass standard-class ()
	((name :initarg :name)		  ; accessor class-name
	 (direct-superclasses :initarg
		:direct-superclasses)	  ; accessor class-direct-superclasses
	 (direct-slots) 		  ; accessor class-direct-slots
	 (class-precedence-list)	  ; accessor class-precedence-list
	 (effective-slots)		  ; accessor class-slots
	 (direct-subclasses :initform ()) ; accessor class-direct-subclasses
	 (direct-methods :initform ())))) ; accessor class-direct-methods

;;; Defining the metaobject slot accessor function as regular functions
;;; greatly simplifies the implementation without removing functionality.

(defun class-name (class)
  (std-slot-value class 'name) )
(defun setf-class-name (new-value class)
  (setf-slot-value new-value class 'name) )

(defun class-direct-superclasses (class)
  (slot-value class 'direct-superclasses) )
(defun setf-class-direct-superclasses (new-value class)
  (setf-slot-value new-value class 'direct-superclasses) )

(defun class-direct-slots (class)
  (slot-value class 'direct-slots) )
(defun setf-class-direct-slots (new-value class)
  (setf-slot-value new-value class 'direct-slots) )

(defun class-precedence-list (class)
  (slot-value class 'class-precedence-list) )
(defun setf-class-precedence-list (new-value class)
  (setf-slot-value new-value class 'class-precedence-list) )

(defun class-slots (class)
  (slot-value class 'effective-slots) )
(defun setf-class-slots (new-value class)
  (setf-slot-value new-value class 'effective-slots) )

(defun class-direct-subclasses (class)
  (slot-value class 'direct-subclasses) )
(defun setf-class-direct-subclasses (new-value class)
  (setf-slot-value new-value class 'direct-subclasses) )

(defun class-direct-methods (class)
  (slot-value class 'direct-methods) )
(defun setf-class-direct-methods (new-value class)
  (setf-slot-value new-value class 'direct-methods) )

;;; defclass

(defmacro defclass (name direct-superclasses direct-slots . opts)
   `(ensure-class ',name
	:direct-superclasses
	  ,(canonicalize-direct-superclasses direct-superclasses)
	:direct-slots
	  ,(canonicalize-direct-slots direct-slots)
	,@(canonicalize-defclass-options opts)))

(defun canonicalize-direct-slots (direct-slots)
   `(list ,@(mapcar 'canonicalize-direct-slot direct-slots)))

(defun canonicalize-direct-slot (spec)
   ((symbolp spec)
    `(list :name `,spec))
   (let ((name (car spec))
	 (initfunction nil)
	 (initform nil)
	 (initargs ())
	 (readers ())
	 (writers ())
	 (other-options ()))
      (do ((olist (cdr spec) (cddr olist)))
	  ((null olist))
	 (case (car olist)
	    (:initform	;* use lambda for initfunction, no FUNCTION form
	       (setq initfunction
		     `(quote (lambda () ,(cadr olist))))
	       (setq initform `(quote ,(cadr olist))))
	    (:initarg (push (cadr olist) initargs))
	    (:reader (push (cadr olist) readers))
	    (:writer (push (cadr olist) writers))
	    (:accessor
		(push (cadr olist) readers)
		(push (pack* 'setf- (cadr olist)) writers))
	    (otherwise (push `(quote ,(car olist)) other-options)
		       (push `(quote ,(cadr olist)) other-options))))
     `(list :name `,name
	    ,@(if initfunction
		 `(:initform ,initform
		    :initfunction ,initfunction))
	    ,@(if initargs `(:initargs ',(reverse initargs)))
	    ,@(if readers `(:readers ',(reverse readers)))
	    ,@(if writers `(:writers ',(reverse writers)))
	    ,@(reverse other-options))))

(defun canonicalize-direct-superclasses (direct-superclasses)
  `(list ,@(mapcar 'canonicalize-direct-superclass direct-superclasses)))

(defun canonicalize-direct-superclass (class-name)
  `(find-class ',class-name t))

(defun canonicalize-defclass-options (opts)
  (mapappend 'canonicalize-defclass-option opts))

(defun canonicalize-defclass-option (option)
   (case (car option)
      (:metaclass
	(list ':metaclass `(find-class ',(cadr option) t)))
      (:default-initargs
	(list ':direct-default-initargs
	      `(list ,@(mapappend '(lambda (x) x)
				  (mapplist '(lambda (key value)
						  `(',key ,value))
					    (cdr option))))))
      (t (list `(quote ,(car option)) `(quote ,(cadr option))))))

;;* The class table is implemented as property list on a global variable.
;;* Class instances are accessed by their class name. Original Closette
;;* stores classes in a hash table.

(setq *class-table* nil)

;;; find-class

(defun find-class (key errorp)
   ((get '*class-table* key))
   (and errorp (break key "Class not found")))

(defun setf-find-class (new-value key)
   (put '*class-table* key new-value))

(defun forget-all-classes () (setf (cdr '*class-table*) nil))

;;* Remove-class takes a class (in symbol form ) and removes it
;;* and everything below it in the class hierarchy.  Methods specialized
;;* to the class and any subclasses are also removed.

(defun remove-class (class-name   class)
   ((setq class (find-class class-name t))
    ((Y-or-N-P "Are you sure you want to remove this class, it's subclasses and methods?")
     ;; take this class out of it's superclasses subclass list
     (dolist (superclass (class-direct-superclasses class))
       (setf-class-direct-subclasses
	  (remove class (class-direct-subclasses superclass))
	  superclass))
	;; now, process this class and all it's subclasses
     (dolist (subclass (subclasses* class))
	;; remove methods from class and generic function
	(dolist (method (class-direct-methods subclass))
	   (remove-method (method-generic-function method) method))
	   ;; remove class from class-table
	   (remprop '*class-table* (class-name subclass)))
     (princ (pack* "Class -> " class-name " has been removed,") t)
     (princ "Any instances of this class are now invalid!" t)
     nil
    )))

;;; Ensure class

(defun ensure-class all-keys
   (let ((name (car all-keys))
	 (metaclass (or (getf* (cdr all-keys) ':metaclass)
			*the-class-standard-class*)))
      ( ((find-class name nil) ;* Offer option to remove existing class!
	   ((Y-or-N-P (pack* "Class -> " name " already exists: remove "
			 name " and redefine it?"))
	      (remove-class name) )
	   (return "Class not redefined!") ) )
      (let ((class (apply (if (eq metaclass *the-class-standard-class*)
			      'make-instance-standard-class
			      'make-instance)
			 metaclass :name name (cdr all-keys))))
	 (setf-find-class class name)
	 class )))

;;; make-instance-standard-class creates and initializes an instance of
;;; standard-class without falling into method lookup. However, it cannot
;;; be called until standard-class itself exists.

(defun make-instance-standard-class lst
   ;; lst looks like (metaclass :NAME name :DIRECT-SUPERCLASSES
   ;;		      direct-superclasses :DIRECT-SLOTS direct-slots
   ;;		     ...)
   (let ((class (std-allocate-instance *the-class-standard-class*)))
       (setf-class-name (caddr lst) class)
       (setf-class-direct-subclasses () class)
       (setf-class-direct-methods () class)
       (std-after-initialization-for-classes class
	   :DIRECT-SUPERCLASSES  (nth 4 lst) ; direct-superclasses
	   :DIRECT-SLOTS (nth 6 lst)) ; direct-slots
   class))

(defun std-after-initialization-for-classes key-lst
   ;; key-lst looks like (class :DIRECT-SUPERCLASSES direct-superclasses
   ;;			    :DIRECT-SLOTS direct-slots)
   (let ((class (car key-lst))
	 (supers
	   (or (getf* (cdr key-lst) ':DIRECT-SUPERCLASSES)
	       (list (find-class 'standard-object t))))
	 (direct-slots (getf* (cdr key-lst) ':DIRECT-SLOTS)))
      (setf-class-direct-superclasses supers class)
      (dolist (superclass supers)
	;;* Original Closette uses 'PUSH here.
	 (setf-class-direct-subclasses
		(cons class
		      (class-direct-subclasses superclass))
		superclass))
      (let ((slots
	      (mapcar '(lambda (slot-properties)
			  (apply 'make-slot-definition slot-properties))
		      direct-slots)))
	  (setf-class-direct-slots slots class)
	  ;; readers and writers
	  (dolist (direct-slot slots)
	     (dolist (reader (slot-definition-readers direct-slot))
		(add-reader-method
		   class reader (slot-definition-name direct-slot)))
	     (dolist (writer (slot-definition-writers direct-slot))
		(add-writer-method
		   class writer (slot-definition-name direct-slot))))
	  (funcall (if (eq (class-of class) *the-class-standard-class*)
		       'std-finalize-inheritance
		       'finalize-inheritance)
		    class))))

;;; Slot definition metaobjects

;;* Combined the definitions MAKE-DIRECT-SLOT-DEFINITION & MAKE-EFFECTIVE-SLOT
;;* -DEFINITION since they were effectively doing the same thing.  The new
;;* function is called MAKE-SLOT-DEFINITION and is called in place of the
;;* other two.	One notable difference is that it doesn't automatically
;;* create slot options with null values, unless of course they're passed in.

(defun make-slot-definition properties
   (do ((slot-opts properties (cddr slot-opts))
	(slot nil (acons (car slot-opts) (cadr slot-opts) slot)))
	  ((null slot-opts)
	      (reverse (if (slot-definition-allocation slot)
			    slot
			   (acons ':allocation ':instance slot))))))

;;* Slot accessors - original Closette provides writers also
;;* (i.e., (defun (setf slot-definition-name)..), but since they were not
;;* used in bootstrapping they were omitted from this version.

(defun slot-definition-name (slot) (cdr (assoc ':name slot)))

(defun eq-slot-definition-name (name slot)
 (eq (slot-definition-name slot) name) )

(defun neq-slot-definition-name (name slot)
 (neq (slot-definition-name slot) name) )

(defun slot-definition-initfunction (slot) (cdr (assoc ':initfunction slot)))

(defun slot-definition-initform (slot) (cdr (assoc ':initform slot)))

(defun slot-definition-initargs (slot) (cdr (assoc ':initargs slot)))

(defun slot-definition-readers (slot) (cdr (assoc ':readers slot)))

(defun slot-definition-writers (slot) (cdr (assoc ':writers slot)))

(defun slot-definition-allocation (slot) (cdr (assoc ':allocation slot)))

;;; finalize-inheritance

(defun std-finalize-inheritance (class)
   (setf-class-precedence-list
	(if (eq (class-of class) *the-class-standard-class*)
	    (std-compute-class-precedence-list class)
	    (compute-class-precedence-list class) )
	class)
   (setf-class-slots
	(if (eq (class-of class) *the-class-standard-class*)
	    (std-compute-slots class)
	    (compute-slots class) )
	class) )

;;;	Class precedence lists

(defun std-compute-class-precedence-list (class)
   (let ((classes-to-order (collect-superclasses* class)))
      (topological-sort classes-to-order
			(remove-duplicates
			   (mapappend 'local-precedence-ordering
				       classes-to-order))
			'std-tie-breaker-rule)))


;;; topological-sort implements the standard algorithm for topologically
;;; sorting an arbitrary set of elements while honoring the precedence
;;; constraints given by a set of (X,Y) pairs that indicate that element
;;; X must precede element Y.  The tie-breaker procedure is called when
;;; it is necessary to choose from multiple minimal elements; both a list
;;; of candidates and the ordering so far are provided as arguments.

(defun topological-sort (elements constraints tie-breaker)
   (let ((remaining-constraints constraints)
	 (remaining-elements elements)
	 (result ()))
      (loop
	 ((null remaining-elements)) ;* are we through?
	 (let ((minimal-elements
		(remove-if '(lambda (class)
			      (member class (mapcar 'cadr remaining-constraints)))
			   remaining-elements)))
	    ((null minimal-elements)
		  ;* if we've gotten this far and no minimal elements, then?
	     (break nil "Inconsistent Precedence Graph"))
	    (let ((choice (if (null (cdr minimal-elements))
			      (car minimal-elements)
			     (funcall tie-breaker
				      minimal-elements
				      result))))
	      (setq result (append result (list choice))
		    remaining-elements (remove choice remaining-elements)
		    remaining-constraints (remove choice
						  remaining-constraints
						  'member)))))
   result)) ;* return result

;;; In the event of a tie while topologically sorting class precedence lists,
;;; the CLOS Specification says to "select the one that has a direct subclass
;;; rightmost in the class precedence list computed so far."  The same result
;;; is obtained by inspecting the partially constructed class precedence list
;;; from right to left, looking for the first minimal element to show up
;;; among the direct superclasses of the class precedence list constituent.

(defun std-tie-breaker-rule (minimal-elements cpl-so-far
    common)
  (setq cpl-so-far (reverse cpl-so-far))
  (loop
    ((null cpl-so-far)	nil)
    ((setq common (intersection minimal-elements
				(class-direct-superclasses (pop cpl-so-far))))
      (car common) ) ) )

;;; This version of collect-superclasses* isn't bothered by cycles in the
;;; class hierarchy, which sometimes happen by accident.

(defun collect-superclasses* (class
    superclasses to-be-processed seen)
  (setq superclasses (list class))
  (loop
    (setq to-be-processed (set-difference superclasses seen))
    ((null to-be-processed)  superclasses)
    (push (car to-be-processed) seen)
    (setq superclasses (union (class-direct-superclasses (car to-be-processed))
			      superclasses)) ) )

;;; The local precedence ordering of a class C with direct superclasses C_1,
;;; C_2, ..., C_n is the set ((C C_1) (C_1 C_2) ... (C_n-1 C_n)).

(defun local-precedence-ordering (class)
   (mapcar 'list
	   (cons class (butlast (class-direct-superclasses class)))
	   (class-direct-superclasses class)) )

;;; Slot inheritance

(defun std-compute-slots (class
    all-slots all-names slot-definitions)
  (setq all-slots (mapappend 'class-direct-slots
			     (class-precedence-list class))
	all-names (remove-duplicates (mapcar 'slot-definition-name all-slots)))
  (loop
    ((null all-names)
      (nreverse slot-definitions) )
    (push (funcall (if (eq (class-of class) *the-class-standard-class*)
		       'std-compute-effective-slot-definition
		       'compute-effective-slot-definition)
		   class
		   (remove (pop all-names) all-slots 'neq-slot-definition-name))
	  slot-definitions) ) )

(defun std-compute-effective-slot-definition (class direct-slots
    initer)
  (setq initer (find-if 'slot-definition-initfunction direct-slots))
  (make-slot-definition
	:name (slot-definition-name (car direct-slots))
	:initform (if initer (slot-definition-initform initer) nil)
	:initfunction (if initer (slot-definition-initfunction initer) nil)
	:initargs (remove-duplicates
			(mapappend 'slot-definition-initargs direct-slots))
	:allocation (slot-definition-allocation (car direct-slots))) )

;;;
;;; Generic function metaobjects and standard-generic-function
;;;

(setq *the-defclass-standard-generic-function*
   '(defclass standard-generic-function ()
	((name :initarg :name)	       ; :accessor generic-function-name
	 (lambda-list
	     :initarg :lambda-list) ; :accessor generic-function-lambda-list
	 (methods :initform ())      ; :accessor generic-function-methods
	 (method-class
	     :initarg :method-class) ; :accessor generic-function-method-class
	 (discriminating-function)	; :accessor generic-function-
					; discriminating-function
	 (classes-to-emf-table :initform ()) ; :accessor classes-to-emf-table
      ))) ;* Original Closette version implements the above as a hash table.

(setq *the-class-standard-gf*) ;standard-generic-function's class metaobject

(defun generic-function-name (gf)
  (slot-value gf 'name) )
(defun setf-generic-function-name (new-value gf)
  (setf-slot-value new-value gf 'name) )

(defun generic-function-lambda-list (gf)
  (slot-value gf 'lambda-list) )
(defun setf-generic-function-lambda-list (new-value gf)
  (setf-slot-value new-value gf 'lambda-list) )

(defun generic-function-methods (gf)
  (slot-value gf 'methods) )
(defun setf-generic-function-methods (new-value gf)
  (setf-slot-value new-value gf 'methods) )

(defun generic-function-discriminating-function (gf)
  (slot-value gf 'discriminating-function) )
(defun setf-generic-function-discriminating-function (new-value gf)
  (setf-slot-value new-value gf 'discriminating-function) )

(defun generic-function-method-class (gf)
  (slot-value gf 'method-class) )
(defun setf-generic-function-method-class (new-value gf)
  (setf-slot-value new-value gf 'method-class) )

;;;
;;; Method metaobjects and standard-method
;;;

(setq *the-defclass-standard-method*
   '(defclass standard-method ()
	((lambda-list :initarg :lambda-list)	; :accessor method-lambda-list
	 (qualifiers :initarg :qualifiers)	; :accessor method-qualifiers
	 (specializers :initarg :specializers)	; :accessor method-specializers
	 (body :initarg :body)		       ; :accessor method-body
	 ;(environment) 	 ;* :accessor method-environment, not used
	 (generic-function :initform nil) ; :accessor method-generic-function
	 (func) 	 ;* :accessor method-function, can't use name function
	)))

(setq *the-class-standard-method*) ;standard-method's class metaobject

(defun method-lambda-list (method)
  (slot-value method 'lambda-list) )
(defun setf-method-lambda-list (new-value method)
  (setf-slot-value new-value method 'lambda-list) )

(defun method-qualifiers (method)
  (slot-value method 'qualifiers) )
(defun setf-method-qualifiers (new-value method)
  (setf-slot-value new-value method 'qualifiers) )

(defun method-specializers (method)
  (slot-value method 'specializers) )
(defun setf-method-specializers (new-value method)
  (setf-slot-value new-value method 'specializers) )

(defun method-body (method)
  (slot-value method 'body) )
(defun setf-method-body (new-value method)
  (setf-slot-value new-value method 'body) )

;;* No functions for method-environment as it's not used anyway

(defun method-generic-function (method)
  (slot-value method 'generic-function) )
(defun setf-method-generic-function (new-value method)
  (setf-slot-value new-value method 'generic-function) )

(defun method-function (method)
  (slot-value method 'func) )
(defun setf-method-function (new-value method)
  (setf-slot-value new-value method 'func) )

;;;	defgeneric

(defmacro defgeneric (function-name lambda-list . opts)
   `(ensure-generic-function
	',function-name
	:lambda-list ',lambda-list
	,@(canonicalize-defgeneric-options opts)))

(defun canonicalize-defgeneric-options (opts)
  (mapappend 'canonicalize-defgeneric-option opts) )

(defun canonicalize-defgeneric-option (option)
   (case (car option)
      (:generic-function-class
	 (list ':generic-function-class `(find-class ',(cadr option) t)))
      (:method-class
	 (list ':method-class `(find-class ',(cadr option) t)))
      (t (list `(quote ,(car option) `(quote ,(cadr option)))))))

;;; find-generic-function looks up a generic-function by name. It's an
;;; artifact of the fact that our generic function metaobjects can't
;;; legally be stored as a symbol's function value.
;;* The generic function table accessors are implemented similar to the
;;* class table accessors (find-class, setf-find-class) in order to get
;;* around using hash tables.

(setq *generic-function-table* nil)

(defun find-generic-function (key errorp)
  ((get '*generic-function-table* key))
  (if errorp (break key "Generic function not found")) )

(defun setf-find-generic-function (new-value key)
  (put '*generic-function-table* key new-value) )

(defun forget-all-generic-functions ()
  (setf (cdr '*generic-function-table*) nil) )

;;* Without this function, once you say (DEFGENERIC foo ()), foo's lambda-list
;;* can't be modified by evaling another DEFGENERIC form. Execute
;;* (remove-generic-function 'foo) and redefine foo as you like.

(defun remove-generic-function (gf-name   gf)
   ((setq gf (find-generic-function gf-name t))
    ((Y-or-N-P "Are you sure you want to remove this generic function and its methods?")
	;; remove methods from generic function
     (dolist (method (generic-function-methods gf))
	(remove-method gf method))
     ;; remove generic function from *generic-function-table*
     (remprop '*generic-function-table* gf-name)
     ;; remove the function definition
     (setf (symbol-function gf-name) nil)
     (princ (pack* "Generic function -> " gf-name " has been removed.") t)
     nil
    )))

;;; ensure-generic-function

(defun ensure-generic-function all-keys
   (let ((function-name (car all-keys))
	 (generic-function-class (or (getf* (cdr all-keys)
					    ':generic-function-class)
				     *the-class-standard-gf*))
	 (method-class (or (getf* (cdr all-keys) ':method-class)
			   *the-class-standard-method*)))
    ((find-generic-function function-name nil)
     (find-generic-function function-name))
    (let ((gf (apply (if (eq generic-function-class *the-class-standard-gf*)
			      'make-instance-standard-generic-function
			      'make-instance)
			 generic-function-class
			 :name function-name
			 :method-class method-class
			 (cdr all-keys))))
	 (setf-find-generic-function gf function-name)
	 gf )))

;;; finalize-generic-function

;;; N.B.  Same basic idea as finalize-inheritance.  Takes care of
;;; recomputing and storing the discriminating function, and clearing
;;; the effective method function table.

(defun finalize-generic-function (gf)
   (setf-generic-function-discriminating-function
      (funcall (if (eq (class-of gf) *the-class-standard-gf*)
		   'std-compute-discriminating-function
		   'compute-discriminating-function)
	       gf)
      gf)
   ;* symbol-function used instead of fdefinition
   (setf (symbol-function (generic-function-name gf))
	 (generic-function-discriminating-function gf))
   (setf-slot-value '() gf 'classes-to-emf-table)
   nil)

;;; make-instance-standard-generic-function creates and initializes an
;;; instance of standard-generic-function without falling into method
;;; lookup.
;;; However, it cannot be called until standard-generic-function exists.

(defun make-instance-standard-generic-function lst
   ;; lst looks like (generic-function-class :NAME function-name
   ;;		      :METHOD-CLASS method-class :LAMBDA-LIST lambda-list
   ;;		     ...)
   (let ((gf (std-allocate-instance *the-class-standard-gf*)))
       (setf-generic-function-name (caddr lst) gf)
       (setf-generic-function-lambda-list (nth 6 lst) gf)
       (setf-generic-function-methods () gf)
       (setf-generic-function-method-class (nth 4 lst) gf)
       (finalize-generic-function gf)
   gf))

;;; defmethod
(defmacro defmethod args
   (let ((parsed-arguments (parse-defmethod args)))
     `(ensure-method (find-generic-function ,(car parsed-arguments) t)
	:lambda-list ',(caddr parsed-arguments)
	:qualifiers ',(cadr parsed-arguments)
	:specializers (canonicalize-specializers ',(cadddr parsed-arguments))
	:body ',(nth 4 parsed-arguments))))

(defun canonicalize-specializers (specializers)
   (mapcar 'canonicalize-specializer specializers))

(defun canonicalize-specializer (specializer)
   (find-class specializer t))

(defun parse-defmethod (args)
   (let ((fn-spec (car args))
	 (qualifiers ())
	 (specialized-lambda-list nil)
	 (body ())
	 (parse-state :qualifiers))
      (dolist (arg (cdr args))
	 (case parse-state    ;* case instead of ecase
	    (:qualifiers
	       (if (and (atom arg) (not (null arg)))
		   (push arg qualifiers) ;* push instead of push-on-end
		   (setq specialized-lambda-list arg
			 parse-state :body)))
	    (:body
	       (push arg body)) ;* push instead of push-on-end
	    (t (break parse-state "Invalid Parse State"))))
       (list fn-spec
	     qualifiers
	     (extract-lambda-list specialized-lambda-list)
	     (extract-specializers specialized-lambda-list)
	     (reverse body) ;* don't have block, so just return body
	     )))

;;; Several tedious funtions for analyzing lambda lists
;;* took out let

(defun required-portion (gf args
    number-required)
  ((< (length args)
      (setq number-required
	    (length (cdar ;* since we know where this is, then hard-code it
			   (analyze-lambda-list (slot-value gf 'lambda-list) ) ) ) ) )
      (break (pack* "GENERIC FUNCTION -> " (generic-function-name gf)
		    ", Required arguments ->" number-required)
	     "Insufficient Arguments") )
  (sublist args 0 (sub1 number-required))) ;* sublist in lieu of subseq

;;* The original Closette handles all lambda-list keywords; the only
;;* one this version handles is &rest.
(defun extract-lambda-list (specialized-lambda-list)
   (let* ((plist (analyze-lambda-list specialized-lambda-list))
	  (requireds (cdr (assoc ':required-names plist)))
	  (rv (cdr (assoc ':rest-var plist))))
     `(,@requireds
       ,@(if rv `(&rest ,rv) ()))))

(defun extract-specializers (specialized-lambda-list) ;* took out let
   (cdr (assoc ':specializers (analyze-lambda-list specialized-lambda-list))))

;;* The original Closette handles all lambda-list keywords; the only
;;* one this version handles is &rest. Rewrote using muLISP Loop instead
;;* of dolist and implicit conds instead of CASE.
(defun analyze-lambda-list (lambda-list
    required-names required-args specializers rest-var state arg)
     (setq state :parsing-required)
     (loop
       (setq arg (pop lambda-list))
       ((null arg)
	 ;;* Use PAIRLIS to create a-list for efficiency instead of LIST
	 (pairlis '(:required-args :required-names :specializers :rest-var)
	    (list (nreverse required-args)
		  (nreverse required-names) (nreverse specializers) rest-var)) )
	( ((member arg '(&key &optional &rest &aux &allow-other-keys))
	     (if (eq arg '&rest)
	       (setq state :parsing-rest)
	       (break arg "Keyword Unsupported") ))
	  ((eq state :parsing-required)
	      (push arg required-args) ;* push instead of push-on-end
	      ((listp arg) ;* push instead of push-on-end
		(push (car arg) required-names)
		(push (cadr arg) specializers) )
	      (push arg required-names)
	      (push 't specializers) )
	  ((eq state :parsing-rest)
	      (setq rest-var arg) )
	  (break state "Invalid Parse State") ) ))

;;; ensure method

(defun ensure-method all-keys
   (let* ((gf (car all-keys))
	  (new-method
	     (apply
		(if (eq (generic-function-method-class gf)
			*the-class-standard-method*)
		    'make-instance-standard-method
		    'make-instance)
		(generic-function-method-class gf)
		(cdr all-keys))))
      (add-method gf new-method)
      new-method))


;;; make-instance-standard-method creates and initializes an instance of
;;; standard-method without falling into method lookup.  However, it cannot
;;; be called until standard-method exists.

(setq *method-count* 0)

(defun make-instance-standard-method lst
   ;; lst looks like (method-class :LAMBDA-LIST lambda-list :QUALIFIERS
   ;;		      qualifiers :SPECIALIZERS specializers :BODY body)
   (let ((method (std-allocate-instance *the-class-standard-method*)))
       (setf-method-lambda-list (caddr lst) method)
       (setf-method-qualifiers (nth 4 lst) method)
       (setf-method-specializers (nth 6 lst) method)
       (setf-method-body (nth 8 lst) method)
       (setf-method-generic-function nil method)
       ;;* storing method function under a symbol name
       (setf-method-function (putd (pack* 'method- (incq *method-count*))
				   (std-compute-method-function method))
			     method)
    method))

;;; add-method

;;; This version first removes any existing method on the generic function
;;; with the same qualifiers and specializers. It's a pain to develop
;;; programs without this feature of full CLOS.

(defun add-method (gf method)
   (let ((old-method
	    (find-method gf (method-qualifiers method)
			    (method-specializers method) nil)))
     (if old-method (remove-method gf old-method)) )
   (setf-method-generic-function gf method)
   (setf-generic-function-methods
       (cons method (generic-function-methods gf))
       gf)  ;* instead of 'push which likes symbols
   (dolist (specializer (method-specializers method))
      (setf-class-direct-methods
	  (adjoin method (class-direct-methods specializer))
	  specializer)) ;* instead of 'pushnew which likes symbols
   (finalize-generic-function gf)
   method)

(defun remove-method (gf method)
   (setf-generic-function-methods
       (remove method (generic-function-methods gf))
	gf)
   (setf-method-generic-function nil method)
   (dolist (class (method-specializers method))
      (setf-class-direct-methods
	  (remove method (class-direct-methods class))
	  class))
   (finalize-generic-function gf)
   method)

(defun find-method (gf qualifiers specializers errorp)
   (let ((method    ;* had to use eqlist because 'equal doesn't
		    ;* handle a list of instances - infinite loop
	    (find-if '(lambda (method)
			(and (equal qualifiers
				    (method-qualifiers method))
			     (eqlist specializers
				     (method-specializers method))))
		     (generic-function-methods gf))))
      (if (and (null method) errorp)
	  (break (pack* "GENERIC FUNCTION -> " (generic-function-name gf))
		 "Method not found")
	  method)))

;;; Reader and writer methods

(defun add-reader-method (class fn-name slot-name)
   (ensure-method
      (ensure-generic-function fn-name :lambda-list '(object))
      :lambda-list '(object)
      :qualifiers ()
      :specializers (list class)
      :body (list `(slot-value object ',slot-name)))
      ;* no environment here
    nil)

(defun add-writer-method (class fn-name slot-name)
   (ensure-method
      (ensure-generic-function fn-name :lambda-list '(new-value object))
      :lambda-list '(new-value object)
      :qualifiers ()
      :specializers (list (find-class 't t) class)
      :body (list `(setf-slot-value new-value object ',slot-name)))
      ;* no environment here
    nil)

;;;
;;; Generic function invocation
;;;

;;; apply-generic-function

(defun apply-generic-function (gf args)
   (apply (generic-function-discriminating-function gf) args))

;;; compute-discriminating-function
;;* Instead of a lambda function, use a closure to make sure the value of
;;* gf is stored with this lambda definition.

(defun std-compute-discriminating-function (gf)
  (closure '(gf)
    '(lambda args
      ((lambda (classes emfun)
	  ((setq emfun (cdr (assoc classes
				   (slot-value gf 'classes-to-emf-table)
				   'eqlist ) ) )
	     (funcall emfun args) )
	  (slow-method-lookup gf args classes) )
       (mapcar 'class-of (required-portion gf args))
       ) ) ) )

(setq *emf-count* 0)

;;* This next function accesses the list of
;;* classes and effective method functions stored in a table.
;;* Original Closette uses hash tables to store these items
;;* and so their accessor functions are those inherent with hash tables.
;;* Effective method functions will be associated with a list of classes,
;;* that's why the use of 'eqlist.

(defun setf-find-emfun (table emf classes
    object)
  ((setq object (assoc classes table 'eqlist))	; use 'eqlist instead of 'equal
    (setf (cdr object) emf)
    table )
  (acons classes emf table) )

(defun slow-method-lookup (gf args classes
    emfun )
  (setq emfun  ;;* storing emf under a symbol name
	(putd (pack* 'emf- (incq *emf-count*))
	      (funcall
		(if (eq (class-of gf) *the-class-standard-gf*)
		     'std-compute-effective-method-function
		     'compute-effective-method-function)
		gf (compute-applicable-methods-using-classes gf classes))))
  (setf-slot-value
    (setf-find-emfun (slot-value gf 'classes-to-emf-table) emfun classes)
     gf
     'classes-to-emf-table )
  (funcall emfun args) )

;;; compute-applicable-methods-using-classes

(defun compute-applicable-methods-using-classes (gf required-classes)
   (sort
      (copy-list
	 (remove-if-not '(lambda (method)
			   (every 'subclassp
				   required-classes
				   (method-specializers method)))
			(generic-function-methods gf)))
      '(lambda (m1 m2)
	 (funcall
	    (if (eq (class-of gf) *the-class-standard-gf*)
		'std-method-more-specific-p
		'method-more-specific-p)
	    gf m1 m2 required-classes))))

;;;   std-method-more-specific-p

(defun std-method-more-specific-p (gf method1 method2 required-classes)
   (catch 'out
      (mapc '(lambda (spec1 spec2 arg-class)
	       (if (neq spec1 spec2)
		(throw 'out   ;* catch & throw in lieu of return-from
		   (sub-specializer-p spec1 spec2 arg-class))))
	     (method-specializers method1)
	     (method-specializers method2)
	     required-classes)
   nil))

;;; apply-methods and compute-effective-method-function

(defun apply-methods (gf args methods)
   (funcall (compute-effective-method-function gf methods) args))

(defun primary-method-p (method) (null (method-qualifiers method)))

(defun before-method-p (method) (equal '(:before) (method-qualifiers method)))

(defun after-method-p (method) (equal '(:after) (method-qualifiers method)))

(defun std-compute-effective-method-function (gf methods
    primaries befores afters)
  (setq primaries (remove-if-not 'primary-method-p methods))
  ((null primaries)
     (Break (pack* "GENERIC FUNCTION -> " (class-name gf))
		   "Primary Method not found"))
  (setq befores (mapcar 'method-function
			(remove-if-not 'before-method-p methods))
	afters (mapcar 'method-function
		       (reverse (remove-if-not 'after-method-p methods))))
  `(lambda (args)
      ,@(append (mapcar 'splice-method befores)
		(list (if afters
			 (cons 'prog1
			       (cons (list (method-function (car primaries))
					    'args )
				      (mapcar 'splice-method afters) ) )
			 (list (method-function (car primaries)) 'args) ) ) ) )
 )

(defun splice-method (func)
  (list func 'args) )

;;* Here original Closette has a definition for compute-primary-emfun
;;* which is used to execute multiple primary methods.	It has been
;;* omitted in this version since multiple primary method execution is
;;* not supported.

;;; apply-method and std-compute-method-function

;;* This version works without multiple primary methods.
(defun apply-method (method args)
   (funcall (method-function method) args))

;;* The result of this function is stored in each method's function
;;* slot. This template is the code needed to execute a method; the
;;* lambda-list and body of method are stored in-line.	The original
;;* Closette version compiles this result before it's stored; it also
;;* provides local definitions for the functions 'call-next-method and
;;* 'next-method-p.
(defun std-compute-method-function (method)
   (let ((lambda-list (method-lambda-list method)))
      `(lambda (args)
	 (apply '(lambda ,(remove '&rest lambda-list)
			 ,@(method-body method))
		(kludge-arglist args ',lambda-list)))))

;;; kludge-arglist was written to simulate the processing of a &rest
;;; lambda-list parameter in a method definition.  If a &rest was
;;; specified in the lambda list of the defmethod, then all the
;;; arguments after the required arguments are packaged into a list
;;; so that they will be assigned to the &rest variable when
;;; the method function (above) is executed.
;;* Any similarities to the original Closette version end at the
;;* function name.

(defun kludge-arglist (arglist lambda-list
   pos)
   ((setq pos (position '&rest lambda-list))
       (append (firstn pos arglist)
	       (list (nthcdr pos arglist))))
   arglist)

;;* Here, the original Closette had the definitions
;;* top-level-environment which returned nil and compile-in-lexical-
;;* environment which called compile on a lambda-expression.

;;* The bootstrapping functions are in a file called closboot.lsp
(load closboot)
