<CsoundSynthesizer>
<CsOptions>
-o "kick1.wav" -W
</CsOptions>
<CsInstruments>
; Initialize the global variables.
sr=48000
ksmps = 1
nchnls = 2
0dbfs = 1

opcode modulation_rm, a, akk
aSigIn, kModAmp, kModFreq xin

aCar oscili kModAmp, kModFreq

aSigIn *= (aCar+1)/2

xout aSigIn
endop

opcode modulation_am, a, akk
aSigIn, kModAmp, kModFreq xin


aCar oscili kModAmp, kModFreq
aSigIn *= aCar

xout aSigIn
endop

</CsInstruments>
<CsScore>

i "am" 0 5 0.1 300 100

i "rm" 5 5 0.1 300 100

</CsScore>

</CsoundSynthesizer>