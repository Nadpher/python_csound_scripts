<CsoundSynthesizer>

<CsOptions>
-d -o combexample.wav -3 
</CsOptions>

<CsInstruments>
;Example by Iain McCurdy

sr = 48000
ksmps = 32
nchnls = 2
0dbfs = 1

giTable ftgen 0, 0, 0, 1, "samples/Goose quack 1.wav", 0, 0, 1 ; MONO

instr 1

ifilelen = nsamp(giTable)

ifreq = (sr/ifilelen) * p5 

;kfileindx loopseg ifreq, 0, 0, istartsamp, 100, istartsamp + sr*p3
;kfileindx = kfileindx % ifilelen

iphs =(sr*p4) / ifilelen

afileindx phasor ifreq, iphs
asig tablei afileindx, giTable, 1

kenv linseg 1, p3, 0

a1, a2 pan2 asig*random:i(0.1, 1) * 0.5, random:i(0, 1), 1
out a1*kenv * p6, a2*kenv * p6

endin

instr 2

kreadpos = p4
idur = p5

kdens rspline p6, p6/(p6/10), 3, 0.8

ktrig metro kdens  + randomi:k(2, -2, 1, 3)

kenv transeg 1, p3, -4, 0

kenvfreq linseg 1, p3, 0.5
schedkwhen ktrig, 0, 0, 1, 0, idur, kreadpos, p7 * kenvfreq, kenv

endin

</CsInstruments>

<CsScore>
t 60

;          startpos   duration   density   freq ratio
i 2 0 4.16    12.557        0.3        20        2

</CsScore>

</CsoundSynthesizer>

