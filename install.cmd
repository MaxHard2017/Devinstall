@echo off
setlocal enableextensions
set TERM=
set HOME=%cd%\hm2
echo home -%HOME%
pause
start .\cygwin64\bin\mintty.exe --configdir=./cygwin64 /bin/bash -l ./../install.sh