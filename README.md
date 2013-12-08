frizzle-the-ripper
==================

Simple script for ripping audio cd's in Mac osX using rsync and lame. (Dutch)

################################################################################
#
# this bash script automates my standard routine for importing Audio-cds.
# 0: when an Audio-cd is mounted, the Terminal starts and the script can be run.
# 1: user specifies a directory name at the prompt.
# 2: audio-cd is copied to the specified directory located in AIFF.
# 3: the audio-cd is ejected.
# 3: tracknumbering is adapted to match VLC's sorting algorithm.
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
#  -December (2013) <By Arjan van Lent aka Socialdefect>
#	      - Dependency check
#	      - support for Audio-cd and Audio cd directory
#             - Some error checks
#  	      - Clean-up aiff files and temp directory when conversion succeeds
#             - Directory name as input
#	      - If $mapnaam is empty directory just use it!
#	      - Display program name and version
#
##############################################################################
