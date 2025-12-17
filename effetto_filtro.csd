<CsoundSynthesizer>
<CsOptions>
-d -o "sample-unpredictable plucks.wav" -3
</CsOptions>
<CsInstruments>
; Initialize the global variables.
sr=48000
ksmps = 1
nchnls = 2
0dbfs = 1

opcode filtro_lp, a, ak
    aSigIn, kCutFreq xin

    aSigIn butlp aSigIn, kCutFreq

    xout aSigIn

endop

opcode filtro_bp, a, akk
    aSigIn, kCutFreq, kBw xin

    aSigIn butbp aSigIn, kCutFreq, kBw

    xout aSigIn

endop

opcode filtro_hp, a, ak
    aSigIn, kCutFreq xin

    aSigIn buthp aSigIn, kCutFreq

    xout aSigIn

endop



</CsInstruments>
<CsScore>

;         audio file path                   
i "effetto_filtro" 0 1  "out/granulare-crescendo\ 180625-191827.wav"

</CsScore>

</CsoundSynthesizer>