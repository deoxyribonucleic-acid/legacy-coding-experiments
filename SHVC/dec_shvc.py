import os, glob
#paths
binpath = '/data1/wangcy/h265/bin_shvc/'
recpath = '/data1/wangcy/h265/yuvdec/'
configpath = './cfg/'
encoderpath = './shvc/bin/'
logpath = './log_shvc/'
yuvpath = '/data1/wangcy/h265/yuvinput/'
name = 'out'
maxlayers = 3
numchunks = 16
def generateCommand(chunk,lid):
    command = encoderpath + 'TAppDecoderStatic'
    command += ' -b ' + binpath +  chunk + '.bin'
    command += ' -lid ' + str(lid)
    command += ' -o' + str(lid)+' ' + recpath + 'L' + str(lid) + '/' + chunk+'.yuv'
    return command


def decSHVC():
    for idc in range(0,numchunks):
        chunk= name+'_chunk_'+str(idc)
        for lid in range(0,maxlayers):
            command = generateCommand(chunk,lid)
            print(command)
            #os.system(command)


if __name__ == '__main__':
    decSHVC()
