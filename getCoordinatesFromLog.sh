# Description: This script will get the coordinates of the nearest minecraft structure from the minecraft log file
# Dependencies: .env file with MINECRAFT_LOG_SOURCE variable
# Usage: bash getCoordinatesFromLog.sh
# Output: coords.txt file with the coordinates of the nearest structure

MINECRAFT_LOG_SOURCE=$(cat .env | grep MINECRAFT_LOG_SOURCE= | sed 's/^.*=//')

tail -50  $MINECRAFT_LOG_SOURCE | grep "The nearest" | tail -1 | sed 's/^.*The nearest //' | cut -d "[" -f2 | cut -d "]" -f1 | sed 's/~/256/g' | sed 's/,//g' > "coords.txt"