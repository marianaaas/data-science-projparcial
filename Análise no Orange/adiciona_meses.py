import pandas as pd
import numpy as np

def listToString(s):
 
    str1 = ""
 
    # traverse in the string
    for ele in s:
        str1 += ele
 
    # return string
    return str1
 

df = pd.read_csv("datatran2019_mari.csv") # nome do arquivo que deseja

data = df[['data_inversa']]

list = data.values.tolist() # transforma os dados em listas para depois transformar cada elemento em string

stri = []
# Neste passo, 
for i in range(len(list)):
    aux1 = listToString(list[i]) # transformando cada dado em string para depois separar os dados pela função split
    stri.append(aux1) 

print(stri)
print("tam string:/n")
print(type(stri))
print(len(stri))

data2 = []
for i in range(len(stri)):
    aux1 = stri[i].split('-') # separa as strings a cada '-'
    data2.append(aux1) 

print(data2[2]) # pega somente os dados que dão os meses


df1 = pd.DataFrame(data2) # transforma-os em dataframes

print(df1[1])

meses = df1[1].to_numpy() # transforma em numpy
print(meses)
print(len(meses))

meses_string = [["Jan"], ["Fev"], ["Mar"], ["Abr"], ["Mai"], ["Jun"], ["Jul"], ["Ago"], ["Set"], ["Out"], ["Nov"], ["Dez"] ]
meses1 = []

# obtem um novo vetor para mostrar os meses em formato de strings
for i in range (len(meses)):
    if(meses[i] == '01'):
        meses1.append(meses_string[0])
    elif (meses[i] == '02'):
        meses1.append(meses_string[1])
    elif (meses[i] == '03'):
        meses1.append(meses_string[2])
    elif (meses[i] == '04'):
        meses1.append(meses_string[3])
    elif (meses[i] == '05'):
        meses1.append(meses_string[4])
    elif (meses[i] == '06'):
        meses1.append(meses_string[5])
    elif (meses[i] == '07'):
        meses1.append(meses_string[6])
    elif (meses[i] == '08'):
        meses1.append(meses_string[7])
    elif (meses[i] == '09'):
        meses1.append(meses_string[8])
    elif (meses[i] == '10'):
        meses1.append(meses_string[9])
    elif (meses[i] == '11'):
        meses1.append(meses_string[10])
    elif (meses[i] == '12'):
        meses1.append(meses_string[11])

print(meses1)

meses_df = pd.DataFrame(meses1)

print(meses_df)

stri2 = []
for i in range(len(list)):
    aux1 = listToString(meses1[i]) # retorna para string para mostrar mais bonitinho no arquivo
    stri2.append(aux1) 

    
df2 = pd.DataFrame({'meses': stri2})
df1 = pd.concat([df, df2], axis=1) # concatena o dado já obtido com a coluna meses gerada

print(df1)

df1.to_csv("dados_novos.csv") # nome do novo arquivo gerado
print("Done")