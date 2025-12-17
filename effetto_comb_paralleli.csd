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

instr effetto_comb_paralleli

seed 0

Sname = p4
p3 = filelen(Sname)

itab ftgen 0, 0, 0, 1, Sname, 0, 0, 0

asigs[] loscilx 1, 1, itab
ifilechnls = lenarray(asigs)

ki = 0
while ki < nchnls do
    
    aout1 vcomb asigs[ki%ifilechnls], 0.1, 1./18+(rnd:k(0.2)), 1
    aout2 vcomb asigs[ki%ifilechnls], 5, 1./(35+rnd:k(0.1)), 1
    aout3 vcomb asigs[ki%ifilechnls], 10, 1./(42+rnd:k(0.01)), 1
    

    outch (ki%ifilechnls)+1, (aout1+aout2+aout3) /3

    ki += 1
od
endin

</CsInstruments>
<CsScore>

;         audio file path                   
i "effetto_comb_paralleli" 0 1  "out/effetto_intermittenza\ 011225-181535.wav"

</CsScore>

</CsoundSynthesizer>