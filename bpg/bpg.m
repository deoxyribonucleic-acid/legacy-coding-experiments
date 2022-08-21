clc;
ExeFileName='.\bpg\bpgenc.exe';
disp(ExeFileName)
clear;clc;
data_size = 1875;
work_dir='D:\matlab';
img_dir = '\source\1024\';
dest_dir = '\recheck\BPG\enc\';
dec_dir = '\recheck\BPG\dec\';
fmt_src = '.jpg';
fmt_dest= '.bpg';
fmt_dec = '.png';
img_wid = 1024;
img_hei = 1024;
bpp=zeros(1,data_size);
qp='63';
parfor i=1:data_size
    img_ind = string(i-1);
    imgdir = convertStringsToChars(strcat(work_dir,img_dir,img_ind,fmt_src));
    destdir = convertStringsToChars(strcat(work_dir,dest_dir,img_ind,fmt_dest));
    decdir = convertStringsToChars(strcat(work_dir,dec_dir,img_ind,fmt_dec));
    disp(['writing into ',destdir])
    dest=[' ','-o',' ',destdir];
    src=[' ',imgdir];
    quality=[' ','-q',' ',qp];
    Cmd=['.\bpg\bpgenc.exe' , quality , dest, src];
    system(Cmd);
    
    disp(['reading from ',imgdir])
    dec=[' ','-o',' ',decdir,' '];
    Cmd1=['.\bpg\bpgdec.exe',dec, destdir];
    disp(Cmd1)
    system(Cmd1);
    storage = dir(destdir);
    bpp(i) = storage.bytes*8/img_wid/img_hei;
    disp(['bpp=',convertStringsToChars(string(bpp(i)))])
end
id = 1:data_size;
scatter(id,bpp);
grid on

disp(['average bpp ',convertStringsToChars(string(mean(bpp)))])