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

instr effetto_comb_seriali

seed 0

Sname = p4

itab ftgen 0, 0, 0, 1, Sname, 0, 0, 0

asigs[] loscilx 0.2, 1, itab, filesr(Sname)/sr
ifilechnls = lenarray(asigs)

ifreqs[] fillarray 0.1, 0.03, 0.0085, 0.061
igs[] fillarray 0.8


ki = 0

aDelayBuf delayr 10
while ki < nchnls do
    kindx = ki%ifilechnls
    
    incomb = p5
    kj = 0


    while kj < incomb do
        aTap deltapi 1./ifreqs[kj%lenarray(ifreqs)]
        delayw asigs[kindx] + (aTap * rspline(0.8, 0.999, 0.01, 0.1))

        kj += 1
    od


    
    outch (kindx)+1, (asigs[kindx] + aTap)/incomb

    ki += 1
od
endin

</CsInstruments>
<CsScore>

;                                   audio file path                   
i "effetto_comb_seriali" 0 60 "out/effetto_mix\ 011225-095217.wav" 2

</CsScore>

</CsoundSynthesizer>