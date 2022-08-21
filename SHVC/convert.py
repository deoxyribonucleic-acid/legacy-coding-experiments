#ffmpeg -r 1 -i /data1/wangcy/CelebAMask-HQ/CelebA-HQ-img/%d.jpg -pix_fmt yuv420p -s 1024x1024 /data1/wangcy/h265/yuvinput/out.yuv
from distutils.cmd import Command
import os, glob
#paths
jpgpath='/data1/wangcy/CelebAMask-HQ/CelebA-HQ-img/'
yuvpath = '/data1/wangcy/h265/yuvinput/'
width  = '1024'
height = '1024'
f=open("D:/SHVC/log.txt","w+")
frames = 30000
chucks = 16
chuck_size=int(frames/chucks)
def convert():
    for chuck in range(0,chucks):
        for idx in range(0,chuck_size):
            idx += chuck*chuck_size
            #ffmpeg -r 1 -i /data1/wangcy/CelebAMask-HQ/CelebA-HQ-img/%d.jpg -pix_fmt yuv420p -s 1024x1024 /data1/wangcy/h265/yuvinput/out.yuv
            command = 'ffmpeg' + ' -r 1'
            command += ' -i ' + jpgpath + str(idx) + '.jpg'
            command += ' -pix_fmt yuv420p -s 1024x1024 '
            command += yuvpath + 'out_chuck_' + str(chuck) + '.yuv'
            #print(command,file=f,flush=True)
            #os.system(command)
        print(idx,file=f,flush=True)    
        print('-----------------------------------',file=f,flush=True)


if __name__ == '__main__':
    # col1               Layer1             layer2        ...
    # chunk1          (PSNR/Size)          (PSNR/Size)    ...
    # chunk2          (PSNR/Size)          (PSNR/Size)    ...
    # chunk3          (PSNR/Size)          (PSNR/Size)    ...
    #  ...                ...                ...          ...
    convert()
