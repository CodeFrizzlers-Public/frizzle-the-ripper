#!/bin/bash

################################################################################
#
# this bash script automates my standard routine for importing Audio-cds.
# 0: when an audio-cd is mounted, the Terminal starts and the script can be run.
# 1: user specifies a directory name at the prompt.
# 2: audio-cd is copied to the specified directory located in AIFF.
# 3: the audio-cd is ejected.
# 3: track numbering is adapted to support sorting in VLC.
# 4: mp3 versions are transcoded and placed inside a separate directory.
#
# copyleft Frizzle january 2013
#
# changelog
#  -october (2012):  
#	      - removed option -b 320 because -V 0 sets proper constraints
#             - added -p for error protection (a 16 bit checksum per frame)
#	      - the directory name is checked for length and existence
#
#  -november (2012): 
#	      - show progress information using rsync instead of cp
#             - extra version called importwithtracknames.sh 
#		which prompts for individual tracknames
#             - drutil eject after copying and user input is finished
#
#  -january (2013):  
#	      - improved documentation
#
################################################################################

MY_DIR=`dirname $0`
DIALOG="$MY_DIR/CocoaDialog.app/Contents/MacOS/CocoaDialog"
#export TERM="xterm-256color"
export TERM="Apple_Terminal"

# if [ ! -d /Volumes/Audio-cd ] dit werkt blijkbaar alleen voor osx NL!
if [ ! -d /Volumes/Audio\ CD ]
 then
 echo -e "\nEr is geen volume Audio-cd.\n"
 echo "Dit betekent:"
 echo "1) dat u bent vergeten een CD in de drive te stoppen. Sufferd!"
 echo "2) dat de CD nog niet gemount is, peuter even in je neus, run dan het script nogmaals."
 echo "of check of het volume zichtbaar is in Finder of op het Bureaublad"
 echo -e "3) dat de CD niet de default naam Audio-cd heeft.
Geval 3 ben ik pas 1x tegengekomen, ben iets te lui om het daarvoor op te lossen"
 echo "Script wordt afgesloten..."
 exit 1;
fi

# echo "\n artiest en eventueel album? \n"


mapnaam=`"$DIALOG" standard-inputbox --title "Mapnaam" --string-output \\
--informative-text "Voer in"`


if [ -z "$mapnaam" ]
 then
  echo "De opgegeven naam is leeg of bevat alleen spaties."
  echo "Script wordt afgesloten..."
  exit 1;
fi

if [ ! -e ~/Music/IEC\ 60908 ]; # IEC 60908 is de norm voor compact disc
 then 
  echo "IEC 60908 bestaat nog niet. Deze map wordt aangemaakt in Music."; 
  mkdir ~/Music/IEC\ 60908  
fi

if [ ! -e ~/Music/ISO\ 11172-3 ]; # ISO 11172-3 is de norm voor mp3
 then 
  echo "ISO 11172-3 bestaat nog niet. Deze map wordt aangemaakt in Music."; 
  mkdir ~/Music/ISO\ 11172-3  
fi

if [ -e ~/Music/IEC\ 60908/"$mapnaam" ] 
 then
  echo "De opgegeven naam bestaat al."
  echo 'Script wordt afgesloten...'
  exit 1;
fi

mkdir -p ~/Music/IEC\ 60908/"$mapnaam"

echo 'CD wordt gedupliceerd'

rsync -avh --chmod=ugo=rwX --progress /Volumes/Audio\ CD/ ~/Music/IEC\ 60908/"$mapnaam"/ 

# let weer op de schrijfwijze van Audio CD

# rsync dupliceert ook het verborgen bestand .TOC.plist
# ik maak er nu geen gebruik van, maar wie weet in de toekomst wel
# 2 a 3 kb groot, is verwaarloosbaar op honderden mb audio-data

drutil eject

cd ~/Music/IEC\ 60908/"$mapnaam"
for i in [1-9][!0-9]*; 
    do mv "$i" 0"$i"; 
	done;
	


Lameloop(){
	for file in ~/Music/IEC\ 60908/"$mapnaam"/*.aiff; do 
    	lame --verbose -q 0 -V 0 -p "$file" "${file%.*}".mp3; 
	done;
	if [ $? != 0 ] ; then
	
	}

Lameloop &>/tmp/lametemp &

while true; do 
	tail -f -n 1 /tmp/lametemp
	rm -v  /tmp/lametemp
done

wait

mkdir -p ~/Music/ISO\ 11172-3/"$mapnaam" 
mv ~/Music/IEC\ 60908/"$mapnaam"/*.mp3 ~/Music/ISO\ 11172-3/"$mapnaam"

echo Het importeren en transcoderen van $mapnaam is geslaagd.
echo Enjoy the music!
# deze meldingen moeten voorwaardelijk zijn.
if [ -f  /tmp/lametemp ]; then
	echo 'Cleaning up'
	rm -v /tmp/lametemp
fi

exit
