import datetime
import subprocess
import shutil
import sys
import os
import inspect
import struct
from decimal import Decimal

available_instruments = []
available_opcodes = []

effetto_file_instrument="""
instr effetto_master

Sname = p4
p3 = filelen(Sname)

itab ftgen 0, 0, 0, 1, Sname, 0, 0, 0

aSigs[] loscilx 1, 1, itab
ifilechnls = filenchnls(Sname)

seed 0

;parametri

;inizio

out aSigs

endin\n
"""

effetto_zakspace_instrument="""
instr effetto_master


seed 0

a1 zar 1
a2 zar 2

;parametri

;inizio

outs a1, a2
zacl 0, 2

endin\n
"""



# --------------
# LETTORE FILE
# --------------
def reperisci(modules):

    #codici da mischiare
    reference = modules if type(modules) is not list else modules[0]
    with open(reference, 'r') as f:
        csound_filebuffer = f.read()
    
    

    if type(modules) is list and len(modules) > 1:

        moduleindex = max(csound_filebuffer.find('\n', csound_filebuffer.rfind("endin"))+1,
                      csound_filebuffer.find('\n', csound_filebuffer.rfind("endop"))+1)

        for i in range(1, len(modules)):
            with open(modules[i], 'r') as ftemp:
                module_buffer = ftemp.read()
            


            #trova l'indice che viene prima, tra gli opcode e gli strumenti
            start_index = min(module_buffer.find("instr"), module_buffer.find("opcode"))
            if start_index <0:
                start_index=max(module_buffer.find("instr"), module_buffer.find("opcode"))
            
            end_index = max(module_buffer.find('\n', module_buffer.rfind("endin"))+1,
                            module_buffer.find('\n', module_buffer.rfind("endop"))+1)

            module_buffer = module_buffer[start_index:end_index]

            csound_filebuffer=csound_filebuffer[: moduleindex] +'\n'+ module_buffer +'\n'+ csound_filebuffer[moduleindex :]
            moduleindex+= len(module_buffer)+2


    #aggiunge strumenti e opcode a lista di nomi reperibili
    temp_index=csound_filebuffer.find("instr")
    print("Available instruments:")
    while temp_index != -1:
        lunghezza_parola=(len("instr"))+1

        eol = csound_filebuffer.find('\n', temp_index)
        instr_name = csound_filebuffer[temp_index+lunghezza_parola:eol]
        print(instr_name)
        available_instruments.append(instr_name)

        temp_index = csound_filebuffer.find("instr", temp_index+lunghezza_parola)
    
    print("\nAvailable opcodes:")
    temp_index=csound_filebuffer.find("opcode")
    while temp_index != -1:
        lunghezza_parola=(len("opcode"))+1
        eol = csound_filebuffer.find('\n', temp_index)
        
        opcode_name = csound_filebuffer[temp_index+lunghezza_parola:csound_filebuffer.find(',', temp_index+lunghezza_parola)]
        print(opcode_name)
        available_opcodes.append(opcode_name)

        temp_index = csound_filebuffer.find("opcode", temp_index+lunghezza_parola)
    print('\n')


    return csound_filebuffer





# ------------------
# INTABELLATORE
# ------------------

