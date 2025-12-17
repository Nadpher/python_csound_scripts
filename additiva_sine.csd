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

instr additiva_sine

 iAmp = p4
 iFreq = p5
 iAttackEnvTimePerc = p6
 iReleaseEnvTimePerc = limit:i(p7, 0, 1-iAttackEnvTimePerc)

 #include "asr_envelope.csd"
 
 aSig poscil kEnv, iFreq

 zawm aSig, 1
 zawm aSig, 2

endin

instr additiva_sine_glissando

 iAmp = p4
 iStartFreq = p5
 iEndFreq = p6
 iCurve = p7
 iAttackEnvTimePerc = p8
 iReleaseEnvTimePerc = limit:i(p9, 0, 1-iAttackEnvTimePerc)

 #include "asr_envelope.csd"


 kPitchEnv transeg iStartFreq, p3, iCurve, iEndFreq

 aSig poscil kEnv, kPitchEnv
 
 zawm aSig, 1
 zawm aSig, 2

endin

instr zak_output_instrument

 ; Read za variable #1.
  a1 zar 1
  a2 zar 2

  ; Generate the audio output.
  outs a1, a2

  ; Clear the za variables, get them ready for 
  ; another pass.
  zacl 0, 2

endin

</CsInstruments>
<CsScore>

i "additiva_sine" 0 5 1 400 0
i "additiva_sine" 5 5 1 500 0
i "output_instrument" 0 10

</CsScore>

</CsoundSynthesizer>