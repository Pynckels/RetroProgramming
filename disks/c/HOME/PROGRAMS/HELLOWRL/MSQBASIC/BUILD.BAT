@echo off

bc HELLOWRL.BAS,HELLOWRL.OBJ;
if errorlevel 1 goto eof

link HELLOWRL.OBJ;

:eof