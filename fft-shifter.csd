<CsoundSynthesizer>
<CsOptions>
-d -o test.wav -3
</CsOptions>
<CsInstruments>

; Initialize the global variables.
sr=48000

; k samps deve essere un divisore int di ihopsize
ksmps = 32

nchnls = 1
0dbfs = 1

; -- FREQUENCY SHIFT OPCODE --
opcode FrequencyShift, a, aiik

 ; fft i-variables
 a1, ifftsize, iolaps, kshiftfreq xin
 
 ;ottieni bin e percentuale di bin basato sulla frequenza da shiftare
 kshiftbins = int(kshiftfreq / (sr/ifftsize))
 
 ; determina grandezza della finestra in campioni
 ihopsize = ifftsize / iolaps
 
 ; var contatori
 kcnt init 0
 kwincnt init 0
 
 ; var buffer
 kIn[] init  ifftsize
 
 kOla[] init ifftsize
 kOut[][] init iolaps, ifftsize
 
 
 kShift[] init ifftsize*2
 
 
 ; per ogni finestra (quindi ogni hopsize campioni)
 if kcnt == ihopsize then
  kShift = 0
 
  ;applica finestra hanning a segnale reale
  kWin[] window kIn, kwincnt*ihopsize, 1

  ; fa fft all'array "finestrato"
  kCmplx[] r2c kWin
  kSpec[] fft kCmplx
 
  kbincount = 0
  
  ; -- START FREQUENCY SHIFT -- 
  while kbincount < ifftsize/2 do
   knewbincount = kbincount+kshiftbins

   if knewbincount < ifftsize && knewbincount >= 0 then
    kShift[knewbincount] = kSpec[kbincount]

   endif 

   kbincount +=1
  od
  ; -- END FREQUENCY SHIFT --
 
  ; fai reverse fft di questa window
  kCmplx fftinv kShift
  kRow[] c2r kCmplx 

  ; applica finestra hanning a array reale output dello shift
  kWin window kRow, kwincnt*ihopsize, 1

  ; imposta array di indice kwincnt in kOut allo shift finestrato
  kOut setrow kWin, kwincnt
 
  kOla = 0
  ki = 0

  ;somma le finestre
  until ki == iolaps do
   kRow getrow kOut, ki
   kOla = kOla + kRow
   ki+=1
  od
 
  ;aumenta contatore finestra
  kwincnt = (kwincnt+1)%iolaps
  kcnt = 0 
 endif
 
 ;trasferisce ifftsize campioni da a1 a kIn[] ogni ksamps
 kIn[] shiftin a1

 ;prende ifftsize campioni da kOla e li mette nella variabile audio a2 ogni ksamps
 a2 shiftout kOla

 kcnt += ksmps
 
 ;segnale finale diviso da num finestre
 xout a2 / iolaps
endop



; -- STRUMENTO 1 --
instr 1 
 ; signal source
 ifn = 1
 ibas = 1
 imod = 1 

 ;oscillatore digitale
 ;a1 loscil 1, 1, ifn, ibas, imod 

 a1 vco2 0.3, 440

 kshift linseg 0, p3, p6

 ; usa opcode per fare shift
 a2 FrequencyShift a1, p4, p5, kshift 

 out a2
endin

</CsInstruments>
<CsScore>

; -- SCORE STATEMENTS --

f 1 0 0 1 "samples/subtractive-saw pluck 180625-105314.wav" 0 0 1

;            fft size   n finestre  freq shift
i 1 0 20     2048       16           2000.

</CsScore>
</CsoundSynthesizer>