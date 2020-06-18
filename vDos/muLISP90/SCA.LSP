;;;	   *	   *	   Static Source Code Analyzer	   *	   *
;;;
;;;
;;; --------------------- System level globals ---------------------------

(setq *analyzed-files*)
(setq *analyzed-definitions*)
(setq *analyzed-globals*)
(setq *library-definitions*)
(setq *library-files*)
(setq *called-definitions*)
(setq *called-globals*)
(setq *parse-state*)
(setq *number-of-arguments*)
(setq *already-displayed*)
(setq *test-first-functions* '(APPLY FUNCALL MAPC MAPL MAPCAR MAPLIST
			       MAPCAN MAPCON SOME NOTANY EVERY NOTEVERY
			       REDUCE REMOVE-IF DELETE-IF FIND-IF
			       POSITION-IF COUNT-IF MEMBER-IF ASSOC-IF
			       RASSOC-IF))

;;; ------------ Global variables available for user modification --------

(setq *record-primitives*)	; record muLISP primitive flag
(setq *globalize-strings*)	; treat strings as globals flag
(setq *suppress-blank-lines* t) ; blank lines in report flag
(setq *alphabetical*)		; order to display definitions flag
(setq *evaluate*)		; evaluate file-level SETQs flag
(setq *tree-depth* 3)		; depth of display trees flag

;;; ------------------- Common Lisp utilities needed ---------------------

