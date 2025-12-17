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

zakinit 2, 1
 
instr sample_simple
 
 Sname = p4
 iReadPosition = p5
 iAmp = p6
 iFreqMultiplier = p7
 
 iAttackEnvTimePerc = p8
 iReleaseEnvTimePerc = limit:i(p9, 0, 1-iAttackEnvTimePerc)

 iPan = p10
 
 iAttackTime = limit:i(p3*iAttackEnvTimePerc, 0.001, p3-0.001)
 iRelTime = limit:i(p3*iReleaseEnvTimePerc, 0.001, p3-0.001)
 iSusTime = p3-(iAttackTime + iRelTime)
 
 kEnv linseg 0, iAttackTime, iAmp, iSusTime, iAmp, iRelTime, 0
 
 aSigs[] diskin Sname, iFreqMultiplier, filelen(Sname)*iReadPosition, 1
 iChannels lenarray aSigs
 
 if iChannels == 1 then
  a1, a2 pan2 aSigs[0]*kEnv, iPan
 else
  a1 = aSigs[0]*kEnv
  a2 = aSigs[1]*kEnv
 endif

 zawm a1, 1
 zawm a2, 2

endin

</CsInstruments>
<CsScore>

;         audio file path                   readpos   amp  freq   env    pan
i 1 0 1  "samples/posso parlare-quiet.wav"    0        1    1      0    

</CsScore>

</CsoundSynthesizer>