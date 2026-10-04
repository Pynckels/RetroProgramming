@echo off

masm HELLOWRL;
if errorlevel 1 goto eof

link HELLOWRL;

:eof
