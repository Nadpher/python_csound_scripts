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

gitable ftgen 0, 0, 0, 1, "samples/sample-glitcher 150625-165715.wav", 0, 0, 1

instr 100

kenv linseg 0, p3/2, 1, p3/2, 0
asig loscil 0.3, p4, gitable, 1 , 1

iamp = p5

a1, a2 pan2 asig * kenv * iamp, random:i(0, 1)

outs a1, a2
endin


instr 1

ktimeenv transeg p4, p3, p6, p5

; il problema qui è che se inizia con valore grande mentre 
; va l'inviluppo salta dei battiti che non dovrebbe teoricamente saltare
ktrig metro 1./ktimeenv

if p4 < p5 then
kpitchenv scale ktimeenv, p8, p9, p4, p5 
else
kpitchenv scale ktimeenv, p8, p9, p5, p4
endif

schedkwhen ktrig, 0, 0, 100, 0, p7, kpitchenv, random:i(0.1, 1)

endin

</CsInstruments>
<CsScore>
t 0 60   

;               times     curve    event dur     pitches
i 1 0 5      1.5 0.01       -16      0.01           1 0.2

</CsScore>

</CsoundSynthesizer>