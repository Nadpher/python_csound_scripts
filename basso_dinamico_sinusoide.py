import random

from intabellatore_utilities import *

from intabellatore_engine import *



# ----------------------------------
# -                                -
# -         MAIN FUNCTION          -
# -                                -
# ----------------------------------

if __name__ == "__main__":
    
    #RICORDATI PER GLI STRUMENTI STRING DEVI USARE
    #GLI ESCAPE CHARACTER INSIEME ALLE VIRGOLETTE \" \"
    
    codici = ["additiva_sine.csd"]
    bpm = 60

    random.seed()

    #liste

    #instr è l'unica cosa che non può usare lambda.
    # in quanto il mapping strumenti-pfield succede prima della 
    # chiamata consecutiva dei pfield

    csdbuffer = reperisci(codici)
    durata = 20
    
    csdbuffer=intabella(csdbuffer,
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
    

    print(csdbuffer)
    exec_csound(csdbuffer, False, bpm, "basso_dinamico_sinusoide")

