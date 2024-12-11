rem adding path to binaries, PATH will be transferred to mintty
rem set PATH=%PATH%;%~d0\VSCinstall\cygwin64\bin
set PATH=%PATH%;%~dp\cygwin64\bin

start bin\mintty.exe --configdir=. /bin/dash