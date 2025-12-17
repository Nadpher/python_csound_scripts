<CsoundSynthesizer>

<CsOptions>
-d -o combexample.wav -3 
</CsOptions>

<CsInstruments>
sr = 96000
ksmps = 16
nchnls = 2
0dbfs = 1

instr click_comb

adirac mpulse p4, 0
aOut delayr (1./p5)
delayw adirac + (aOut*p6)

ki=0
while ki <nchnls do
    outch ki+1, adirac + (aOut*p4)
    ki+=1
od

endin


</CsInstruments>

<CsScore>

;         
i "click_comb" 0 5 1 80 .99

</CsScore>

</CsoundSynthesizer>

