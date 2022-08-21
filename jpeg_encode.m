clear;clc;
data_size = 30000;
work_dir='D:\matlab';
img_dir = '\256\';
dest_dir = '\out256\';
fmt_src = '.jpg';
fmt_dest= '.jpg';
img_wid = 256;
img_hei = 256;
qf = 1;
bpp=zeros(1,data_size);
parfor i=1:data_size
    
    img_ind = string(i-1);
    imgdir = convertStringsToChars(strcat(work_dir,img_dir,img_ind,fmt_src));
    destdir = convertStringsToChars(strcat(work_dir,dest_dir,img_ind,fmt_dest));
   
    disp(['reading from ',imgdir])
    img= imread(imgdir);
   
    disp(['writing into ',destdir])
    imwrite(img,destdir,'Quality',qf);
   
    disp(['calculating ',destdir])
    jpeg= imread(destdir);
   
    storage = dir(destdir);
    bpp(i) = storage.bytes*8/img_wid/img_hei;
    disp(['bpp=',convertStringsToChars(string(bpp(i)))])
end
id = 1:data_size;
scatter(id,bpp);
grid on

disp(['average bpp ',convertStringsToChars(string(mean(bpp)))])