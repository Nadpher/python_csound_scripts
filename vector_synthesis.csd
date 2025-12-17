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
 
instr vector_synth
 
 seed 0

 Sname = p4
 iTablesNum = p5
 iAmp = p6
 iFreq = p7

 iTabSize = (filelen(Sname)*filesr(Sname))/iTablesNum
 iTables[] init iTablesNum

 aPhasor phasor (filesr(Sname)/iTabSize)*iFreq

 ; generazione di tables
 ; da 1 a nTables

 ii=0
 while ii < iTablesNum do
  iTables[ii] ftgen 0, 0, iTabSize, 1, Sname, (filelen(Sname)/iTablesNum)*ii, 0, 1
  ii+=1
 od
 
 kTabIndex linseg 0, p3, iTablesNum-1

 aSig1 tableikt aPhasor, iTables[floor(kTabIndex)], 1
 aSig2 tableikt aPhasor, iTables[floor(kTabIndex+1)], 1

 iAttackEnvTimePerc = p8
 iReleaseEnvTimePerc = limit:i(p9, 0, 1-iAttackEnvTimePerc)
 
 iAttackTime = limit:i(p3*iAttackEnvTimePerc, 0.001, p3-0.001)
 iRelTime = limit:i(p3*iReleaseEnvTimePerc, 0.001, p3-0.001)
 iSusTime = p3-(iAttackTime + iRelTime)

 kEnv linseg 0, iAttackTime, iAmp, iSusTime, iAmp, iRelTime, 0
 
 outall (aSig1 * (1-(kTabIndex%1.)) + aSig2*(((kTabIndex+1)%1.))) * kEnv
endin

</CsInstruments>
<CsScore>

i 1 0 20 "samples/minut miagoli 2025-07-19.wav" 128 0.2 8000  0 0    

</CsScore>

</CsoundSynthesizer>