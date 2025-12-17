<CsoundSynthesizer>
<CsOptions>
-d -o "sample-unpredictable plucks.wav" -3
</CsOptions>
<CsInstruments>


; Initialize the global variables.
sr=96000
ksmps = 64
nchnls = 2
0dbfs = 1

instr 100
aphs phasor ((sr/nsamp(p4)) /(sr/p5)) * p8, p6

asig tablei aphs, p4, 1

kenv linseg 0, 0.01, 1, p3-0.02, 1, 0.01, 0
aenv interp kenv

a1,a2 pan2 asig*0.25*aenv, p7

outs a1, a2

endin



instr 1

seed 0

  Sname=p4

  irepmin = p5
  irepmax = p6

  irep = int(random(irepmin, irepmax))
  
  imindur = p7
  imaxdur = p8

  ifreq = p9
  
  irepcnt = 0
  idur random imindur, imaxdur

  icnt = 0
  ipos random 0, 1
  ipan random 0, 1
  ilen random p10, 1

  itable ftgen 0, 0, 0, 1, Sname, 0, 0, 0

  isr = filesr(Sname)

  while icnt < p3 do

    event_i "i", 100, icnt, idur*ilen, itable, isr, ipos, ipan, ifreq
    icnt += idur
    if irepcnt == irep then
      ilen random 0.1, 1
      idur = random:i(imindur, imaxdur)
      irep = int(random(irepmin, irepmax))
      ipan random 0, 1
      ipos random 0, 1

      irepcnt = 0
    endif

    irepcnt += 1
  od

endin

</CsInstruments>
<CsScore>
t 0 60 

;                                  repetitions    periods    freq   minlenmult
i 1 0 40  "samples/sample-simple 090925-131344.wav"      1 4           0.04 0.2   1     1

</CsScore>

</CsoundSynthesizer>