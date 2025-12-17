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


;interrupt instrument
instr 2

turnoff2 1, 2, 0.01
turnoff

endin

instr 1

Sname = p4
iskiptime = p5
iamp = p6
ifreq = p7
ienv = p8
ipan = p9

asig[] diskin Sname, ifreq, iskiptime, 1
idiskchans lenarray asig

kenv linseg 0, min(max(0.001, p3*ienv), p3-0.001), iamp, min(max(0.001, p3*(1.-ienv)), p3-0.001), 0
aenv interp kenv

if idiskchans == 1 then

    a1, a2 pan2 asig[0] * aenv, ipan
    outs a1, a2

else 

    aL = (asig[0] * (1-(ipan/2.)) + asig[1]*((1-ipan)/2.))*2
    aR = (asig[0]*(ipan/2.) + asig[1]*(ipan/2.+0.5))*2

    outs aL *aenv, aR * aenv
endif

endin

</CsInstruments>
<CsScore>
t 0 60

;         audio file path                   readpos   amp  freq   env    pan
i 1 0 1  "samples/posso parlare-quiet.wav"    0        1    1      0      0.5

</CsScore>

</CsoundSynthesizer>