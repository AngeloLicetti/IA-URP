;File:	ANIMAL.LSP  (C) 	    09/10/91		Soft Warehouse, Inc.


;		* * *	The Animal Guessing Game   * * *

(DEFUN ANIMAL (
    *ANIMAL-NET* *NET-DIRTY*)
  (ANIMAL-DISPLAY)
  (TERPRI 2)
  (SETQ *ANIMAL-NET* *INITIAL-ANIMAL-NET*)
  ( ((PROBE-FILE "ANIMAL.MEM")
      (WRITE-SENTENCE "Would you like to refresh my memory about animals ")
      ((Y-OR-N "from the pre-built animal data file?")
	(ANIMAL-NET-LOAD)
	(TERPRI) )
      (TERPRI) ) )
  (LOOP
    (ANIMAL-PLAY)
    ((NOT (Y-OR-N "Would you like to play another round?")))
    (CLEAR-SCREEN) )
  (TERPRI)
  ( ((NOT *NET-DIRTY*))
    (WRITE-SENTENCE "Do you want to save all the animals you have taught ")
    ((Y-OR-N "me so I will remember them next time we play?")
      (ANIMAL-NET-SAVE)
      (TERPRI) )
    (TERPRI) )
  (WRITE-SENTENCE "I hope you enjoyed playing the Animal Game.	")
  (WRITE-SENTENCE "Let's do it again some time!")
  (TERPRI 2) )

