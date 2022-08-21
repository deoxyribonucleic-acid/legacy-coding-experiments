@echo off
setlocal enabledelayedexpansion

set inPath=d:\matlab\result\BPG_QP41\out512\
set outPath=d:\matlab\bpg_dec\QP41\512\
if not exist %outPath% (mkdir %outPath%)
for %%i in (%inPath%*.*) do (set old=%%i
	set out=%outPath%%%~ni.png
	bpgdec -i !old!
	bpgdec -o !out! !old!
)