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

giTable ftgen 0, 0, 0, 1, "samples/vocal fry-001.wav", 0, 0, 1
giBpm = 90.

instr 1
aSig loscil 1, 1000, giTable, 1, 1

kEnv linseg 1, p3-0.01, 1, 0.01, 0
outall aSig * kEnv

endin

instr 2

isubdmin = p4
isubdmax = p5


;niente terzine
kchangehowoften = (giBpm/ (1./isubdmin)) / 60.
ksubd = 1./ pow(2, int(randomh:k(log2(isubdmin), log2(isubdmax), kchangehowoften)))

krhythm = (giBpm / ksubd) / 60.

kTrig metro krhythm

schedkwhen kTrig, 0, 0, 1, 0, min(1./(sr/nsamp(giTable)), 1./krhythm)
endin

</CsInstruments>
<CsScore>

i2 0 60 1 64 

</CsScore>

</CsoundSynthesizer>