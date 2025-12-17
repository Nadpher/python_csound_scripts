import math
import random
import itertools
import os

# ----- UTILITY -----

# FILE

def get_folder_wavs(directory):
    dir_list = os.listdir(directory)

    return [ directory + val for val in list(filter(lambda x: ".wav" in x, dir_list))]




# direct functions
def freq_to_note(freq, diapason=440):
    LA3 = 69
    return LA3 + 12*math.log2(freq/diapason)

def note_to_freq(note, diapason=440):
    LA3 = 69
    return math.pow(2, (note-LA3)/12) * diapason

def clamp(val, smallest, biggest):
    return max(smallest, min(val, biggest))

def scale(val, inmin, inmax, outmin, outmax):
    return ((val-inmin)/(inmax-inmin))*(outmax-outmin) + outmin


#time functions (using lambda x: x/durata), quindi sempre normalizzato tra 0 e 1
def time_start_from(t, start_pos):
    return max(0, (t-start_pos)/(1-start_pos) )

def time_end_at(t, end_pos):
    return min(1, t * (1./end_pos))

def time_repeat(t, times):
    return (t*times) % 1.001


def exponential(t, minrange, maxrange, curve):
    return scale(t ** curve, 0, 1, minrange, maxrange)

def triangular(t, peak):

    if t <= peak:
        return (peak - abs(t-peak)) / peak
    else:
        remainder = 1-peak
        return abs((t-peak)-remainder) / remainder


def random_subdivisions(bpm, volte, min_sub, max_sub):
    unit = 60./bpm
    # unit è equivalente a 1 in beats
    out=[]

    for _ in range(volte):
        subdivision = random.randint(min_sub, max_sub)
        temp = [unit/subdivision] * subdivision

        out.extend(temp)

    return out    


# --- FUNZIONI LINSEG ---


# i valori di tempo sono percentuali di p3 in questo caso.
# principalmente e/o solo utilizzabile con l'effettatore
def linseg_random(min_value, max_value, max_step):

    random.seed()

    i=0

    step = 0
    table=[]
    while i<1:
        
        val = random.uniform(min_value, max_value)
        table.append(val)

        step = random.uniform(0, max_step)
        i+=step

        table.append(step)
        if i>1: i-= (i-1)

    table.append(random.uniform(min_value, max_value))

    return table

def linseg_repeat(values, times):
    for i in range(1, len(values), 2):
        values[i] = values[i]* (1./times)
    
    values.append(0.01)
    out = values * times
    out = out[:-1]
    
    return out

def linseg_instant(values):
    out=[]

    unflattened = list(itertools.batched(values, 2))
    for i in range(len(unflattened)-1):
        pair = list(unflattened[i])
        pair.extend(pair)
        pair[len(pair)-1]=0.01
        out.extend(pair)
    
    out.append(0)

    return out

def linseg_append(values, append_list):
    total_append_time=0
    for i in range(1, len(append_list), 2):
        total_append_time+=append_list[i]

    rescale_factor = 1-total_append_time

    print(total_append_time)
    print(rescale_factor)
    for i in range(1, len(values), 2):
        values[i] *= rescale_factor
    
    return values+append_list[1:]

def linseg_prepend(values, append_list):
    total_append_time=0
    for i in range(1, len(append_list), 2):
        total_append_time+=append_list[i]

    rescale_factor = 1-total_append_time
    for i in range(1, len(values), 2):
        values[i] *= rescale_factor
    
    return append_list[:-1]+values

#TODO: STUDIATI o i polinomi di newton o di lagrange e reimplementa
def linseg_approximate_exponential(values, curve, inbetweens):
    out = []

    unflattened = list(itertools.batched(values, 2))
    for i in range(len(unflattened)-1):
        value_range = abs(unflattened[i][0]- unflattened[i+1][0])
        if unflattened[i][0] < unflattened[i+1][0]:
            new_values = [unflattened[i][0]+pow((((value_range/inbetweens)*j)/value_range), curve) for j in range(inbetweens)]
        else:
            new_values = [unflattened[i][0]-pow((((value_range/inbetweens)*j)/value_range), curve) for j in range(inbetweens)]

        new_times = [(unflattened[i][1]/inbetweens) for _ in range(inbetweens)]

        out.extend(zip(new_values, new_times))
    out = list(itertools.chain.from_iterable(out))
    out.append(values[len(values)-1])

    return out

def linseg_retrogrado(values):
    for i in range(1, len(values), 2):
        values[i] /=2
    
    return values + list(reversed(values[:-1]))

def linseg_p2_to_relative_time(values, durata):
    for i in range(1, len(values), 2):
        values[i] /=durata

    return values


