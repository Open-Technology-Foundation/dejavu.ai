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
if '/usr/share/dejavu.ai' not in sys.path:
  sys.path.append('/usr/share/dejavu.ai')
from dejavu_std import *

AWE_URL       = 'https://raw.githubusercontent.com/f/awesome-chatgpt-prompts/main/prompts.csv'
AWE_CSV_FILE  = 'awesome-gpt-prompts.csv'
AWE_JSON_FILE = 'awesome-gpt-prompts.json'

def convert_awesome_csv_to_json(csv_file: str, indent: int = 2):
  """ convert_awesome_csv_to_json """
  csv_rows = []
  with open(csv_file) as AWE_CSV_FILE:
    reader = csv.DictReader(AWE_CSV_FILE)
    title = reader.fieldnames
    for row in reader:
      csv_rows.extend([{title[i]:row[title[i]] for i in range(len(title)) if title[i] == 'act' or title[i] == 'prompt'}])
  return json.dumps(csv_rows, indent=indent)


def alpha_sort_json(json_str, key, indent: int = 2):
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


def search_awesome_prompt(act: str) -> str:
  """ search for awesome prompt with key """
  data = json.load(open(AWE_JSON_FILE))
  for item in data:
    if act == item['act'].strip():
      return item['prompt']
  return ''


def list_awesome_prompt():
  """ list awesome prompts """
  data = json.load(open(AWE_JSON_FILE))
  i = 0
  for item in data:
    i += 1
    print(str(i) + '. ' + item['act'] + ':', item['prompt'], '\n---')
  return ''


def update_awesome(verbose=True) -> bool:
  """ update awesome prompts """
#  global AWE_CSV_FILE, AWE_JSON_FILE, AWE_URL
  if verbose:
    printinfo(f'Updating {AWE_JSON_FILE}')
    printinfo(f'  from {AWE_URL}')
  try:
    response = requests.get(AWE_URL, timeout=5)
  except Exception as e:
    printerr(f'Could not obtain {AWE_CSV_FILE} from {AWE_URL}')
    printerr(e)
    return False

  if str(response) != '<Response [200]>':
    printerr(f'Could not obtain {AWE_CSV_FILE} from {AWE_URL}')
    return False

  try:
    writefile(AWE_CSV_FILE, response.text)
  except:
    printerr(f'Error writing {AWE_CSV_FILE}')
    return False

  text = convert_awesome_csv_to_json(AWE_CSV_FILE)
  os.remove(AWE_CSV_FILE)
  writefile(AWE_JSON_FILE, alpha_sort_json(text, 'act'))
  if verbose:
    printinfo(f'{AWE_JSON_FILE} has been updated.')
  return True


def select_awesome_prompt(aw_args) -> str:
  """
  Select an awesome prompt from list.
    select_awesome_prompt(['update'])
    select_awesome_prompt(['list'])
    select_awesome_prompt(['select'])
  """
  chop_len = 32  # max length for prompt title field
  try:
    for awarg in aw_args:
      if awarg in ('-u', '--update', 'update', 'upgrade'):
        update_awesome()
        return ''
      if awarg in ('-l', '--list', 'list'):
        list_awesome_prompt()
        return ''
      if awarg in ('-s', '--select', 'select'):
        pass
      else:
        pass
    acts = key_values_list(readfile(AWE_JSON_FILE), 'act')
    awe_prompt = ''
    while True:
      key = selectList(acts, 'Select Awesome Prompt', chop_len)
      if key == 'q':
        awe_prompt = ''
        break
      if key:
        awe_prompt = search_awesome_prompt(key)
        if len(awe_prompt) == 0:
          printerr(f'{key} not found!')
          continue
        printinfo(f'{key}: {awe_prompt}', prefix='')
      key = input_key('Send this prompt to GPT?', ['y', 'n', 'q'])
      if key == 'q':
        awe_prompt = ''
        break
      if key == 'y':
        break
  except:
    print()
    return ''
  return awe_prompt


# end
