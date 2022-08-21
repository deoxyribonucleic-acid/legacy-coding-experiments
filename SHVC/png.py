from concurrent.futures import thread
import threading
import cv2 as cv
import numpy as np
yuv_in = 'D:/matlab'
#paths
#yuv_in = '/data1/wangcy/h265/yuvdec/'
#yuv_out = '/data1/wangcy/h265/yuv/'
logpath = './log_shvc/'
#png_path = '/data1/wangcy/h265/png/'
name='out'
width  = 1024
height = 1024
frames = 1875
fps = 1
maxlayers = 3
numchunks = 16
exitFlag = 0
f=open("D:/logtrans.txt","w+")

def generateCommand(lid,chunk,img):
    command = 'ffmpeg -f rawvideo -framerate ' + str(fps)
    command += ' -s ' + str(width) + 'x' + str(height)
    command += ' -pixel_format yuv420p'
    command += ' -i ' + yuv_in + 'L' + str(lid) + '/' + name + '_chunk_' + str(chunk) + '.yuv'
    #command += ' -c:v rawvideo -filter:v \"select=\'between(n\, ' + str(img) + '\, ' + str(img) + ')\'\" '
    command += ' -c copy -f segment -segment_time 0.01 '
    command += png_path + 'L' + str(lid) + '/' + str(img+1875*chunk) + '.png'
    #ffmpeg -f rawvideo -framerate 25 -s 1280x720 -pixel_format yuv420p -i in.yuv -c copy -f segment -segment_time 0.01 frames%d.yuv
    print(command)
#ffmpeg -s 1024x1024 -i /data1/wangcy/h265/yuvinput/out_full.yuv -c:v rawvideo -filter:v "select='between(n\, 5625\, 7499)'" /data1/wangcy/h265/yuvinput/out_chunk_3.yuv
    return command

class convert_chunk (threading.Thread):
    def __init__(self, threadID, name, counter,level,chunk):
        threading.Thread.__init__(self)
        self.threadID = threadID
        self.name = name
        self.counter = counter
        self.level = level
        self.chunk=chunk
    def run(self):
        print ("Starting " + self.name)
        for img in range(0,frames):
            command = generateCommand(self.level,self.chunk,img)
            #os.system(command)
            #inf = yuv_out + 'L' + str(lid) + '/' + str(img+1875*self.chunk) + '.yuv'
            #outf = png_path + 'L' + str(lid) + '/' + str(img+1875*self.chunk) + '.png'
            #png_conv(inf,outf)
            #print(inf)
            #print(outf)
            #print(command,file=f)

        print ("Exiting " + self.name)
 
def png_conv(inf,outf):
        path=inf
        binfile = open(path, 'rb')
        image_y = [[0] * width for i in range(height)]
        image_u = [[0] * width for i in range(height)]
        image_v = [[0] * width for i in range(height)]
        for r in range(height):
            for c in range(width):
                image_y[r][c] = binfile.read(1)[0]
            Image_Y = np.array(image_y)

        for r in range(int(height / 2)):
            for c in range(int(width / 2)):
                pixel = binfile.read(1)[0]
                image_u[2 * r + 0][2 * c + 0] = pixel
                image_u[2 * r + 1][2 * c + 0] = pixel
                image_u[2 * r + 0][2 * c + 1] = pixel
                image_u[2 * r + 1][2 * c + 1] = pixel
        Image_U = np.array(image_u)

        for r in range(int(height / 2)):
            for c in range(int(width / 2)):
                pixel = binfile.read(1)[0]
                image_v[2 * r + 0][2 * c + 0] = pixel
                image_v[2 * r + 0][2 * c + 1] = pixel
                image_v[2 * r + 1][2 * c + 0] = pixel
                image_v[2 * r + 1][2 * c + 1] = pixel
        Image_V = np.array(image_v)
        binfile.close()
        compose = np.array([Image_Y, Image_V, Image_U]).transpose([1, 2, 0]).astype(np.uint8)
        Image = cv.cvtColor(compose, cv.COLOR_YUV2RGB)
        cv.imwrite(outf, Image)
        print(outf)

threads = []
id = 0
for lid in range(0,maxlayers):
    for cid in range(0,numchunks):
        thread=convert_chunk(id,'L'+str(lid)+'chunk'+str(cid),id,lid,cid)
        id += 1
        threads.append(thread)
        thread.start()