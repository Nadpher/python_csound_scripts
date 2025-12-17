<CsoundSynthesizer>
<CsOptions>
--midioutfile="randomchords.mid"
</CsOptions>
<CsInstruments>
; Initialize the global variables.
ksmps = 64

#define MIDI_NOTE_OFF #128#
#define MIDI_NOTE_ON  #144#

giBpm = 1.5


instr 1
kchn = p4

ivel random 40, 115
inote = p5

katt init 0
krelease release 

if katt == 0 then

 midiout $MIDI_NOTE_ON, kchn, inote, int(ivel)

 katt = 1
endif

if krelease == 1 then
 midiout $MIDI_NOTE_OFF, kchn, inote, 0
endif

endin


instr 2
isubdiv = 1./p4

print isubdiv
inote = p5

print inote

ifreq= (giBpm/60.) / isubdiv
iperiod= 1./ifreq

ktrig metro ifreq
idur =1
schedkwhen ktrig, 0, 0, 1, 0, iperiod, int(random:k(1, 16+0.999)), inote

endin

</CsInstruments>
<CsScore>

i 2 0 600 64 48
i . . .   65 52
i . . .   66 55
i . . .   67 59
i . . .   68 60
i . . .   69 64
i . . .   70 67
i . . .   71 71
i . . .   72 72
i . . .   73 76
i . . .   74 79
i . . .   75 83

</CsScore>

</CsoundSynthesizer>