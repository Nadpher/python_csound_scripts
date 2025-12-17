<CsoundSynthesizer>

<CsOptions>
-d -o combexample.wav -3 
</CsOptions>

<CsInstruments>
;Example by Iain McCurdy

sr = 96000
ksmps = 16
nchnls = 2
0dbfs = 1

giEnv ftgen 0, 0, 8192, 9, 1/2, 1, 0 ;half sine as envelope
giTable ftgen 0, 0, 0, 1, "samples/additiva-paddoni 090625-175857-glued reversed 001-glued-01.wav", 0, 0, 1 ; MONO

instr 1

ifilelen = nsamp(giTable)

istartsamp = sr*p4
ifreq = (sr/ifilelen) * (p5+ random:i(0.1, -0.1))

;kfileindx loopseg ifreq, 0, 0, istartsamp, 100, istartsamp + sr*p3
;kfileindx = kfileindx % ifilelen
;iphs = istartsamp/ifilelen
iphs = istartsamp/ifilelen
afileindx phasor ifreq, iphs
asig tablei afileindx, giTable, 1

kenvindx linseg 0, p3 , 1
kenv tablei kenvindx, giEnv, 1

ipan = random:i(0, 1)

a1, a2 pan2 asig*random:i(0.1, 1) * 0.25, ipan, 1

out a1*kenv, a2*kenv

endin

instr 2

;evita che vada sotto 0
ireadpos = max(p4, 0)

idur = p5
imindens = p6
imaxdens = p7
ifreq = p8

seed 0


kdens rspline imaxdens, imindens, 2, 0.2

kdensenv transeg 1, p3, -4, 0

ktrig metro kdens * kdensenv

schedkwhen ktrig, 0, 0, 1, 0, idur, ireadpos, ifreq * (kdens/imindens), kdens

endin

</CsInstruments>

<CsScore>

;              startpos   duration   min density  max density  freq ratio 
i 2 0 30           9       2       2           200               5000

</CsScore>

</CsoundSynthesizer>

