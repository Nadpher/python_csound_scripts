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

opcode comb_filter, a, aii
    aSigIn, iBaseVal, iMaxVal xin

aDel init 0

iMaxG = .99

ibaseval =0

aDel vdelayx aSigIn+aDel

xout aSigIn+aDel
endop

</CsInstruments>
<CsScore>

;         audio file path                   
i "effetto_comb_paralleli" 0 1  "out/effetto_intermittenza\ 011225-181535.wav"

</CsScore>

</CsoundSynthesizer>