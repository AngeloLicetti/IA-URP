;;;		* * * A muLISP CLOS program to add two polynomials * * *

;; An example borrowed from Understanding CLOS by Jo A. Lawless and Molly M.
;; Miller.  This file shows how methods can be specialized for a class.

;; First, borrow some COMMON.LSP macros.

(DEFMACRO DOTIMES ((VAR COUNTFORM RSLTFORM) . BODY)
; Binds VAR to 0 through the value of COUNTFORM and evaluates BODY.
  (LET ((DOTIMES (GENSYM)))
    (LIST 'LET
	  (LIST (LIST VAR 0)
		(LIST DOTIMES COUNTFORM))
	  (LIST* 'LOOP
		 (LIST (LIST '>= VAR DOTIMES) RSLTFORM)
		 (APPEND BODY (LIST (LIST 'INCQ VAR))))) ) )

(DEFMACRO UNLESS (TEST . BODY)
; If the value of TEST is NIL, BODY is evaluated.
  (LIST 'IF TEST NIL (CONS 'PROGN BODY)) )

;; Now, we create a class and a generic function...

;; Define the class POLYNOMIAL.
(defclass polynomial ()
   ;; A polynomial has just a vector of coefficients.
   ((coefficients :initarg :coefficients
		  :accessor poly-coeff
		  :initform 0)))

;; Define a generic function PLUS.
(defgeneric plus (x y))

;;; To apply the operation to specific classes, we define methods for the
;;; generic function PLUS that use numbers, polynomials, and a combination
;;; of both.  These methods provide the expected behavior for PLUS and
;;; allow the addition of two numbers, two polynomials, a number and a
;;; polynomial, and a polynomial and a number.	The last two cases are
;;; distinguished because muLISP CLOS selects methods based on their class
;;; arguments, and the order in which the arguments are specified affects
;;; the order in which methods are invoked.

;; Define a method on PLUS that accepts two numbers.
(defmethod plus ((x number) (y number))
   (+ x y))

;; Define a method on PLUS that accepts two polynomials.
(defmethod plus ((x polynomial) (y polynomial))
   (let* ((x-coef (poly-coeff x))
	  (y-coef (poly-coeff y))
	  (maxlen (max (length x-coef) (length y-coef)))
	  (minlen (min (length x-coef) (length y-coef)))
	  (result-coefficients (make-list maxlen)))
       (unless (= maxlen (length x-coef))
	   ;; Make sure x is longer
	   (psetq x-coef y-coef y-coef x-coef))
       (dotimes (i maxlen)
	  (setf (nth i result-coefficients)
		(if (>= i minlen)
		    (nth i x-coef)
		    (+ (nth i y-coef) (nth i x-coef)))))
       (make-instance 'polynomial :coefficients result-coefficients)))

;; Define a method on PLUS that accepts a number and a polynomial.
(defmethod plus ((x number) (y polynomial))
   (let* ((y-coef (poly-coeff y))
	  (result-coef (copy-list y-coef)))
      (if (< 2 (length y-coef))
	  (setf (nth 0 result-coef) (+ x (nth 0 y-coef)))
	  (setf (nth 0 result-coef) x))
      (make-instance 'polynomial :coefficients result-coef)))

;; Define a method on PLUS that accepts a polynomial and a number.
;; It simply reverses the arguments so that the preceding method
;; can perform the operation.
(defmethod plus ((x polynomial) (y number))
   ;; Simply reverse argument and call PLUS.
   (plus y x))

;;; To display the results in polynomial form, we need to write a method
;;; for the predefined generic function PRINT-OBJECT.

;; Define a PRINT-OBJECT method for polynomials so you can see them
;; in the usual notation.
(defmethod print-object ((instance polynomial) stream)
   (let* ((coeff (poly-coeff instance))
	  (lasti (sub1 (length coeff))))
      (princ "#<Polynomial (" stream)
      (dotimes (i (add1 lasti))
	 (unless (zerop (nth i coeff))
	    (princ (nth i coeff) stream)
	    (unless (= i 0)
	       (write-string "x" stream)
	       (( >= i 2)
		(write-string "^" stream)
		(princ i stream)))
	     (unless (= i lasti)
		(write-string " + " stream))))
       (princ ")>" stream)
   ))

;;; Now we apply the method whose parameters are specialized on
;;; polynomials

;(PLUS (MAKE-INSTANCE 'polynomial :coefficients '(3 4 5 2 0 8 7))
;      (MAKE-INSTANCE 'polynomial :coefficients '(3 4 5 2 0 7)))

;;; Similarly, we get the expected results when we invoke plus with
;;; other parameter specializers
(fresh-line)
(write-line
  "Try (PLUS (MAKE-INSTANCE 'polynomial :coefficients '(3 4 5 2 0 8 7)) 100)")

;;; Now, just the ordinary plus on two numbers

(write-line "or this - (PLUS 2 3)")
