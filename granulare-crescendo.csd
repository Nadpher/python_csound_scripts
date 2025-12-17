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

giTable ftgen 0, 0, 0, 1, "samples/violin.wav", 0, 0, 1 ; MONO

instr 1

ifilelen = nsamp(giTable)

ifreq = (sr/ifilelen) * random:i(0.125, 10)

;kfileindx loopseg ifreq, 0, 0, istartsamp, 100, istartsamp + sr*p3
;kfileindx = kfileindx % ifilelen

iphs =(sr*p4) / ifilelen

afileindx phasor ifreq, iphs
asig tablei afileindx, giTable, 1

kenv linseg 0, p3/2, 1, p3/2,0

a1, a2 pan2 asig*random:i(0.1, 1) * 0.5, random:i(0, 1), 1
out a1*kenv * p6, a2*kenv * p6

endin

instr 2

kreadpos = p4
idur = p5

kenv transeg 0.2, p3, -4, 1
kdens transeg 0.1, p3, 2, p6

idens = p6
ktrig metro kdens + randomi:k(0.5, -0.5, 0.1, 3)

schedkwhen ktrig, 0, 0, 1, 0, idur, kreadpos, p7, kenv

endin

</CsInstruments>

<CsScore>
t 60

;          startpos   duration   density   freq ratio
i 2 0 120    0        2      10        4

</CsScore>

</CsoundSynthesizer>

