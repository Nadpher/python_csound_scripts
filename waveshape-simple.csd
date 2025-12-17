<CsoundSynthesizer>
<CsOptions>
-d -o "sample-unpredictable plucks.wav" -3
</CsOptions>
<CsInstruments>
; Initialize the global variables.
sr=48000
ksmps = 64
nchnls = 2
0dbfs = 1

seed 0

instr 1

Sname = p4
iskiptime = p5
iamp = p6
ifreq = p7
ienv = p8
ipan = p9

asig[] diskin Sname, ifreq, iskiptime, 1

kenv linseg 0, min(max(0.001, p3*ienv), p3-0.001), iamp, min(max(0.001, p3*(1.-ienv)), p3-0.001), 0
aenv interp kenv

ifunc ftgen 0, 0, 4097, -7, -0.5, 1024, -0.5, 2048, .5, 1024, .5

anoise pinker
anoise *= rspline(0.01, 0.1, 0.3, 3)

ki = 0
while ki < lenarray(asig) && ki < nchnls do
    
    aindx = (asig[ki] +1) / 2
    aout tablei aindx, ifunc, 1    
    outch ki+1, aout +anoise

    ki+=1
od

endin

</CsInstruments>
<CsScore>
t 0 60

;         audio file path                   readpos   amp  freq   env    pan
i 1 0 10  "samples/posso parlare-loud.wav"    0        1    1      0      0.5

</CsScore>

</CsoundSynthesizer>