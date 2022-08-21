for %%a in ("*.yuv") do Encoderapp -i "%%a" -c encoder_intra_vtm.cfg -fr 1 -f 1 -wdt 1024 -hgt 1024 -b %%~an.bin -o %%~an.yuv
pause