# non mi sorprenderebbe se questo codice risultasse essere
# incredibilmente inefficiente ( e deficiente )
def intabella(csound_filebuffer, onset, dur_sezione, instr, *argv):

    # se uso uno strumento non precedentemente riperito, ritorna fail
    for name in instr:
        if name not in instr:
            print("ERRORE: Hai utilizzato uno strumento non reperibile!\n")
            return -1

    #trova prima pos nello score
    writeindex = csound_filebuffer.find('\n', csound_filebuffer.find("<CsScore>"))+1

    #"pulisce" lo score se è la prima chiamata
    if not intabella.called:
        csound_filebuffer = csound_filebuffer[:writeindex] + csound_filebuffer[csound_filebuffer.find("</CsScore>"):]




    #strumenti chiamati
    if type(instr) is not list: instr = [instr]
    instrnum = len(instr)

   

    #hashmap di liste
    arguments={}
    arguments_indx={}
    previous_pfields={}
    final_pfields = {}

    #fa mapping per gli elementi unici
    instr_unique = list(dict.fromkeys(instr))

    #prende solo tante liste pfield quanto sono gli strumenti senza duplicati
    for i in range(len(instr_unique)):

        #in caso che le liste pfield siano minori degli strumenti
        #allora le riutilizza
        argv_indx = i%len(argv)

        # I PFIELD PER STRUMENTO SONO PER FORZA LISTE
        # PERCHE' DEVONO INCLUDERE INIZIO E DURATA NELLO SCORE (P2 E P3)
        if type(argv[argv_indx]) is not list or not argv:
            print("ERRORE: Non hai inserito il numero di pfield corretti\n")
            return -1
        
        else:
            for j in range(len(argv[argv_indx])):
                if type(argv[argv_indx][j]) is not list: argv[i][j] = [argv[i][j]]
            
            arguments[instr_unique[i]]=argv[argv_indx]
            arguments_indx[instr_unique[i]]=[0 for _ in range(len(argv[argv_indx]))]
            previous_pfields[instr_unique[i]]=[0 for _ in range(len(argv[argv_indx]))]
            final_pfields[instr_unique[i]]=[[] for _ in range(len(argv[argv_indx]))]




    #INTABELLATURA |||
    count = onset
    instr_indx = 0

    while count < dur_sezione+onset:

        instr_indx %= instrnum
        instr_name = instr[instr_indx]
        line = "i " + "\""+str(instr_name)+"\""

        #pfields 
        for i in range(len(arguments[instr_name])):
            val = arguments[instr_name][i][arguments_indx[instr_name][i]]


            #per le lambda
            #scusa fa davvero schifo
            if inspect.isfunction(val):
                val_args=inspect.getfullargspec(val)[0]
                if not val_args:
                    val = arguments[instr_name][i][arguments_indx[instr_name][i]]()
                else:
                    call_args = []

                    for arg in val_args:
                        if arg == 'x':

                            # QUESTE DIFFERENZE,
                            # QUANDO TROPPO PICCOLE,
                            # POSSONO CAUSARE QUELLO CHE E' CHIAMATA
                            # IN ANALISI NUMERICA 
                            # "CATASTROPHIC CANCELLATION",
                            # DOVE L'APPROSSIMAZIONE DEL VALORE RISULTANTE
                            # E' TOTALMENTE SBAGLIATA
                            #
                            # per questo uso la library decimal
                            # in ogni caso, è molto probabile che il problema si presenti a causa
                            # delle funzioni utility che operano tutte a livello float,
                            # sempre per lo stesso motivo
                             
                            current_pos=Decimal(count)-Decimal(onset)
                            if i>0: current_pos -= Decimal(previous_pfields[instr_name][0])

                            call_args.append(float(current_pos /Decimal(dur_sezione)))
                        elif arg[0] == 'p':
                            #arg nome = "pN" quindi prende dall'indice 1 e non 0
                            #-2 perchè il pfield più piccolo che elabora è p2 che è uguale a i == 0
                            pfieldnum = int(arg[1:])-2
                            call_args.append(previous_pfields[instr_name][pfieldnum])
                        else:
                            print("ERRORE: Pfield lambda con parametro non valido!\n")
                            return -1

                    # in base all'ordine di I e dei pfield potrebbe prendere il pfield corrente o quello precedente.
                    val = arguments[instr_name][i][arguments_indx[instr_name][i]](*call_args)
                    
            

            #per le liste in liste
            if type(val) is list:
                arguments[instr_name][i][arguments_indx[instr_name][i]:arguments_indx[instr_name][i]] = val
                val = val[0]

            #stringhe automaticamente aggiungono le virgolette
            if isinstance(val, str):
                val = "\"" + val +"\""

            #per aumentare il tempo
            # i == 0 significa che si riferisce a p2
            if i == 0:
                line += ' ' + str(count)
                count+= val
            else:
                line += ' ' + str(val)

            arguments_indx[instr_name][i] +=1
            arguments_indx[instr_name][i] %= len(arguments[instr_name][i])
            previous_pfields[instr_name][i] = val

            final_pfields[instr_name][i].append(val)



        line += '\n'
        csound_filebuffer = csound_filebuffer[: writeindex] + line + csound_filebuffer[writeindex :]      

        instr_indx +=1
        #sposta indice di scrittura
        writeindex+=len(line)
    
    line = ";CALL " + str(intabella.called) +" ^^^\n"
    csound_filebuffer = csound_filebuffer[: writeindex] + line + csound_filebuffer[writeindex :]      
    writeindex+=len(line)

    intabella.called += 1

    intabella.durata_cumulativa=max(dur_sezione+onset, intabella.durata_cumulativa)

    return csound_filebuffer, final_pfields, intabella.durata_cumulativa
