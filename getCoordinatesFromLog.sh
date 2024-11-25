MINECRAFT_LOG_SOURCE=$(cat .env | grep MINECRAFT_LOG_SOURCE= | sed 's/^.*=//')

tail -50  $MINECRAFT_LOG_SOURCE | grep "The nearest" | tail -1 | sed 's/^.*The nearest //' | cut -d "[" -f2 | cut -d "]" -f1 | sed 's/~/256/g' | sed 's/,//g' > "coords.txt"