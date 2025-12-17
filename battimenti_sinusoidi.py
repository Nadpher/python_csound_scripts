import random
import math

from intabellatore_utilities import *

from intabellatore_engine import *


if __name__ == "__main__":
        
    codici = ["additiva_sine.csd"]
    bpm = 60

    random.seed()

    #liste

    # instr è l'unica cosa che non può usare lambda.
    # in quanto il mapping strumenti-pfield succede prima della 
    # chiamata consecutiva dei pfield

    csd_buffer = reperisci(codici)
    durata = 20

    p2 = [random.uniform(1.2, 3.5) for _ in range(1000)]
    p3 = p2

    freq = 500

    amp = 0.25

    csd_buffer, pfields, dur_cumulativa=intabella(csd_buffer,
                    0,
                    durata,
                    bpm,
                    ["additiva_sine"],

                    [
                        p2,
                        p3,
                        0.33,
                        freq,
                        0
                    ]
    )

    csd_buffer,pfields, dur_cumulativa=intabella(csd_buffer,
                    0,
                    durata,
                    bpm,
                    ["additiva_sine_glissando"],

                    [
                        p2,
                        p3,
                        amp/2.,
                        lambda: freq+random.uniform(5, 500),
                        freq,
                        2,
                        0
                    ]
    )

    

    if csd_buffer != -1:
        csd_buffer = effetta_zakspace(csd_buffer, dur_cumulativa)
    if csd_buffer != -1: exec_csound(csd_buffer, False, bpm, "battimenti_sinusoidi")

