import os

def getEDITOR():
  EDITOR = os.environ.get('EDITOR')
  if not EDITOR:
    _ent_EDITOR = os.environ.get('_ent_EDITOR')
    if _ent_EDITOR:
      EDITOR = _ent_EDITOR
    elif os.environ.get('SUDO_EDITOR'):
      EDITOR = os.environ.get('SUDO_EDITOR')
    elif os.environ.get('SELECTED_EDITOR'):
      EDITOR = os.environ.get('SELECTED_EDITOR')
    elif os.path.isfile(os.path.join(os.environ.get('HOME'), '.selected_editor')):
      with open(os.path.join(os.environ.get('HOME'), '.selected_editor')) as f:
        SELECTED_EDITOR = f.read()
      if SELECTED_EDITOR:
        EDITOR = SELECTED_EDITOR
    elif os.path.isfile('/etc/alternatives/editor'):
      EDITOR = '/etc/alternatives/editor'
  return EDITOR

def getBROWSER():
  BROWSER = os.environ.get('BROWSER')
  if not BROWSER:
    _ent_BROWSER = os.environ.get('_ent_BROWSER')
    if _ent_BROWSER:
      BROWSER = _ent_BROWSER
    elif os.path.isfile('/usr/bin/w3m'):
      BROWSER = '/usr/bin/w3m'
    elif os.path.isfile('/usr/bin/lynx'):
      BROWSER = '/usr/bin/lynx'
  return BROWSER
