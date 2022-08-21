import os, glob
import threading,time
#paths
yuvname='out'
binpath = '/data1/wangcy/h265/bin_shvc/'
configpath = './cfg/'
encoderpath = './shvc/bin/'
logpath = './log_shvc/'
yuvpath = '/data1/wangcy/h265/yuvinput/'
width  = '1024'
height = '1024'
frames = '1875'
fps = '1'
maxlayers = 3
filelist = ['stefan.yuv'] #jsut a placeholder, ignore
#qp = ['21', '24', '27', '30', '33', '36']
qp = ['51', '46', '41']
exitFlag = 0
f=open("D:/log.txt","w+")
def generateConfig(chunk):
    filename = './cfg/' + chunk + '.cfg'
    fp =  open(filename, 'w')
    fp.write('FramesToBeEncoded     : {}    # Number of frames to be coded \n'.format(frames))
    fp.write('Level0          : 4.1         # Level of the whole bitstream \n')
    fp.write('Level1          : 3.1         # Level of the base layer \n')
    fp.write('Level2          : 4.1         # Level of the enhancement layer \n')
    fp.write('\n')
    fp.write('#======== File I/O =============== \n')
    for layers in range(maxlayers):
        #write section for each layers
        fp.write('InputFile{} : {} \n'.format(layers, yuvpath + chunk + '.yuv'))
        fp.write('FrameRate{} : {}   # Frame Rate per second \n'.format(layers, fps))
        fp.write('InputBitDepth{} : 8 # Input bitdepth for layer {} \n'.format(layers, layers))
        fp.write('SourceWidth{}  : {} # Input  frame width \n'.format(layers, width))
        fp.write('SourceHeight{} : {} # Input  frame height \n'.format(layers, height))
        fp.write('RepFormatIdx{} : 0 # Index of corresponding rep_format() in the VPS \n'.format(layers))
        fp.write('IntraPeriod{} : -1 # Period of I-Frame ( -1 = only first) \n'.format(layers))
        fp.write('ConformanceMode{} : 1 # conformance mode \n'.format(layers))
        fp.write('QP{}  : {} \n'.format(layers, qp[layers]))
        fp.write('LayerPTLIndex{}   : {} \n'.format(layers, layers + 1))
        fp.write('\n')
    fp.close()


def generateCommand(chunk):
    '''
    TAppEncoderStatic -c cfg/encoder_randomaccess_scalable.cfg -c cfg/per-sequence-svc/BasketballDrive-2x.cfg -c cfg/layers.cfg -q0 22 -q1 22 -b str/BasketballDrive.bin -o0 rec/BasketballDrive_l0_rec.yuv -o1 rec/BasketballDrive_l1_rec.yuv
    '''
    #only need to run for 5 layers
    command = encoderpath + 'TAppEncoder.exe'
    command += ' -c '+ configpath + 'encoder_randomaccess_scalable.cfg'
    command += ' -c ' + 'D:/SHVC/cfg/' + chunk + '.cfg '
    command += ' -c ' + configpath + 'threelayers.cfg '
    command += ' -q0 ' + qp[0] + ' -q1 ' + qp[1] + ' -q2 ' + qp[2]
    #command += ' -q3 ' + qp[3] + ' -q4 ' + qp[4]
    command += ' -b ' + binpath +  chunk + '.bin'
    command += ' | tee ' +  logpath + chunk + '.txt'
    return command

class SHVC (threading.Thread):
    def __init__(self, threadID, name, counter):
        threading.Thread.__init__(self)
        self.threadID = threadID
        self.name = name
        self.counter = counter
    def run(self):                   #把要执行的代码写到run函数里面 线程在创建后会直接运行run函数 
        print ("Starting " + self.name)
        #print_time(self.name, self.counter, 5)
        chunk=yuvname+'_chuck_'+str(self.threadID)
        print(chunk)
        generateConfig(chunk)
        # run SHVC encode on this chunk
        command = generateCommand(chunk)
        print(command,file=f)
        #os.system(command)
        print ("Exiting " + self.name)
 
def print_time(threadName, delay, counter):
    while counter:
        if exitFlag:
            (threading.Thread).exit()
        time.sleep(delay)
        print("%s: %s" % (threadName, time.ctime(time.time())))
        counter -= 1

thread0 = SHVC(0, "Thread-0", 0)
thread1 = SHVC(1, "Thread-1", 1)
thread2 = SHVC(2, "Thread-2", 2)
thread3 = SHVC(3, "Thread-3", 3)

thread4 = SHVC(4, "Thread-4", 4)
thread5 = SHVC(5, "Thread-5", 5)
thread6 = SHVC(6, "Thread-6", 6)
thread7 = SHVC(7, "Thread-7", 7)

thread8 = SHVC(8, "Thread-8", 8)
thread9 = SHVC(9, "Thread-9", 9)
thread10 = SHVC(10, "Thread-10", 10)
thread11 = SHVC(11, "Thread-11", 11)

thread12 = SHVC(12, "Thread-12", 12)
thread13 = SHVC(13, "Thread-13", 13)
thread14 = SHVC(14, "Thread-14", 14)
thread15 = SHVC(15, "Thread-15", 15)

thread0.start()
thread1.start()
thread2.start()
thread3.start()

thread4.start()
thread5.start()
thread6.start()
thread7.start()

thread8.start()
thread9.start()
thread10.start()
thread11.start()

thread12.start()
thread13.start()
thread14.start()
thread15.start()