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

seed 0

opcode pitch, a, akkk
aSigIn, kSemitones, kTimeWindow, kCrossFadeFraction xin

 kCrossFadeSamples = (kTimeWindow*sr)*kCrossFadeFraction

aSigIn transpose aSigIn, kSemitones, kTimeWindow, kCrossFadeSamples

xout aSigIn
endop

opcode pitch_lfo, a, akkk
aSigIn, kSemitonesMin, kSemitonesMax, kFreq xin

kSemitones lfo 1, kFreq
kSemitones scale kSemitones, kSemitonesMax, kSemitonesMin, 1, -1

aSigIn transpose aSigIn, kSemitones, 0.02, 0.02*sr*(1./2.)

xout aSigIn
endop


</CsInstruments>
<CsScore>

;         audio file path                   
i "effetto_amp" 0 1  "out/stochastic_sampler 251125-120857.wav" 0

</CsScore>

</CsoundSynthesizer>