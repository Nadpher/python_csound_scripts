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

gitable ftgen 0, 0, 0, 1, "samples/sample-glitcher 150625-165715.wav", 0, 0, 0

instr 1

a1, a2 flooper 1, 0.05, p4, p5, p6, gitable

kenv linseg 0, 0.01, 1, p3/2-0.01, 1, p3/2,0
outs a1 * kenv, a2*kenv

endin

</CsInstruments>
<CsScore>
t 0 60   

;          
i 1 0 40 0 10 10

</CsScore>

</CsoundSynthesizer>