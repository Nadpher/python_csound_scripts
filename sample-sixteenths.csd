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

giTable ftgen 0, 0, 0, 1, "samples/Goose quack 1.wav", 0.1, 0, 1
giBpm = 150

instr 1

kEnv linseg 1, 0.05, 0
aenv interp kEnv
a1 loscil 1, 10, giTable, 1, 1
a1, a2 pan2 a1 * aenv * random:i(0.1, 1), random:i(0, 1)
outs a1, a2

endin


instr 2

isubdivide = p4
kcnt init 0 

krhythm = (giBpm / (1./3.)) / 60.

kaccent = kcnt % (isubdivide)

kTrig metro krhythm
schedkwhen kTrig, 0, 0, 1, 0, 1./krhythm

if kTrig == 1 then
kcnt += 1
endif
endin

</CsInstruments>
<CsScore>

i2 0 30

</CsScore>

</CsoundSynthesizer>