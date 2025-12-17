<CsoundSynthesizer>
<CsOptions>
--midioutfile="randomchords.mid"
</CsOptions>
<CsInstruments>

; Initialize the global variables.
sr=96000
ksmps = 8

instr 100

inote = p4
ivel random 1, p5  

noteondur floor(random:i(1, 16+0.99)), inote, ivel, p3

endin


instr chromatic

inote = p4

iminnotes = p5
imaxnotes = p6

imindens = p7
imaxdens = p8

idur = p9
ilfofreqs = p10

imaxvel = p11

kdens lfo 1, ilfofreqs
kdens scale kdens, imaxdens, imindens, 1, -1

knotes lfo 1, ilfofreqs
knotes scale knotes, imaxnotes, iminnotes, 1, -1

kmetro metro kdens + random:k(-0.2, 0.2)

schedkwhen kmetro, 0, 0, 100, 0, idur, inote+floor(random:k(iminnotes-1, knotes-0.01))-floor(knotes/2.), imaxvel

endin


instr chord

inote = p4
ichord[] fillarray 0, 3, 7

iminnotes = p5
imaxnotes = p6

imindens = p7
imaxdens = p8

idur = p9
ilfofreqs = p10

imaxvel = p11

kdens lfo 1, ilfofreqs
kdens scale kdens, imaxdens, imindens, 1, -1

knotes lfo 1, ilfofreqs
knotes scale knotes, imaxnotes, iminnotes, 1, -1

kmetro metro kdens + random:k(-0.2, 0.2)

kchosennote = floor(random:k(0, knotes-0.01))

schedkwhen kmetro, 0, 0, 100, 0, idur, (inote+ ichord[kchosennote%lenarray(ichord)]) + 12* int(kchosennote/lenarray(ichord)), imaxvel

endin


</CsInstruments>
<CsScore>
t 0 60 
;                      note  num notes  density   dur   lfo freq  max vel
i "chromatic" 0 120    64    1 6        1 100     0.05   0.1       60

</CsScore>

</CsoundSynthesizer>