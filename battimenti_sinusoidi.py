import random
import math

from intabellatore_utilities import *

from intabellatore_engine import *


# ----------------------------------
# -                                -
# -         MAIN FUNCTION          -
# -                                -
# ----------------------------------

if __name__ == "__main__":
        
    codici = ["additiva_sine.csd"]
    bpm = 60

    random.seed()

    #liste

    # instr è l'unica cosa che non può usare lambda.
    # in quanto il mapping strumenti-pfield succede prima della 
    # chiamata consecutiva dei pfield

    csdbuffer = reperisci(codici)
    durata = 20

    p2 = [random.uniform(1.2, 3.5) for _ in range(1000)]
    p3 = p2

    freq = 500

    amp = 0.25

    csdbuffer=intabella(csdbuffer,
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

    csdbuffer=intabella(csdbuffer,
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

    

    csdbuffer= effetta_zakspace(csdbuffer, durata)
    if csdbuffer != -1: exec_csound(csdbuffer, False, bpm, "battimenti_sinusoidi")

