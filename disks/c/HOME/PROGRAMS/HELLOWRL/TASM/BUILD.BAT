@echo off

tasm HELLOWRL
if errorlevel 1 goto eof

tlink HELLOWRL

:eof
