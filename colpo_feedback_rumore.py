import random

from intabellatore_utilities import *

from intabellatore_engine import *


if __name__ == "__main__":
    
    
    codici = ["click_comb.csd"]
    bpm = 60

    random.seed()

    #liste

    #instr è l'unica cosa che non può usare lambda.
    # in quanto il mapping strumenti-pfield succede prima della 
    # chiamata consecutiva dei pfield

    csdbuffer = reperisci(codici)
    durata = 90

    #sampler
    csdbuffer,pfield = intabella(
            csdbuffer,
            0,               #onset
            durata,          #durata sezione in secondi
            bpm,             #bpm
              
            "click_comb", #comb

            #da qui in giù pfield
            [[0 for _ in range(100)] + [durata],
             durata, 
             0.18, 
             lambda: random.uniform(50, 1000), 
             lambda: 0.999] 
        )
    
#   csdbuffer = intabella(
#          csdbuffer,
#          durata/2,
#          False,
#          bpm,             #bpm
#          durata/2,          #durata sezione in secondi
#          "\"sample_simple\"", #sampler
#            
#          #da qui in giù pfield
#
#      )
#          [lambda: random.uniform(0.12, 1), lambda:random.uniform(0.1, 3), "\"samples/posso parlare-loud.wav\"", 0, lambda:random.uniform(0.5, 1), lambda:random.uniform(50, 1000), lambda:random.uniform(0,1), 0.5] 

    print(csdbuffer)
    exec_csound(csdbuffer, False, bpm, "stochastic_sampler")
    

