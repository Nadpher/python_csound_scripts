<CsoundSynthesizer>
<CsOptions>
-d -o "sample-unpredictable plucks.wav" -3
</CsOptions>
<CsInstruments>


; Initialize the global variables.
sr=96000
ksmps = 64
nchnls = 2
0dbfs = 1

gitable ftgen 0, 0, 0, 1, "samples/Goose quack 1.wav", 0, 0, 1

instr 1

seed 0

iminfreq = 1
imaxfreq = 100

krandomz randomh iminfreq, imaxfreq, randomh:k(2, rspline(0.1, 50, 0.2, 2), 0.5, 3), 3

asig flooper 1, krandomz, 0, p4, p5, gitable
kloopenv loopseg krandomz, 0, 0, 0, 100, 1

kenv transeg 0, 0.01, 1, 1, p3/2-0.01, 1, 1, p3/2, -2,0
a1, a2 pan2 asig * kenv *kloopenv, scale(krandomz, iminfreq, imaxfreq, 0, 1)

outs a1, a2

endin

</CsInstruments>
<CsScore>
t 0 60   

;          
i 1 0 120 0.3 0.3

</CsScore>

</CsoundSynthesizer>