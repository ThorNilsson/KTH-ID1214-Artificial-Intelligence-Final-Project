# Description: Get the last player coordinates from the minecraft log file
# Dependencies: .env file with MINECRAFT_LOG_SOURCE variable
# Usage: bash getPlayerCoordinatesFromLog.sh
# Output: coords.txt file with the last player coordinates

MINECRAFT_LOG_SOURCE=$(cat .env | grep MINECRAFT_LOG_SOURCE= | sed 's/^.*=//')

tail -50  $MINECRAFT_LOG_SOURCE | grep "Teleported" | tail -1 | sed 's/^.*to//' > "coords.txt"