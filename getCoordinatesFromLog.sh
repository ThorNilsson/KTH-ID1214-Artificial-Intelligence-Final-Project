# Description: This script will get the coordinates of the nearest minecraft structure from the minecraft log file
# Dependencies: .env file with MINECRAFT_LOG_SOURCE variable
# Usage: bash getCoordinatesFromLog.sh
# Output: coords.txt file with the coordinates of the nearest structure

MINECRAFT_LOG_SOURCE=$(cat .env | grep MINECRAFT_LOG_SOURCE= | sed 's/^.*=//')

tail -n 50  $MINECRAFT_LOG_SOURCE | grep "The nearest" | tail -1 | sed 's/^.*The nearest //' | cut -d "[" -f2 | cut -d "]" -f1 | sed 's/~/200/g' | sed 's/,//g' | sed 's/$/ 0 0 /'> "coords.txt"