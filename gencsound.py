import datetime
import os
import sys

tempo = datetime.datetime.now()
timestring = tempo.strftime("%d%m%y-%H%M%S")

outputdir = "out"
currentdir = os.path.dirname(os.path.realpath(__file__))

print(currentdir[currentdir.rfind('/')+1:])

if currentdir[currentdir.rfind('/')+1:] == outputdir:
    outputdir=''
elif not os.path.exists(outputdir + '/'):
    os.mkdir(outputdir)

filepath = sys.argv[1]
filename = filepath[filepath.rfind('/')+1:(filepath.rfind(' ') if filepath.rfind(' ') != -1 and filepath[filepath.rfind(' ')+1].isnumeric() else filepath.rfind('.'))]

print(filename)

newcsdpath ="\"" + currentdir + '/' + outputdir + '/' + filename + ' ' + timestring + ".csd\""
newwavpath = "\"" + currentdir + '/' + outputdir + '/' + filename  + ' ' + timestring + ".wav\""

flags = " -W -3"


if os.system("csound \"" + filepath + "\" -o " + newwavpath + flags) == 0:
    print(newcsdpath)
    print(newwavpath)

    with open(filepath, 'r') as f:
        buffercsound = f.readlines()

    buffercsound[2] = "-d -o " + '\"' + newwavpath[newwavpath.rfind('/')+ 1: ] + " -W\n"

    with open(newcsdpath[newcsdpath.find(outputdir):].removesuffix('\"'), 'x') as f:
        f.writelines(buffercsound)

    print("file generati: \n" + newcsdpath + '\n' + newwavpath)
