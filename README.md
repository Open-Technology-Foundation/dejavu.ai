# DéjàVu GPT-3 Terminal
Bring the power of GPT-3 directly to your terminal command-line.

(The DéjàVu web interface is also available [here](https://okusiassociates.com/dejavu/).)

## Requirements
For the moment, ```DéjàVu GPT-3 Terminal``` has only been tested on Ubuntu Linux.  Other platforms may require minor adjustments. 

You will need to obtain an API key from [openAI](https://openai.com) in order to run this program.

## Installation
You should have copied down your openAI API key and organization ID (if applicable). Update your environment variables as follows:

```
export OPENAI_API_KEY='sk-_your_key_'
export OPENAI_ORGANIZATION_ID='org-_your_org_id'
```

```dejavu.install``` will detect these variables during instalation.

Once that's done, you're ready to install DejaVu. 

```dejavu.install``` will:

 - Execute ```apt update``` and ```apt upgrade``` (can disable with --no-apt)
 - Install python 3, pip and git packages (disabled with --no-apt)
 - Modify ```~/.bashrc``` and ```/etc/bash.bashrc``` to include openai environment variables.
 - Store program files in ```/usr/share/dejavu.ai```
 - Install the executable ```dejavu``` in ```/usr/local/bin/```
 - Create symlink ```dv``` for ```dejavu``` in ```/usr/local/bin```, only if ```dv``` does not already exist.

### Synopsis: dejavu.install \[-vqaVh\]
	Options : -v|--verbose   Verbose on (default)
	        : -q|--quiet     Verbose off. 
	        :                If environment key ```OPENAI_API_KEY```
	        :                has already been set you will not 
	        :                be prompted to input it.
	        : -a|--no-apt    Do not execute apt during installation.
	        : -u|--upgrade   Upgrade ```dejavu``` from git repository.
	        : -V|--version   Print version.

## Execution
When you've installed the program, run:

```
dejavu [training_file]
```

If no training_file is specified, it will default to ```training.dejavu.txt``` located in ```~/.dejavu/```

### Synopsis: dejavu \[-vquV\] \[TrainingFile\]
TrainingFile is a saved conversation file, or the name of a new conversation you wish to create.
 
Training Files are located in ~/.dejavu/ with extension '.dejavu.txt'.

The default Training File is training.dejavu.txt. This can/should be edited to suit your own personality and requirements.

	Options : -v|--verbose   Verbose on (default)
          : -q|--quiet     Verbose off. Start-up status 
          :                messages will not appear.
          : -l|--list      List conversation files.
          : -u|--upgrade   Upgrade DéjàVu from git repository.
          : -V|--version   Print DéjàVu version.

