#!/usr/bin/python3
"""
webscraper
#webpage = 'https://news.detik.com/pemilu/d-6520027/mahasiswa-demo-bakar-ban-depan-kantor-kpu-sempat-dorong-dorong-polisi'
#webpage = 'https://en.antaranews.com/news/272634/ministry-sets-up-media-center-to-improve-cultural-content-management'
"""
import os
import sys
import re
import urllib
import html
import requests
import json

script_version  = '1.0'
script_name     = os.path.realpath(sys.argv.pop(0))
script_dir      = os.path.dirname(script_name)
if not script_dir in sys.path: sys.path.append(script_dir)
script_name     = os.path.basename(script_name)

from dejavu_std import printerr, printstd, printinfo, UseColor, readfile

try:
  with open(f'{script_dir}/scrape_profiles.json', 'r') as f:
      scrapeProfiles = json.load(f)
except FileNotFoundError:
  printerr(f'{script_dir}/scrape_profiles.json could not be opened.')
  sys.exit()

def get_domain_name(url):
  """ get domain name from url """
  host = urllib.parse.urlparse(url).hostname
  if host:
    hostname = host.split('.')
    if hostname[0] == 'www':
      del hostname[0]
    return '.'.join(hostname)
  return False

def htmd(string):
  """ unescape escaped html """
  return html.unescape(string)

def strip_tags(string):
  """This function removes all HTML tags from a given string.
    Args:
        string (str): The string to be stripped of HTML tags.
    Returns:
        str: The string with all HTML tags removed.
    """
  regex = re.compile(r'<.*?>')
  return regex.sub('', string)


def remsp(string):
  """ remove all double occurances of space """
  return re.sub(r'\ +', ' ', string)

def match_tag(string, tag, stpos):
  """ match html tag in string """
  pattern = re.compile(r'<' + tag + r'[ >]')
  result = pattern.search(string, stpos)
  if result: return result.start()
  return -1

def remove_tag(htmlstring, start_tag, stTag_keyword, **kwargs):
  """ remove html tag from string """
  verbose = kwargs.get('verbose', 0)
  stTag = f'<{start_tag}'
  endTag = f'</{start_tag}>'
  stTag_index = match_tag(htmlstring, start_tag, 0)
  if verbose > 1: printstd(f'{stTag},{endTag},{stTag_index}, {stTag_keyword}')
  while stTag_index != -1:
    # find end > of start tag
    eot = htmlstring.find('>', stTag_index+1)
    if eot == -1:
      if verbose: printerr(f'end of start tag {stTag} not found')
      break
    endTag_index = htmlstring.find(endTag, stTag_index+1)
    if endTag_index == -1:
      if verbose: printerr(f'end tag {endTag} not found')
      break
    if stTag_keyword \
        and not stTag_keyword in htmlstring[stTag_index: eot]:
      stTag_index = match_tag(htmlstring, start_tag, eot)
      if verbose > 1: printerr(f'keyword {stTag_keyword} not found')
      continue
    # find real endTag_index
    start_sub = match_tag(htmlstring, start_tag, eot+1)
    while start_sub < endTag_index and start_sub != -1:
      end_sub = htmlstring.find(endTag, start_sub+1)
      if end_sub > endTag_index or end_sub == -1: break
      endTag_index = htmlstring.find(endTag, end_sub+1)
      if endTag_index == -1:
        if verbose: printerr(f'end tag {endTag} not found')
        break
      start_sub = match_tag(htmlstring, start_tag, endTag_index+1)

    htmlstring = htmlstring[:stTag_index] + htmlstring[endTag_index + len(endTag):]

    stTag_index = match_tag(htmlstring, start_tag, stTag_index)
  return htmlstring

