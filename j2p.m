clear;clc;
data_size = 1;
work_dir='D:\matlab';
img_dir = '\source\1024\';
dest_dir = '\target_bpp\1024\jp2\enc\';
dec_dir = '\target_bpp\1024\jp2\dec\';
fmt_src = '.jpg';
fmt_dest= '.jp2';
fmt_dec = '.png';
img_wid = 1024;
img_hei = 1024;
cr = 1150;
bpp=zeros(1,data_size);
parfor i=1:data_size
    
    img_ind = string(i-1);
    imgdir = convertStringsToChars(strcat(work_dir,img_dir,img_ind,fmt_src));
    destdir = convertStringsToChars(strcat(work_dir,dest_dir,img_ind,fmt_dest));
    decdir = convertStringsToChars(strcat(work_dir,dec_dir,img_ind,fmt_dec));
    disp(['reading from ',imgdir])
    img= imread(imgdir);
   
    disp(['writing into ',destdir])
    imwrite(img,destdir,'CompressionRatio',cr);
   
    disp(['calculating ',destdir])
    jpeg= imread(destdir);
    imwrite(jpeg,decdir);
    storage = dir(destdir);
    bpp(i) = storage.bytes*8/img_wid/img_hei;
    disp(['bpp=',convertStringsToChars(string(bpp(i)))])
end
id = 1:data_size;
scatter(id,bpp);
grid on

disp(['average bpp ',convertStringsToChars(string(mean(bpp)))])