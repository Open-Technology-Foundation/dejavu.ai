# DéjàVu GPT-3 Terminal
Bring the power of GPT-3 directly to your terminal command-line.

(The DéjàVu web interface is also available [here](https://okusiassociates.com/dejavu/).)

## Requirements
For the moment, DéjàVu GPT-3 Terminal has only been tested on Ubuntu Linux.  Other platforms may require minor adjustments. 

You will need to obtain an API key from [openAI](https://openai.com) in order to run this program.

## Installation
You should have copied down your openAI API key and organization ID (if applicable). Update your environment variables as follows:

```
export OPENAI_API_KEY='sk-_your_key_'
export OPENAI_ORGANIZATION_ID='org-_your_org_id'
```

```dejavu.install``` will detect these variables during instalation.

Once that's done, you're ready to install DejaVu. 

Run ```dejavu.install``` to get going. The ```Python3``` and ```pip``` packages will be installed and/or updated during the installation. 

The DejaVu executable is be found in ```/usr/local/bin/``` while all other files are stored in ```/usr/share/dejavu.ai/```.

## Execution
When you're ready to launch the program, run:

```
dejavu [training_file]
```

If no training_file is specified, it will default to ```training.dejavu.txt``` located in ```~/.dejavu/```

Now start chatting!
