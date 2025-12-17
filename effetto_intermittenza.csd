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

opcode intermittenza, a, akk
    aSigIn, kFreq, kCutAmp xin

    kmixpercent init 0
    kmixpercent randomh 0, 1.99, kFreq, 3
    aSigIn *= (floor(kmixpercent)+kCutAmp*abs(1-floor(kmixpercent)))

    xout aSigIn
endop

</CsInstruments>
<CsScore>

;         audio file path                   
i "effetto_intermittenza" 0 1 "out/effetto_intermittenza\ 011225-181356.wav"

</CsScore>

</CsoundSynthesizer>