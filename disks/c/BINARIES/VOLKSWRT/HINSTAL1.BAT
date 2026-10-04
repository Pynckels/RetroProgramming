ECHO OFF
IF %1. == . GOTO BAD
:INSERT1
IF EXIST VW3.EXE GOTO PR1OK
ECHO ú
ECHO Remove the Volkswriter INSTALLATION diskette and replace it
ECHO with the PROGRAM 1 Diskette.
PAUSE
GOTO INSERT1
:PR1OK
ECHO Copying the VW 3 program file
COPY VW3.* %1
ECHO ú
ECHO Remove the Volkswriter PROGRAM 1 diskette and replace it with the
ECHO Volkswriter PROGRAM 2 diskette.
:INSERT2
PAUSE
IF NOT EXIST VW3.MES GOTO NOT2
ECHO Copying files from the PROGRAM 2 diskette . . .
COPY VW3.O*  %1 /V
COPY VW3.?E? %1 /V
ECHO 	Dictionary files. . .
COPY VW3.A*  %1 /V
ECHO 	Auxiliary files. . .
COPY *.TBL %1 /V
COPY VWSTYLE.??? %1
COPY PRINTIN?  %1 /V
COPY KEYBD*.* %1 /V
rem ECHO 	TopView compatibility files.
rem COPY *.PIF %1 /V
ECHO ú
ECHO Remove the PROGRAM 2 diskette and replace it with
ECHO the TUTORIALS & UTILITIES diskette.
ECHO ú
PAUSE
:INSERT3
IF NOT EXIST TUTOR1 GOTO NOT3
ECHO ú
ECHO Copying files from the TUTORIALS & UTILITIES diskette. . .
COPY *.* %1
ECHO ú
ECHO Remove the TUTORIALS & UTILITIES diskette and replace it
ECHO with the INSTALLATION diskette
PAUSE
:INSERT4
IF NOT EXIST CONFIGUR.EXE GOTO NOT4
ECHO ú
COPY HDVW3.SYS %1VW3.SYS
ECHO Copying CONFIGUR.EXE, the Configuration program. . .
COPY CONFIGUR.EXE %1
%1
ECHO Loading "CONFIGUR", the Volkswriter 3 configuration program
CONFIGUR C %1
ECHO ú
ECHO   For best program performance, you should have a "CONFIG.SYS" file
ECHO   that contains the line "BUFFERS=n", where "n" is a number 8 or greater,
ECHO   and the line "FILES=n" where "n" is a number 15 or greater.
ECHO ú
ECHO   (For further details on performance check Appendix A of
ECHO   the Volkswriter 3 manual.)
ECHO ú
ECHO  You have now completed installation.
ECHO ú
ECHO  To start Volkswriter 3 type VW3 and press Enter.
ECHO ú
ECHO  To use Volkswriter's on-screen tutorials, enter VW3 TUTOR1.
ECHO ú
ECHO            SEE CHAPTER 1 IN THE VOLKSWRITER 3 MANUAL.
ECHO ú
GOTO EXIT
:NOT2
ECHO ú
ECHO That is not the correct diskette.
ECHO ú
ECHO Please insert the Volkswriter PROGRAM 2 disk.
ECHO    (Enter Ctrl C to quit without installing.)
ECHO ú
GOTO INSERT2
:NOT3
ECHO ú
ECHO That is not the correct diskette.
ECHO ú
ECHO Please insert the Volkswriter TUTORIALS/UTILITIES diskette.
ECHO (Enter Ctrl C to quit without installing.)
PAUSE
GOTO INSERT3
:NOT4
ECHO ú
ECHO That is not the correct diskette.
ECHO ú
ECHO Please insert the Volkswriter INSTALLATION diskette.
ECHO (Enter Ctrl C to quit without installing.)
PAUSE
GOTO INSERT4
:BAD
ECHO ú
ECHO To install Volkswriter 3 on a hard disk, insert the Volkswriter 3
ECHO PROGRAM 1 diskette in the floppy drive and enter HINSTALL.
ECHO Refer to the installation instructions for further details.
ECHO ú
:EXIT
