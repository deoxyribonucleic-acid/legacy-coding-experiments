
@set DIR=*
@set ENC=H264AVCEncoderLibTestStatic.exe
@set DEC=H264AVCDecoderLibTestStatic.exe
@set RES=DownConvertStatic.exe
@set EXT=BitStreamExtractorStatic.exe
@set SNR=PSNRStatic.exe
@set CMP=YUVCompareStatic.exe
@set SFL=snrSVC.txt

::===== encode =====
@%ENC% –pf main.cfg
pause
::===== extract =====
@%EXT% test.264 str_D0_Q0.264 -l 0 -f 0 -keepf
@%EXT% test.264 str_D0_Q1.264 -l 0 -f 1 -keepf
@%EXT% test.264 str_D1_Q0.264 -l 1 -f 0 -keepf
@%EXT% test.264 str_D1_Q1.264 -l 1 -f 1 -keepf
@%EXT% test.264 str_D2_Q0.264 -l 2 -f 0 -keepf
@%EXT% test.264 str_D2_Q1.264 -l 2 -f 1 -keepf
@%EXT% test.264 str_D2_Q2.264 -l 2 -f 2 -keepf
pause
::===== decode =====
@%DEC% str_D0_Q0.264 dec_D0_Q0.yuv
@%DEC% str_D0_Q1.264 dec_D0_Q1.yuv
@%DEC% str_D1_Q0.264 dec_D1_Q0.yuv
@%DEC% str_D1_Q1.264 dec_D1_Q1.yuv
@%DEC% str_D2_Q0.264 dec_D2_Q0.yuv
@%DEC% str_D2_Q1.264 dec_D2_Q1.yuv
@%DEC% str_D2_Q2.264 dec_D2_Q2.yuv
pause
::===== get PSNR =====
@%SNR% 256 256 02.yuv dec_D0_Q0.yuv 0 0 str_D0_Q0.264 15 D0Q0 2>  %SFL%
@%SNR% 256 256 02.yuv dec_D0_Q1.yuv 0 0 str_D0_Q1.264 15 D0Q1 2>> %SFL%
@%SNR% 512 512 01.yuv dec_D1_Q0.yuv 0 0 str_D1_Q0.264 30 D1Q0 2>> %SFL%
@%SNR% 512 512 01.yuv dec_D1_Q1.yuv 0 0 str_D1_Q1.264 30 D1Q1 2>> %SFL%
@%SNR% 1024 1024 00.yuv dec_D2_Q0.yuv 0 0 str_D2_Q0.264 60 D2Q0 2>> %SFL%
@%SNR% 1024 1024 00.yuv dec_D2_Q1.yuv 0 0 str_D2_Q1.264 60 D2Q1 2>> %SFL%
@%SNR% 1024 1024 00.yuv dec_D2_Q2.yuv 0 0 str_D2_Q2.264 60 D2Q2 2>> %SFL%
pause
::===== check encoder/decoder match
@%CMP% 256 256 dec_D0_Q0.yuv enc_D0_Q0.yuv 1
@%CMP% 256 256 dec_D0_Q1.yuv enc_D0_Q1.yuv 1
@%CMP% 512 512 dec_D1_Q0.yuv enc_D1_Q0.yuv 1
@%CMP% 512 512 dec_D1_Q1.yuv enc_D1_Q1.yuv 1
@%CMP% 1024 1024 dec_D2_Q0.yuv enc_D2_Q0.yuv 1
@%CMP% 1024 1024 dec_D2_Q2.yuv enc_D2_Q2.yuv 1
pause
::===== output PSNR file =====
@type %SFL%
