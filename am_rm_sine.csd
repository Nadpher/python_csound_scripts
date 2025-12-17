<CsoundSynthesizer>
<CsOptions>
-o "kick1.wav" -W
</CsOptions>
<CsInstruments>
; Initialize the global variables.
sr=48000
ksmps = 32
nchnls = 2
0dbfs = 1

instr rm
amod poscil p4, p6
acar poscil amod, p5

ki =0
while ki <nchnls do
outch ki +1, acar
ki +=1
od

endin


instr am
amod poscil p4, p6
acar poscil (amod + p4 )/2., p5

ki =0
while ki <nchnls do
outch ki +1, acar
ki += 1
od

endin

</CsInstruments>
<CsScore>

i "am" 0 5 0.1 300 100

i "rm" 5 5 0.1 300 100

</CsScore>

</CsoundSynthesizer>