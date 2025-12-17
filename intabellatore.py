import random
import math

from intabellatore_utilities import *

from intabellatore_engine import *


if __name__ == "__main__":
        
    codici = ["sample_simple.csd", "effetto_intermittenza.csd", "effetto_amp.csd", "effetto_modulation.csd"]
    bpm = 60

    random.seed()

    # instr è l'unica cosa che non può usare lambda.
    # in quanto il mapping strumenti-pfield succede prima della 
    # chiamata consecutiva dei pfield

    csd_buffer = reperisci(codici)
    
    # PARAMETRI SPECIALI LAMBDA:
    # X : posizione nel tempo normalizzato tra 0 e 1, quindi tra 0 e durata_sezione
    # pX : pfield precedente OPPURE quello corrente se è utilizzato in un parametro superiore a quello riferito
    # quindi un lambda p2: usato nella posizione del ritmo prenderà il valore precedente,
    # mentre un lambda p2: usato nella durata usa la stessa durata del ritmo


    durata = 20
        

    csd_buffer, pfields, dur_cumulativa =intabella(csd_buffer,
                    0,
                    durata,
                    ["sample_simple"],
                    [
                        
                    ]
    )

    fx_chain=[
        "amp",
  #      "intermittenza",
        "modulation_rm"
    ]

    fx_parameters=[
        [linseg_random(0.2, 2, 0.05)],
  #      [linseg_random(30, 50, .1), linseg_retrogrado([1, 1, 0])],
        [1, linseg_random(200, 1000, .4)]
    ]

    if csd_buffer != -1:
        csd_buffer = effetta_zakspace(csd_buffer, dur_cumulativa, fx_chain, fx_parameters)

    if csd_buffer != -1: exec_csound(csd_buffer, False, bpm, "sounds_crossfade", True)