(DEFUN ANIMAL-PLAY (
    NET NEW-NET ANIMAL ANSWERS QUESTION)
  (SETQ NET *ANIMAL-NET*)
  (WRITE-SENTENCE "Think of an animal and I will try to guess what it ")
  (WRITE-SENTENCE "is by asking you some simple yes-or-no questions.")
  (TERPRI 2)
  (WRITE-SENTENCE "Press any key when you are ready to start the game... ")
  (CLEAR-INPUT)
  (READ-BYTE)
  (TERPRI 2)
  (LOOP
    ((ATOM (CDR NET))
      ((Y-OR-N (PACK* "I bet it's " (@ (CAR NET)) "?"))
	(TERPRI)
	(WRITE-SENTENCE "Hurray, I got it!  Thanks for the game.")
	(TERPRI 2) )
      (TERPRI)
      (WRITE-SENTENCE "I give up.  What animal were you thinking of?  ")
      (SETQ ANIMAL (STRING-UPCASE (STRING-TRIM " " (READ-LINE))))
      (TERPRI)
      ((EQ ANIMAL (CAR NET))
	(WRITE-SENTENCE "Stop fooling around!  ")
	(WRITE-SENTENCE "That is the animal I just guessed.")
	(TERPRI 2) )
      (SETQ NEW-NET (ALREADY-EXISTS ANIMAL (REVERSE ANSWERS) *ANIMAL-NET*))
      ( ((NOT NEW-NET))
	(WRITE-SENTENCE
		"I think you may have incorrectly answered the question")
	(TERPRI)
	(CENTER (PACK* '\" (CAR NEW-NET) "?\""))
	(TERPRI)
	((Y-OR-N "Are you sure you answered this question correctly?")
	  (REMOVE-ANIMAL ANIMAL *ANIMAL-NET*)
	  (WRITE-SENTENCE
		"OK, I fixed my memory so I won't make that mistake again.")
	  (TERPRI 2) )
	(TERPRI 2)
	(RETURN) )
      (WRITE-SENTENCE "Please enter a question that I can ask for which ")
      (WRITE-SENTENCE "a YES answer indicates ")
      (WRITE-SENTENCE (PACK* (@ ANIMAL) " rather than " (@ (CAR NET)) "? "))
      (SETQ QUESTION (STRING-DOWNCASE (STRING-TRIM " " (READ-LINE)))
	    QUESTION (STRING-RIGHT-TRIM "?.! " QUESTION)
	    QUESTION (PACK* (CHAR-UPCASE (CHAR QUESTION 0))
			    (SUBSTRING QUESTION 1)))
      (TERPRI)
      (DISPLACE NET (LIST QUESTION (LIST (CAR NET)) (LIST ANIMAL)))
      (WRITE-SENTENCE "Thanks for telling me that.  ")
      (WRITE-SENTENCE "I'll be sure to remember it.")
      (TERPRI 2)
      (SETQ *NET-DIRTY* T) )
    (PUSH (Y-OR-N (PACK* (CAR NET) '\?)) ANSWERS)
    (TERPRI)
    (SETQ NET (IF (CAR ANSWERS) (CADDR NET) (CADR NET))) ) )

(DEFUN ALREADY-EXISTS (ANIMAL ANSWERS NET)
  ((ATOM (CDR NET)) NIL)
  ((CAR ANSWERS)
    ((MEMBER-NET ANIMAL (CADR NET)) NET)
    (ALREADY-EXISTS ANIMAL (CDR ANSWERS) (CADDR NET)) )
  ((MEMBER-NET ANIMAL (CADDR NET)) NET)
  (ALREADY-EXISTS ANIMAL (CDR ANSWERS) (CADR NET)) )

(DEFUN REMOVE-ANIMAL (ANIMAL NET)
  ((MEMBER-NET ANIMAL (CADR NET))
    (SETQ SUB-NET (CADR NET))
    ((EQ ANIMAL (CAR (CADR SUB-NET)))
      (RPLACA (CDR NET) (CADDR SUB-NET)) )
    ((EQ ANIMAL (CAR (CADDR SUB-NET)))
      (RPLACA (CDR NET) (CADR SUB-NET)) )
    (REMOVE-ANIMAL ANIMAL (CADR NET)) )
  (SETQ SUB-NET (CADDR NET))
  ((EQ ANIMAL (CAR (CADR SUB-NET)))
    (RPLACA (CDDR NET) (CADDR SUB-NET)) )
  ((EQ ANIMAL (CAR (CADDR SUB-NET)))
    (RPLACA (CDDR NET) (CADR SUB-NET)) )
  (REMOVE-ANIMAL ANIMAL (CADDR NET)) )

(DEFUN MEMBER-NET (ANIMAL NET)
  (LOOP
    ((ATOM (CDR NET))
      (EQ (CAR NET) ANIMAL) )
    ((MEMBER-NET ANIMAL (CADR NET)))
    (SETQ NET (CADDR NET)) ) )

(DEFUN ANIMAL-NET-LOAD ()
  ((OPEN-INPUT-FILE "ANIMAL.MEM")
    (UNWIND-PROTECT
      (SETQ *ANIMAL-NET* (ANIMAL-NET-FIXUP (READ)))
      (CLOSE-INPUT-FILE) ) ) )

(DEFUN ANIMAL-NET-FIXUP (NET)
  ((ATOM NET)
    (LIST NET) )
  (LIST (CAR NET)
	(ANIMAL-NET-FIXUP (CADR NET))
	(ANIMAL-NET-FIXUP (CADDR NET))) )

(DEFUN ANIMAL-NET-SAVE ()
  ((OPEN-OUTPUT-FILE "ANIMAL.MEM")
    (UNWIND-PROTECT
      (PROGN
	(ANIMAL-NET-WRITE *ANIMAL-NET* 0)
	(TERPRI) )
      (CLOSE-OUTPUT-FILE) )
    (SETQ *NET-DIRTY*) ) )

(DEFUN ANIMAL-NET-WRITE (NET TAB)
  (SPACES TAB)
  ((ATOM (CDR NET))
    (PRIN1 (CAR NET)) )
  (PRINC '\()
  (PRINT (CAR NET))
  (ANIMAL-NET-WRITE (CADR NET) (+ TAB 2))
  (TERPRI)
  (ANIMAL-NET-WRITE (CADDR NET) (+ TAB 2))
  (PRINC '\)) )

(SETQ *INITIAL-ANIMAL-NET*
 '("Does it have a backbone"
    ("Can it fly"
	(WORM)
	(MOSQUITO))
    ("Is it a warm blooded animal"
	("Does it have gills and live all its life in water"
	    ("Does it start life with gills and then become an air breather"
		("Does it have legs"
		    (SNAKE)
		    (CROCODILE))
		(FROG))
	    ("TUNA FISH"))
	("Does it nurse its young with milk"
	    ("Can it fly"
		(CHICKEN)
		(ROBIN))
	    ("Does it live in water"
		("Is it a commonly domesticated animal"
		    (TIGER)
		    (DOG))
		(DOLPHIN)) ))) )

(DEFUN DISPLACE (LST1 LST2)
  (RPLACA LST1 (CAR LST2))
  (RPLACD LST1 (CDR LST2)) )

(DEFUN ANIMAL-DISPLAY ()
  (CLEAR-SCREEN)
  (CENTER "The Animal Guessing Game")
  (TERPRI 2)
  (WRITE-SENTENCE "This word game builds and uses a discrimination net ")
  (WRITE-SENTENCE "to logically determine which animal the player is ")
  (WRITE-SENTENCE "thinking of by asking a series of yes-or-no questions.") )

(DEFUN @ (NOUN)
  ((FINDSTRING (CHAR NOUN 0) "AEIOUaeiou")
    (PACK* "an " NOUN) )
  (PACK* "a " NOUN) )

(DEFUN CENTER (MSG)
  (SET-CURSOR (ROW) (TRUNCATE (- (COLUMNS) (LENGTH MSG)) 2))
  (WRITE-SENTENCE MSG) )

(DEFUN Y-OR-N (MSG
    CHAR)
  ( ((NULL MSG))
    (WRITE-SENTENCE (PACK* MSG " (Y/N) ") T) )
  (CLEAR-INPUT T)
  (LOOP
    (SETQ CHAR (CHAR-UPCASE (ASCII (READ-BYTE T))))
    ((EQ CHAR 'Y) (WRITE-LINE CHAR T) T)
    ((EQ CHAR 'N) (WRITE-LINE CHAR T) NIL)
    (WRITE-BYTE 7 NIL T) ) )

(DEFUN WRITE-SENTENCE (SENTENCE
    INDEX *AUTO-NEWLINE*)
  (LOOP
    ((EQ SENTENCE ""))
    (SETQ INDEX (- (COLUMNS) (COLUMN)))
    ((NULL (CHAR SENTENCE INDEX))
      (WRITE-STRING SENTENCE) )
    (LOOP
      ((EQ (CHAR SENTENCE INDEX) " ")
	(WRITE-LINE (SUBSTRING SENTENCE 0 (SUB1 INDEX)))
	(SETQ SENTENCE (STRING-LEFT-TRIM " " (SUBSTRING SENTENCE INDEX))) )
      ((ZEROP INDEX)
	((ZEROP (COLUMN))
	  (WRITE-LINE (SUBSTRING SENTENCE 0 (SUB1 (COLUMNS))))
	  (SETQ SENTENCE (STRING-LEFT-TRIM " " (SUBSTRING SENTENCE (COLUMNS)))) )
	(TERPRI) )
      (DECQ INDEX) ) ) )

(PROGN ((GETD 'WINDOWS T))
       (CLOSE-INPUT-FILE (FIND "ANIMAL.LSP" (INPUT-FILES) 'FINDSTRING))
       (ANIMAL) )

(SETQ *INIT-WINDOW* "Animal")
(SETQ *WINDOW-TYPES* (SORT (ADJOIN "Animal" *WINDOW-TYPES*) 'STRING<))
(SETQ DRIVER 'WINDOWS)

(DEFUN "Animal" (COMMAND
    *ANIMAL-NET* *NET-DIRTY*)
  ((EQ COMMAND 'CREATE-WINDOW)
    (LIST "Animal" (COPY-TREE *INITIAL-ANIMAL-NET*) NIL) )
  ((EQ COMMAND 'CLOSE-WINDOW))
  ((EQ COMMAND 'UPDATE-WINDOW)
    (CURRENT-WINDOW)
    (ANIMAL-DISPLAY) )
  (ANIMAL-STATUS)
  (UNWIND-PROTECT
    (LOOP
      (EXECUTE-OPTION 'COMMAND *ANIMAL-OPTIONS*) )
    (UPDATE-STATE '(*ANIMAL-NET* *NET-DIRTY*)) ) )

(SETQ *ANIMAL-OPTIONS* '(
	("Go" . ANIMAL-RUN)
	("Options" . (
		("Color" . (
			("Menu" . SET-MENU-COLOR)
			("Work" . SET-WORK-COLOR) ))
		("Display" . SET-DISPLAY)
		("Execute" . GO-DOS) ))
	("Quit" . QUIT-PROGRAM)
	("Transfer" . (
		("Load" . ANIMAL-NET-LOAD)
		("Save" . ANIMAL-NET-SAVE) ))
	("Window" . CHANGE-WINDOW) ))

(DEFUN ANIMAL-RUN ()
  (PROMPT-WINDOW)
  (CLEAR-SCREEN)
  (SETQ *PROMPT*)
  (CURRENT-WINDOW T)
  (CURSOR-ON)
  (CENTER "The Animal Guessing Game")
  (TERPRI 2)
  (ANIMAL-PLAY)
  (CLEAR-INPUT) )

(DEFUN ANIMAL-STATUS ()
  (CLEAR-STATUS "Animal")
  (WRITE-STRING "The Animal Guessing Game") )

(PROGN
  (TERPRI)
  (WRITE-SENTENCE "Press the ESC key and open an \"Animal\" window ")
  (WRITE-SENTENCE "to play the Animal Guessing Game.")
  (TERPRI) )
