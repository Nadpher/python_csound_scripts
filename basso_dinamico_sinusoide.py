import random

from intabellatore_utilities import *

from intabellatore_engine import *


if __name__ == "__main__":
        
    codici = ["additiva_sine.csd"]
    bpm = 60

    random.seed()

    #instr è l'unica cosa che non può usare lambda.
    # in quanto il mapping strumenti-pfield succede prima della 
    # chiamata consecutiva dei pfield

    csd_buffer = reperisci(codici)
    durata = 20
    
    csd_buffer, pfields, dur_cumulativa=intabella(csd_buffer,
                    0,
                    durata,
                    bpm,
                    ["\"additiva_sine\""],

                    [
                        lambda: random.uniform(0.4, 2.7),
                        5,
                        lambda:random.uniform(0, 0.4),
                        lambda: random.uniform(50, 60),
                        0.5,
                    ]
    )
    
    if csd_buffer != -1:
        csd_buffer = effetta_zakspace(csd_buffer, dur_cumulativa)
    if csd_buffer!=-1: exec_csound(csd_buffer, False, bpm, "basso_dinamico_sinusoide")

