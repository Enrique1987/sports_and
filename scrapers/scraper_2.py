import csv
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from time import sleep
from datetime import datetime

print("Iniciando driver")
driver = webdriver.Chrome()

web =  (##### INTRODUCIR WEB #####)
print(datetime.now().strftime('%H:%M:%S'), " - ", "Iniciando extracción\n\n")

archivodestino = open("instalaciones_deportivas.csv", 'w', encoding='utf-8')
archivodestino.write("NRegistro;Nombre;Codigo;Prov;Com;Muni;Nuc_pob;Ano_cre;Esp_dep;Titul;Gestor;Actividad;Pav\n")
archivodestino.close()

for n_prov in range(1,9):
  driver.get(web) 
  driver.execute_script("document.getElementById('provincias').value='" + str(n_prov) + "'")
  driver.execute_script("provinciaSeleccionada()")
  sleep(3)
  all_muns = driver.find_element_by_id("municipios")
  lista_pueblos = [int(value.get_attribute("value")) for value in all_muns.find_elements_by_tag_name("option") if len(value.get_attribute("value")) > 0]
  sleep(3)
  
  for n_mun in lista_pueblos:
    try:
      driver.get(web) 
      driver.execute_script("document.getElementById('provincias').value='" + str(n_prov) + "'")
      driver.execute_script("provinciaSeleccionada()")
      sleep(1)
      driver.execute_script("document.getElementById('municipios').value='" + str(n_mun) + "'")
      sleep(1)
      driver.execute_script("buscar('basico');")
      sleep(3)
      try:
        caden = driver.find_element_by_xpath("//*[@style='border:0px solid;']").text
  
        for n_pagina in range(1, int(caden[5:])+1):
            print(datetime.now().strftime('%H:%M:%S'), " - ", "Extrayendo Provincia ", n_prov, "- Municipio ", n_mun, "- Pagina ", n_pagina)
            try:
              insert_pag = driver.find_element_by_id("inputIrA")
              insert_pag.send_keys(n_pagina)
              insert_pag.send_keys(Keys.ENTER)
              
              
              element = driver.find_element_by_id("regListado")
              info = eval(element.get_attribute('value'))
              
              with open("instalaciones_deportivas.csv",'a', newline='', encoding='utf-8') as out:
                  csv_out=csv.writer(out, delimiter=";")
                  for i in info:
                    csv_out.writerow(i)
              
              sleep(3)
            
            except:
                print(datetime.now().strftime('%H:%M:%S'), " - ", "Error al extraer pagina -> ", n_pagina)
      
      except:
        print(datetime.now().strftime('%H:%M:%S'), " - ", "Extrayendo Provincia ", n_prov, "- Municipio ", n_mun)
        element = driver.find_element_by_id("regListado")
        info = eval(element.get_attribute('value'))
              
        with open("instalaciones_deportivas.csv",'a', newline='', encoding='utf-8') as out:
            csv_out=csv.writer(out, delimiter=";")
            for i in info:
              csv_out.writerow(i)
        sleep(3)
    
    except:
      continue

driver.close()