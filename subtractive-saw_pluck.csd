<CsoundSynthesizer>
<CsOptions>
-d -o "noisy saw.wav" -3
</CsOptions>
<CsInstruments>
; Initialize the global variables.
sr=48000
ksmps = 64
nchnls = 2
0dbfs = 1


instr 1

kfreq = p5

kenv linseg 0, p3/2, 1, p3/2, 0

aOut vco2 p4 * kenv, kfreq , 10

kcf linseg p8,p3/4, p7, (p3/4)*3, p8

aOut butbp aOut, kcf, p9, 1
a1, a2 pan2 aOut, p6

outs a1, a2

endin


</CsInstruments>
<CsScore>
t0 60
i1 0 60 1 500 0.5 

</CsScore>

</CsoundSynthesizer>