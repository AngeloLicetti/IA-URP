ECHO OFF
:MENU
CLS
ECHO EXAMPLE.BAT is an example of the use
ECHO of the RAMCRAM batch file utility:
ECHO 
	 Program Selection Menu
ECHO 
      1 - Run muLISP-90 program
ECHO 
      2 - Display file directory
RAMCRAM C
IF ERRORLEVEL 33 GOTO IS80COL
IF ERRORLEVEL 32 GOTO IS40COL
IF ERRORLEVEL 20 GOTO IS80COL
IF ERRORLEVEL 19 GOTO IS40COL
IF ERRORLEVEL 14 GOTO IS80COL
IF ERRORLEVEL 13 GOTO IS40COL
IF ERRORLEVEL  6 GOTO IS80COL
IF ERRORLEVEL  4 GOTO IS40COL
IF ERRORLEVEL  2 GOTO IS80COL
:IS40COL
ECHO 
      3 - Switch to 80 column mode
GOTO MOREMENU
:IS80COL
ECHO 
      3 - Switch to 40 column mode
:MOREMENU
ECHO 
      4 - Quit and return to MS-DOS

RAMCRAM D
RAMCRAM 4
IF ERRORLEVEL 4 GOTO GOMSDOS
IF ERRORLEVEL 3 GOTO CHGMODE
IF ERRORLEVEL 2 GOTO DISPDIR
MULISP
GOTO MENU
:DISPDIR
DIR
PAUSE
GOTO MENU
:CHGMODE
RAMCRAM C
IF ERRORLEVEL 33 GOTO TOMODE1
IF ERRORLEVEL 32 GOTO TOMODE7
IF ERRORLEVEL 20 GOTO TOMODE1
IF ERRORLEVEL 19 GOTO TOMODE3
IF ERRORLEVEL 14 GOTO TOMODE1
IF ERRORLEVEL 13 GOTO TOMODE3
IF ERRORLEVEL  8 GOTO TOMODE1
IF ERRORLEVEL  7 GOTO TOMODE32
IF ERRORLEVEL  6 GOTO TOMODE1
IF ERRORLEVEL  4 GOTO TOMODE3
IF ERRORLEVEL  2 GOTO TOMODE1
:TOMODE3
RAMCRAM C 3
GOTO MENU
:TOMODE1
RAMCRAM C 1
GOTO MENU
:TOMODE7
RAMCRAM C 7
GOTO MENU
:TOMODE32
RAMCRAM C 20
GOTO MENU
:GOMSDOS
CLS