(DEFUN YES-OR-NO-P (MSG
; Displays MSG, and returns T if the user enters Yes; it returns NIL if the
; users enters No.
    LINE )
  (CLEAR-INPUT T)
  (LOOP
    ( ((NULL MSG))
      (FRESH-LINE T)
      (WRITE-STRING (PACK* MSG " (Yes or No) ") T) )
    (WRITE-BYTE 7 NIL T)
    (SETQ LINE (STRING-UPCASE (READ-LINE T)))
    ((EQ LINE 'YES))
    ((EQ LINE 'NO)  NIL) ) )

;;; -------------------- Analysis utilities --------------------------------

(DEFMACRO PUSH-on-end (OBJ SYM TEST)
; If OBJ is not a member of the stack SYM, pushes OBJ onto the end of stack.
  (LIST 'SETQ SYM (LIST 'ADJOINend OBJ SYM TEST)) )

(defun adjoinend (obj lst test)
  ;; if OBJ is a member, just return lst, otherwise put OBJ on end of lst.
  ((member obj lst test) lst)
  (append lst (list obj)) )

(defun addnew (symbol key object
   ;; modify the property list so that it accumulates a list of values
   ;; instead of replacing one value with another.
    prop-list)
  ((null (setq prop-list (get symbol key)))	;is there anything here?
    (put symbol key (list object)))
  ((member object prop-list) prop-list) 	;is object already here?
  (put symbol key (nconc prop-list (list object))) )

(defun add-extension (filename)
  ;; Adds a .LSP extension if no extension is specified
  ((member "." (unpack filename)) filename)
  (pack* filename "." 'lsp) )

(defun member-or-it (obj lst)
  ;; Determines if obj is a member of lst, or is obj lst?
  ((member obj lst))
  ((eq obj lst)) )

(defun source-string-p (object)
  ;; Determine if object is really a string instead of a global variable or
  ;; fluid.  Return T if a string and NIL if seen as a global.
  (or (neq (print-length object) (length object))	;lowercase string?
      (eq : (substring object 0 0))			;keyword
      (and (eq (length object) 1)			;strange symbol
	   (not (alphanumericp object)) ) ) )

;;; -------------------- Analysis core ------------------------------------

(defun analyze-files (files library-files
  ;; Top-level user interface function to source analyzer. Accepts file(s)
  ;; to be analyzed & library-file(s) to compare definitions to.  Definitions
  ;; in library-files which are referenced in the analyzed files will
  ;; not be recorded unless *record-primitives* is nonNIL. (Neither will
  ;; muLISP primitives!)
    filename expr)
  ((null files) nil)
  (if (and library-files (null *record-primitives*))
      (record-library-definitions
	(if (atom library-files) (list library-files) library-files)) )
  (if (atom files)
      (setq files (list files)))
  (loop
    ( ((open-input-file (setq filename (add-extension (pop files))))
       (write-line (pack* "Analyzing file " filename))
       (loop
	(setq expr (read filename t 'eof))
	((eq expr 'eof)
	  (close-input-file filename)
	  (push-on-end filename *analyzed-files*) )
	( ((eq (car expr) 'defun)
	    ((and (not (cdddr expr))	  ;is this an ftype DEFUN?
		  (member (caaddr expr) '(NLAMBDA LAMBDA MACRO)))
	       (analyze-definition-body filename 'function (cadr expr)
				     (car (cdaddr expr)) (cdr (cdaddr expr)) ) )
	    ((and (not (cdddr expr))	  ;is this an address DEFUN?
		  (numberp (caaddr expr)) )
		(analyze-definition-body filename 'function (cadr expr) nil nil) )
	    ;; otherwise, it must be the common DEFUN!
	    (analyze-definition-body filename 'function
				  (cadr expr) (caddr expr) (cdddr expr) ) )
	  ((eq (car expr) 'setq)	  ;is this a global variable?
	    (if *evaluate* (eval expr))   ;do we want to evaluate it?
	    (analyze-setq-form filename expr) )
	  ((eq (car expr) 'defmacro)	  ;is this a macro?
	    (analyze-definition-body filename 'macro
				     (cadr expr) (caddr expr) (cdddr expr) ) )
	  ((eq (car expr) 'if)		  ;is this a top-level if?
	    (analyze-if-statement filename
				  (cadr expr) (caddr expr) (cadddr expr) )
	   ) ) ) )
      (write-line (pack* "File " filename " does not exist!") t) )
    ((null files)			;done?
      (clean-up-data)
      nil ) ) )

(defun record-library-definitions (files
  ;; Store any macro or function definition contained in the library files for
  ;; future comparison with referenced definitions in the analyzed files.
    filename expr)
  (loop
    (if (open-input-file (setq filename (add-extension (pop files))))
      (loop
	(setq expr (read filename t 'eof))
	((eq expr 'eof)
	  (close-input-file filename)
	  (push-on-end filename *library-files*) )
	( ((member (car expr) '(defun defmacro))
	     (push-on-end (cadr expr) *library-definitions*) ) ) )
      (write-line (pack* "File " filename " does not exist!") t) )
      ((null files)) ) )

(defun clear-all ()
  ;; Make sure all property lists and globals are initialized properly
  (mapc '(lambda (func) (remprop func 'file)
			(remprop func 'arguments)
			(remprop func 'f-calls)
			(remprop func 'f-callers)
			(remprop func 'g-calls)
			(remprop func 'unbound)
			(remprop func 'count)
			(remprop func 'max-calling-args)
			(remprop func 'type) )
	(union *called-definitions* *analyzed-definitions*) )
  (mapc '(lambda (glob) (remprop glob 'g-callers)
			(remprop glob 'file) )
	(union *called-globals* *analyzed-globals*) )
  (setq *analyzed-definitions*)
  (setq *analyzed-globals*)
  (setq *called-definitions*)
  (setq *called-globals*)
  (setq *analyzed-files*)
  (setq *library-files*)
  (setq *library-definitions*) )

(defun analyze-setq-form (filename form)
  ;; Loop through multiple global variables and their values
  ;; recording global variable names
  (loop
    (pop form)
    ((null form))
    (analyze-global filename (pop form)) ) )

(defun analyze-global (filename name)
  ;; Record information about a global variable.
  (addnew name 'file filename)
  (push-on-end name *analyzed-globals*) )

(defun analyze-if-statement (filename test then else)
  ;; Check first to find any 'defuns, otherwise we may not want
  ;; to evaluate the test!
  ((and (find-defun then)	;is there a defun lurking somewhere?
	(eval test) )		;does the test eval nonNIL?
      (process-if-defun then) ) ;then process the "then"
  ((and (find-defun else)	;is there a defun lurking somewhere?
	(not (eval test)) )	;does the test eval NIL?
      (process-if-defun else) ) );then process the "else"

(defun find-defun (form)
  ;; we allow for the "defun" to be either the first form, or
  ;; somewhere inside a PROGN form.
  (or (eq (car form) 'defun)
      (and (eq (car form) 'progn)
	   (assoc 'defun (cdr form)) ) ) )

(defun process-if-defun (form
    ;; if the defun is the first form, then process it - otherwise, loop
    ;; through the forms in the PROGN, looking for "defun" or why not "setq".
    expr)
  (if (eq (car form) 'defun)
	(analyze-definition-body filename 'function (cadr form) (caddr form)
				(cdddr form) )
	(loop
	  (setq expr (pop form))
	  (if (eq (car expr) 'setq)
	    (analyze-setq-form filename expr) )
	  (if (eq (car expr) 'defun)
	    (analyze-definition-body filename 'function (cadr expr)
				     (caddr expr) (cdddr expr) ) )
	  ((null form)) ) ) )

(defun analyze-definition-body (filename type name args body)
  ;; Store information about this definition (function or macro) and
  ;; then send it off for the body to be processed.
  (addnew name 'file filename)
  (put name 'type type)
  (if (member name *analyzed-definitions*)
    ;; handle more than one function or macro definition
    (handle-function-redefinition name)
    ;; else assume this is the first time we've seen this definition
    (progn
      (push-on-end name *analyzed-definitions*)
      (put name 'count 1) ) )
  (put name 'arguments args)
  (setq *parse-state* ':body)
  (analyze-function-body-aux name (if args
				      (if (atom args)
					  (list args)
					  (if (eq type 'macro)
					      (parse-macro-arglist args)
					    args) ) )
			     body) )

(defun parse-macro-arglist (arglist)
    ;; if we have a macro arglist that has dotted pairs, then
    ;; pull them out into a single argument list for easier processing.
  ((null arglist) nil)
  ((atom arglist) (list arglist))
  (append (parse-macro-arglist (car arglist))
	  (parse-macro-arglist (cdr arglist)) ) )

(defun handle-function-redefinition (name)
   ;; delete properties of the old definition and links to other functions
   ;; and/or global variables that may no longer be valid.
   (put name 'count (+ 1 (get name 'count)))	;increment count
   (mapc '(lambda (func) (put func 'f-callers
			      (remove name (get func 'f-callers)) ) )
	  (get name 'f-calls) )
   (mapc '(lambda (glob) (put glob 'g-callers
			      (remove name (get glob 'g-callers)) ) )
	  (get name 'g-calls) )
   (put name 'f-calls nil)
   (put name 'g-calls nil) )

(defun analyze-function-body-aux (name args obj)
  ;; This is the workhorse of analyzing a definition body!  It is a
  ;; recursive search through the body (obj) looking for other called
  ;; definitions and used variables.
  ((atom obj)				 ; are we looking at an atom?
    ((or (numberp obj) (null obj) (eq obj 't))
      (setq *parse-state* ':element) )	 ; is it like 5, nil, or t?
    ((eq *parse-state* ':quote)
      (setq *parse-state* ':element) )	 ; is this just a quoted atom?
    ((eq *parse-state* ':element)
      ((member-or-it obj args)) 	 ; is object part of argument list?
      ((and (not *globalize-strings*)	 ; is the flag off?
	    (source-string-p obj)) )	 ; is this a double-quoted string?
      (record-global-variable-usage name obj) )
    ((eq *parse-state* ':function-name)
      (record-function-call name obj *number-of-arguments*)
      ((eq obj 'quote)			 ; is this a quoted list of variables?
	(setq *parse-state* ':quote))
      (setq *parse-state* ':element) ) )
  ;; OK, our obj must be a list - decide how to parse from here
  ((and (cdr obj) (atom (cdr obj)))	; what to do with dotted-pairs?
     (setq *parse-state* ':element) )	; nothing, right now!
  ((eq (car obj) 'lambda)		; do we have an in-line lambda?
      (setq *parse-state* ':body)
      (analyze-function-body-aux
	name
	(append args (if (atom (cadr obj)) (list (cadr obj)) (cadr obj)))
	(cddr obj)) )
  ((eq *parse-state* ':quote)		; what to with quoted lists?
    (setq *parse-state* ':element) )	; nothing at all!
  ((member (car obj) '(let let*))	; let or let*?
    (analyze-let-form name args (car obj) (cadr obj) (cddr obj)) )
  ((member (car obj) '(do do*)) 	; do or do*?
    (analyze-do-form name args (car obj) (cadr obj) (cddr obj)) )
  ((member (car obj) '(dolist dotimes)) ; dolist or dotimes
    (analyze-dolist-form name args (car obj) (cadr obj) (cddr obj)) )
  ((eq (car obj) 'case) 		; CASE special form?
    (analyze-case-form name args (car obj) (cadr obj) (cddr obj)) )
  ((and (member (car obj) *test-first-functions*)
	(eq (caadr obj) 'quote)
	(atom (cadadr obj)))
    (analyze-test-first-functions name args (car obj) (cadadr obj) (cddr obj))
  )
  (if (eq *parse-state* ':body)
      (setq *parse-state* ':element)
      (setq *parse-state* ':function-name
	    *number-of-arguments* (- (length obj) 1) ) )
  (loop
    (analyze-function-body-aux name args (pop obj) )
    ((null obj)) ) )

(defun analyze-let-form (function-name args let vardefs body
  ;; Analyze the special form LET or LET*
     vardef letvars)
  (record-function-call function-name let)
  (if (atom (car vardefs))
    (setq letvars vardefs)
    (loop			; analyze LET(*) variables
      (setq vardef (pop vardefs))
      (push (car vardef) letvars)
      (setq *parse-state* ':body)
      (analyze-function-body-aux function-name
				(if (eq let 'let*)
				    (append letvars args)
				    args)
				 (cdr vardef) )
      ((null vardefs)) ) )
  (setq *parse-state* ':body)
  ;; Analyze LET(*) body
  (analyze-function-body-aux function-name (append letvars args) body) )

(defun analyze-case-form (function-name args case keyform body
  ;; Analyze special form CASE
     caseform)
  (record-function-call function-name case)
  (setq *parse-state* ':element)
  (analyze-function-body-aux function-name args keyform)
  (loop 			; analyze each caseform
    (setq caseform (pop body))
    (setq *parse-state* ':quote)
    (if (neq (car caseform) 'otherwise)
      (analyze-function-body-aux function-name args (car caseform) ) )
    (setq *parse-state* ':body)
    (analyze-function-body-aux function-name args (cdr caseform))
    ((null body)) ) )

(defun analyze-do-form (function-name args do vardefs body
  ;; Analyze special form DO(*)
     vardef dovars)
  (record-function-call function-name do)
  (loop
    (setq vardef (pop vardefs))
    (setq *parse-state* ':element)
    (analyze-function-body-aux function-name
			      (if (eq do 'do*)
				  (append dovars args)
				  args)
			       (cadr vardef) )
    (push (car vardef) dovars)
    (setq *parse-state* ':element)
    (analyze-function-body-aux function-name
			       (append dovars args)
			       (caddr vardef) )
    ((null vardefs)) )
  (setq *parse-state* ':body)
  (analyze-function-body-aux function-name (append dovars args) body) )

(defun analyze-dolist-form (function-name args dolstimes vardef body)
  ;; Analyze special form DOLIST or DOTIMES
  (record-function-call function-name dolstimes)
  (setq *parse-state* ':element)
  (analyze-function-body-aux function-name
			     args
			     (cadr vardef) )
  (setq *parse-state* ':element)
  (analyze-function-body-aux function-name
			     args
			     (caddr vardef) )
  (setq *parse-state* ':body)
  (analyze-function-body-aux function-name (cons (car vardef) args) body) )

(defun analyze-test-first-functions (function-name args function-with-test
				     test-function body)
  ;; Analyze functions whose 1st argument is a function
  ;; For example: (mapcar 'minus ....)
  (record-function-call function-name function-with-test)
  (record-function-call function-name 'quote)
  (record-function-call function-name test-function)
  (setq *parse-state* ':body)
  (analyze-function-body-aux function-name args body) )

(defun record-function-call (caller-func called-func number-of-args
  ;; Record call and caller information about function or macro definition.
    tmp)
  ((and (null *record-primitives*)	; should we record this function?
	(or (numberp (getd called-func))
	    (member called-func *library-definitions*))))
  (addnew caller-func 'f-calls called-func)
  (addnew called-func 'f-callers caller-func)
  ;; keep track of the maximum number of arguments called-func is sent
  (if number-of-args
      (if (or (null (setq tmp (get called-func 'max-calling-args)))
	      (< tmp number-of-args) )
	  (put called-func 'max-calling-args number-of-args) ) )
  (push-on-end called-func *called-definitions*) )

(defun record-global-variable-usage (caller-func called-global)
  ;; Keep track of who is using the global variable.
  (addnew caller-func 'g-calls called-global)
  (addnew called-global 'g-callers caller-func)
  (push-on-end called-global *called-globals*) )

(defun clean-up-data ()
  ;; Now that we're done, we know the difference between definitions
  ;; that were referenced and definitions analyzed.
  ;; Also, calculate unassigned fluids.
  (setq *called-definitions*
	(set-difference *called-definitions* *analyzed-definitions*)
	*called-globals*
	(set-difference *called-globals* *analyzed-globals*))
  (calculate-unassigned-fluids) )

(defun calculate-unassigned-fluids (
  ;; Calculates fluids used in a function that are not in all of the callers
  ;; lambda lists.
    def-list def fluids fluid)
  (setq def-list *analyzed-definitions*)
  (loop
    ((null def-list))
    (setq def (pop def-list)
	  fluids (intersection (get def 'g-calls) *called-globals*) )
    (put def 'unbound nil)			;initialize property to nil
    (loop
      ((null fluids))
      (setq fluid (pop fluids))
      (if (catch 'found-one			;have we found an unbound?
		 (search-callers (expand (list def)) fluid))
	   (addnew def 'unbound fluid) ) ) ) )	;then add it to property list

(defun search-callers (queue fluid)
  ;; Search through all the callers of definition, looking for fluid in
  ;; the argument list.  If fluid is not in argument list, then look at
  ;; callers of callers and so on, until 1) fluid can't be found or 2) fluid
  ;; is found somewhere in the calling tree for all callers of the definition.
  ((null queue) nil)
  ((eq (car queue) 'fully-expanded)	;signal that no more callers
    (throw 'found-one t) )		     ;found an unbound fluid
  (if (member-or-it fluid (if (eq (get (caar queue) 'type) 'macro)
			    (parse-macro-arglist (get (caar queue) 'arguments))
			    (get (caar queue) 'arguments) ) )
    (search-callers (cdr queue) fluid)
    (search-callers (append (expand (car queue)) (cdr queue)) fluid) ) )

(defun expand (path)
  ;; Take a calling path and explode the first member's callers.
  ;; If there are no callers, then return the signal 'fully-expanded.
  ;; If the calling path tries to recurse upon itself, return nil.
  ((null (list-callers (car path)))
    (list 'fully-expanded) )
  (remove-if '(lambda (path) (member (car path) (cdr path)))
	       (mapcar '(lambda (caller) (cons caller path))
		       (list-callers (car path)) ) ) )

;;; Once the data is analyzed, we can do something with it...

;;; -------------------- Functions to write detailed analysis report------

(defun display-all (filename)
  ;; User interface function to dump out a detailed report of analysis.
  (if *analyzed-files*
    (display-dispatch filename 'report-analysis) ) )

(defun display-dispatch (filename task arg
  ;; This function opens an output file (if specified), sets the *line-length*
  ;; appropriately and then passes on the work to the appropriate "task".
    *line-length*)
  ((null task) nil)
  ((null filename)	; OK, we're going to the screen
     (setq *line-length* (- (columns) 1))
     (apply task arg) nil)
  ((or (not (probe-file filename))	;look for file
       (Yes-or-No-P "File exists, overwrite it?"))
     (open-output-file filename t)
     (setq *line-length* (file-line-length))
     (apply task arg)
     (close-output-file filename)
     nil ) )

(defun report-analysis (
  ;; Writes report title and header information, then calls functions to
  ;; format information about macros, globals and functions.
    macros functions)
  (terpri 1)
  (write-centered-string "STATIC SOURCE CODE ANALYSIS")
  (terpri 2)
  (print-indented-lines "Files:" 0 *analyzed-files* 8)
  (print-indented-lines "Library Files:" 0 *library-files* 16)
  (terpri 1)
  (write-line (pack* "muLISP primitives are"
		     (if *record-primitives* " " " NOT ")
		     "recorded.") )
  (write-line (pack* "Strings are"
		     (if *globalize-strings* " "  " NOT ")
		     "treated as fluids.") )
  (write-line (pack* "Blank output lines will"
		     (if *suppress-blank-lines*  " NOT " " ")
		     "be displayed.") )
  (write-line (pack* "Top level SETQs have"
		     (if *evaluate*  " " " NOT ")
		     "been evaluated.") )
  (write-line (pack* "Definitions will be displayed in "
		     (if *alphabetical*  "alphabetical" "file")
		     " order.") )
  (setq macros (remove-if '(lambda (x) (neq (get x 'type) 'macro))
			  *analyzed-definitions*))
  (setq functions (set-difference *analyzed-definitions* macros))
  (terpri 2)
  ( ((null macros))
    (write-centered-string '"MACROS")
    (terpri 1)
    (mapc 'print-function-data (if *alphabetical*
				   (sort (copy-list macros) 'STRING<)
				   macros) )
    (terpri 2) )
  ( ((null *analyzed-globals*))
    (write-centered-string '"GLOBAL VARIABLES")
    (terpri 1)
    (mapc 'print-global-data (if *alphabetical*
				 (sort (copy-list *analyzed-globals*) 'STRING<)
				 *analyzed-globals*) )
    (terpri 2) )
  ( ((null functions))
    (write-centered-string '"FUNCTIONS")
    (terpri 1)
    (mapc 'print-function-data (if *alphabetical*
				 (sort (copy-list functions) 'STRING<)
				  functions)) ) )

(defun print-function-data (function-name)
  ;; Outputs information about a definition (macro or function).
  (terpri 1)
  (write function-name)
  (spaces 1)
  (print-argument-list function-name)
  (print-indented-lines "calls:" 2 (list-calls function-name) 14)
  (print-indented-lines "called by:" 2 (list-callers function-name) 14)
  (print-indented-lines "globals:" 2 (list-globals function-name) 14)
  (print-indented-lines "fluids:" 2  (list-fluids function-name) 14)
  (print-indented-lines "unbound:" 2 (list-unbound function-name) 14)
  (if (> (length *analyzed-files*) 1)
    (print-indented-lines "file:" 2 (list-file function-name) 14))
  ((> (get function-name 'count) 1)
    (write-line (pack* "*** Warning - this definition is defined "
		       (get function-name 'count)
		       " times!") )
    (write-line "*** Only the last definition is analyzed - previous callers are maintained") ) )

(defun print-argument-list (definition
  ;; Correctly formats the argument list of a function or macro.
    arguments max-calling-args)
  ;; if we don't have any arguments, easy - just write a left and right paren
  ((null (setq arguments (get definition 'arguments)))
     (write-line "()") )
  ;; if arguments is an atom, easy again - just write it
  ((atom arguments)
     (write-line arguments))
  ;; if we've got a macro, then just PRINT the arguments as is, because the
  ;; chances that: 1) we identified a caller, or 2) correctly matched the
  ;; calling arguments are SLIM!!!  Also, the occurrence of dotted pairs
  ;; is not being handled by print-indented-lines.
  ((eq (get definition 'type) 'macro)
    (print arguments) )
  ;; otherwise, it's a function.  If it wasn't called, or it was called with
  ;; more arguments than in the official arglist, then print-indented-lines
  ((or (null (setq max-calling-args (get definition 'max-calling-args)))
       (>= max-calling-args (length arguments))) ; with more arguments?
     (print-indented-lines "(" 0 arguments (+ 1 (spaces)) ")"))
  ;; if called with zero arguments, then all in arglist must be fluids - so
  ;; write left paren and skip line ELSE write the number of arguments it
  ;; was called with.
  (if (zerop max-calling-args)
    (write-line "(")
    (print-indented-lines "(" 0 (firstn max-calling-args arguments) 0))
  ;; write the rest of the arguments and the right paren
  (print-indented-lines "" 0 (nthcdr max-calling-args arguments) 4 ")") )

(defun print-global-data (var-name)
  ;; Outputs information about a global variable.
  (terpri 1)
  (print var-name)
  (print-indented-lines "used by:" 2 (list-users var-name) 14)
  ((> (length *analyzed-files*) 1)
    (print-indented-lines "file:" 2 (list-file var-name) 14) ) )

(defun print-indented-lines (heading head-indent lst indent footer
    ;; the intent of this function is to write a heading, after first
    ;; indenting by HEAD-INDENT.  Then loop through LST, collect all that
    ;; will fit on a line (with spaces in between); print that; then
    ;; tab over to indent and continue this process until LST is exhausted.
    ;; At this point any FOOTER will be printed.
    counter line name)
  ((and (null lst) *suppress-blank-lines*))	; anything to output?
  (spaces head-indent)
  (write-string heading)			;write the heading
  (tab indent)					;tab to the appropriate spot
  ((null lst) (terpri 1))			;if no data, then exit
  (setq counter (spaces) line nil)		;set up
  (if (null footer) (setq footer ""))
  (loop
    ((null lst)
      (write-line (pack (nreverse (push footer line)))))
    (setq name (pop lst))
    (( (cannot-fit (print-length name)) ;can this name fit?
	 (write-line (pack (nreverse line)))
	 (tab indent)
	 (setq counter (spaces) line nil)))
   (push (name-to-print-name name) line)
   (incq counter (print-length name))
   (and lst (not (cannot-fit 1))
	(push '| | line) (incq counter 1) ) ) )

(defun cannot-fit (obj-length)
  ;; Determine if an object of "obj-length" can fit onto the current
  ;; print line, counter being a fluid that keeps track of how many
  ;; characters are on the line so far, *line-length* being a fluid that
  ;; holds the length of the line.
  (> (+ counter obj-length) *line-length*) )

(defun tab (n)
  ;; Move over to "n".
  (spaces (- n (spaces))) )

(defun name-to-print-name (name)
  ;; Return the printable version of name.
  ((eq (length name) (print-length name))
    name )
  (pack* '\| name '\|) )

(defun write-centered-string (text)
  ;; Write "text" centered on the line.
  (spaces (truncate (- *line-length* (length text)) 2))
  (write-string text)
  (terpri 1) )

;;; --------- Interactive listing functions for analyzed data ------------

(defun list-callers (symbol)
  ;; List definitions that call symbol.
  (get symbol 'f-callers))

(defun list-calls (symbol)
  ;; List definitions that symbol calls.
  (get symbol 'f-calls) )

(defun list-globals (symbol)
  ;; List globals that are referenced in the definition of symbol.
  (intersection (get symbol 'g-calls) *analyzed-globals*) )

(defun list-fluids (symbol)
  ;; List fluids that are referenced in the definition of symbol.
  (set-difference (intersection (get symbol 'g-calls) *called-globals*)
		  (get symbol 'unbound) ) )

(defun list-unbound (symbol)
  ;; List fluids that are not bound in all of symbol's callers.
  (get symbol 'unbound) )

(defun list-users (symbol)
  ;; List definitions that call (or use) a global variable (symbol).
  (get symbol 'g-callers) )

(defun list-file (symbol)
  ;; List file(s) where symbol is defined or used.
  (get symbol 'file) )

(defun list-definitions (filename)
  ;; List definitions which were analyzed in file (filename).
  ((member (add-extension filename) *analyzed-files*)
    (remove-if '(lambda (x) (not (member (add-extension filename)
					 (get x 'file) ) ) )
	     *analyzed-definitions* ) ) )

(defun list-undefined (
  ;; List definitions that were called but are not defined anywhere.  Return
  ;; as a dotted-pair list where the first element is the definition not
  ;; defined and the second element is the calling definition.
    return-list defs)
  (setq return-list nil
	defs (remove-if '(lambda (x) (numberp (getd x)))
		(set-difference *called-definitions* *library-definitions*) ) )
  (loop
    ((null defs) (reverse return-list))
    (setq def (pop defs))
    (mapc '(lambda (y) (setq return-list (acons def y return-list)))
	  (list-callers def) ) ) )

(defun list-uncalled ()
  ;; List definitions that were not called but are defined.
  (remove-if '(lambda (x) (list-callers x)) *analyzed-definitions*) )

(defun list-unassigned (
  ;; List variables used as fluids, but not in all appropriate callers lambda
  ;; lists.  Return as a dotted-pair list where the first element is the
  ;; variable and the second element is the definition where it is used.
    return-list defs)
  (setq return-list nil
	defs *analyzed-definitions*)
  (loop
    ((null defs) (reverse return-list))
    (setq def (pop defs))
    (mapc '(lambda (y) (setq return-list (acons y def return-list)))
	  (list-unbound def) ) ) )

;;; ----------- Interactive display functions for analyzed data ----------

(defun display-definition (symbol output-file)
  ;; Display all known information about a function or macro (symbol).
  ((member symbol *analyzed-definitions*)
    (display-dispatch output-file 'print-function-data (list symbol)) ) )

(defun display-calls (symbol output-file)
  ;; Display a calling tree with symbol at the top level.
  ;; Check symbol to make sure it's valid and then send to dispatcher.
  ((member symbol *analyzed-definitions*)
    (setq *already-displayed* nil)
    (display-dispatch output-file 'display-calls-aux (list symbol 0)) ) )

(defun display-calls-aux (symbol depth end
  ;; Display call tree of function or macro.
    calls)
  ((null      ;should we expand further?
     (process-def-name symbol depth (setq calls (list-calls symbol))) ) )
  (loop
    ((null calls))
    (write-backbone depth end calls)
    (write-byte 196)	;write -
    (write-byte 16)	;write ->
    (display-calls-aux (pop calls) (+ depth 1)
		       (if (null calls)
			   (cons (+ depth 1) end)
			   end) ) ) )

(defun display-callers (symbol output-file)
  ;; Display caller tree with symbol at the top level.
  ;; Check symbol to make sure it's valid and then send to dispatcher.
  ((member symbol *analyzed-definitions*)
    (setq *already-displayed* nil)
    (display-dispatch output-file 'display-callers-aux (list symbol 0)) ) )

(defun display-callers-aux (symbol depth end
  ;; Display calling tree of function or macro.
    callers)
  ((null  ; should we expand at this level?
    (process-def-name symbol depth (setq callers (list-callers symbol))) ) )
  (loop
    ((null callers))
    (write-backbone depth end callers)
    (write-byte 196)	 ; write -
    (write-byte 174)	 ; write <<
    (display-callers-aux (pop callers) (+ depth 1)
			 (if (null callers)
			     (cons (+ depth 1) end)
			     end) ) ) )

(defun write-backbone (depth end tree-list)
  ;; This function writes the tree's backbone and start of nodes.
  (write-vertical-lines depth end)
  (write-byte 179)			; write |
  (terpri 1)
  (write-vertical-lines depth end)
  ((eq (length tree-list) 1)		; is this the last one at this level?
    (write-byte 192) )			; write end of level symbol
  (write-byte 195) )			; write |-

(defun process-def-name (symbol depth expansion)
  ;; Write definition name and 1) check to see if we've maxed out on depth,
  ;; return nil if so, otherwise, 2) determine if we've already processed
  ;; this definition. If so, then return nil, else mark it and return nonNIL.
  (write symbol)
  ((or (= depth *tree-depth*) (> depth *tree-depth*))
    (terpri 1)
    nil)
  ((member symbol *already-displayed*)
    (write-line (if expansion ". . ." ""))
     nil )
  (terpri 1)
  (push symbol *already-displayed*) )

(defun write-vertical-lines (depth end
  ;; This function's job is to decide when to bring tree limbs down
  ;; in the display (i.e., if we're at the last node, then we don't want
  ;; to bring the limbs down any farther.
    counter indent)
  (setq counter 0
	indent	3)
  (loop
    ((= counter depth)			;have we reached current level?
      (tab (* counter indent))) 	;move over to that level
    (tab (* counter indent))		;move over a level
    ( ((member (+ 1 counter) end))	;end at this level?
      (write-string (ascii 179)) )	;if not, then write |
    (incq counter) ) )