intabella.called=0
intabella.durata_cumulativa=0


# --------------
# EFFETTATORE
# --------------
def effetta_file(csound_filebuffer, subject, fx_chain=[], fx_parameters=[[]]):

    for fx in fx_chain:
        if fx not in available_opcodes:
            print("ERRORE: Hai utilizzato un opcode non reperibile!\n")
            return -1

    #aggiunge il concatenatore
    writeindex=max(csound_filebuffer.find('\n',csound_filebuffer.rfind("endop"))+1,
                   csound_filebuffer.find('\n',csound_filebuffer.rfind("endin"))+1)
    
    csound_filebuffer = csound_filebuffer[: writeindex] + effetto_file_instrument + csound_filebuffer[writeindex :]



    # -- PARAMETRI --
    writeindex = csound_filebuffer.find(";parametri")
    if writeindex == -1:
        print("ERRORE: Non esiste punto di inizio per i parametri dell'effettatore\n")
        return -1
    
    csound_filebuffer = csound_filebuffer[: writeindex] + csound_filebuffer[writeindex+len(";parametri"):]

    parameter_variable_list=[]
    pcounter=1
    for parameter_list in fx_parameters:
        if type(parameter_list) is not list: parameter_list = [parameter_list]

        temp=[]
        for parameter in parameter_list:

            temp.append("kp"+str(pcounter))
            line ="kp" + str(pcounter) +' '

            #LINSEG QUI
            if type(parameter) is list:
                line+= "linseg "

                for j in range(len(parameter)):
                    if j%2!=0: line+="p3*"
                    line+=str(parameter[j]) + ', '
                
                line = line[:-2]
            else:
                line+= "= " + str(parameter)

            
            line+='\n'

            csound_filebuffer = csound_filebuffer[: writeindex] + line + csound_filebuffer[writeindex :]
            writeindex+=len(line)

            pcounter+=1
        
        parameter_variable_list.append(temp)
        
    print(parameter_variable_list)



    # -- CANALI --
    nchannels_subject=0
    with open(subject, 'rb') as f1:
        header_beginning = f1.read(0x18)
        nchannels_subject, = struct.unpack_from('<H', header_beginning, 0x16)    

    chnls_indx = csound_filebuffer.find("nchnls")
    csound_filebuffer = csound_filebuffer[:csound_filebuffer.find('=', chnls_indx)] + "= "+str(nchannels_subject) + csound_filebuffer[csound_filebuffer.find('\n', chnls_indx):]



    # -- EFFETTI -- 
    writeindex = csound_filebuffer.find(";inizio")
    if writeindex == -1:
        print("ERRORE: Non esiste punto di inizio per l'effettatore\n")
        return -1

    csound_filebuffer = csound_filebuffer[: writeindex] + csound_filebuffer[writeindex+len(";inizio"):]

    out_var_name="aSigs"
    for j in range(nchannels_subject):
        for i in range(len(fx_chain)):
            line = out_var_name+"[" +str(j)+"] " + fx_chain[i] + ' '+ out_var_name+"["+str(j)+"], "
            for parameter in parameter_variable_list[i%len(parameter_variable_list)]:
                line+= parameter+ ', '


            line = line[:-2]
            line +='\n'

            csound_filebuffer = csound_filebuffer[: writeindex] + line + csound_filebuffer[writeindex :]
            writeindex+=len(line)

    if not intabella.called:
        writeindex = csound_filebuffer.find('\n', csound_filebuffer.find("<CsScore>"))+1
        csound_filebuffer = csound_filebuffer[:writeindex] + csound_filebuffer[csound_filebuffer.find("</CsScore>"):]

    writeindex=csound_filebuffer.find("</CsScore>")
    line = "i " + "\"effetto_master\"" + " 0" + ' 1 ' + '\"'+subject+'\"' +'\n'
    
    csound_filebuffer = csound_filebuffer[: writeindex] + line + csound_filebuffer[writeindex :]


    return csound_filebuffer


