@echo off

cobol HELLOWRL;
if errorlevel 1 goto eof

link HELLOWRL;

:eof