import random
import math

from intabellatore_utilities import *

from intabellatore_engine import *


if __name__ == "__main__":
        
    codici = ["subtractive_noise.csd", "effetto_amp.csd", "effetto_filtro.csd", "effetto_pitch.csd"]
    bpm = 60

    random.seed()

    # instr è l'unica cosa che non può usare lambda.
    # in quanto il mapping strumenti-pfield succede prima della 
    # chiamata consecutiva dei pfield

    csd_buffer = reperisci(codici)
    durata = 40

    p2 = [0.1] + [lambda p2: max(0.01, p2 + random.choice([0.001, -0.001]))]*1000

    csd_buffer, pfields =intabella(csd_buffer,
                    0,
                    durata,
                    ["subtractive_noise"],

                    [
                        durata,
                        durata,
                        0.4,
                        .99,
                        0,
                        0.25
                    ]
    )

    fx_chain = [
        "amp",
        #"pitch",
        "filtro_bp"]
    fx_parameters=[
        [[1, 0.5, 4, 0.5, 1]],
        #[linseg_repeat(linseg_random(0, 1, 0.1), 5)],
        [linseg_random(80, 1000, .5), [1000, .25, 50, .5, 50, .25, 100]]
    ]

    if csd_buffer != -1:
        csd_buffer = effetta_zakspace(csd_buffer, durata, fx_chain, fx_parameters)

    if csd_buffer != -1: exec_csound(csd_buffer, False, bpm, "noise_focus", False)

