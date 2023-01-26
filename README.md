# dejavu.ai
Bring GPT-3 directly to your terminal command-line with this light-weight python program!

## Requirements
Typically only tested on Ubuntu Linux, but other platforms may require minor adjustments. You will need to obtain an API key from openAI in order to get started.

## Installation
You should have copied down your openAI API key and organization ID (if applicable). Update your environment variables as follows:

```
export OPENAI_API_KEY='sk-_your_key_'
export OPENAI_ORGANIZATION_ID='org-_your_org_id'
```

```dejavu.install``` will detect these variables during instalation.

Once that's done, you're ready to install DejaVu. 

Run ```dejavu.install``` to get going. ```Python3``` and ```pip``` will be installed/updated during the installation. 

The DejaVu executable will be found in ```/usr/local/bin/``` while all other files will be stored in ```/usr/share/dejavu.ai/```.

## Execution
When you're ready to launch the program, run:

```
dejavu [training_file]
```

If no training_file is specified, it will default to ```training.dejavu.txt``` located in ```~/.dejavu/```

