from concurrent.futures import thread
from genericpath import exists
from os import mkdir
import os
import shutil
import threading
import cv2 as cv
import numpy as np
yuv_in = 'D:/matlab'
#paths
yuv_in = '/data1/wangcy/h265/yuvdec/'
logpath = './log_shvc/'
yuv_out = '/data1/wangcy/h265/yuv'
png_path = '/data1/wangcy/h265/png/'
tmppath= '/data1/wangcy/h265/temp'
name='out'
width  = 1024
height = 1024
frames = 1875
maxlayers = 3
numchunks = 16
exitFlag = 0

def run_yuv(inf):
    #./ffmpeg -f rawvideo -framerate 1 -s 1024x1024 -pixel_format yuv420p -i 'D:\matlab\jsvm-master\bin64\1024.yuv' 
    # -c copy -f segment -segment_time 0.01 %d.yuv
    #if not exists(tmppath):
        #mkdir(tmppath)
    command = 'ffmpeg -y -f rawvideo -framerate 1 -s 1024x1024 -pixel_format yuv420p '
    command += ' -i ' + inf
    command += ' -c copy -f segment -segment_time 0.01 '
    command += tmppath + '%d.yuv'
    print(command)
    #os.system(command)

def clear(level,chunk):
    #f=os.listdir(tmppath)
    f=range(0,1875)
    n=0
    for i in f:
        #设置旧文件名（就是路径+文件名）
        oldname = tmppath+ os.sep + str(i)   # os.sep添加系统分隔符
        #设置新文件名
        newname = tmppath + os.sep +str(n+1875*chunk)+'.yuv'
        #os.rename(oldname,newname)   #用os模块中的rename方法对文件改名
        if i == 1874:
            print(oldname,'======>',newname)
        outfolder = yuv_out + os.sep + 'L' + str(lid) + os.sep
        outfile = outfolder +str(n+1875*chunk)+'.yuv'
        #shutil.move(newname,outfile)
        if i==1874:
            print(newname,'======>',outfile)
        n+=1
    
for lid in range(0,maxlayers):
    for cid in range(0,numchunks):
        inf = yuv_in + 'L' + str(lid) + os.sep + 'out_chunk_' + str(cid) + '.yuv'
        run_yuv(inf)
        clear(lid,cid)