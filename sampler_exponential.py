import random
import math

from intabellatore_utilities import *

from intabellatore_engine import *


if __name__ == "__main__":
        
    codici = ["sample_simple.csd", "effetto_amp.csd", "effetto_filtro.csd", "effetto_pitch.csd"]
    bpm = 60

    random.seed()

    # instr è l'unica cosa che non può usare lambda.
    # in quanto il mapping strumenti-pfield succede prima della 
    # chiamata consecutiva dei pfield

    

    csd_buffer = reperisci(codici)
    durata = 20

    curve =2

    onset=0
    for _ in range(20):
        durata = random.uniform(0.1, 1.3)
        curve = random.uniform(.5, 4)

        csd_buffer, pfields, durata_effettiva =intabella(csd_buffer,
                        onset,
                        durata,
                        ["sample_simple"],
                        [
                            lambda x: exponential(x, .05, .5, curve),
                            lambda x: exponential(x, .1, .05, curve),
                            random.choice(get_folder_wavs("samples/")),
                            random.uniform(0,1),
                            0.1,
                            random.uniform(1,200),
                            lambda x: exponential(x, .5, 0, curve),
                            1,
                            lambda: random.uniform(0, 1)
                        ]
        )
        onset += durata

    fx_chain = [
 #        "filtro_bp",
         "amp"
          ]
    
    max_amp = 16
    fx_parameters=[
 #       [random.uniform(100, 1000), 250],
        [linseg_prepend(linseg_append(linseg_random(1, max_amp, .05), [0, .25,max_amp*4]), [max_amp,.1,0])]
    ]

    if csd_buffer != -1:
        csd_buffer = effetta_zakspace(csd_buffer, durata_effettiva, fx_chain, fx_parameters)

    if csd_buffer != -1: exec_csound(csd_buffer, False, bpm, "sampler_exponential", True)

