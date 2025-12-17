<CsoundSynthesizer>

<CsOptions>
-d -o combexample.wav -3 
</CsOptions>

<CsInstruments>
;Example by Iain McCurdy

sr = 96000
ksmps = 32
nchnls = 2
0dbfs = 1

giEnv ftgen 0, 0, 8192, 9, 1/2, 1, 0 ;half sine as envelope

instr 100

itable = p4
ifilesr = p5
iphs = p6

iaudiolen = nsamp(itable)

ifreq = ((sr/iaudiolen) / (sr/ifilesr) )* p7

afileindx phasor ifreq, iphs

asig tablei afileindx, itable, 1

kenvindx linseg 0, p3, 1
kenv tablei kenvindx, giEnv, 1

aenv interp kenv

a1, a2 pan2 asig *random:i(0.05, 1) * 0.5*aenv, random:i(0, 1)

out a1, a2

endin



instr 1

Sname = p4
ireadpos = p5
idur = p6
idens = p7
ifreq = p8
iphsfreq = p9

itable ftgen 0, 0, 0, 1, Sname, 0, 0, 1 ; MONO
iaudioseconds = nsamp(itable) /filesr(Sname)

kphasor phasor iphsfreq
kphasor scale kphasor, iaudioseconds, 0, 1, 0


kfinalpos = ((ireadpos+kphasor) % iaudioseconds)/iaudioseconds

ktrig metro idens + rspline(2, -2, 1, 0.2)
schedkwhen ktrig, 0, 0, 100, 0, idur, itable, filesr(Sname), kfinalpos, ifreq + rspline(0.01, -0.01, 1, 0.2)

endin

</CsInstruments>

<CsScore>
t 60

;                                             startpos   duration   density   freq  phs-freq
i 1 0 80 "samples/62-251025_1005.wav"          0         0.4        20      1     0.05  

</CsScore>

</CsoundSynthesizer>

