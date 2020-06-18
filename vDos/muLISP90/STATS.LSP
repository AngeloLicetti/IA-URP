; File: STATS.LSP (c)		    03/06/91		Soft Warehouse, Inc.


;	* * *	Data Space Size Statistics Display   * * *

(TERPRI 2)
(WRITE-STRING "  Symbol table size:  ")
(PRINT (IF (GETD 'NEW-CODE-SPACE)
	   (* 4 (- (DSMEMORY 0 NIL T) (LOCATION NIL)))
	   (* 1 (- (DSMEMORY 0 NIL T) (LOCATION NIL))) ))

(WRITE-STRING "  Number table size:  ")
(PRINT (IF (GETD 'NEW-CODE-SPACE)
	   (* 4 (- (DSMEMORY 4 NIL T) (DSMEMORY 2 NIL T)))
	   (* 1 (- (DSMEMORY 8 NIL T) (DSMEMORY 4 NIL T))) ))

(WRITE-STRING "    Cons space size:  ")
(PRINT (IF (GETD 'NEW-CODE-SPACE)
	   (* 2 (- (DSMEMORY 6 NIL T) (DSMEMORY 4 NIL T)))
	   (* 1 (- (DSMEMORY 12 NIL T) (DSMEMORY 8 NIL T))) ))

(WRITE-STRING "  String space size:  ")
(PRINT (IF (GETD 'NEW-CODE-SPACE)
	   (DSMEMORY 40 NIL T)
	   (- (DSMEMORY 20 NIL T) (DSMEMORY 16 NIL T)) ))

(WRITE-STRING "  Vector space size:  ")
(PRINT (IF (GETD 'NEW-CODE-SPACE)
	   (- 65536 (DSMEMORY 44 NIL T))
	   (- (DSMEMORY 28 NIL T) (DSMEMORY 24 NIL T)) ))

(IF (GETD 'NEW-CODE-SPACE)
    (PROGN

(SETQ NUM 1)
(LOOP
  (WRITE-STRING (PACK* "D-code space " NUM " size:  "))
  ((OR (>= NUM 6) (ZEROP (DSMEMORY (+ 148 (* 2 NUM)) NIL T)))
    (PRINT (- (DSMEMORY 36 NIL T) (DSMEMORY 34 NIL T))) )
  (PRINT (- (DSMEMORY (+ 146 (* 2 NUM)) NIL T) (DSMEMORY 34 NIL T)))
  (INCQ NUM) )
(SETQ NUM 'NUM)

)   (PROGN

(WRITE-STRING "  D-code space size:  ")
(PRINT (- (DSMEMORY 32 NIL T) (DSMEMORY 28 NIL T)))
))
