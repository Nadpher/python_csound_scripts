<CsoundSynthesizer>
<CsOptions>
-d -o "sample-unpredictable plucks.wav" -3
</CsOptions>
<CsInstruments>
; Initialize the global variables.
sr=48000
ksmps = 64
nchnls = 1
0dbfs = 1

gS_file = "samples/risatafake.wav"

instr 1

idutyc = p4
ifreq = p5

iattcurve =p6
irelcurve =p7

ibuffer ftgen 0,0,0,1,gS_file,0,0,1

itransientpoint = p3*idutyc

kEnv transeg 0.01, itransientpoint, iattcurve, 1, p3 * (1.-idutyc), irelcurve, 0

idoppsemitone = p8

kfreqenv transeg 1, itransientpoint, 1, 1, p3*(1.-idutyc), irelcurve, 1./pow(2, idoppsemitone/12.)

asig loscil 1, ifreq * kfreqenv, ibuffer, 1, 1
out asig*kEnv
endin

</CsInstruments>
<CsScore>

i 1 0 5 0.2 100 20 -8 24

</CsScore>

</CsoundSynthesizer>