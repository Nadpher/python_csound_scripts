<CsoundSynthesizer>
<CsOptions>
-d -o test.wav -3
</CsOptions>
<CsInstruments>

; Initialize the global variables.
sr=48000
ksmps = 32
nchnls = 1
0dbfs = 1

; -- FREQUENCY SHIFT OPCODE --
opcode FrequencyShift, a, aiik

 a1, ifftsize, iwindows, kfreqshift xin

 ioverlap = ifftsize/iwindows

 iwintype = 1 ;hann window

 ;fft & frequency shift
 fsig pvsanal a1, ifftsize, ioverlap, ifftsize, iwintype
 fshift pvshift fsig, kfreqshift, 0

 a2 pvsynth fsig

 xout a2
endop



; -- STRUMENTO 1 --
instr 1 
 ; signal source
 ifn = 1
 ibas = 1
 imod = 1 

 ;oscillatore digitale
 a1 loscil 1, 1, ifn, ibas, imod 

 ; frequency shift env
 kshift transeg p6, p3, -4, p6/2

 ; usa opcode per fare shift
 a2 FrequencyShift a1, p4, p5, kshift 

 out a2
endin

</CsInstruments>
<CsScore>

; -- SCORE STATEMENTS --

f 1 0 0 1 "samples/risatafake.wav" 0 0 1

;            fft size   n finestre  freq shift
i 1 0 20     2048       16          5000.

</CsScore>
</CsoundSynthesizer>