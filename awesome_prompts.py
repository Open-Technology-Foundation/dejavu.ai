#!/usr/bin/python3
"""
"Awesome Prompts"
https://raw.githubusercontent.com/f/awesome-chatgpt-prompts/main/prompts.csv
"""
import os
import sys
import csv
import json
import requests
if not '/usr/share/dejavu.ai' in sys.path: sys.path.append('/usr/share/dejavu.ai')
from dejavu_std import *

URL       = 'https://raw.githubusercontent.com/f/awesome-chatgpt-prompts/main/prompts.csv'
CSV_FILE  = 'awesome-gpt-prompts.csv'
JSON_FILE = 'awesome-gpt-prompts.json'

def convert_awesome_csv_to_json(csv_file, indent=2):
  """ convert_awesome_csv_to_json """
  csv_rows = []
  with open(csv_file) as CSV_FILE:
    reader = csv.DictReader(CSV_FILE)
    title = reader.fieldnames
    for row in reader:
      csv_rows.extend([{title[i]:row[title[i]] for i in range(len(title)) if title[i] == 'act' or title[i] == 'prompt'}])
  return json.dumps(csv_rows, indent=indent)

def alpha_sort_json(json_str, key, indent=2):
  """ alpha_sort_json """
  json_data = json.loads(json_str)
  sorted_json = sorted(json_data, key=lambda j: j[key])
  return json.dumps(sorted_json, indent=indent)

def key_values_list(json_str, key):
  """ key_values_list """
  json_data = json.loads(json_str)
  key_list = []
  for item in json_data:
    key_list.append(item[key])
  return key_list

def search_awesome_prompt(act):
  """ search_awesome_prompt """
  data = json.load(open(JSON_FILE))
  for item in data:
    if item['act'] == act:
      return item['prompt']
  return None

def list_awesome_prompt():
  """ list_awesome_prompt """
  data = json.load(open(JSON_FILE))
  i = 0
  for item in data:
    i += 1
    print(str(i) + '. ' + item['act'] + ':', item['prompt'], '\n---')
  return None

def update_awesome():
  """ update awesome prompts """
#  global CSV_FILE, JSON_FILE, URL
  printinfo(f'Updating {JSON_FILE}')
  printinfo(f'  from {URL}')
  response = requests.get(URL, timeout=5)
  if str(response) != '<Response [200]>':
    printerr(f'Could not obtain {CSV_FILE} from {URL}')
    return False
  try:
    writefile(CSV_FILE, response.text)
  except:
    printerr(f'Error writing {CSV_FILE}')
    return False
  text = convert_awesome_csv_to_json(CSV_FILE)
  os.remove(CSV_FILE)
  writefile(JSON_FILE, alpha_sort_json(text, 'act'))
  printinfo(f'{JSON_FILE} has been updated.')
  return True

def select_awesome_prompt(aw_args):
  """ 
  Select an awesome prompt from list. 
    select_awesome_prompt(['update'])
    select_awesome_prompt(['list'])
    select_awesome_prompt(['select'])
  """
  global ScreenColumns
  try:
    for awarg in aw_args:
      if awarg in ('-u', '--update', 'update', 'upgrade'):
        update_awesome()
        return ''
      elif awarg in ('-l', '--list', 'list'):
        list_awesome_prompt()
        return ''
      elif awarg in ('-s', '--select', 'select'):
        pass
      else:
        pass

    acts = key_values_list(readfile(JSON_FILE), 'act')
    awe_prompt = ''
    while True:
      while True:
        ScreenColumns = getScreenColumns()
        i = 0
        maxlen = 0
        for act in acts:
          i += 1
          nact = f'{i:3d} {act}'
          if len(nact) > maxlen: maxlen = len(nact)
        #maxlen += 1
        i = 0
        column = 0
        for act in acts:
          i += 1
          if column+maxlen > ScreenColumns: 
            print()
            column = 0
          print(f'{i:3d} {act}'.ljust(maxlen, ' '),  end='')
          column += maxlen
        if column != 0: print()
        key = input(f'Select 1-{len(acts)}/q: ')
        if key == '0' or key == 'q': 
          key = 'q'
          break
        if not is_num(key): continue
        nkey = int(str(key))
        if nkey == 0: continue 
        key = acts[nkey-1]
        break
      
      if key == 'q':
        awe_prompt = ''
        break
      if key:
        awe_prompt = search_awesome_prompt(key)
        if awe_prompt:
          printinfo(f'{key}: {awe_prompt}')
        else:
          printerr(f'{key} not found!')

      key = input('Proceed with this prompt? y/n/q: ')
      if key == 'q':
         awe_prompt = ''
         break
      if key == 'y':
        break
  except:
    print()
    return ''
  return awe_prompt

#end
