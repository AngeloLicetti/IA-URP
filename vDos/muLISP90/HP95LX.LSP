(DEFUN INITIALIZE-SERIAL-PORT (POWER BAUD)
; If POWER is NIL, turns HP 95LX serial port power OFF; if POWER is nonNIL,
; turns power ON and sets serial port baud rate to BAUD.  NOTE: Turning the
; power OFF when the serial port is not in use saves battery power.
  ((HP95LX-P)
    (REGISTER 0 (IF POWER 1 0) 74)
    (INTERRUPT 21)				; Turn power ON or OFF
    ((NOT POWER))
    (REGISTER 0 (+ 3 (* 32 (POSITION BAUD '(110 150 300 600 1200 2400 4800 9600)))))
    (REGISTER 3 0)
    (INTERRUPT 20) ) )				; Set baud rate

(DEFUN HP95LX-P ()
; Returns true if running on an HP 95LX, else NIL.
  ((= (CSMEMORY 855) 2) 		; IBM PC compatible computer?
    (REGISTER 0 19924)
    (REGISTER 1 0)
    (INTERRUPT 21)
    (= (REGISTER 1) 18512) ) )		; An HP 95LX, if BX = 'HP'.
