; File: CLOSURE.LSP  (c)	    03/06/91		Soft Warehouse, Inc.


;			The muLISP Closure Package

(DEFUN CLOSURE (CLOSURE-VARLIST CLOSURE-FUNCTION)
; Creates a dynamic closure of CLOSURE-FUNCTION over the variables in
; CLOSURE-VARLIST.  The closure is implemented using a closure alist.
  (SETQ CLOSURE-VARLIST (PAIRLIS CLOSURE-VARLIST (MAPCAR 'EVAL CLOSURE-VARLIST)))
  (LIST 'LAMBDA 'CLOSURE-ARGLIST (LIST 'CLOSURE-APPLY
				       (LIST 'QUOTE CLOSURE-FUNCTION)
				       (LIST 'QUOTE CLOSURE-VARLIST)
				       'CLOSURE-ARGLIST)) )

(DEFUN CLOSURE-APPLY (CLOSURE-FUNCTION CLOSURE-ALIST CLOSURE-ARGLIST)
; Swaps the variables in CLOSURE-ALIST with their closure values.
; Applies CLOSURE-FUNCTION to the arguments in CLOSURE-ARGLIST.
; Saves the new closure values of the variables in CLOSURE-ALIST while
; restoring their original values.
; Returns the value of the function application.
  (SWAP-VALUE CLOSURE-ALIST)
  (UNWIND-PROTECT
    (APPLY CLOSURE-FUNCTION CLOSURE-ARGLIST)
    (SWAP-VALUE CLOSURE-ALIST) ) )

(DEFUN SWAP-VALUE (ALIST
; Swaps the values of the variables on ALIST with the values on ALIST.
    TMP)
  (LOOP
    ((NULL ALIST))
    (SETQ TMP (CAAAR ALIST))
    (SET (CAAR ALIST) (CDAR ALIST))
    (RPLACD (POP ALIST) TMP) ) )

(DEFMACRO LET-CLOSED (LETLIST CLOSURE-FUNCTION)
; Creates a form that temporarily binds the variables in LETLIST, and then
; calls CLOSURE with the variables in LETLIST and CLOSURE-FUNCTION.
  (CONS (LIST 'LAMBDA
	      (MAPCAR '(LAMBDA (VAR) (IF (ATOM VAR) VAR (CAR VAR))) LETLIST)
	      (LIST 'CLOSURE
		    (LIST 'QUOTE
			  (MAPCAR '(LAMBDA (VAR) (IF (ATOM VAR) VAR (CAR VAR)))
				  LETLIST))
		    CLOSURE-FUNCTION))
	(MAPCAR '(LAMBDA (VAR) (IF (ATOM VAR) NIL (CADR VAR))) LETLIST)) )

(DEFUN CLOSUREP (OBJECT)
; Returns T if OBJECT is a dynamic closure, otherwise it returns NIL.
  (AND (EQ (CAR OBJECT) 'LAMBDA)
       (EQ (CADR OBJECT) 'CLOSURE-ARGLIST)
       (EQ (CAADDR OBJECT) 'CLOSURE-APPLY)) )

(DEFUN COPY-CLOSURE (CLOSURE)
; Creates and returns a copy of CLOSURE.
  ((CLOSUREP CLOSURE)
    (LIST 'LAMBDA 'CLOSURE-ARGLIST (LIST 'CLOSURE-APPLY
			       (LIST 'QUOTE (CLOSURE-FUNCTION CLOSURE))
			       (LIST 'QUOTE (COPY-ALIST (CLOSURE-ALIST CLOSURE)))
			       'CLOSURE-ARGLIST)) )
  (BREAK (LIST 'COPY-CLOSURE CLOSURE) "Nonclosure Argument") )

(DEFUN SYMEVAL-IN-CLOSURE (CLOSURE SYMBOL)
; Returns the value of SYMBOL in CLOSURE.  If SYMBOL is not a closure
; variable of CLOSURE, it returns the current value of SYMBOL.
  ((CLOSUREP CLOSURE)
    ((SYMBOLP SYMBOL)
      ((SETQ CLOSURE (ASSOC SYMBOL (CLOSURE-ALIST CLOSURE)))
	(CDR CLOSURE) )
      (CAR SYMBOL) )
    (BREAK (LIST 'SYMEVAL-IN-CLOSURE CLOSURE SYMBOL) "Nonsymbolic argument") )
  (BREAK (LIST 'SYMEVAL-IN-CLOSURE CLOSURE SYMBOL) "Nonclosure Argument") )

(DEFUN SET-IN-CLOSURE (CLOSURE SYMBOL OBJECT)
; Binds the closure variable SYMBOL in CLOSURE to OBJECT and returns OBJECT.
; If SYMBOL is not a closure variable of CLOSURE, it binds SYMBOL to OBJECT.
  ((CLOSUREP CLOSURE)
    ((SYMBOLP SYMBOL)
      ((SETQ CLOSURE (ASSOC SYMBOL (CLOSURE-ALIST CLOSURE)))
	(RPLACD CLOSURE OBJECT)
	OBJECT )
      (SET SYMBOL OBJECT) )
    (BREAK (LIST 'SET-IN-CLOSURE CLOSURE SYMBOL OBJECT) "Nonsymbolic argument") )
  (BREAK (LIST 'SET-IN-CLOSURE CLOSURE SYMBOL OBJECT) "Nonclosure Argument") )

(DEFUN LOCATE-IN-CLOSURE (CLOSURE SYMBOL)
; Returns the alist pair for SYMBOL in CLOSURE.  If SYMBOL is not a closure
; variable of CLOSURE, it returns SYMBOL.
  ((CLOSUREP CLOSURE)
    ((SYMBOLP SYMBOL)
      ((ASSOC SYMBOL (CLOSURE-ALIST CLOSURE)))
      SYMBOL )
    (BREAK (LIST 'LOCATE-IN-CLOSURE CLOSURE SYMBOL) "Nonsymbolic argument") )
  (BREAK (LIST 'LOCATE-IN-CLOSURE CLOSURE SYMBOL) "Nonclosure Argument") )

(DEFUN CLOSURE-ALIST (CLOSURE)
; Creates and returns an alist of the closure variables of CLOSURE paired
; with their closure values.
  ((CLOSUREP CLOSURE)
    (CADR (CADDR (CADDR CLOSURE))) )
  (BREAK (LIST 'CLOSURE-ALIST CLOSURE) "Nonclosure Argument") )

(DEFUN CLOSURE-FUNCTION (CLOSURE)
; Returns the closure function of CLOSURE.
  ((CLOSUREP CLOSURE)
    (CADR (CADR (CADDR CLOSURE))) )
  (BREAK (LIST 'CLOSURE-FUNCTION CLOSURE) "Nonclosure Argument") )

(DEFUN CLOSURE-VARIABLES (CLOSURE)
; Returns the closure variables of CLOSURE.
  ((CLOSUREP CLOSURE)
    (MAPCAR 'CAR (CLOSURE-ALIST CLOSURE)) )
  (BREAK (LIST 'CLOSURE-VARIABLES CLOSURE) "Nonclosure Argument") )

(DEFUN BOUNDP-IN-CLOSURE (CLOSURE SYMBOL)
; Returns T if SYMBOL is a symbol that is bound in CLOSURE, otherwise it
; returns NIL.
  ((CLOSUREP CLOSURE)
    ((SYMBOLP SYMBOL)
      ((SETQ CLOSURE (ASSOC SYMBOL (CLOSURE-ALIST CLOSURE)))
	(NEQ SYMBOL (CDR CLOSURE)) )
      ((NULL SYMBOL))
      (NEQ SYMBOL (CAR SYMBOL)) )
    (BREAK (LIST 'BOUNDP-IN-CLOSURE CLOSURE SYMBOL) "Nonsymbolic argument") )
  (BREAK (LIST 'BOUNDP-IN-CLOSURE CLOSURE SYMBOL) "Nonclosure Argument") )
