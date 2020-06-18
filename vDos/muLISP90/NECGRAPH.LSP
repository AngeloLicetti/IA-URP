;File: NECGRAPH.LSP		    03/06/91		Soft Warehouse, Inc.


;		     NEC PC-9801 Graphics Functions

; On 12/15/87 T. Hiruta of SEG Corp. found and corrected a bug in
; NECGRAPH.LSP that prevented the program from working correctly on
; NEC PC-9801 series E, F, M, and V computers.

(DEFUN GRAPHICS-INIT (
; builds interrupt vectors 0A0H through 0AFH and initializes graphics.
; It must be called before using the other functions in this file.
    CTR)
  (MEMORY 4640 207)		;Make Interrupt 0C5H point to an IRET
  (MEMORY 788 134 T)
  (MEMORY 790 63888 T)
  (SETQ CTR 0)
  (LOOP 			;Build interrupt vectors 0A0H through 0AFH
    ((= CTR 64))
    (MEMORY (+ 640 CTR) (MEMORY (+ 1022214 CTR) NIL T) T)
    (MEMORY (+ 642 CTR) 63888 T)
    (INCQ CTR 4) )
  (SETQ *LIOS* (+ (CSMEMORY) (TRUNCATE (+ 15 (ALLOCATE 5120)) 16 ) ) )
  (SETQ *LIO* (* *LIOS* 16))
  (REGISTER 7 *LIOS*)
  (INTERRUPT 160)
 )

(DEFUN GRAPHICS-SCREEN (MODE SWITCH APAGE DPAGE)
; sets the display mode, display switch, active page, and display page.
  (MEMORY *LIO* MODE)
  (MEMORY (+ *LIO* 1) SWITCH)
  (MEMORY (+ *LIO* 2) APAGE)
  (MEMORY (+ *LIO* 3) DPAGE)
  (REGISTER 7 *LIOS*)
  (REGISTER 1 0)
  (INTERRUPT 161) )

(DEFUN GRAPHICS-WINDOW (X1 Y1 X2 Y2 COLOR BORDER-COLOR)
; establishes a rectangular graphics window and fills it with COLOR and
; borders it with BORDER-COLOR.  If COLOR is not given, the window is
; not filled.  If BORDER-COLOR is not given, the window is not bordered.
  (MEMORY *LIO* X1 T)
  (MEMORY (+ *LIO* 2) Y1 T)
  (MEMORY (+ *LIO* 4) X2 T)
  (MEMORY (+ *LIO* 6) Y2 T)
  (MEMORY (+ *LIO* 8) (OR COLOR 255))
  (MEMORY (+ *LIO* 9) (OR BORDER-COLOR 255))
  (REGISTER 7 *LIOS*)
  (REGISTER 1 0)
  (INTERRUPT 162) )

(DEFUN GRAPHICS-COLOR (FOREGROUND-COLOR BACKGROUND-COLOR BORDER-COLOR)
; sets the foreground, background, and border colors used for graphics.
; Any color that is NIL or not given remains unchanged.
  (MEMORY *LIO* 0)
  (MEMORY (+ *LIO* 1) (OR BACKGROUND-COLOR 255))
  (MEMORY (+ *LIO* 2) (OR BORDER-COLOR 255))
  (MEMORY (+ *LIO* 3) (OR FOREGROUND-COLOR 255))
  (REGISTER 7 *LIOS*)
  (REGISTER 1 0)
  (INTERRUPT 163) )

(DEFUN GRAPHICS-CLS ()
; clears graphics screen
  (REGISTER 7 *LIOS*)
  (INTERRUPT 165) )

(DEFUN GRAPHICS-PLOT-DOT (X Y COLOR)
; plots a dot at the point (X,Y) in color number COLOR.
  (MEMORY *LIO* X T)
  (MEMORY (+ *LIO* 2) Y T)
  (MEMORY (+ *LIO* 4) (OR COLOR 255))
  (REGISTER 0 256)
  (REGISTER 7 *LIOS*)
  (REGISTER 1 0)
  (INTERRUPT 166) )

(DEFUN GRAPHICS-PLOT-LINE (X1 Y1 X2 Y2 COLOR CODE STYLE)
; If CODE=0, plots a line from (X1,Y1) to (X2,Y2) in color number COLOR.
; If CODE=1, plots a box from (X1,Y1) and (X2,Y2) in color number COLOR.
; If CODE=2, fills a box from (X1,Y1) and (X2,Y2) in color number COLOR.
; If STYLE=0, uses a solid line; if STYLE=1, uses a dashed line.
  (MEMORY *LIO* X1 T)
  (MEMORY (+ *LIO* 2) Y1 T)
  (MEMORY (+ *LIO* 4) X2 T)
  (MEMORY (+ *LIO* 6) Y2 T)
  (MEMORY (+ *LIO* 8) (OR COLOR 255))
  (MEMORY (+ *LIO* 9) (OR CODE 0))
  (MEMORY (+ *LIO* 10) (OR STYLE 0))
  (MEMORY (+ *LIO* 11) 255)
  (REGISTER 7 *LIOS*)
  (REGISTER 1 0)
  (INTERRUPT 167) )

(DEFUN GRAPHICS-PLOT-BOX (X1 Y1 X2 Y2 COLOR)
; plots a box defined by (X1,Y1) and (X2,Y2) in color number COLOR.
  (GRAPHICS-PLOT-LINE X1 Y1 X2 Y2 COLOR 1 0) )

(DEFUN GRAPHICS-PLOT-CIRCLE (CX CY RX RY COLOR)
; plots a circle centered at (CX,CY) with X and Y-axis radii of RX and RY
; respectively in color number COLOR.
  (MEMORY *LIO* CX T)
  (MEMORY (+ *LIO* 2) CY T)
  (MEMORY (+ *LIO* 4) RX T)
  (MEMORY (+ *LIO* 6) (OR RY RX) T)
  (MEMORY (+ *LIO* 8) (OR COLOR 255))
  (MEMORY (+ *LIO* 9) 0)		  ;Draw code
  (REGISTER 7 *LIOS*)
  (REGISTER 1 0)
  (INTERRUPT 168) )

(DEFUN GRAPHICS-READ-DOT (X Y)
; returns the color of the point at (X,Y).
  (MEMORY *LIO* X T)
  (MEMORY (+ *LIO* 2) Y T)
  (REGISTER 7 *LIOS*)
  (REGISTER 1 0)
  (INTERRUPT 175)
  (REGISTER 0) )

(IF (MEMBER (CSMEMORY 855) '(9 10))	; If NEC PC-9801 or Fujitsu,
    (GRAPHICS-INIT) )			; initialize graphics mode.
