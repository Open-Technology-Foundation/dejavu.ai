# DéjàVu Webscraper vs 1.0

## SYNOPSIS
**webscrape [-svqV] url|file**
   
Where `file` is an existing local html file, 
    OR
  `url` is a url (https://...).

## DESCRIPTION
`webscraper` scrapes html code from a url or file, and returns cleaned up text.

### Requirements
For the moment, `webscraper` has only been tested on Ubuntu Linux 22.04.  Other platforms may require some adjustments (push them to this repository). 

## OPTIONS

*-s*, *--scraper* [profile]
: If `profile` not specified, lists available scraper profiles.  `profile` defaults to the generic profile if a pre-defined profile is not found.  The profiles json file can be viewed/edited at `/usr/share/dejavu.ai/webscrape/scrape_profiles.json`

*-v*, *--verbose*
: Increase verbosity. 

*-q*, *--quiet*
: No verbosity. 

*-V*, *--version*
: Print version. 

## REQUIRES
Python 3

## REPORTING BUGS
Report bugs and deficiencies, and get involved, on the [DéjàVu Webscrape github page](https://github.com/GaryDean/dejavu.ai/tree/master/webscrape)

## COPYRIGHT
Copyright  ©  2023  Okusi Associates.  License GPLv3+: GNU GPL version 3 or 
later [GNU Licences](https://gnu.org/licenses/gpl.html).
This is free software: you are free to change and redistribute it.  There is 
NO WARRANTY, to the extent permitted by law.

## SEE ALSO
  [DéjàVu Webscrape github](https://github.com/GaryDean/dejavu.ai/tree/master/webscrape)

  [DéjàVu github](https://github.com/GaryDean/dejavu.ai.git)

  [DéjàVu Web](https://okusiassociates.com/dejavu/)

  [openAI API](https://openai.com/api/)