def effetta_zakspace(csound_filebuffer, dur_sezione, fx_chain=[], fx_parameters=[[]]):

    for fx in fx_chain:
        if fx not in available_opcodes:
            print("ERRORE: Hai utilizzato un opcode non reperibile!\n")
            return -1

    #aggiunge il concatenatore
    writeindex=max(csound_filebuffer.find('\n',csound_filebuffer.rfind("endop"))+1,
                   csound_filebuffer.find('\n',csound_filebuffer.rfind("endin"))+1)
    
    csound_filebuffer = csound_filebuffer[: writeindex] + effetto_zakspace_instrument + csound_filebuffer[writeindex :]



    # -- PARAMETRI --
    writeindex = csound_filebuffer.find(";parametri")
    if writeindex == -1:
        print("ERRORE: Non esiste punto di inizio per i parametri dell'effettatore\n")
        return -1
    
    csound_filebuffer = csound_filebuffer[: writeindex] + csound_filebuffer[writeindex+len(";parametri"):]

    parameter_variable_list=[]
    pcounter=1
    for parameter_list in fx_parameters:
        if type(parameter_list) is not list: parameter_list = [parameter_list]

        temp=[]
        for parameter in parameter_list:

            temp.append("kp"+str(pcounter))
            line ="kp" + str(pcounter) +' '

            #LINSEG QUI
            if type(parameter) is list:
                line+= "linseg "

                for j in range(len(parameter)):
                    if j%2!=0: line+="p3*"
                    line+=str(parameter[j]) + ', '
                
                line = line[:-2]
            else:
                line+= "= " + str(parameter)

            
            line+='\n'

            csound_filebuffer = csound_filebuffer[: writeindex] + line + csound_filebuffer[writeindex :]
            writeindex+=len(line)

            pcounter+=1
        
        parameter_variable_list.append(temp)
        
    print(parameter_variable_list)


    # -- EFFETTI -- 
    writeindex = csound_filebuffer.find(";inizio")
    if writeindex == -1:
        print("ERRORE: Non esiste punto di inizio per l'effettatore\n")
        return -1

    csound_filebuffer = csound_filebuffer[: writeindex] + csound_filebuffer[writeindex+len(";inizio"):]

    out_var_name="a"
    for j in range(2):
        for i in range(len(fx_chain)):
            line = out_var_name+ str(j+1) + ' ' + fx_chain[i] + ' ' + out_var_name + str(j+1) +', '
            for parameter in parameter_variable_list[i%len(parameter_variable_list)]:
                line+= parameter+ ', '


            line = line[:-2]
            line +='\n'

            csound_filebuffer = csound_filebuffer[: writeindex] + line + csound_filebuffer[writeindex :]
            writeindex+=len(line)

    if not intabella.called:
        writeindex = csound_filebuffer.find('\n', csound_filebuffer.find("<CsScore>"))+1
        csound_filebuffer = csound_filebuffer[:writeindex] + csound_filebuffer[csound_filebuffer.find("</CsScore>"):]

    writeindex=csound_filebuffer.find("</CsScore>")
    line = "i " + "\"effetto_master\"" + " 0 " + str(dur_sezione) +'\n'
    
    csound_filebuffer = csound_filebuffer[: writeindex] + line + csound_filebuffer[writeindex :]


    return csound_filebuffer





# scrive infine il file csound su disco e lo esegue
def exec_csound(csound_filebuffer, ismidi, tempo, nome="intabellatore", print_debug=True):

    if print_debug: print(csound_filebuffer)
    
    if not hasattr(exec_csound, "called"):
        exec_csound.called = 0  # it doesn't exist yet, so initialize it

    # SCRIVE FILE SU DISCO
    time = datetime.datetime.now()
    timestring = ' ' +time.strftime("%d%m%y-%H%M%S")

    if exec_csound.called:
        timestring=''

    outputdir = "out"

    if not os.path.exists(outputdir + '/'):
        os.mkdir(outputdir)

    newcsdpath ="\"" + outputdir +'/'+ nome + timestring + ".csd\""
    
    writepath =newcsdpath[newcsdpath.find(outputdir):].removesuffix('\"')

    with open(writepath, 'w') as f:
        f.write(csound_filebuffer)

    # ESEGUE CSOUND
    if ismidi:       
        subprocess.run(["csound",
                         writepath,
                         "-t",
                         str(tempo),
                         "--midiout=\"" + writepath.replace(".csd", '') + ".mid\""
                         ])
    else:
        newfile = writepath.replace(".csd", '') + ".wav"

        subprocess.run(["csound", 
                        writepath,
                        "-t",
                        str(tempo),
                        "-W",
                        "-3",
                        "-o",
                        newfile
                        ])

    # fai una copia di questo script 
    shutil.copy(sys.argv[0], writepath.replace(".csd", '') +".py")

    exec_csound.called += 1

    return writepath
