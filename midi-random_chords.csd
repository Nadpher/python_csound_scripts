<CsoundSynthesizer>
<CsOptions>
--midioutfile="randomchords.mid"
</CsOptions>
<CsInstruments>
; Initialize the global variables.
ksmps = 64

#define MIDI_NOTE_OFF #128#
#define MIDI_NOTE_ON  #144#

giBpm = 110


instr 1
kchn = p4

kvel random 40, 115  

inumnotes = p5
inotes[] init inumnotes

ii = 0
while ii < inumnotes do
 inotes[ii] = int(random(24, 60+0.999))
 ii +=1
od

katt init 0
krelease release 

if katt == 0 then
 ki = 0
 while ki < inumnotes do
  midiout $MIDI_NOTE_ON, kchn, inotes[ki], int(kvel)
  ki +=1
 od

 katt = 1
endif

if krelease == 1 then
 ki = 0
 while ki < inumnotes do
  midiout $MIDI_NOTE_OFF, kchn, inotes[ki], 0
  ki +=1
 od
endif

endin
 
instr 2
seed 0

irhythm = (giBpm/60.) 
print irhythm
ktrig metro irhythm

iperiod = (60. / giBpm)

iminparts = 2
imaxparts = 9

schedkwhen ktrig, 0, 0, 1, 0, iperiod, 1, int(random:k(iminparts, imaxparts+0.999))
endin


</CsInstruments>
<CsScore>
t 60

i2 0 21 

</CsScore>

</CsoundSynthesizer>