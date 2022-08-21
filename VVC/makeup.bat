@echo off
setlocal enabledelayedexpansion

set inPath=D:\matlab\source\1024\
set outPath=d:\matlab\vvc_dec\1024\
set makeupPath=d:\matlab\vvc_dec\makeup\1024\
if not exist %makeupPath% (mkdir %makeupPath%)
for %%i in (%inPath%*.*) do (
	if not exist %outPath%%%~ni.png (
	set old=%%i
	set mkub=%makeupPath%%%~ni.bin
	set mkuo=%makeupPath%%%~ni.yuv
	Encoderapp -i !old! -c encoder_intra_vtm.cfg -fr 1 -f 1 -wdt 1024 -hgt 1024 -b !mkub! -o !mkuo!)
)
pause