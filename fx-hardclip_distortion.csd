<CsoundSynthesizer>
<CsOptions>
-d -o test.wav -3
</CsOptions>
<CsInstruments>
; Initialize the global variables.
sr=48000
ksmps = 64
nchnls = 2
0dbfs = 1

instr 1

itab ftgen 0, 0, 0, 1, "samples/risatafake.wav", 0, 0, 1

p3 = nsamp(itab) / sr

athreshold = a(ampdbfs(-p4))

a1 loscil 1, 1, itab, 1, 0

;clipper
aout select a1, athreshold, a1, a1, a1 - (a1 - athreshold)
aout select aout, -athreshold, aout + ((aout*-1) - athreshold), a1, aout

;rescale to 0
if p5 == 1 then
 aout /= athreshold
endif

outall aout

endin

</CsInstruments>
<CsScore>

;       drive  rescale
i 1 0 1  24       1

</CsScore>

</CsoundSynthesizer>