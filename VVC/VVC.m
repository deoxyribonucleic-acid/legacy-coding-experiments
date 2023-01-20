clc;clear;
%global params
img_wid = 768; %长宽和数�?�集大�?
img_hei = 512;


%folders
work_dir='D:\matlab'; %主文件夹目录
img_dir = '\source\1024\'; %输入的jpg的目�?
yuv_dir = '\VVC\yuv\'; %jpg转yuv 输出目录
rec_dir = '\VVC\rec\'; %VVC压缩�?�的�?构图片(.yuv)的输出目�?
bit_dir = '\VVC\enc\'; %vvc压缩�?�的�?�?�?.bin）的输出目录
fmt_src = '.png'; %指定输入输出格�? �?�?�?
fmt_trans = '.yuv';
fmt_bitstream= '.bin';
fmt_reconst = '.yuv';

%params for ffmpeg
fmt='yuv420p';
ffmpegpath='D:\matlab\JPG2YUV\ffmpeg.exe'; %ffmpeg的路�?

%params for VVC encode
vvcpath='D:\matlab\VVC\EncoderApp.exe'; %vvc编解�?器的路�?
decpath='D:\matlab\VVC\DecoderApp.exe';
cfg_dir ='D:\matlab\VVC\encoder_intra_vtm.cfg'; %vvc�?置的路�?
qp='61'; %qp�? 这个�?改
imgs=dir(convertStringsToChars(strcat(work_dir,img_dir,'*.png')));
bpp=zeros(1,size(imgs,1));
%bpp_name=zeros(1,size(imgs,1));
parfor i=1:size(imgs,1) %parfor多线程循环，debug的时候改�?for
    %d拼接文件路�
    [a,img_ind,ext] = fileparts(imgs(i).name);
    imgpath = convertStringsToChars(strcat(work_dir,img_dir,img_ind,fmt_src));
    yuvpath = convertStringsToChars(strcat(work_dir,yuv_dir,img_ind,fmt_trans));
    reconstpath = convertStringsToChars(strcat(work_dir,rec_dir,img_ind,fmt_reconst));
    bitstreampath = convertStringsToChars(strcat(work_dir,bit_dir,img_ind,fmt_bitstream));
    
    %用ffmpeg把输入的jpg�?��?yuv
    if exist(yuvpath,'file')==0 && exist(bitstreampath,'file')==0
        disp(['converting ',imgpath])
        cmd1 = [ffmpegpath,' -i ',imgpath,      ...
                           ' -pix_fmt ',fmt,    ...
                           ' ',yuvpath];
        system(cmd1);
    end
    %yuv进行压缩
    if exist(bitstreampath,'file')==0 || 1 %判断：无�?�?就用vvc编�?
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
    %有�?�?无�?构，就用解�?器解�?
    if exist(reconstpath,'file')==0
        cmd3 = [decpath,' -b ',bitstreampath,                               ...
                        ' -o ',reconstpath];
        system(cmd3);
    end
    %算bpp
    disp(['reading from ',bitstreampath])
    storage = dir(bitstreampath);
    bpp(i)= storage.bytes*8/img_wid/img_hei;
    disp(['bpp=',convertStringsToChars(string(bpp(i)))])
    bpp_name(i)=strcat(img_ind,ext," ",string(bpp(i)));
end
%plotting
id = 1:size(imgs,1);
scatter(id,bpp,2,'filled');
grid on
%average bpp calculation
disp(['average bpp ',convertStringsToChars(string(mean(bpp)))]) %这儿输出平�?�bpp（控制�?��?
disp(bpp_name)