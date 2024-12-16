@echo off
setlocal enableextensions
set TERM=
start %cd%\cygwin64\bin\mintty.exe --configdir=./cygwin64 /bin/bash -l %cd%/install.sh