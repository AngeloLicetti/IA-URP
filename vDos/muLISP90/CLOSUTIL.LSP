;;;		      The Common LISP subset needed by muLISP CLOS

(DEFMACRO SETF LST
; If PLACE is a valid place form, (SETF PLACE FORM) stores the result of
; evaluating FORM in PLACE.
  ((NULL LST) NIL)
  ((NULL (CDDR LST))
    ((ATOM (CAR LST))
      (CONS 'SETQ LST) )
    (MAKE-SET-FORM (CAR LST) (CADR LST)) )
  (CONS 'PROGN (SETF-AUX LST)) )

(DEFUN SETF-AUX (LST
; Returns a list of SETF forms.
    TMP)
  ((NULL LST) NIL)
  ((ATOM (CAR LST))
    ((AND (SETQ TMP (SETF-AUX (CDDR LST))) (EQ (CAAR TMP) 'SETQ))
      (CONS (LIST* 'SETQ (CAR LST) (CADR LST) (CDAR TMP)) (CDR TMP)) )
    (CONS (LIST 'SETQ (CAR LST) (CADR LST)) TMP) )
  (CONS (MAKE-SET-FORM (CAR LST) (CADR LST)) (SETF-AUX (CDDR LST))) )

(DEFUN MAKE-SET-FORM (PLACE VALUE)
; Returns a form that changes the value stored at PLACE to VALUE.
  ((ATOM PLACE)
    (LIST 'SETQ PLACE VALUE) )
  ((EQ (CAR PLACE) 'CAR)
    (LIST 'CAR (LIST 'RPLACA (CADR PLACE) VALUE)) )
  ((OR (EQ (CAR PLACE) 'CDR) (EQ (CAR PLACE) 'REST))
    (LIST 'CDR (LIST 'RPLACD (CADR PLACE) VALUE)) )
  ((EQ (CAR PLACE) 'NTH)
    (LIST 'CAR (LIST 'RPLACA (CONS 'NTHCDR (CDR PLACE)) VALUE)) )
  ((EQ (CAR PLACE) 'GET)
    (LIST 'PUT (CADR PLACE) (CADDR PLACE) VALUE) )
  ((EQ (CAR PLACE) 'SYMBOL-FUNCTION)
    (LIST 'PUTD (CADR PLACE) VALUE) )
  ((GET (CAR PLACE) 'CAR)  (LIST 'CAR
      (LIST 'RPLACA (LIST (GET (CAR PLACE) 'CAR) (CADR PLACE)) VALUE)) )
  ((GET (CAR PLACE) 'CDR)  (LIST 'CDR
      (LIST 'RPLACD (LIST (GET (CAR PLACE) 'CDR) (CADR PLACE)) VALUE)) )
  ((GET (CAR PLACE) 'NTH)
    (LIST 'CAR (LIST 'RPLACA
		     (LIST 'NTHCDR (GET (CAR PLACE) 'NTH) (CADR PLACE))
		     VALUE)) )
  ((MACRO-P (CAR PLACE))
    (MAKE-SET-FORM (MACROEXPAND PLACE) VALUE) )
  (BREAK (LIST 'SETF PLACE VALUE) "Invalid Place Form") )

(MAPC '(LAMBDA (PAIR) (PUT (CAR PAIR) 'CAR (CDR PAIR)))
  '((CAAR . CAR) (CADR . CDR)
    (CAAAR . CAAR) (CAADR . CADR) (CADAR . CDAR) (CADDR . CDDR)
    (CAAAAR . CAAAR) (CAAADR . CAADR) (CAADAR . CADAR) (CAADDR . CADDR)
    (CADAAR . CDAAR) (CADADR . CDADR) (CADDAR . CDDAR) (CADDDR . CDDDR)) )

(MAPC '(LAMBDA (PAIR) (PUT (CAR PAIR) 'CDR (CDR PAIR)))
  '((CDAR . CAR) (CDDR . CDR)
    (CDAAR . CAAR) (CDADR . CADR) (CDDAR . CDAR) (CDDDR . CDDR)
    (CDAAAR . CAAAR) (CDAADR . CAADR) (CDADAR . CADAR) (CDADDR . CADDR)
    (CDDAAR . CDAAR) (CDDADR . CDADR) (CDDDAR . CDDAR) (CDDDDR . CDDDR)) )

(MAPC '(LAMBDA (PAIR) (PUT (CAR PAIR) 'NTH (CDR PAIR)))
  '((FIRST . 0) (SECOND . 1) (THIRD . 2) (FOURTH . 3) (FIFTH . 4)
    (SIXTH . 5) (SEVENTH . 6) (EIGHTH . 7) (NINTH . 8) (TENTH . 9)) )


(DEFUN SYMBOL-FUNCTION (SYM)
; If SYM is a symbol, returns SYM's function definition.
  ((SYMBOLP SYM)
    ((FBOUNDP SYM)
      (GETD SYM) )
    (BREAK (LIST 'SYMBOL-FUNCTION SYM) "Undefined Function") ) )

(DEFUN MACRO-P (SYM)
; If SYM is a macro, it returns T, otherwise it returns NIL.
  (EQ (GETD SYM T) 'MACRO) )

(DEFUN FBOUNDP (SYM)
; If SYM is a function, macro, or special form, it returns T, otherwise it
; returns NIL.
  (GETD SYM T) )

(SETQ *GENSYM-PREFIX* 'G)
(SETQ *GENSYM-COUNT* 0)

(DEFUN GENSYM (ATM)
; (GENSYM) returns the symbol whose print name consists of *GENSYM-PREFIX*
; concatenated to *GENSYM-COUNT* and increments *GENSYM-COUNT*.
; (GENSYM symbol) sets *GENSYM-PREFIX* to <symbol>.
; (GENSYM integer) sets *GENSYM-COUNT* to <integer>.
  ( ((NULL ATM))
    ((SYMBOLP ATM)
      (SETQ *GENSYM-PREFIX* ATM) )
    ((AND (INTEGERP ATM) (>= ATM 0))
      (SETQ *GENSYM-COUNT* ATM) ) )
  (PROG1 (PACK* *GENSYM-PREFIX* *GENSYM-COUNT*)
	 (INCQ *GENSYM-COUNT*)) )

(DEFMACRO LET (LETLIST . BODY)
; Binds the variables in LETLIST in parallel, and evaluates the BODY.
   (CONS (LIST* 'LAMBDA
		(MAPCAR '(LAMBDA (VAR) (IF (ATOM VAR) VAR (CAR VAR))) LETLIST)
		BODY)
	 (MAPCAR '(LAMBDA (VAR) (IF (ATOM VAR) NIL (CADR VAR))) LETLIST)) )

(DEFMACRO LET* (LETLIST . BODY)
; Binds the variables in LETLIST sequentially, and evaluates the BODY.
   (CONS (LIST* 'LAMBDA
		(MAPCAR '(LAMBDA (VAR) (IF (ATOM VAR) VAR (CAR VAR))) LETLIST)
		(CONS 'SETQ
		      (MAPCAN '(LAMBDA (VAR)
				(IF (ATOM VAR)
				    (LIST VAR NIL)
				    (LIST (CAR VAR) (CADR VAR))) )
			      LETLIST))
		BODY)
	 (MAPCAR '(LAMBDA (VAR) (IF (ATOM VAR) VAR (CAR VAR))) LETLIST)) )

(DEFMACRO CASE (KEYFORM . CASES)
; If the value of KEYFORM matches the car of a case in CASES, the cdr of the
; case is evaluated using an implicit PROGN.
  (LIST (LIST 'LAMBDA
	      '(KEY)
	      (CONS 'COND
		    (MAPCAR '(LAMBDA (CASE) (CONS
			       (IF (MEMBER (CAR CASE) '(T OTHERWISE))
				   T
				   (LIST (IF (ATOM (CAR CASE)) 'EQL 'MEMBER)
					 KEY
					 (LIST 'QUOTE (CAR CASE))) )
			       (OR (CDR CASE) '(NIL))) )
			     CASES)))
	KEYFORM) )

(DEFMACRO DO (LETLIST . BODY)
; Repeatedly binds the variables in LETLIST in parallel and evaluates BODY,
; until a nonNIL implicit COND is encountered in BODY.
  (CONS (LIST 'LAMBDA
	      (MAPCAR '(LAMBDA (VAR) (IF (ATOM VAR) VAR (CAR VAR))) LETLIST)
	      (CONS 'LOOP
		    (APPEND BODY (LIST (CONS 'PSETQ
			(MAPCAN '(LAMBDA (VAR)
				   ((ATOM VAR) NIL)
				   ((CDDR VAR)
				     (LIST (CAR VAR) (CADDR VAR)) ) )
				LETLIST))))))
	(MAPCAR '(LAMBDA (VAR) (IF (ATOM VAR) NIL (CADR VAR))) LETLIST)) )

(DEFMACRO DOLIST ((VAR LISTFORM RSLTFORM) . BODY)
; Sets VAR to each element of the value of LISTFORM and evaluates BODY.
  (LET ((DOLIST (GENSYM)))
    (LIST 'LET
	  (LIST (LIST DOLIST LISTFORM))
	  (LIST* 'LOOP
		 (LIST (LIST 'ATOM DOLIST) RSLTFORM)
		 (LIST 'SETQ VAR (LIST 'POP DOLIST))
		 BODY)) ) )

; Section 5.8.2:  Read Macro Characters

(SETQ *BACKQUOTE-CHAR* '\`)	;Determines the backquote macro character

(SETQ *LPAR* '\()
(SETQ *RPAR* '\))

(DEFUN READ-BACKQUOTE (PAREN-DEPTH
; This backquote facility conforms to the Common LISP standard as
; described in Section 22.1.3 of Common LISP by Steele [1984].
; It was contributed by Fujimasa Kouno of Tokushima, Japan.
    OBJ CHAR FORM-LIST)
  (SETQ CHAR (PEEK-CHAR T))

  ((EQ CHAR *BACKQUOTE-CHAR*)
    ((ZEROP PAREN-DEPTH)
      (READ) )
    (LIST 'LIST (READ)) )

  ((EQ CHAR '\')
    (READ-CHAR)
    ((ZEROP PAREN-DEPTH)
      (LIST 'QUOTE (LIST 'QUOTE (EVAL (READ-BACKQUOTE PAREN-DEPTH)))) )
    (LIST 'LIST (LIST* 'LIST ''QUOTE (CDR (READ-BACKQUOTE PAREN-DEPTH)))) )

  ((EQ CHAR '\.)
    ((ZEROP PAREN-DEPTH)
      (BREAK CHAR "Syntax Error") )
    (READ-CHAR)
    (SETQ CHAR (PEEK-CHAR T))
    ((EQ CHAR '\,)
      (READ-CHAR)
      (SETQ CHAR (PEEK-CHAR))
      ((OR (EQ CHAR '@) (EQ CHAR '\.))
	(BREAK CHAR "Syntax Error") )
      (SETQ OBJ (READ)
	    CHAR (PEEK-CHAR T) )
      ((EQ CHAR *RPAR*) OBJ)
      (BREAK CHAR "Syntax Error") )
    (SETQ OBJ (READ-BACKQUOTE 0)
	  CHAR (PEEK-CHAR T) )
    ((EQ CHAR *RPAR*) OBJ)
    (BREAK CHAR "Syntax Error") )

  ((EQ CHAR '\,)
    (READ-CHAR)
    (SETQ CHAR (PEEK-CHAR))
    ((AND (EQ CHAR '\@) (NEQ PAREN-DEPTH 0))
      (READ-CHAR)
      (SETQ OBJ (READ))
      ((EQ (PEEK-CHAR T) *RPAR*) OBJ)
      (LIST 'COPY-LIST OBJ) )
    ((AND (EQ CHAR '\.) (NEQ PAREN-DEPTH 0))
      (READ-CHAR)
      (READ) )
    ((OR (EQ CHAR '\@) (EQ CHAR '\.))
      (BREAK CHAR "Syntax Error") )
    ((ZEROP PAREN-DEPTH)
      (READ) )
    (LIST 'LIST (READ)) )

  ((EQ CHAR *RPAR*)
    (READ-CHAR)
    NIL)

  ((EQ CHAR *LPAR*)
    (READ-CHAR)
    (LOOP
      ((NULL (SETQ OBJ (READ-BACKQUOTE (ADD1 PAREN-DEPTH))))
	((ZEROP PAREN-DEPTH)
	  (CONS 'NCONC (NREVERSE FORM-LIST)) )
	(LIST 'LIST (CONS 'NCONC (NREVERSE FORM-LIST))) )
      (PUSH OBJ FORM-LIST) ) )

  ((ZEROP PAREN-DEPTH)
    (LIST 'QUOTE (READ)) )
  (LIST 'LIST (LIST 'QUOTE (READ))) )

(SET-MACRO-CHAR *BACKQUOTE-CHAR* '(LAMBDA ()
  (READ-BACKQUOTE 0) ))

(DEFUN Y-OR-N-P (MSG
; Displays MSG, and returns T if the user presses Y; it returns NIL if the
; users presses N.
    CHAR )
  ( ((NULL MSG))
    (FRESH-LINE T)
    (WRITE-STRING (PACK* MSG " (Y/N) ") T) )
  (CLEAR-INPUT T)
  (LOOP
    (SETQ CHAR (CHAR-UPCASE (ASCII (READ-BYTE T))))
 ((EQ CHAR 'Y)
      (WRITE-STRING CHAR T)
      T )
    ((EQ CHAR 'N)
      (WRITE-STRING CHAR T)
      NIL )
    (WRITE-BYTE 7 NIL T) ) )

;;; remove-if-not returns a top-level copy of list except
;;; for those elements for which (test element) is NIL.

(defun remove-if-not (test lst)
   ((atom lst) lst)
   ((not (funcall test (car lst)))
     (remove-if-not test (cdr lst)))
   (cons (car lst) (remove-if-not test (cdr lst))))

;;;	Closette utilities

;;; getf* returns the value on the plist under the indicator key.
;;; Plist is a list of sequential keys and values '(:a atom :b boy)
;;* This function is used to get at the value of a function parameter passed
;;* like a keyword to the function.

(defun getf* (plist key)
  (do ((x plist (cddr x)))
      ((null x) nil)
      ((eq (car x) key) (cadr x))))

;;; get-properties* is similar to get-properties except it works with
;;; lists  of sequential keys and values (See getf* comments.)
;;; and it returns the list of (value foundp). Foundp to indicate that
;;; the value was found as the value itself may be nil.
;;* This function is substituted for 'get-properties in original Closette.

(defun get-properties* (plist indicators)
   ((null indicators) (list nil nil))
   (do ((x plist (cddr x)))
	((null x) (list nil nil))
	((member (car x) indicators) (list (cadr x) t))))

;;; eqlist is written to support comparison of lists of
;;; class instances.  The class instances are compared using 'eq.
;;* This function is used instead of 'equal in the original Closette whenever
;;* lists of class instances are to be compared.

(defun eqlist (arg1 arg2)
  (every 'eq arg1 arg2) )

;;* mapappend is like mapcar except the results are appended together:

(defun mapappend (fun args)
   ((null args)  ())
   (append (funcall fun (car args))
	   (mapappend fun (cdr args))))

;;* mapplist is mapcar for property lists:

(defun mapplist (fun x)
   ((null x) ())
   (cons (funcall fun (car x) (cadr x))
	 (mapplist fun (cddr x))))

;			The muLISP Structure Package

(DEFMACRO DEFSTRUCT (STRUCTSPEC . SLOTSPECS)
; Creates a new structure.
  (LIST 'DEFSTRUCT-AUX
	(LIST 'QUOTE STRUCTSPEC)
	(LIST 'QUOTE SLOTSPECS)) )

(DEFUN DEFSTRUCT-AUX (STRUCTSPEC SLOTSPECS)
  (LET* ((name (GET-STRUCT-NAME STRUCTSPEC))
	 (options (GET-STRUCT-OPTIONS name STRUCTSPEC))
	 (slotnams (GET-STRUCT-SLOT-NAMES name SLOTSPECS))
	 (slotvals (GET-STRUCT-SLOT-VALUES name SLOTSPECS))
	 (named? (OR (ASSOC ':NAMED options)
		     (NOT (ASSOC ':TYPE options))) ) )
    (LET ((istruct (ASSOC ':INCLUDE options)) )
      ((CHECK-INCLUDED-STRUCT name istruct named?)
	(SETQ slotnams
	      (APPEND (GET (CADR istruct) 'STRUCT-SLOTNAMES)
		      slotnams))
	(SETQ slotvals
	      (MAPCAR '(LAMBDA (SNAM SVAL)
			   ((CADR (ASSOC SNAM (CDDR istruct))) )
			   SVAL)
		      slotnams
		      (APPEND (GET (CADR istruct) 'STRUCT-SLOTVALS)
			      slotvals))) ) )
    (PUTSTRUCT name options slotnams slotvals named?
	(CHECK-STRUCT-MACDEFS name
	    (APPEND (FORM-STRUCT-CONSTRUCTORS name options slotnams
					      slotvals named?)
		    (FORM-STRUCT-ACCESSORS name options slotnams
					   named?)
		    (FORM-STRUCT-PREDICATE name options named?)
		    (FORM-STRUCT-COPIER name options)))) ) )

(DEFUN GET-STRUCT-NAME (STRUCTSPEC)
; Extracts and returns the structure name specification from STRUCTSPEC,
; verifying that it is a symbol.
  (LET ((stnam (IF (CONSP STRUCTSPEC) (CAR STRUCTSPEC) STRUCTSPEC) ) )
    ((SYMBOLP stnam) stnam)
    (BREAK (LIST* 'DEFSTRUCT STRUCTSPEC SLOTSPECS) "Nonsymbolic Argument") ) )

(DEFUN GET-STRUCT-OPTIONS (NAME STRUCTSPEC)
; Extracts the structure option specifications from STRUCTSPEC, verifying
; that each is a supported option.  Collects and returns the options in
; a uniform "a-list" format.
  ((ATOM STRUCTSPEC) NIL)
  (MAPCAR '(LAMBDA (OPT)
	       (LET ((optnam (IF (CONSP OPT) (CAR OPT) OPT) ) )
		 ((AND (SYMBOLP optnam)
		       (MEMBER optnam '(:CONC-NAME :CONSTRUCTOR :COPIER
				 :PREDICATE :INCLUDE :TYPE :NAMED)) )
		   (CONS optnam (IF (CONSP OPT) (CDR OPT))) )
		 (BREAK (LIST* 'DEFSTRUCT STRUCTSPEC SLOTSPECS)
			"Unsupported Option") ) )
	  (CDR STRUCTSPEC)) )

(DEFUN GET-STRUCT-SLOT-NAMES (NAME SLOTSPECS)
; Extracts the structure slot names from SLOTSPECS, verifying that each
; is a symbol.	Returns a list of the slot names.
  (MAPCAR '(LAMBDA (SLOT)
	       (LET ((snam (IF (CONSP SLOT) (CAR SLOT) SLOT)) )
		 ((SYMBOLP snam) snam)
		 (BREAK (LIST* 'DEFSTRUCT STRUCTSPEC SLOTSPECS)
			"Nonsymbolic Argument") ) )
	  SLOTSPECS) )

(DEFUN GET-STRUCT-SLOT-VALUES (NAME SLOTSPECS)
; Extracts the structure slot values from SLOTSPECS, supplying NIL as
; the value for any slot without a specified value.  Returns a list of
; the slot values.
  (MAPCAR '(LAMBDA (SLOT) (IF (CONSP SLOT) (CADR SLOT)))
	  SLOTSPECS) )


(DEFUN CHECK-INCLUDED-STRUCT (NAME ISTRUCT NAMED?)
; Checks that the (:INCLUDE ...) option ISTRUCT (if any) specifies a
; valid, previously defined structure which is compatible with the
; structure being defined.
  ((NULL ISTRUCT) NIL)
  (LET ((iname (CADR ISTRUCT)) )
    ((GET iname 'STRUCT-MACROS)
      ((GET iname 'NAMED-STRUCT)
	((IDENTITY NAMED?) T)
	(BREAK (LIST* 'DEFSTRUCT STRUCTSPEC SLOTSPECS)
	       "Include Error") )
      ((NOT NAMED?) T)
      (BREAK (LIST* 'DEFSTRUCT STRUCTSPEC SLOTSPECS)
	     "Include Error") )
    (BREAK (LIST* 'DEFSTRUCT STRUCTSPEC SLOTSPECS)
	   "Undefined Structure") ) )

(DEFUN CHECK-STRUCT-MACDEFS (NAME MACDEFS)
; Checks that each MACRO (<name> . <definition>) pair in the list
; MACDEFS will NOT cause an incompatible redefinition of an existing
; function.
  (MAPCAR '(LAMBDA (MACDEF)
	       ((OR (NULL (GETD (CAR MACDEF) T))
		    (EQUAL (GETD (CAR MACDEF)) (CDR MACDEF)) )
		  MACDEF)
	       (IF (NULL (GET (CAR MACDEF) 'STRUCTS))
		   (PUT (CAR MACDEF) 'STRUCTS (CONS)) )
	       ((NULL (REMOVE NAME (GET (CAR MACDEF) 'STRUCTS)))
		  MACDEF)
	       (BREAK (LIST* 'DEFSTRUCT STRUCTSPEC SLOTSPECS)
		      "Incompatible Definition") )
	MACDEFS) )


(DEFUN FORM-STRUCT-CONSTRUCTORS (NAME OPTIONS SLOTNAMS SLOTVALS NAMED?)
; Formulates constructor functions as MACROs for the structure NAME in
; accordance with OPTIONS, SLOTNAMS, SLOTVALS, and NAMED?.  Returns a
; list of constructor function (<name> . <definition>) pairs (or NIL
; if no constructor functions were desired).
  (LET ((consopt (ASSOC ':CONSTRUCTOR OPTIONS)) )
    ((NULL consopt)
      (LIST (CONS (PACK* 'MAKE- NAME)
		  (STRUCT-KEYWORD-CONSTRUCTOR NAME SLOTNAMS SLOTVALS
			NAMED?))) )
    (MAPCAN '(LAMBDA (OPT)
		 ((EQ (CAR OPT) ':CONSTRUCTOR)
		   ((NULL (CDR OPT))
		     (LIST (CONS (PACK* 'MAKE- NAME)
				 (STRUCT-KEYWORD-CONSTRUCTOR NAME
				       SLOTNAMS SLOTVALS NAMED?))) )
		   ((NULL (CADR OPT)) )
		   ((NULL (CDDR OPT))
		     (LIST (CONS (CADR OPT)
				 (STRUCT-KEYWORD-CONSTRUCTOR NAME
				       SLOTNAMS SLOTVALS NAMED?))) )
		   (LIST (CONS (CADR OPT)
			       (STRUCT-POSITIONAL-CONSTRUCTOR NAME
				     SLOTNAMS SLOTVALS (CADDR OPT)
				     NAMED?))) ) )
	    OPTIONS) ) )

(DEFUN STRUCT-KEYWORD-CONSTRUCTOR (NAME SLOTNAMS SLOTVALS NAMED?)
; Formulates a keyword constructor function as a MACRO for the structure
; NAME in accordance with SLOTNAMS, SLOTVALS, and NAMED?.  Returns the
; definition for the constructor.
  (LIST 'MACRO
	'SLOTSPECS
	(APPEND '(LIST* 'LIST)
		(IF NAMED? (LIST (LIST 'QUOTE (LIST 'QUOTE NAME))))
		(LIST (LIST 'MAPCAR
			    ''(LAMBDA (SNAM SVAL)
				  (LET ((spec (MEMBER (PACK* '":" SNAM)
						      SLOTSPECS)) )
				    ((NULL spec) SVAL)
				    (CADR spec) ) )
			    (LIST 'QUOTE SLOTNAMS)
			    (LIST 'QUOTE SLOTVALS) ) ) ) ) )

(DEFUN STRUCT-POSITIONAL-CONSTRUCTOR (NAME SLOTNAMS SLOTVALS ARGS NAMED?)
; Formulates a positional constructor as a MACRO for the structure NAME
; in accordance with SLOTNAMS, SLOTVALS, ARGS, and NAMED?.  Returns the
; definition for the constructor.
  (LIST 'MACRO
	'BODY
	(APPEND '(LIST 'LIST)
		(IF NAMED? (LIST (LIST 'QUOTE (LIST 'QUOTE NAME))))
		(MAPCAR '(LAMBDA (SNAM SVAL)
			     ((MEMBER SNAM ARGS)
			       (LIST 'NTH
				     (ADD1 (POSITION SNAM ARGS))
				     'BODY) )
			     SVAL)
			SLOTNAMS
			SLOTVALS) ) ) )

(DEFUN FORM-STRUCT-ACCESSORS (NAME OPTIONS SLOTNAMS NAMED?)
; Formulates accessor functions as MACROs for the structure NAME in
; accordance with OPTIONS, SLOTNAMS, and NAMED?.  Returns a list of
; accessor function  (<name> . <definition>) pairs.
  (LET ((namopt (ASSOC ':CONC-NAME OPTIONS)) )
    (LET ((prefix (COND ((OR (NULL namopt)
			     (NULL (CDR namopt)) )
			  (PACK* NAME '"-") )
			((NULL (CADR namopt)) '"")
			((CADR namopt)) ) )
	  (slotpsn (IF NAMED? 1 0)) )
      (MAPCAR '(LAMBDA (SNAM)
		  (CONS (PACK* prefix SNAM)
			(LIST 'MACRO 'BODY
			      (LIST 'LIST ''NTH slotpsn (LIST 'CADR 'BODY)))
			(INCQ slotpsn)) )
	      SLOTNAMS) ) ) )

(DEFUN FORM-STRUCT-PREDICATE (NAME OPTIONS NAMED?)
; Formulates a predicate function as a MACRO for the structure NAME in
; accordance with OPTIONS and NAMED?.  Returns a list consisting of the
; predicate function (<name> . <definition>) pair (or NIL if no predicate
; function was desired).
  (LET ((predopt (ASSOC ':PREDICATE OPTIONS)) )
    ((NOT NAMED?)
      ((OR (NULL predopt)
	   (AND (CDR predopt)
		(NULL (CADR predopt)) ) ) )
      (BREAK (LIST* 'DEFSTRUCT STRUCTSPEC SLOTSPECS)
	     "Unnamed Structure") )
    ((OR (NULL predopt)
	 (NULL (CDR predopt))
	 (CADR predopt))
      (LIST (CONS (IF (OR (NULL predopt) (NULL (CDR predopt)))
		      (PACK* NAME '"-P")
		      (CADR predopt) )
		  (LIST 'MACRO
			'BODY
			(LIST 'LIST
			      ''EQ
			      (LIST 'LIST
				    ''CAR
				    (LIST 'CADR 'BODY))
			      (LIST 'QUOTE (LIST 'QUOTE NAME)))) ) ) ) ) )

(DEFUN FORM-STRUCT-COPIER (NAME OPTIONS)
; Formulates a copier function as a MACRO for the structure NAME in
; accordance with OPTIONS.  Returns a list consisting of the copier
; function (<name> . <definition>) pair (or NIL if no copier function
; was desired).
  (LET ((copyopt (ASSOC ':COPIER OPTIONS)) )
    ((OR (NULL copyopt)
	 (NULL (CDR copyopt))
	 (CADR copyopt))
      (LIST (CONS (IF (OR (NULL copyopt) (NULL (CDR copyopt)))
		      (PACK* 'COPY- NAME)
		      (CADR copyopt) )
		  (LIST 'MACRO
			'BODY
			(LIST 'LIST
			      ''COPY-LIST
			      (LIST 'CADR 'BODY)) ) ) ) ) ) )


(DEFUN PUTSTRUCT (NAME OPTIONS SLOTNAMS SLOTVALS NAMED? MACDEFS)
; Installs the structure NAME.
  (IF (GET NAME 'STRUCT-MACROS) (REMSTRUCT NAME) )
  (PUT NAME 'STRUCT-OPTIONS OPTIONS)
  (PUT NAME 'STRUCT-SLOTNAMES SLOTNAMS)
  (PUT NAME 'STRUCT-SLOTVALS SLOTVALS)
  (PUT NAME 'NAMED-STRUCT NAMED?)
  (PUT NAME 'STRUCT-MACROS
       (MAPCAR '(LAMBDA (MACDEF)
		    (PUT (CAR MACDEF) 'STRUCTS
			 (CONS NAME (GET (CAR MACDEF) 'STRUCTS)))
		    (PUTD (CAR MACDEF) (CDR MACDEF)) )
	       MACDEFS))
  NAME )

(DEFUN REMSTRUCT (NAME)
; Removes the structure NAME.
  (REMPROP NAME 'STRUCT-OPTIONS)
  (REMPROP NAME 'STRUCT-SLOTNAMES)
  (REMPROP NAME 'STRUCT-SLOTVALS)
  (REMPROP NAME 'NAMED-STRUCT)
  (MAPC '(LAMBDA (MACDEF)
	     (LET ((sts (REMOVE NAME (GET MACDEF 'STRUCTS))) )
	       ((NULL sts)
		 (REMPROP MACDEF 'STRUCTS)
		 (REMD MACDEF) )
	       (PUT MACDEF 'STRUCTS sts) ) )
	(GET NAME 'STRUCT-MACROS) )
  (REMPROP NAME 'STRUCT-MACROS) )

(DEFUN CLOSURE (CLOSURE-VARLIST CLOSURE-FUNCTION)
; Creates a dynamic closure of CLOSURE-FUNCTION over the variables in
; CLOSURE-VARLIST.  The closure is implemented using a closure alist.
  (SETQ CLOSURE-VARLIST (PAIRLIS CLOSURE-VARLIST (MAPCAR 'EVAL CLOSURE-VARLIST)))
  (LIST 'LAMBDA 'CLOSURE-ARGLIST (LIST 'CLOSURE-APPLY
				       (LIST 'QUOTE CLOSURE-FUNCTION)
				       (LIST 'QUOTE CLOSURE-VARLIST)
				       'CLOSURE-ARGLIST)) )

(DEFUN CLOSURE-APPLY (CLOSURE-FUNCTION CLOSURE-ALIST CLOSURE-ARGLIST
; Swaps the variables in CLOSURE-ALIST with their closure values.
; Applies CLOSURE-FUNCTION to the arguments in CLOSURE-ARGLIST.
; Saves the new closure values of the variables in CLOSURE-ALIST while
; restoring their original values.
; Returns the value of the function application.
    new-list)
  (setq new-list (copy-alist closure-alist))
  (SWAP-VALUE new-list)
  (UNWIND-PROTECT
    (APPLY CLOSURE-FUNCTION CLOSURE-ARGLIST)
    (SWAP-VALUE new-list) ) )

(DEFUN SWAP-VALUE (ALIST
; Swaps the values of the variables on ALIST with the values on ALIST.
    TMP)
  (LOOP
    ((NULL ALIST))
    (SETQ TMP (CAAAR ALIST))
    (SET (CAAR ALIST) (CDAR ALIST))
    (rplacd (POP ALIST) tmp  ) ))
