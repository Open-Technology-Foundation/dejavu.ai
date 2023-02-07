% DV(1) GPT-3 Terminal and Chatbot | Version 0.9
% Gary Dean
% December 2022

# NAME
DejaVu - GPT-3 Terminal and Chatbot vs 0.9

# SYNOPSIS
**dejavu** [-vqlxuV] [-c cmd] [dvfile]
   
Where ```dvfile``` is an existing conversation file, or the name of a new 
conversation you wish to create.

The default ```dvfile``` is ```~/.dv/default.dv```. This can/should be edited 
to suit your own personality and requirements.

By default, ```dv``` conversation files are located and created in ```~/.dv/``` with the extension ```.dv```.

# DESCRIPTION
DejaVu is a GPT-3 Terminal and Chatbot program that remembers context.
It brings the power of GPT-3 directly to your terminal command-line.

Remembers context and history. You may never Google search anything ever again :) ...

## Requirements
For the moment, ```DéjàVu GPT-3 Terminal``` has only been tested on Ubuntu Linux 22.04.  Other platforms may require adjustments to the Python source code. 

Before starting, you will also need to obtain an API key from [openAI](https://openai.com/api/) in order to run this program. See ENVIRONMENT.

## Installation
Installation One-Liner, if you're in a hurry:

```
git clone https://github.com/GaryDean/dejavu.ai.git /tmp/dejavu && /tmp/dejavu/dv.install
```

```dejavu.install``` will detect these variables during installation. If  it doesn't, check your environment.

Once that's done, you're ready to install. ```dejavu.install``` will:

 - Execute ```apt update``` and ```apt upgrade``` (disable with --no-apt)
 - Install python 3, pip and git packages (disabled with --no-apt)
 - Modify ```~/.bashrc``` and ```/etc/bash.bashrc``` to include openai environment variables.
 - Store program files in ```/usr/share/dejavu.ai```
 - Create symlinks ```dv``` and ```dejavu``` in ```/usr/local/bin```.

## Execution

To run:

```
dejavu [conversation_file]
```

If no conversation_file is specified, it will default to ```~/.dv/default.dv```.


# OPTIONS
**-v**, **--verbose**
: Verbose on (default)

**-q**, **--quiet**
: Verbose off. Start-up status messages will not appear.

**-l**, **--list**
: List conversation files in ~/.dejavu.

**-c**, **--cmd 'cmd'**
: Execute 'cmd' on entry to DéjàVu. Use with -x to immediately 
exit. May be used multiple times.

**-f**, **--cmd-file**
: Execute a Dejavu command text file.

**-x**, **--exit**
: Immediately exit DéjàVu after first command.

**-u**, **--upgrade**
: Upgrade DéjàVu from git repository.

**-V**, **--version**
: Print DéjàVu version.

# ENVIRONMENT
Before running, make sure you have set up you openAI API key in your system's environment.  If you set up your openAI account as an organization, you will also need to set your organization ID. Update your environment variables as follows:

```
export OPENAI_API_KEY='sk-_your_key_'
export OPENAI_ORGANIZATION_ID='org-_your_org_id_'
```

You may wish to place these declarations into your ```.bash.rc``` and/or ```/etc/bash.bashrc``` files.  

# EXAMPLES

```

# run ~/.dv/default.dv
dejavu

# run ~/.dv/chat.dv (autosave chatbot)
dejavu chat

# run ~/.dv/techlead.dv (THE techlead)
dejavu techlead

# get a quick answer to a question and exit
dejavu -c 'in python, display syntax, options, usage and examples for .replace()' -x

```

# OPERATION

## DéjàVu System Commands
Note: All commands can be shortened to first four letters, eg, **!temp** for **!temperature**

**range** can be in the forms "1,2,3", "4-6", "7-", "-8", "all" and can be combined in any order.

```
         !status: Show status of current environment.
!temperature [f]: Display or Set Temperature.
                  Valid value for "f" is 0.0 - 1.0.
!list [long|short] [range]: 
                  List current conversation.
                  "short" for condenced list, "long" for full list.
                  Default is "long".
                  If "range" omitted, lists entire conversation.
   !delete range: Delete conversation items in "range".
          !clear: Clear all conversation.  Same as !delete 1-
          !files: Display conversation scripts in current and user home
                  directories, with option to edit.
           !edit: Edit the current conversation prompt.dv file.
!prompt [prompt]: Display current conversation set-up information.
                  If "prompt" is specified, set the new conversion prompt.
   !tldr [range]: Summarize all conversation responses in "range".
                  Default is the previous response.
!summarize [conversation|prompt|all]: 
                  Summarise every conversation or prompt items.
                  Default is "conversation".
    !save [file]: Save current conversation.  If "file" is not specified
                  then saves to current conversation file.
  !import [file]: Import "file" into the input prompt.
                  If "file" is not specified, opens EDITOR to enable 
                  multi-line commands.
  !exec [cmd...]: Execute a shell command.
  !echo [on|off]: Turn command echo on|off.
           !help: Open DéjàVu Help file.
     !exit|!quit: Exit DéjàVu.  Pressing ^C will also exit.
```

# REQUIRES
Python 3, pip, git, openai API key/s, apt install access

# REPORTING BUGS
Report bugs and deficiencies on the Dejavu [github page](https://github.com/GaryDean/dejavu.ai.git)

# COPYRIGHT
Copyright  ©  2023  Okusi Associates.  License GPLv3+: GNU GPL version 3 or 
later [GNU Licences](https://gnu.org/licenses/gpl.html).
This is free software: you are free to change and redistribute it.  There is 
NO WARRANTY, to the extent permitted by law.

# AUTHORS
Written by Gary Dean, garydean@okusi.id

# SEE ALSO
[openai api](https://openai.com/api/)

[dejavu github](https://github.com/GaryDean/dejavu.ai.git)

[dejavu web](https://okusiassociates.com/dejavu/)
