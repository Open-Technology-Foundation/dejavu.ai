# DéjàVu Webscraper vs 1.0

## SYNOPSIS
**webscrape [-svqV] url|file**
   
Where `file` is an existing local html file, 
  OR
  `url` is a url (https://...).

## DESCRIPTION
Wescraper scrapes html code from a url or file, and returns cleaned up text.

### Requirements
For the moment, `webscraper` has only been tested on Ubuntu Linux 22.04.  Other platforms may require some adjustments (for which, please push to this repository also). 

## OPTIONS
*-s*, *--scraper* [profile] 
If `profile` not specified, lists available  
scraper profiles.  `profile` defaults to the 
generic profile if a pre-defined profile is  
not found.  The profiles json file can be viewed/edited  
at `/usr/share/dejavu.ai/webscrape/scrape_profiles.json`

*-v*, *--verbose*
: Increase verbosity. 

*-q*, *--quiet*
: No verbosity. 

*-V*, *--version*
: Print version. 

## REQUIRES
Python 3

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
