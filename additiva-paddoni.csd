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

instr 1

 iamp = ampdbfs(-6) 
 asig poscil iamp/p4, p5, -1, p6

 kenv expseg 0.001, p3/2, 1, p3/random:i(2,4), 0.01

 a1, a2 pan2 asig * kenv, random:i(0,1)
 out a1, a2

endin

instr 2

 seed 0

 istartingpoint = 0.01

 idursect = p3
 isections = p4
 inumvoices = p5

 p3 = (idursect * isections) - (((1-istartingpoint)*idursect)*isections)
 ibwsemitones = p6

 iminfreq = p7
 imaxfreq = p8

 iphs random 0, 1

 isectcount = 0
 while isectcount < isections do
  
  iindex = 0

  icentralfreq = random:i(iminfreq, imaxfreq)
  while iindex < inumvoices do
   ;metà dei semitoni sopra, metà dei semitoni sotto
   ifreqtopedge = (icentralfreq * pow(2, (ibwsemitones/2.)/12.) - icentralfreq)
   ifreqbottomedge = (icentralfreq*pow(2, -(ibwsemitones/2.)/12.)- icentralfreq) 

   ifreq = random:i(icentralfreq - ifreqbottomedge, icentralfreq+ ifreqtopedge)
   event_i "i", 1, p2 + (idursect*isectcount*istartingpoint), idursect, inumvoices, ifreq, iphs
   iindex += 1
  od

  isectcount += 1
 od

endin

</CsInstruments>
<CsScore>

      ;durata sez    ;n sez   ;n voci  ;bw semitoni   ;min  max freq
i 2 0 15             50       400       3            20   500

</CsScore>

</CsoundSynthesizer>