def scrape_page(webpage, **kwargs):
  """ scrape webpage """
  scVerbose = kwargs.get('verbose', 0)
  def vprint(*string):
    if scVerbose:
      list(map(printinfo, string))

  if '\n' in webpage:
    webpage = webpage[:webpage.index('\n')]
  vprint(f'Webpage: {webpage}')

  scraper_profile = kwargs.get('profile', 'auto')
  if scraper_profile == 'auto':
    scraper_profile = next((key for key, value in scrapeProfiles.items() \
        if get_domain_name(webpage) == key), None)
  if scraper_profile is None: scraper_profile = 'generic'
  vprint(f'Profile: {scraper_profile}')

  if webpage.startswith('http'):
    string = requests.get(webpage, timeout=10).text
  else:
    string = readfile(webpage)
  if not string:
    vprint(f'Failed to load {webpage}')
    return ''

  string = re.sub(r'<!--.*?-->', '', string, flags=re.DOTALL)
  string = string.replace('\r\n',     '\n')
  string = string.replace('\r',       '\n')

  for tag in ['p','div','h1','h2','h3','h4','h5','h6','blockquote','ol','ul','dl','code' ]:
    string = string.replace(f'</{tag}>', f'</{tag}>\n\n')
  string = string.replace('<br>',     '\n\n')
  string = string.replace('<br />',   '\n\n')
  string = string.replace('<br/>',    '\n\n')
  string = string.replace('&nbsp;',   ' ')
  string = string.replace('&thinsp;', ' ')
  string = string.replace('\t',       ' ')
  string = remsp(string)

  # ----------------
  for tag in scrapeProfiles[scraper_profile]:
    sx = tag.find(' ')
    if sx != -1:
      stag = tag[:sx]
      skw = tag[sx+1:]
    else:
      stag = tag
      skw = ''

    string = remove_tag(string, stag, skw, verbose=scVerbose)
  # ----------------

  string = strip_tags(string)
  arr = string.split("\n")
  arr = list(map(str.strip, arr))
  str1 = ''
  for line in arr:
    line = line.strip()
    if not line or line == "": continue
    str1 += line + "\n\n"
  string = htmd(str1)

  return  f'# Source: {webpage}\n' \
        + f'# Profile: {scraper_profile}\n' \
        + string

# --------------------------------------------------------------------
if __name__ == '__main__':
  verbose = 0
  profile = 'auto'
  webpage = ''
  while len(sys.argv):
    arg = sys.argv.pop(0)
    if arg in ['-h', '--help']:
      printstd(f'{script_name} vs {script_version}',
        f'Usage: {script_name} [options] url|file',
        '  Where url|file is the object to scrape.',
        '    -s|--scraper [url|file]',
        '                   If url|file not specified, lists available scraper profiles.',
        '    -v|--verbose   Increase verbosity.',
        '    -q|--quiet     No verbosity.',
        '    -V|--version   Print version.'
      )
      sys.exit()
    elif arg in ['-V', '--version']:
      print(script_version)
      sys.exit()
    elif arg in ['-v', '--verbose']:
      verbose += 1
    elif arg in ['-q', '--quiet']:
      verbose = 0
    elif arg in ['-s', '--scraper']:
      if len(sys.argv):
        profile = sys.argv.pop(0)
        if profile in list(scrapeProfiles.keys()):
          continue
        printerr(f'Scraper "{profile}" not found.')
        printstd('')
      printstd('Scrape profiles are located in:', f'  {script_dir}/scrape_profiles.json', '')
      printstd('Available Scrape Profiles:')
      for arg in list(scrapeProfiles.keys()):
        printstd('  '+arg)
      sys.exit()
    elif arg.startswith('-'):
      printerr(f'Invalid option {arg}.')
    else:
      webpage = arg

  try:
    scrape = scrape_page(webpage, profile=profile, verbose=verbose)
    print(scrape)
  except KeyboardInterrupt:
    print('^C')
  except FileNotFoundError:
    printerr('Input url|file was not found.')
  except Exception as e:
    printerr(e)

  sys.exit()
