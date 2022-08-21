clc;clear;
%global params
img_wid = 1024; %长宽和数据集大小
img_hei = 1024;
data_size = 1875;
bpp=zeros(1,data_size);

%folders
work_dir='D:\matlab'; %主文件夹目录
img_dir = '\source\1024\'; %输入的jpg的目录
yuv_dir = '\recheck\VVC\yuv\'; %jpg转yuv 输出目录
rec_dir = '\recheck\VVC\dec\'; %VVC压缩后的重构图片(.yuv)的输出目录
bit_dir = '\recheck\VVC\enc\'; %vvc压缩后的码流（.bin）的输出目录
fmt_src = '.jpg'; %指定输入输出格式 不要动
fmt_trans = '.yuv';
fmt_bitstream= '.bin';
fmt_reconst = '.yuv';

%params for ffmpeg
fmt='yuv420p';
ffmpegpath='D:\matlab\JPG2YUV\ffmpeg.exe'; %ffmpeg的路径

%params for VVC encode
vvcpath='D:\matlab\VVC\EncoderApp.exe'; %vvc编解码器的路径
decpath='D:\matlab\VVC\DecoderApp.exe';
cfg_dir ='D:\matlab\VVC\encoder_intra_vtm.cfg'; %vvc配置的路径
qp='63'; %qp值 这个要改

parfor i=1:data_size %parfor多线程循环，debug的时候改成for
    %d拼接文件路径
    img_ind = string(i-1);
    imgpath = convertStringsToChars(strcat(work_dir,img_dir,img_ind,fmt_src));
    yuvpath = convertStringsToChars(strcat(work_dir,yuv_dir,img_ind,fmt_trans));
    reconstpath = convertStringsToChars(strcat(work_dir,rec_dir,img_ind,fmt_reconst));
    bitstreampath = convertStringsToChars(strcat(work_dir,bit_dir,img_ind,fmt_bitstream));
    
    %用ffmpeg把输入的jpg换成yuv
    if exist(yuvpath,'file')==0 && exist(bitstreampath,'file')==0
        disp(['converting ',imgpath])
        cmd1 = [ffmpegpath,' -i ',imgpath,      ...
                           ' -pix_fmt ',fmt,    ...
                           ' ',yuvpath];
        system(cmd1);
    end
    %yuv进行压缩
    if exist(bitstreampath,'file')==0 %判断：无码流就用vvc编码
        cmd2 = [vvcpath,' -i ',yuvpath,                                     ...
                        ' -c ' ,cfg_dir,                                    ...
                        ' -fr ','1',                                        ...
                        ' -f ','1',                                         ...
                        ' -q ',qp,                                          ...
                        ' -wdt ',convertStringsToChars(string(img_wid)),    ...
                        ' -hgt ',convertStringsToChars(string(img_hei)),    ...
                        ' -b ',bitstreampath,                               ...
                        ' -o ',reconstpath]
        system(cmd2);
    end
    %有码流无重构，就用解码器解码
    if exist(reconstpath,'file')==0
        cmd3 = [decpath,' -b ',bitstreampath,                               ...
                        ' -o ',reconstpath];
        system(cmd3);
    end
    %算bpp
    disp(['reading from ',bitstreampath])
    storage = dir(bitstreampath);
    bpp(i) = storage.bytes*8/img_wid/img_hei;
    disp(['bpp=',convertStringsToChars(string(bpp(i)))])
end
%plotting
id = 1:data_size;
scatter(id,bpp,2,'filled');
grid on
%average bpp calculation
disp(['average bpp ',convertStringsToChars(string(mean(bpp)))]) %这儿输出平均bpp（控制台）