; File: HELP.LSP  (C)		    01/25/93		Soft Warehouse, Inc.

;			  muLISP Help Facility

; If this file is loaded and <name> is the name of a function,
; special form, macro, or variable that is defined in the muLISP
; machine language kernel or in a muLISP library file, the command

;		(HELP 'name)

; displays <name>'s arguments or initial value and the page it is
; documented on in the muLISP Reference Manual.


; To use the help facility from any MS-DOS directory, set the variable
; *HELP-FILE* to the full path and file name of this file after loading it.
; For example:	(SETQ *HELP-FILE* "C:\\MULISP\\HELP.LSP")

(SETQ *HELP-FILE* (CAR (INPUT-FILES)))


(DEFUN HELP LST
; Display help on argument, if given; otherwise display next help.
  (WRITE-LINE (IF LST (HELP-NAME (CAR LST)) (NEXT-HELP-NAME)))
  NIL )

(MOVD 'HELP '?)

(DEFUN HELP-NAME (NAME
; Returns help line associated with NAME.
    NUM LINE *INPUT-FILE*)
  (SETQ NAME (HELP-NAME-TRIM (STRING-UPCASE NAME))
	LINE (CHAR NAME 0))
  (LOOP 			; Set NUM to offset of NAME's first letter
    ((NOT (ALPHA-CHAR-P LINE))
      (SETQ NUM (CDR (ASSOC '+ *HELP-OFFSETS*))) )
    ((SETQ NUM (CDR (ASSOC LINE *HELP-OFFSETS*))))
    (SETQ LINE (ASCII (ADD1 (ASCII LINE)))) )
  ((OPEN-INPUT-FILE *HELP-FILE*)
    (FILE-READ-POSITION NUM)
    (SETQ NUM (SUB1 (LENGTH NAME)))
    (UNWIND-PROTECT
      (LOOP			; Sequentially search for NAME in file
	((NOT (LISTEN))  NIL)
	(SETQ LINE (READ-LINE))
	((FUNCALL (IF (ALPHA-CHAR-P NAME) 'STRING>= 'STRING=)
		  (SUBSTRING (HELP-NAME-TRIM LINE) 0 NUM)
		  NAME)
	  (SETQ *HELP-OFFSET* (FILE-READ-POSITION))
	  LINE ) )
      (CLOSE-INPUT-FILE)) ) )

(DEFUN NEXT-HELP-NAME (
; Returns next help line at *HELP-OFFSET* and updates *HELP-OFFSET*.
    *INPUT-FILE*)
  ((OPEN-INPUT-FILE *HELP-FILE*)
    (FILE-READ-POSITION *HELP-OFFSET*)
    (UNWIND-PROTECT
      (LOOP
	((NOT (LISTEN))  NIL)
	((NEQ (SETQ LINE (READ-LINE)) "")
	  (SETQ *HELP-OFFSET* (FILE-READ-POSITION))
	  LINE ) )
      (CLOSE-INPUT-FILE)) ) )

(DEFUN HELP-NAME-TRIM (NAME)
  ((AND (OR (CHAR= NAME '*) (CHAR= NAME ':))
	(CHAR NAME 1)
	(ALPHA-CHAR-P (CHAR NAME 1)))
    (SUBSTRING NAME 1) )
  NAME )


(SETQ *HELP-OFFSETS* NIL)		; A-list of help file offsets

(LOOP					; Build *HELP-OFFSETS* and *HELP-OFFSET*
  ((NOT (LISTEN *HELP-FILE*))
    (TERPRI 2 T)
    (WRITE-LINE
      "For help on the muLISP primitive <name>, enter:	(HELP 'name)" T)
    (SETQ *HELP-OFFSETS* (NREVERSE *HELP-OFFSETS*)
	  *HELP-OFFSET* (CDAR *HELP-OFFSETS*)
	  *INPUT-FILE*) )
  ((LAMBDA (NUM LINE)
      ((EQ LINE ||))
      ((EQ LINE (ASCII 12)))
      ((NOT (ALPHA-CHAR-P (CAAR *HELP-OFFSETS*))))
      (SETQ LINE (CHAR LINE (IF (OR (CHAR= LINE '*) (CHAR= LINE ':)) 1 0)))
      ((CHAR= LINE (CAAR *HELP-OFFSETS*)))
      (PUSH (CONS LINE NUM) *HELP-OFFSETS*) )
    (FILE-READ-POSITION NIL *HELP-FILE*)
    (READ-LINE *HELP-FILE*)) )

ABS [n] 				   Numerical	  Function     138
ABSTRAP [object]			   Break	  Function     277
ACONS [key, object, a-list]		   A-list	  Function     94
ACOS [n]				   IRRATNAL.LSP   Function     291
ACOSH [n]				   IRRATNAL.LSP   Function     293
ACOT [n, m]				   IRRATNAL.LSP   Function     291
ACOTH [n]				   IRRATNAL.LSP   Function     293
ACSC [n]				   IRRATNAL.LSP   Function     291
ACSCH [n]				   IRRATNAL.LSP   Function     293
ADD1 [n]				   Numerical	  Function     133
ADJOIN [object, list, test]		   Constructor	  Function     61
ALLOCATE [n]				   Memory	  Function     204
ALPHA-CHAR-P [symbol]			   Character	  Function     152
ALPHANUMERICP [symbol]			   Character	  Function     152
AND [form1, ..., formn] 		   Logical	  Special form 51
APPEND [list1, ..., listn]		   Constructor	  Function     63
APPLY [function, arg1, ..., argn, arglist] Application	  Function     190
AREF [array, subscript1, ...]		   ARRAY.LSP	  Macro        283
ARRAY-DIMENSION [array, axis]		   ARRAY.LSP	  Function     284
ARRAY-DIMENSIONS [array]		   ARRAY.LSP	  Function     284
ARRAY-IN-BOUNDS [array, subscript1, ...]   ARRAY.LSP	  Function     285
ARRAY-RANK [array]			   ARRAY.LSP	  Function     284
ARRAY-TOTAL-SIZE [array]		   ARRAY.LSP	  Function     284
ARRAYP [object] 			   ARRAY.LSP	  Function     285
ASCII [atom]				   Character	  Function     156
ASEC [n]				   IRRATNAL.LSP   Function     291
ASECH [n]				   IRRATNAL.LSP   Function     293
ASH [n, count]				   Numerical	  Function     146
ASIN [n]				   IRRATNAL.LSP   Function     291
ASINH [n]				   IRRATNAL.LSP   Function     293
ASSOC [key, a-list, test]		   A-list	  Function     95
ASSOC-IF [test, a-list] 		   A-list	  Function     95
ATAN [n, m]				   IRRATNAL.LSP   Function     291
ATANH [n]				   IRRATNAL.LSP   Function     293
ATOM [object]				   Recognizer	  Function     42
*AUTO-NEWLINE*: T			   Output	  Control var. 225

BACK [distance] 			   GRAPHICS.LSP   Function     311
BACKGROUND-COLOR [n]			   Screen	  Function     234
BENCH-MARK [form]			   Hardware	  Macro        238
BINARY-LOAD [file, offset]		   Hardware	  Function     247
*BLANK-COMPRESS*: NIL			   Output	  Control var. 225
BORDER-COLOR [n]			   Screen	  Function     234
BOUNDP [symbol] 			   Symbol	  Function     101
BOUNDP-IN-CLOSURE [closure, symbol]	   CLOSURE.LSP	  Function     308
BREAK [object, message] 		   Break	  Function     273
BREAK					   Break	  Variable     273
BREAK-CHARS [list, flag]		   Input	  Function     208
BUTLAST [list, n]			   Constructor	  Function     66
BUTTON-PRESSES [button] 		   MOUSE.LSP	  Function     315
BUTTON-RELEASES [button]		   MOUSE.LSP	  Function     315

CAAAAR [object] 			   Selector	  Function     54
CAAADR [object] 			   Selector	  Function     54
CAAAR [object]				   Selector	  Function     54
CAADAR [object] 			   Selector	  Function     54
CAADDR [object] 			   Selector	  Function     54
CAADR [object]				   Selector	  Function     54
CAAR [object]				   Selector	  Function     54
CADAAR [object] 			   Selector	  Function     54
CADADR [object] 			   Selector	  Function     54
CADAR [object]				   Selector	  Function     54
CADDAR [object] 			   Selector	  Function     54
CADDDR [object] 			   Selector	  Function     54
CADDR [object]				   Selector	  Function     54
CADR [object]				   Selector	  Function     54
CAR [object]				   Selector	  Function     53
CASE [keyform, case1, ..., casen]	   Control	  Macro        175
CATCH [tag, form1, ..., formn]		   Control	  Special form 179
CDAAAR [object] 			   Selector	  Function     54
CDAADR [object] 			   Selector	  Function     54
CDAAR [object]				   Selector	  Function     54
CDADAR [object] 			   Selector	  Function     54
CDADDR [object] 			   Selector	  Function     54
CDADR [object]				   Selector	  Function     54
CDAR [object]				   Selector	  Function     54
CDDAAR [object] 			   Selector	  Function     54
CDDADR [object] 			   Selector	  Function     54
CDDAR [object]				   Selector	  Function     54
CDDDAR [object] 			   Selector	  Function     54
CDDDDR [object] 			   Selector	  Function     54
CDDDR [object]				   Selector	  Function     54
CDDR [object]				   Selector	  Function     54
CDR [object]				   Selector	  Function     53
CEILING [n, m]				   Numerical	  Function     140
CHANGE-WINDOW [ ]			   WINDOWS.LSP	  Function     341
CHAR [atom, n]				   String	  Function     160
CHAR-CODE [symbol]			   Character	  Function     156
CHAR-DOWNCASE [symbol]			   Character	  Function     157
CHAR-EQUAL [sym1, ..., symn]		   Character	  Function     155
CHAR-GREATERP [sym1, ..., symn] 	   Character	  Function     155
CHAR-LESSP [sym1, ..., symn]		   Character	  Function     155
CHAR-NOT-EQUAL [sym1, ..., symn]	   Character	  Function     155
CHAR-NOT-GREATERP [sym1, ..., symn]	   Character	  Function     155
CHAR-NOT-LESSP [sym1, ..., symn]	   Character	  Function     155
CHAR-UPCASE [symbol]			   Character	  Function     157
CHAR=  [symbol1, ..., symboln]		   Character	  Function     154
CHAR<  [symbol1, ..., symboln]		   Character	  Function     154
CHAR>  [symbol1, ..., symboln]		   Character	  Function     154
CHAR<=	[symbol1, ..., symboln] 	   Character	  Function     154
CHAR>=	[symbol1, ..., symboln] 	   Character	  Function     154
CHAR/=	[symbol1, ..., symboln] 	   Character	  Function     154
CLEAR-INPUT [source]			   Input	  Function     211
CLEAR-SCREEN [ ]			   Screen	  Function     232
CLOSE-INPUT-FILE [file] 		   Input file	  Function     251
CLOSE-OUTPUT-FILE [file]		   Output file	  Function     257
CLOSE-WINDOW				   WINDOWS.LSP	  Keyword      340
CLOSURE [varlist, function]		   CLOSURE.LSP	  Function     304
CLOSURE-ALIST [closure] 		   CLOSURE.LSP	  Function     308
CLOSURE-FUNCTION [closure]		   CLOSURE.LSP	  Function     308
CLOSURE-VARIABLES [closure]		   CLOSURE.LSP	  Function     308
CLOSUREP [closure]			   CLOSURE.LSP	  Function     306
CLR [ ] 				   GRAPHICS.LSP   Function     310
CODE-CHAR [n]				   Character	  Function     156
*COLOR* 				   GRAPHICS.LSP   Control var. 309
COLUMN [ ]				   Screen	  Function     231
COLUMNS [ ]				   Screen	  Function     231
COMMENT [comments]			   Evaluation	  Macro        188
COMPILE [name]				   COMPILE.LSP	  Function     346
COMPILE-FILE [compile-files, load-files]   COMPILE.LSP	  Function     348
:CONC-NAME [prefix]			   STRUCTUR.LSP   Option       295
COND [cond1, ..., condn]		   Control	  Special form 174
*CONDENSE*: NIL 			   Definition	  Control var. 120
CONS [obj1, obj2]			   Constructor	  Function     60
CONSOLE-INTERRUPT [ ]			   Break	  Function     276
CONSP [object]				   Recognizer	  Function     43
CONSTANTP [object]			   Evaluation	  Function     187
:CONSTRUCTOR [name, arglist]		   STRUCTUR.LSP   Option       295
CONTINUE-PROMPT [ ]			   WINDOWS.LSP	  Function     341
:COPIER [name]				   STRUCTUR.LSP   Option       295
COPY-ALIST [a-list]			   A-list	  Function     94
COPY-CHAR-TYPE [char1, char2, flag]	   Input	  Function     214
COPY-CLOSURE [closure]			   CLOSURE.LSP	  Function     306
COPY-LIST [list]			   Constructor	  Function     64
COPY-TREE [object]			   Constructor	  Function     64
COS [n] 				   IRRATNAL.LSP   Function     290
COS-DEG [angle] 			   GRAPHICS.LSP   Function     309
COSH [n]				   IRRATNAL.LSP   Function     292
COT [n] 				   IRRATNAL.LSP   Function     290
COTH [n]				   IRRATNAL.LSP   Function     292
COUNT [object, list, test]		   Search	  Function     82
COUNT-IF [test, list]			   Search	  Function     82
CREATE-WINDOW				   WINDOWS.LSP	  Keyword      340
CSC [n] 				   IRRATNAL.LSP   Function     290
CSCH [n]				   IRRATNAL.LSP   Function     292
CSMEMORY [offset, value, flag]		   Hardware	  Function     243
CURSOR-LINES [start-line, end-line]	   Screen	  Function     236

DECF [place, n] 			   Numerical	  Macro        135
DECQ [symbol, n]			   Numerical	  Special form 134
DEFAULT-DRIVE [drive]			   Directory	  Function     264
DEFAULT-PATH [drive, path]		   Directory	  Function     264
DEFFLAVOR [name, vars, flavors, opt1, ...] FLAVORS.LSP	  Macro        298
DEFMACRO [sym, arglist, form1, ...]	   Definition	  Special form 119
DEFMETHOD [(flv type meth), args, form1, ...] FLAVORS.LSP Macro        300
DEFSTRUCT [(name opt1 ...), slot1, ...]    STRUCTUR.LSP   Macro        294
DEFUN [symbol, arglist, form1, ..., formn] Definition	  Special form 118
DEFUN [symbol, (ftype arglist form1 ... formn)] Definition Special form 118
DEFUN [symbol, address] 		   Definition	  Special form 118
DEFWHOPPER [(flavor meth), args, form1, ...] FLAVORS.LSP  Macro        301
DELETE [item, list, test]		   Deletion	  Function     77
DELETE-COMPILER [ ]			   COMPILE.LSP	  Macro        347
DELETE-DUPLICATES [list, test]		   Deletion	  Function     79
DELETE-FILE [file]			   File 	  Function     262
DELETE-IF [test, list]			   Deletion	  Function     78
DELETE-LINES [n]			   Screen	  Function     232
DELETE-NTH [list, n]			   Modifier	  Function     75
DENOMINATOR [n] 			   Numerical	  Function     139
DENTRAP [object]			   Break	  Function     277
DIGIT-CHAR-P [symbol, radix]		   Character	  Function     153
DIRECTORY [path]			   Directory	  Function     264
DISPLAY-PAGE [n, active-only]		   Screen	  Function     235
DIVIDE [n, m]				   Numerical	  Function     143
DO [letlist, form1, ..., formn] 	   Control	  Macro        177
DO* [letlist, form1, ..., formn]	   Control	  Macro        177
DOLIST [(var list result), form1, ..., formn]  Control	  Macro        178
DOS [command]				   Control	  Function     183
DOT [x, y]				   GRAPHICS.LSP   Function     309
DOTIMES [(var count result), form1, ..., formn]  Control  Macro        178
DRIVER [file]				   Driver	  Function     271
DRIVER: 'DRIVER 			   Driver	  Control var. 270
DSMEMORY [offset, value, flag]		   Hardware	  Function     243

EIGHTH [list]				   Selector	  Function     56
ENCODE-UNIVERSAL-TIME [s, m, h, d, mo, y, z]   Hardware   Function     239
ENDP [object]				   Recognizer	  Function     44
EQ [obj1, obj2] 			   Comparator	  Function     45
EQL [obj1, obj2]			   Comparator	  Function     46
EQUAL [obj1, obj2, test]		   Comparator	  Function     47
ERROR-BEEP [ ]				   WINDOWS.LSP	  Function     341
EVAL [form]				   Evaluation	  Function     184
EVAL-FUNCTION-P [symbol]		   Definition	  Function     114
EVENP [object]				   Numerical	  Function     126
EVERY [test, list1, ..., listn] 	   Mapping	  Function     195
*EXACT-MODE*: NIL			   Numerical	  Control var. 122
EXACT-MODEP [ ] 			   IRRATNAL.LSP   Function     286
EXECUTE [program, command]		   Control	  Function     183
EXECUTE-OPTION [prompt, option-tree]	   WINDOWS.LSP	  Function     341
EXP [n] 				   IRRATNAL.LSP   Function     286
EXPT [n, m]				   IRRATNAL.LSP   Function     287

FBOUNDP [symbol]			   Definition	  Function     114
FIFTH [list]				   Selector	  Function     56
FILE-DATE [file]			   File 	  Function     263
FILE-LENGTH [file]			   File 	  Function     263
FILE-LINE-LENGTH [n, file]		   Output file	  Function     261
FILE-READ-POSITION [n, file]		   Input file	  Function     254
FILE-WRITE-POSITION [n, file]		   Output file	  Function     260
FILL [list, object]			   Modifier	  Function     71
FIND [object, list, test]		   Search	  Function     80
FIND-IF [test, list]			   Search	  Function     80
FINDSTRING [atom1, atom2, n]		   String	  Function     166
FIRST [list]				   Selector	  Function     56
FIRSTN [n, list]			   Constructor	  Function     66
FLAG [symbol, flag]			   Flag 	  Function     111
FLAGP [symbol, flag]			   Flag 	  Function     111
FLOOR [n, m]				   Numerical	  Function     140
FMAKUNBOUND [symbol]			   Definition	  Function     117
FOREGROUND-COLOR [n]			   Screen	  Function     234
FORWARD [distance]			   GRAPHICS.LSP   Function     311
FOURTH [list]				   Selector	  Function     56
*FREE-LIST*: NIL			   Memory	  Variable     203
FRESH-LINE [sink]			   Output	  Function     223
FUNCALL [function, arg1, ..., argn]	   Application	  Function     189
FUNCTIONP [object]			   Evaluation	  Function     187

GCD [n1, ..., nm]			   Numerical	  Function     136
GCDTRAP [obj1, obj2]			   Break	  Function     277
*GCHOOK*: NIL				   Memory	  Control var. 203
*GCSTAT*: NIL				   Memory	  Control var. 201
GENSYM [atom]				   String	  Function     168
*GENSYM-COUNT*: 0			   String	  Control var. 168
*GENSYM-PREFIX*: G			   String	  Control var. 168
GET [symbol, key, default]		   Property	  Function     109
GET-DECODED-TIME [ ]			   Hardware	  Function     239
GET-PROPERTIES [plist, key-list]	   Property	  Function     109
GET-UNIVERSAL-TIME [ ]			   Hardware	  Function     239
GET-MACRO-CHAR [char, flag]		   Input	  Function     215
GETD [symbol, flag]			   Definition	  Function     112
GETF [plist, key, default]		   Property	  Function     109
GETSET [parameter]			   Directory	  Function     265
:GETTABLE-INSTANCE-VARIABLES		   FLAVORS.LSP	  Option       298
GO-DOS [ ]				   WINDOWS.LSP	  Function     342

HIDE-MOUSE [ ]				   MOUSE.LSP	  Function     314
*HISTORY-LENGTH*: 25			   DEBUG.LSP	  Control var. 338

IDENTITY [object]			   Evaluation	  Function     186
IF [testform, thenform, elseform]	   Control	  Special form 173
*IGNORE-CASE*: NIL			   Input	  Control var. 219
INCF [place, n] 			   Numerical	  Macro        135
:INCLUDE [structure]			   STRUCTUR.LSP   Option       296
:INCLUDED-FLAVORS [flavor1, ..., flavorn]  FLAVORS.LSP	  Option       299
INCQ [symbol, n]			   Numerical	  Special form 134
:INITABLE-INSTANCE-VARIABLES		   FLAVORS.LSP	  Option       298
:INITIAL-CONTENTS expression		   ARRAY.LSP	  Option       282
:INITIAL-ELEMENT expression		   ARRAY.LSP	  Option       282
*INIT-WINDOW*				   WINDOWS.LSP	  Control var. 339
*INPUT-ECHO*: NIL			   Input	  Control var. 218
INPUT-FILE [file]			   Input file	  Function     252
*INPUT-FILE*: NIL			   Input file	  Control var. 253
INPUT-FILE-P [file]			   Input file	  Function     252
INPUT-FILES [ ] 			   Input file	  Function     252
INSERT-LINES [n]			   Screen	  Function     232
*INSERT-MODE*: T			   Line editor	  Control var. 280
INSERT-NTH [item, list, n]		   Modifier	  Function     75
INTEGER-LENGTH [n]			   Numerical	  Function     147
INTEGERP [object]			   Recognizer	  Function     41
INTERRUPT [n]				   Hardware	  Function     246
*INTERRUPT-HOOK*: 'CONSOLE-INTERRUPT   Break		  Control var. 276
INTERSECTION [list1, list2, test]	   Set		  Function     90
ISQRT [n]				   IRRATNAL.LSP   Function     287

KEY-TRANSLATION [char, index]		   Line editor	  Function     388

LAMBDA					   Definition	  Keyword      112
LAST [list]				   Selector	  Function     57
LCM [n1, ..., nm]			   Numerical	  Function     137
LCMTRAP [obj1, obj2]			   Break	  Function     277
LCONC [dotted-pair, list]		   Modifier	  Function     76
LDIFF [list, tail]			   Constructor	  Function     67
LEFT [angle]				   GRAPHICS.LSP   Function     310
*LEFT-BUTTON*				   MOUSE.LSP	  Variable     315
LENGTH [object] 			   Selector	  Function     59
LET [letlist, form1, ..., formn]	   Control	  Macro        172
LET* [letlist, form1, ..., formn]	   Control	  Macro        172
LET-CLOSED [letlist, function]		   CLOSURE.LSP	  Macro        305
LINE [x1, y1, x2, y2]			   GRAPHICS.LSP   Function     309
*LINE-COLUMN*				   Line editor	  Variable     279
LINE-EDIT [text, point, col, width]	   Line editor	  Function     279
*LINE-POINT*				   Line editor	  Variable     279
*LINE-TERMINATOR*			   Line editor	  Variable     279
LIST [obj1, ..., objn]			   Constructor	  Function     62
LIST* [obj1, ..., objn] 		   Constructor	  Function     62
LIST-LENGTH [object]			   Selector	  Function     59
LISTEN [source] 			   Input	  Function     211
LISTP [object]				   Recognizer	  Function     43
LN [n]					   IRRATNAL.LSP   Function     288
LOAD [file, display]			   Memory image   Function     268
*LOAD-VERBOSE*: T			   Memory image   Control var. 268
LOCATE-IN-CLOSURE [closure, symbol]	   CLOSURE.LSP	  Function     307
LOCATION [object]			   Hardware	  Function     245
LOG [n, base]				   IRRATNAL.LSP   Function     288
LOGAND [n1, ..., nm]			   Numerical	  Function     145
LOGBITP [index, n]			   Numerical	  Function     144
LOGEQV [n1, ..., nm]			   Numerical	  Function     145
LOGIOR [n1, ..., nm]			   Numerical	  Function     145
LOGNOT [n]				   Numerical	  Function     144
LOGTEST [n, m]				   Numerical	  Function     144
LOGXOR [n1, ..., nm]			   Numerical	  Function     145
LOOP [form1, ..., formn]		   Control	  Special form 176
LOWER-CASE-P [symbol]			   Character	  Function     151

MACRO					   Definition	  Keyword      112
MACRO-FUNCTION [symbol] 		   Macro	  Function     197
MACRO-P [symbol]			   Definition	  Function     114
MACROEXPAND [form]			   Macro	  Function     198
MACROEXPAND: T				   Macro	  Control var. 199
MACROEXPAND-1 [form]			   Macro	  Function     198
MAKE-ARRAY [dimensions, opt1, ..., optn]   ARRAY.LSP	  Function     282
MAKE-INSTANCE [flavor, vars]		   FLAVORS.LSP	  Macro        302
MAKE-LIST [n, object, list]		   Constructor	  Function     64
MAKE-RANDOM-STATE [state]		   Numerical	  Function     149
MAKE-WINDOW [row, column, rows, cols]	   Screen	  Function     230
MAPC [function, list1, ..., listn]	   Mapping	  Function     191
MAPCAN [function, list1, ..., listn]	   Mapping	  Function     193
MAPCAR [function, list1, ..., listn]	   Mapping	  Function     192
MAPCON [function, list1, ..., listn]	   Mapping	  Function     193
MAPL [function, list1, ..., listn]	   Mapping	  Function     191
MAPLIST [function, list1, ..., listn]	   Mapping	  Function     192
MAX [n1, ..., nm]			   Numerical	  Function     130
MAXTRAP [obj1, obj2]			   Break	  Function     277
MEMBER [object, list, test]		   Search	  Function     84
MEMBER-IF [test, list]			   Search	  Function     84
MEMORY [address, value, flag]		   Hardware	  Function     242
MERGE [list1, list2, test]		   Sorting	  Function     99
:METHOD-COMBINATION			   FLAVORS.LSP	  Option       299
MIN [n1, ..., nm]			   Numerical	  Function     130
MINTRAP [obj1, obj2]			   Break	  Function     277
MINUSP [object] 			   Numerical	  Function     125
MISMATCH [list1, list2, test]		   Search	  Function     83
MOD [n, m]				   Numerical	  Function     142
MOUSE-BOX [x1, y1, x2, y2]		   MOUSE.LSP	  Function     316
MOUSE-POSITION [x, y]			   MOUSE.LSP	  Function     314
MOUSE-RESET [ ] 			   MOUSE.LSP	  Function     313
MOUSE-STATUS [ ]			   MOUSE.LSP	  Function     315
*MOUSE-X*				   MOUSE.LSP	  Function     314
*MOUSE-Y*				   MOUSE.LSP	  Function     314
MOVD [symbol1, symbol2] 		   Definition	  Function     116

:NAMED					   STRUCTUR.LSP   Option       296
NBUTLAST [list, n]			   Modifier	  Function     74
NCONC [list1, ..., listn]		   Modifier	  Function     72
NEQ [obj1, obj2]			   Comparator	  Function     45
NEQL [obj1, obj2]			   Comparator	  Function     46
NEW-CODE-SPACE [ ]			   Memory	  Function     205
NIL					   Evaluation	  Constant     44
NINTERSECTION [list1, list2, test]	   Set		  Function     90
NINTH [list]				   Selector	  Function     56
NLAMBDA 				   Definition	  Keyword      112
NO-EVAL-FUNCTION-P [symbol]		   Definition	  Function     114
:NO-VANILLA-FLAVOR			   FLAVORS.LSP	  Option       299
NOT [object]				   Logical	  Function     50
NOTANY [test, list1, ..., listn]	   Mapping	  Function     194
NOTEVERY [test, list1, ..., listn]	   Mapping	  Function     195
NRECONC [list, object]			   Modifier	  Function     73
NREVERSE [list, object] 		   Modifier	  Function     73
NSET-DIFFERENCE [list1, list2, test]	   Set		  Function     91
NSET-EXCLUSIVE-OR [list1, list2, test]	   Set		  Function     92
NSUBLIS [a-list, object, test]		   A-list	  Function     97
NSUBST [new, old, object, test] 	   Substitution   Function     87
NSUBST-IF [new, test, object]		   Substitution   Function     88
NSUBSTITUTE [new, old, list, test]	   Substitution   Function     85
NSUBSTITUTE-IF [new, test, list]	   Substitution   Function     86
NTH [n, list]				   Selector	  Function     58
NTHCDR [n, list]			   Selector	  Function     58
NULL [object]				   Recognizer	  Function     44
NUMBERP [object]			   Recognizer	  Function     41
NUMERATOR [n]				   Numerical	  Function     139
NUMERIC-CHAR-P [symbol] 		   Character	  Function     152
NUMTRAP [object]			   Break	  Function     277
NUNION [list1, list2, test]		   Set		  Function     89

OBLIST [ ]				   Constructor	  Function     69
ODDP [object]				   Numerical	  Function     126
OPEN-INPUT-FILE [file]			   Input file	  Function     250
OPEN-OUTPUT-FILE [file, overwrite]	   Output file	  Function     255
OR [form1, ..., formn]			   Logical	  Special form 52
ORDERP [obj1, obj2]			   Comparator	  Function     49
OTHERWISE				   Control	  Keyword      175
*OUTPUT-ECHO*: NIL			   Output	  Control var. 225
OUTPUT-FILE [file]			   Output file	  Function     258
*OUTPUT-FILE*: NIL			   Output file	  Control var. 259
OUTPUT-FILE-P [file]			   Output file	  Function     258
OUTPUT-FILES [ ]			   Output file	  Function     258

PACK [list]				   String	  Function     159
PACK* [atom1, ..., atomn]		   String	  Function     159
PAIRLIS [keys, objects, a-list] 	   A-list	  Function     94
PALETTE-COLOR [n]			   Screen	  Function     234
PARSE-INTEGER [string, radix]		   Input	  Function     213
PEEK-CHAR [type, source, eof-p, eof-v]	   Input	  Function     210
PENDOWN [ ]				   GRAPHICS.LSP   Function     310
PENUP [ ]				   GRAPHICS.LSP   Function     310
PI [ ]					   IRRATNAL.LSP   Function     289
PLOT-CIRCLE [x, y, r, color]		   Screen	  Function     237
*PLOT-COLOR*: 15			   Screen	  Control var. 237
PLOT-DOT [x, y, color]			   Screen	  Function     237
PLOT-LINE [x1, y1, x2, y2, color]	   Screen	  Function     237
PLUSP [object]				   Numerical	  Function     125
POP [symbol]				   Symbol	  Special form 106
PORTIO [port, value, flag]		   Hardware	  Function     241
POSITION [object, list, test]		   Search	  Function     81
POSITION-IF [test, list]		   Search	  Function     81
PRECISION [n]				   Numerical	  Function     122
:PREDICATE [name]			   STRUCTUR.LSP   Option       295
PRIN1 [object, sink]			   Output	  Function     221
PRINC [object, sink]			   Output	  Function     221
PRINT [object, sink]			   Output	  Function     221
*PRINT-BASE*: 10			   Output	  Control var. 227
*PRINT-DOWNCASE*: NIL			   Output	  Control var. 226
*PRINT-ESCAPE*: T			   Output	  Control var. 226
PRINT-LENGTH [atom]			   String	  Function     167
*PRINT-POINT*: 7			   Output	  Control var. 228
PRINT-SCREEN [row, col] 		   Output	  Function     Readme
*PRINT-TRACE*: NIL			   DEBUG.LSP	  Control var. 338
*PRINTER-ECHO*: NIL			   Output	  Control var. 225
PROBE-FILE [file]			   File 	  Function     262
PROG1 [form1, ..., formn]		   Control	  Special form 171
PROG2 [form1, ..., formn]		   Control	  Macro        171
PROGN [form1, ..., formn]		   Control	  Special form 170
PROMPT-YN [prompt]			   WINDOWS.LSP	  Function     341
PSETQ [symbol1, form1, ..., symboln, formn]  Symbol	  Special form 104
PUSH [form, symbol]			   Symbol	  Special form 107
PUSHNEW [form, symbol, test]		   Symbol	  Macro        107
PUT [symbol, key, object]		   Property	  Function     108
PUTD [symbol, definition]		   Definition	  Function     115

QUIT-PROGRAM [ ]			   WINDOWS.LSP	  Function     342
QUOTE [object]				   Evaluation	  Special form 186

RANDOM [n, state]			   Numerical	  Function     148
*RANDOM-STATE*				   Numerical	  Control var. 149
RANDOM-STATE-P [object] 		   Numerical	  Function     150
RASSOC [key, a-list, test]		   A-list	  Function     96
RASSOC-IF [test, a-list]		   A-list	  Function     96
RATIONAL				   IRRATNAL.LSP   Keyword      286
RATIONALP [object]			   Recognizer	  Function     41
READ [source, eof-p, eof-v]		   Input	  Function     207
READ-ATOM [source, eof-p, eof-v]	   Input	  Function     208
*READ-BASE*: 10 			   Input	  Control var. 218
READ-BYTE [source, eof-p, eof-v]	   Input	  Function     209
READ-CHAR [source, eof-p, eof-v]	   Input	  Function     209
READ-DOT [x, y] 			   Screen	  Function     237
READ-FROM-STRING [string, eof-p, eof-v]    Input	  Function     212
READ-LINE [source, eof-p, eof-v]	   Input	  Function     209
READ-RECORD [n, source, eof-p, eof-v]	   Input	  Function     209
*READ-STRINGS*				   Input	  Variable     212
*READ-UPCASE*: T			   Input	  Control var. 218
RECLAIM [ ]				   Memory	  Function     200
REDUCE [function, list, initial]	   Mapping	  Function     196
REGISTER [regnum, low, high]		   Hardware	  Function     246
REM [n, m]				   Numerical	  Function     142
REMD [symbol]				   Definition	  Function     117
REMF [place, key]			   Property	  Function     110
REMFLAG [symbol, flag]			   Flag 	  Function     111
REMOVE [item, list, test]		   Deletion	  Function     77
REMOVE-DUPLICATES [list, test]		   Deletion	  Function     79
REMOVE-IF [test, list]			   Deletion	  Function     78
REMPROP [symbol, key]			   Property	  Function     110
RENAME-FILE [oldname, newname]		   File 	  Function     262
REPLACE [list1, list2]			   Modifier	  Function     71
REPLACE-NTH [item, list, n]		   Modifier	  Function     75
:REQUIRED-FLAVORS [flavor1, ..., flavorn]  FLAVORS.LSP	  Option       298
REST [list]				   Selector	  Function     56
RESTART [ ]				   Control	  Function     182
RETURN [form]				   Control	  Special form 181
REVAPPEND [list, object]		   Constructor	  Function     68
REVERSE [list, object]			   Constructor	  Function     68
RIGHT [angle]				   GRAPHICS.LSP   Function     310
*RIGHT-BUTTON*				   MOUSE.LSP	  Variable     315
ROUND [n, m]				   Numerical	  Function     141
ROW [ ] 				   Screen	  Function     231
ROWS [ ]				   Screen	  Function     231
RPLACA [obj1, obj2]			   Modifier	  Function     70
RPLACD [obj1, obj2]			   Modifier	  Function     70
RUN-WINDOW				   WINDOWS.LSP	  Keyword      340

SAVE [file]				   Memory image   Function     266
SEC [n] 				   IRRATNAL.LSP   Function     290
SECH [n]				   IRRATNAL.LSP   Function     292
SECOND [list]				   Selector	  Function     56
SELF					   FLAVORS.LSP	  Variable     303
SEND [object, operation, arg1, ..., argn]  FLAVORS.LSP	  Macro        303
SET [symbol, object]			   Symbol	  Function     102
SET-CURSOR [row, column]		   Screen	  Function     231
SET-DIFFERENCE [list1, list2, test]	   Set		  Function     91
SET-DISPLAY [ ] 			   WINDOWS.LSP	  Function     342
SET-EXCLUSIVE-OR [list1, list2, test]	   Set		  Function     92
SET-IN-CLOSURE [closure, symbol, object]   CLOSURE.LSP	  Function     307
SET-INSERT [ ]				   WINDOWS.LSP	  Function     342
SET-MACRO-CHAR [char, defn, flag]	   Input	  Function     215
SET-MENU-COLOR [ ]			   WINDOWS.LSP	  Function     342
SET-MUTE [ ]				   WINDOWS.LSP	  Function     342
SET-WORK-COLOR [ ]			   WINDOWS.LSP	  Function     342
SETCOLOR [angle]			   GRAPHICS.LSP   Function     310
SETF [place1, form1, ..., placen, formn]   Symbol	  Macro        105
SETHEADING [angle]			   GRAPHICS.LSP   Function     310
SETPOS [x, y]				   GRAPHICS.LSP   Function     310
SETQ [symbol1, form1, ..., symboln, formn] Symbol	  Special form 103
:SETTABLE-INSTANCE-VARIABLES		   FLAVORS.LSP	  Option       298
SEVENTH [list]				   Selector	  Function     56
SHIFT [n, count]			   Numerical	  Function     146
*SHOW-LOAD*: T				   DEBUG.LSP	  Control var. 335
SHOW-MOUSE [ ]				   MOUSE.LSP	  Function     314
SHOW-PROMPT [prompt]			   WINDOWS.LSP	  Function     342
SIGNUM [n]				   Numerical	  Function     138
SIN [n] 				   IRRATNAL.LSP   Function     290
SIN-DEG [angle] 			   GRAPHICS.LSP   Function     309
SINH [n]				   IRRATNAL.LSP   Function     292
SIXTH [list]				   Selector	  Function     56
SLEEP [seconds] 			   Hardware	  Function     240
SNAPSHOT [address, atom]		   Hardware	  Function     248
SOME [test, list1, ..., listn]		   Mapping	  Function     194
SORT [list, test]			   Sorting	  Function     100
SPACES [n, sink]			   Output	  Function     223
SPECIAL 				   Definition	  Keyword      112
SPECIAL-FORM-P [symbol] 		   Definition	  Function     114
SPLIT [list]				   Sorting	  Function     98
SQRT [n]				   IRRATNAL.LSP   Function     287
STABLE-SORT [list, test]		   Sorting	  Function     100
STACK-LIST [ ]				   Constructor	  Function     69
STRING-CAPITALIZE [atom]		   String	  Function     165
STRING-DOWNCASE [atom]			   String	  Function     165
STRING-EQUAL [atom1, atom2]		   String	  Macro        161
STRING-GREATERP [atom1, atom2]		   String	  Macro        163
*STRING-INDEX*				   Input	  Variable     212
STRING-LEFT-TRIM [chars, atom]		   String	  Function     164
STRING-LESSP [atom1, atom2]		   String	  Macro        163
STRING-NOT-EQUAL [atom1, atom2] 	   String	  Macro        163
STRING-NOT-GREATERP [atom1, atom2]	   String	  Macro        163
STRING-NOT-LESSP [atom1, atom2] 	   String	  Macro        163
STRING-RIGHT-TRIM [chars, atom] 	   String	  Function     164
STRING-TRIM [chars, atom]		   String	  Function     164
STRING-UPCASE [atom]			   String	  Function     165
STRING=  [atom1, atom2, flag]		   String	  Function     161
STRING<  [atom1, atom2, flag]		   String	  Function     162
STRING>  [atom1, atom2, flag]		   String	  Function     162
STRING<=  [atom1, atom2, flag]		   String	  Function     162
STRING>=  [atom1, atom2, flag]		   String	  Function     162
STRING/=  [atom1, atom2, flag]		   String	  Function     162
STRINGP [object]			   Recognizer	  Function     40
SUB1 [n]				   Numerical	  Function     133
SUBLIS [a-list, object, test]		   A-list	  Function     97
SUBLIST [list, n, m]			   Constructor	  Function     65
SUBSETP [list1, list2, test]		   Set		  Function     93
SUBST [new, old, object, test]		   Substitution   Function     87
SUBST-IF [new, test, object]		   Substitution   Function     88
SUBSTITUTE [new, old, list, test]	   Substitution   Function     85
SUBSTITUTE-IF [new, test, list] 	   Substitution   Function     86
SUBSTRING [atom, n, m]			   String	  Function     160
SYMBOL-FUNCTION [symbol]		   Definition	  Function     113
SYMBOL-PLIST [symbol]			   Property	  Function     109
SYMBOL-VALUE [symbol]			   Symbol	  Function     101
SYMBOLP [object]			   Recognizer	  Function     40
SYMEVAL-IN-CLOSURE [closure, symbol]	   CLOSURE.LSP	  Function     307
SYSTEM [n]				   Control	  Function     182

*TAB-EXPAND*: NIL			   Input	  Control var. 218
TAILP [list1, list2]			   Comparator	  Function     48
TAN [n] 				   IRRATNAL.LSP   Function     290
TANH [n]				   IRRATNAL.LSP   Function     292
TCONC [dotted-pair, object]		   Modifier	  Function     76
TENTH [list]				   Selector	  Function     56
TERPRI [n, sink]			   Output	  Function     223
THIRD [list]				   Selector	  Function     56
THROW [tag, form]			   Control	  Special form 181
*THROW-TAG*				   Control	  Variable     181
TIME [reset]				   Hardware	  Function     238
*TIME-ZONE*: 0				   Hardware	  Control var. 239
TONE [frequency, milliseconds]		   Hardware	  Function     240
*TRAP [obj1, obj2]			   Break	  Function     277
TREE-EQUAL [obj1, obj2, test]		   Comparator	  Function     47
TRUNCATE [n, m] 			   Numerical	  Function     141
TURTLE [ ]				   GRAPHICS.LSP   Function     312
TURTLE-WINDOW [ ]			   GRAPHICS.LSP   Function     312
:TYPE LIST				   STRUCTUR.LSP   Option       296

*UNDEFINED-HOOK*: 'UNDEFINED-FUNCTION	   Break	  Control var. 276
UNDEFINED-FUNCTION [form]		   Break	  Function     276
UNDEFMETHOD [(flavor type method)]	   FLAVORS.LSP	  Macro        300
UNDERFLOW [n]				   Numerical	  Function     124
UNION [list1, list2, test]		   Set		  Function     89
UNLESS [testform, form1, ..., formn]	   Control	  Macro        173
UNPACK [atom]				   String	  Function     158
UNREAD-CHAR [source]			   Input	  Function     210
UNWIND-PROTECT [form1, form2, ..., formn]  Control	  Special form 180
UPDATE-STATE [arglist]			   WINDOWS.LSP	  Function     343
UPDATE-WINDOW				   WINDOWS.LSP	  Keyword      340
UPPER-CASE-P [symbol]			   Character	  Function     151

VECTOR [obj1, ..., objn]		   ARRAY.LSP	  Function     282
VIDEO-MODE [n, compressed-text-flag]	   Screen	  Function     233

*WINDOW-TYPES*				   WINDOWS.LSP	  Control var. 339
WINDOWS [command-line]			   WINDOWS.LSP	  Function     343
WHEN [testform, form1, ..., formn]	   Control	  Macro        173
WRITE [object, sink]			   Output	  Function     220
WRITE-BYTE [n, m, sink] 		   Output	  Function     224
WRITE-LINE [symbol, sink]		   Output	  Function     222
WRITE-SCREEN [sink]			   Output	  Function     Readme
WRITE-STRING [symbol, sink]		   Output	  Function     222

Y-OR-N-P [message]			   Query	  Function     278
YES-OR-NO-P [message]			   Query	  Function     278

ZEROP [object]				   Numerical	  Function     125

+  [n1, ..., nm]			   Numerical	  Function     131
-  [n1, ..., nm]			   Numerical	  Function     131
*  [n1, ..., nm]			   Numerical	  Function     132
/  [n1, ..., nm]			   Numerical	  Function     132

+TRAP [obj1, obj2]			   Break	  Function     277
-TRAP [obj1, obj2]			   Break	  Function     277
*TRAP [obj1, obj2]			   Break	  Function     277
/TRAP [obj1, obj2]			   Break	  Function     277

=  [n1, ..., nm]			   Numerical	  Function     127
/=  [n1, ..., nm]			   Numerical	  Function     127
<  [n1, ..., nm]			   Numerical	  Function     128
>  [n1, ..., nm]			   Numerical	  Function     128
<=  [n1, ..., nm]			   Numerical	  Function     129
>=  [n1, ..., nm]			   Numerical	  Function     129

\  (back slash) 			   Input	  Escape char. 207
|  (vertical bar)			   Input	  Escape char. 207

(  (left parenthesis)			   Input	  Macro char.  216
)  (right parenthesis)			   Input	  Macro char.  216
]  (right square bracket)		   Input	  Macro char.  216
,  (comma)				   Input	  Macro char.  216
'  (single quote)			   Input	  Macro char.  216
;  (semicolon)				   Input	  Macro char.  216
"  (double quote)			   Input	  Macro char.  217
`  (backquote)				   Input	  Macro char.  217

+  (last form read)			   Driver	  Variable     271
++  (form before last form)		   Driver	  Variable     271
+++  (two before last form)		   Driver	  Variable     271
*  (value of last form read)		   Driver	  Variable     271
**  (value of form before last form)	   Driver	  Variable     271
***  (value of two before last form)	   Driver	  Variable     271
-  (current form being evaluated)	   Driver	  Variable     271
