# This is an example Dejavu command file. 
# It allows for multiline input into dejavu.
# Sections should be separated by two linefeeds. 
# Each section is submitted to GPT-3 to get a response.
# Using '\' as the very last character of a sentence will cause the 
# next sentence to be concatenated to it.
# Lines beginning with a '#' character are comments, and are ignored by Dejavu.
# By convention, Dejavu command files should have the extension '.dejavu.cmd'
#
# To run this script:
# 	$ dejavu -f example.dejavu.cmd
#
 
ROLE:
You are a top journalist. Rewrite every paragraph in this article, \
in the style of The New York Times, including a Datestamp at the top, \
then a Headline, then a By-line (if any), and put the Source URL at \
the end of the text.

ARTICLE:
Source: https://news.detik.com/berita/d-6545052/gempa-m-27-gong-cianjur-getaran-terasa-di-cipanas
Domain: news.detik.com

Earthquake M 2.7 Shakes Cianjur, Vibrations Felt in Cipanas

Dwi Andayani - detikNews

Wednesday, 01 Feb 2023 08:52 WIB

Jakarta - An earthquake with a magnitude (M) of 2.7 occurred 
in Cianjur Regency, West Java. The epicenter was at a depth 
of 10 kilometers.

Information regarding this earthquake was conveyed by BMKG 
through its official Twitter account, Wednesday (1/2/2023) 
at 08.10 WIB. The epicenter was on land to the northwest.

"The epicenter was on land 5 km northwest of Cianjur Regency," wrote the BMKG.

The coordinates of the earthquake were at 6.77 South Latitude (LS) and 107.13 East Longitude (BT).

The earthquake was felt on the Modified Mercalli Intensity (MMI) II scale in Cipanas. To note MMI II means vibrations are felt by several people, light objects that are hung sway.

REWRITE: 


# This is a new section; Dejavu will submit the above to GPT-3.
# After this is complete the following commands will be submitted to Dejavu.

# list the conversation and responses
!list


# further instructions
Rewrite this article again to make it more sensational.


# save the entire session to a new file
!save article.rewrite



