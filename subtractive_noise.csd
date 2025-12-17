<CsoundSynthesizer>
<CsOptions>
-o "kick1.wav" -W
</CsOptions>
<CsInstruments>
; Initialize the global variables.
sr=48000
ksmps = 1
nchnls = 2
0dbfs = 1

zakinit 2, 1

instr subtractive_noise

 iAmp = p4
 kBeta = p5
 iAttackEnvTimePerc = p6
 iReleaseEnvTimePerc = limit:i(p7, 0, 1-iAttackEnvTimePerc)

 #include "asr_envelope.csd"

 aSig noise kEnv, kBeta

 zawm aSig, 1
 zawm aSig, 2

endin


instr pink_noise

 iAmp = p4
 iAttackEnvTimePerc = p5
 iReleaseEnvTimePerc = limit:i(p6, 0, 1-iAttackEnvTimePerc)

 #include "asr_envelope.csd"

 aSig pinker

 zawm aSig * kEnv, 1
 zawm aSig * kEnv, 2

endin

</CsInstruments>
<CsScore>

i "additiva_sine" 0 5 1 400 0
i "additiva_sine" 5 5 1 500 0
i "output_instrument" 0 10

</CsScore>

</CsoundSynthesizer>