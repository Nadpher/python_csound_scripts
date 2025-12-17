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

seed 0

opcode amp, a, ak
aSigIn, kAmp xin

aSigIn *= kAmp

xout aSigIn 
endop

</CsInstruments>
<CsScore>

;         audio file path                   
i "effetto_amp" 0 1  "out/stochastic_sampler 251125-120857.wav" 0

</CsScore>

</CsoundSynthesizer>