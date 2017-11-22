# -*- coding: utf-8 -*-
"""
Octubre 2017

@author: Jose D. Mateo

"""
import unidecode
import pandas as pd
import numpy as np
from selenium import webdriver
from bs4 import BeautifulSoup
from time import sleep
from datetime import datetime


def pulsar_boton(numero_boton):
  driver.execute_script("eval('getEntidades("+ str(numero_boton) +")');")
  sleep(10)


def extraer_info():
  soup = BeautifulSoup(driver.page_source, 'lxml')
  attr = {'id':'datos'}
  datos_web = soup.find('div', attr)
  l_valor_v = list()
  td_s = datos_web.find_all("td") 
  
  for td in td_s:
    l_valor_v.append(td.string) 
    
  l_valor_v = [x for x in l_valor_v if x is not None]
  l_valor_v = [x.strip() for x in l_valor_v]
  
  indices = list(range(2,61,3))
  l_valor_v = [v for i, v in enumerate(l_valor_v) if i not in indices]
  
  l_campos_v = ["NumeroInscripcion", "Nombre"]
  l_campos_v = l_campos_v*(len(l_valor_v)//2)
  
  l_campos = list()
  l_valor = list()
  li_s = datos_web.find_all("li") 
  for li in li_s:
    try:
      str_linea = li.get_text()
      campo = str_linea[:str_linea.index(":")].replace(" ", "").replace(".", "").replace("\n","")
      campo = unidecode.unidecode(campo)
      valor = str_linea[str_linea.index(":")+2:].replace("\n","")
      l_campos.append(campo) 
      l_valor.append(valor)
      l_valor = [x.replace("\t","") for x in l_valor]
      
    except:
      continue
  
  indices_ini = list(range(0,239,12))
  indices_fin = list(range(12,239,12))
  indices_fin.append(240)
  
  lista_dicts = list()
  for i in zip(indices_ini, indices_fin):
    d1 = dict(zip(l_campos_v[(i[0]//12)*2:(i[0]//12)*2+2], l_valor_v[(i[0]//12)*2:(i[0]//12)*2+2]))
    d2 = dict(zip(l_campos[i[0]:i[1]], l_valor[i[0]:i[1]]))
    lista_dicts.append({**d1, **d2})
    
  return(lista_dicts)
    
    
print("Iniciando driver")
driver = webdriver.Chrome() 
web =  (###### INTRODUCIR WEB  ######)
print("Iniciando extracción de información\n\n", "Web: ", web, "\n")
driver.get(web)

start_button = driver.find_element_by_class_name("botonEstilizado")
sleep(3)
start_button.click()
sleep(15)

lista_final = extraer_info()
lista_fallos = list()
print(datetime.now().strftime('%H:%M:%S'), " - Página 1 - Ok")

for i in range(2, 1179):
  try:
    pulsar_boton((i-1)*20)
    lista_final += extraer_info()
    print(datetime.now().strftime('%H:%M:%S'), (" - Página %d - Ok" % i))
  
  except:
    print("Falló la extracción de la página %d" % i)
    lista_fallos.append(i)
    continue
  
driver.close()


df = pd.DataFrame(lista_final)
cols = ["NumeroInscripcion", "Nombre", "Deporte", "Tipo", "Direccion", "Municipio", "Provincia", "CP", "Fechainscripcion", "Telefono", "Email", "Fax", "Mod_est", "Otrosd"]
df = df[cols]
df = df.replace('----', np.nan)
df = df.replace('*', np.nan)
df.to_csv("BD_asociaciones_deportivas_AND.csv", sep=";", index=False)

if len(lista_fallos)==0: print("Script Finalizado con éxito") 
if len(lista_fallos)>0: print("Script Finalizado.\nFallaron las páginas: ", lista_fallos)
