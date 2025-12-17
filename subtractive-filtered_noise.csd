<CsoundSynthesizer>
<CsOptions>
-d -o "noisy saw.wav" -3
</CsOptions>
<CsInstruments>
; Initialize the global variables.
sr=96000
ksmps = 64
nchnls = 2
0dbfs = 1


instr 1

kcf rspline p4, p5, 0.01, 0.1
ibw = p6

asig pinker
asig butbp asig, kcf, ibw

kenv linseg random:i(0.1,1), p3, 0
a1, a2 pan2 asig*kenv, random:i(0, 1)

outs a1, a2

endin


</CsInstruments>
<CsScore>

i1 0 60 1 

</CsScore>

</CsoundSynthesizer>