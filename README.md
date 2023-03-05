# DéjàVu - GPT Terminal Chatbot and Scripting vs 0.9

## SYNOPSIS
**dejavu [-vqlxuV] [-c cmd] [dvfile]**
   
Where `dvfile` is an existing conversation file, or the name of a new 
conversation you wish to create.

The default `dvfile` is `~/.dv/default.dv`.  This can/should be edited 
to suit your own personality and requirements.  By default, `dv` conversation files are located and created in `~/.dv/` with the extension `.dv`.

## DESCRIPTION
DéjàVu is a GPT Terminal Chatbot program with interesting scripting capabilities.  It brings the power of GPT-3 and GPT-3.5 directly to your terminal command-line.  You may never Google search anything ever again :) ...

Remembers context and history.  You and your AI can have multiple 'personalities' or subject chatfiles.

### Requirements
For the moment, `DéjàVu GPT Terminal` has only been tested on Ubuntu Linux 22.04.  Other platforms may require adjustments to the Python source code. 

Before starting, you will also need to obtain an API key from [openAI](https://openai.com/api/) in order to run this program.  See ENVIRONMENT.

### Installation
Installation One-Liner, if you're in a hurry:

```
git clone https://github.com/GaryDean/dejavu.ai.git /tmp/dejavu && /tmp/dejavu/dv.install
```

`dejavu.install` will detect these variables during installation.  If  it doesn't, check your environment.

Once that's done, you're ready to install.  `dejavu.install` will:

 - Execute `apt update` and `apt upgrade` (disable with --no-apt)
 - Install python 3, pip and git packages (disabled with --no-apt)
 - Modify `~/.bashrc` and `/etc/bash.bashrc` to include openai environment variables.
 - Store program files in `/usr/share/dejavu.ai`
 - Create symlinks `dv` and `dejavu` in `/usr/local/bin`.

### Execution

To run:

```
dejavu [conversation_file]
```

If no conversation_file is specified, it will default to `~/.dv/default.dv`.


## OPTIONS
*-v*, *--verbose*
: Verbose on (default)

*-q*, *--quiet*
: Verbose off.  Start-up status messages will not appear.

*-l*, *--list*
: List conversation files in ~/.dejavu.

*-c*, *--cmd 'cmd'*
: Execute 'cmd' on entry to DéjàVu.  Use with -x to immediately 
exit.  May be used multiple times.

*-f*, *--cmd-file*
: Execute a DéjàVu command text file.

*-x*, *--exit*
: Immediately exit DéjàVu after script/command completion.

*-u*, *--upgrade*
: Upgrade DéjàVu from git repository.

*-V*, *--version*
: Display DéjàVu version.

## ENVIRONMENT
Before running, make sure you have set up you openAI API key in your system's environment.  If you set up your openAI account as an organization, you will also need to set your organization ID.  Update your environment variables as follows:

```
export OPENAI_API_KEY='sk-_your_key_'
export OPENAI_ORGANIZATION_ID='org-_your_org_id_'
```

You may wish to place these declarations into your `.bash.rc` and/or `/etc/bash.bashrc` files.

## EXAMPLES

```

## run ~/.dv/default.dv
dejavu

## run ~/.dv/chat.dv (autosave chatbot)
dejavu chat

## run ~/.dv/techlead.dv (THE techlead)
dejavu techlead

## get a quick answer to a question and exit
dejavu -xc 'in python, display syntax, options, usage and examples for .replace()'

```

## OPERATION

### DéjàVu System Commands
DéjàVu system commands are differentiated from GPT instructions by starting with a '/' character (or alternatively, a '!' character).

For instance, `/status` will display all current DéjàVu and GPT settings. 

Note that all commands can be shortened to their first four letters, eg, */temp* for *!temperature*

*range* can be in the forms "1,2,3", "4-6", "7-", "-8", "all" and can be combined in any order.

```
Help and Status
  /                Short command help.
  /help            Open DéjàVu help file. Can also use "//"
  /exit|/quit      Exit DéjàVu.  Pressing ^C will also exit.
  /status          Show status of current environment.
  /vars            Show current variables.

Conversations
  /list [long|short] [range] 
                   List current conversation.
                   "short" for condenced list, "long" for full list.
                   Default is "long".
                   If "range" omitted, lists entire conversation.
  /delete range    Delete conversation items in "range".
  /clear           Clear all conversation.  Same as /delete 1-
  /tldr [range]    Summarize all conversation responses in "range".
                   Default is the previous response.
  /summarize [conversation|prompt|all] 
                   Summarise every conversation or prompt items.
                   Default is "conversation".
  /autosave [on|off] 
                   Save all conversation to current dv Script on exit.
                   Default is Off.
  /save [file]     Save current conversation.  If "file" is not specified
                   then saves to current conversation file.
  /awesome [select|list|update] 
                   Lists over a 100 prompt suggestions from prompts.chat.
                   If no subcommand is specified, defaults to "select".
                   Updating occurs directly from prompts.chat github page
  /import [file]   Import "file" into the input prompt.
                   If "file" is not specified, opens EDITOR to enable 
                   multi-line commands.

GPT Settings
  /user_name [name] Set/Display user name.
  /ai_name [name]  Set/Display AI name.
  /engine [engine] Set/Display GPT engine.
  /temperature [f] Set/Display temperature (0.0-1.0).
  /top_p [f]       Set/Display top_p (0.0-1.0).
  /tokens [n]      Set/Display tokens to use.
  /freq_pen        Set/Display frequency penalty (-2-2).
  /pres_pen        Set/Display presence penalty (-2-2).
  /prompt [prompt] Display current conversation set-up information.
                   If "prompt" is specified, set the new conversion prompt.

Scripts
  /files           Display conversation scripts in current and user home
                   directories, with option to edit.
  /edit [file]     Edit "file". If "file" not specified, edit the current
                   script file.
  /run [file]      Run the "file" script. If not specified, display a list
                   of available scripts.
  /instruction string 
                   Insert an instruction. Usually only used in scripts.
  /conversation string 
                   Add to conversation array. Usually only used in scripts.
  /echo [on|off]   Turn command echo on|off. Usually only used in scripts.
  /exec [cmd...]   Execute a shell command.
```

### Prompt Engineering
Prompt Engineering is a critial part of getting the most out of DéjàVu and GPT models.  Here are some guidelines:

#### 1: Understand the importance of “context”
The most important factor to consider when designing a prompt is context.  Making sure the context is relevant is crucial for getting coherent and accurate responses from GPT.

Without sufficient context, GPT may generate responses that are off-topic, irrelevant, or inconsistent with the goal of the prompt.  To ensure the prompt has an adequate amount of context, include all relevant background information.

#### 2: Define a clear task
After providing context, the next step to designing an effective prompt is to define a clear instruction for GPT.

This requires that you have a clear understanding of the task to be completed, and the task definition should be specific, concise, and avoid ambiguity or vagueness.

#### 3: Be specific
When designing a prompt make sure the prompt is specific.  The more details and precision included in the prompt, the more likely it is that the GPT will generate a targeted and accurate response.

This includes important details such as what the goal is, the starting and ending points, characters involved, or any relevant background information.  If the prompt is too vague, it will result in off-topic, irrelevant, or inconsistent responses.

#### 4: Iterate
Iteration is an effective way of designing an effective prompt.  Prompt design is often an iterative process that involves multiple attempts and cycles of design, testing, and evaluation.

Each iteration offers an opportunity to refine or improve the prompt.  For example, if GPT generates an off-topic response, you could add more specific instructions or additional context to the prompt.

The iterative approach it allows for continuous improvement and optimization of the generated content.

## REQUIRES
Python 3, pip, git, openai API key/s, apt install access

## REPORTING BUGS
Report bugs and deficiencies on the [DéjàVu github page](https://github.com/GaryDean/dejavu.ai.git)

## COPYRIGHT
Copyright  ©  2023  Okusi Associates.  License GPLv3+: GNU GPL version 3 or 
later [GNU Licences](https://gnu.org/licenses/gpl.html).
This is free software: you are free to change and redistribute it.  There is 
NO WARRANTY, to the extent permitted by law.

## SEE ALSO
  [openAI API](https://openai.com/api/)

  [DéjàVu github](https://github.com/GaryDean/dejavu.ai.git)

  [DéjàVu web](https://okusiassociates.com/dejavu/)
