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

giTable ftgen 0, 0, 0, 1, "samples/minut miagoli 2025-07-19.wav", 23, 0, 1
giBpm = 90

instr 100

ichance = p4

kEnv linseg 1, 0.05, min(int(random:i(0, ichance)), 1)
aenv interp kEnv
a1 loscil 1, 50, giTable, 1, 1

a1, a2 pan2 a1 * aenv, random:i(0, 1)
outs a1, a2

endin

instr 1

isubdivide = p4

krhythm = (giBpm / (1./4.)) / 60.

kenv transeg 0.25, p3, 2, 4

kfreq =(krhythm + randomi:k(-0.5, 0.5, krhythm/4))  * kenv

kTrig metro kfreq
schedkwhen kTrig, 0, 0, 100, 0, 1./kfreq, 1 * kenv

endin

</CsInstruments>
<CsScore>

i1 0 60

</CsScore>

</CsoundSynthesizer>