@echo off
setlocal enabledelayedexpansion

set inPath=d:\matlab\result\vvc_out\rec256\
set outPath=d:\matlab\vvc_dec\256\
if not exist %outPath% (mkdir %outPath%)
for %%i in (%inPath%*.*) do (set old=%%i
	set out=%outPath%%%~ni.png
	if not exist %outPath%%%~ni.png (ffmpeg -s 256x256 -i !old! !out!)
)
pause