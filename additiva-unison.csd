<CsoundSynthesizer>
<CsOptions>
-o "kick1.wav" -W
</CsOptions>
<CsInstruments>
; Initialize the global variables.
sr=48000
ksmps = 32
nchnls = 2
0dbfs = 1

instr 100

 iamp = ampdbfs(-6) 
 asig poscil iamp/p4, p5, -1, random:i(0, 1)
 
 ienvpercent = max(0.001)
 kenv linseg  0, min(max(0.001, p3*(1.-p6)), p3-0.001), 1, min(max(0.001, p3*p6), p3-0.001), 0

 a1, a2 pan2 asig * kenv, random:i(0,1)
 out a1, a2

endin

instr 1

 inumvoices = p4
 ifreq = p5
 isemitonedetune = p6

 ifreqdetune = (ifreq*pow(2, isemitonedetune/12.)) -ifreq

 print ifreqdetune

 ipartialdetune = ifreqdetune / inumvoices

 print ipartialdetune

 istartingfreq = ifreq - (ifreqdetune/2.)


 iindex = 0
 while iindex < inumvoices do
  ifinalfreq = istartingfreq + (ipartialdetune*iindex)
  event_i "i", 100, p2, p3, p4, ifinalfreq, p7
  iindex += 1
 od

endin

</CsInstruments>
<CsScore>

i1 0 60 500 200 2 0

</CsScore>

</CsoundSynthesizer>