
;;;		* * *	A muLISP CLOS Based Window System   * * *

;;; This file illustrates how to use the muLISP CLOS Package to implement
;;; a simple windowing system.	The code is not necessarily meant to be
;;; highly efficient or elegant.  This file should be loaded from the
;;; muLISP Command Line.  Results are unpredictable when loaded on top
;;; of an existing window system, such as the EDITOR or DEBUGGER.

(setq *all-windows*)

;; This is the basic window class
(defclass window ()
   ((top :initarg :top :reader top)		; top of the window in rows
    (left :initarg :left :reader left)		; left edge in columns
    (height :initarg :height :reader height)	; height in columns
    (width :initarg :width :reader width)	; width in rows
    (current-row :initform 0 :accessor current-row) ; cursor position [row]
    (current-col :initform 0 :accessor current-col) ; cursor position [col]
    (exposedp :initform () :accessor exposedp) ; window exposed? [visible]
    (border :initform 1 :reader border)        ; border width
    (border-color :initform 7 :reader border-color) ; border color
    (foreground :initform 15 :reader foreground)    ; window foreground color
    (background :initform 0 :reader background)     ; window background color
    (old-coordinates :accessor oldc)	;storage for previous coordinates
    (old-row-column  :accessor oldrc))) ;storage for previous row/column

;; After a window is created, add its name to the list of windows
(defmethod initialize-instance :after ((w window)) (push w *all-windows*))

;; To expose a window make a window with the edges of the window object and
;; set the cursor position to the proper row and column if the window is
;; already exposed, otherwise refresh the window.
(defgeneric expose (window))
(defmethod expose ((w window))
  ((exposedp w)
   (make-window (+ (top w) (border w))
	       (+ (left w) (border w))
	       (- (height w) (* 2 (border w)))
	       (- (width w) (* 2 (border w))))
   (set-cursor (current-row w) (current-col w)))
  (refresh w))

;; This method makes a window of the proper color with a clear screen and
;; sets the exposedp variable to true.
(defgeneric refresh (window))
(defmethod refresh ((w window))
  (background-color (border-color w))
  (foreground-color 0)
  (make-window (top w) (left w) (height w) (width w))
  (clear-screen)
  (background-color (background w))
  (foreground-color (foreground w))
  (make-window (+ (top w) (border w))
	       (+ (left w) (border w))
	       (- (height w) (* 2 (border w)))
	       (- (width w) (* 2 (border w))))
  (clear-screen)
  (setf-current-row 0 w)
  (setf-current-col 0 w)
  (setf-exposedp 't w))

;; After a window is sent a refresh message check all other windows and if
;; they are covered by the new window then deexpose them.
(defmethod refresh :after ((w window))
   (let ((windows (remove w *all-windows*)))
     (loop
       ((null windows))
       ( ((no-overlap (top w) (left w) (height w) (width w) (car windows))
	  (pop windows))
	 (setf-exposedp nil (pop windows))))))

;; Before you can print to a window it must be exposed
;; Store coordinates, row and column of previous window
(defgeneric print-to-window (window str row column))
(defmethod print-to-window :before ((w window) str row column)
  (setf-oldc (make-window) w)
  (setf-oldrc (list (row) (column)) w)
  (expose w))

;; Before you can princ to a window it must be exposed
;; Store coordinates, row and column of previous window
(defgeneric princ-to-window (window str row column))
(defmethod princ-to-window :before ((w window) str row column)
  (setf-oldc (make-window) w)
  (setf-oldrc (list (row) (column)) w)
  (expose w))

;; Print the str to the row and column of the window
(defmethod print-to-window ((w window) str row column)
  (if (and (integerp row) (integerp column))
      (set-cursor row column))
  (print str)
  (setf-current-row (row) w)   ;reset row and column
  (setf-current-col (column) w)
  t)

;; Same as print-to-window
(defmethod princ-to-window ((w window) str row column)
  (if (and (integerp row) (integerp column))
      (set-cursor row column))
  (princ str)
  (setf-current-row (row) w) ;reset row and column
  (setf-current-col (column) w)
  t)

;; Now we want to return to the current window after we have
;; printed to another window, so we reset the dimensions and
;; cursor position to that which we saved before printing.
(defmethod print-to-window :after ((w window) str row column)
  (apply 'make-window (oldc w))
  (apply 'set-cursor (oldrc w)))

;; Same as above
(defmethod princ-to-window :after ((w window) str row column)
  (apply 'make-window (oldc w))
  (apply 'set-cursor (oldrc w)))

;; Does a window overlap the box formed by top1 left1 height1 width1?
(defun no-overlap (top1 left1 height1 width1 window2)
  ((lambda (top2 left2 height2 width2	 bottom1 bottom2 right1 right2)
	   (setq bottom1 (+ top1 height1) bottom2 (+ top2 height2)
		 right1 (+ left1 width1) right2 (+ left2 width2))
	   ((or (<= top1 top2 bottom1)
		(<= top1 bottom2 bottom1)
		(<= top2 bottom1 bottom2))
	    ((or (<= left1 left2 right1)
		 (<= left1 right2 right1)
		 (<= left2 right1 right2)) nil))
	   't)
  (top window2)
  (left window2)
  (height window2)
  (width window2)))

;---------------------------------------------------------------------------
; Make instances of the WINDOW flavor
(setq small (make-instance 'window
			   :top 2
			   :left 10
			   :height 8
			   :width 60))

(setq tiny (make-instance 'window
			   :top 3
			   :left 30
			   :height 8
			   :width 20
			   :border 2))

(setq main (make-instance 'window
			  :top 12
			  :left 0
			  :height 12
			  :width 80))


(expose main)		  ; Expose the window MAIN

(write-line
   "Try the command (PRINT-TO-WINDOW SMALL 'HELLO 2 2).")

;;; Other examples to try

;(princ-to-window tiny "goodbye" 1 3)
;(refresh small)
;(expose tiny)
;(refresh main)
