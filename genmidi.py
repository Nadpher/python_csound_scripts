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
newmidipath = "\"" + currentdir + '/' + outputdir + '/' + filename  + ' ' + timestring + ".mid\""

if os.system("csound \"" + filepath + "\" --midioutfile=" + newmidipath) == 0:
    print(newcsdpath)
    print(newmidipath)

    with open(filepath, 'r') as f:
        buffercsound = f.readlines()

    buffercsound[2] = "-d --midioutfile=" + '\"' + newmidipath[newmidipath.rfind('/')+ 1: ] + "\n"

    with open(newcsdpath[newcsdpath.find(outputdir):].removesuffix('\"'), 'x') as f:
        f.writelines(buffercsound)

    print("file generati: \n" + newcsdpath + '\n' + newmidipath)
