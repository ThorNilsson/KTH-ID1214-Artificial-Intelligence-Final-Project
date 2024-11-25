#to run this script, use the following command:
# bash moveScreenshot.sh <structure>
# where <structure> is the name of the structure that the screenshot is of
# This script moves the most recent screenshot from the source directory to the destination directory
# The source directory is specified in the .env file
# The destination directory is the TrainingData directory, with a subdirectory for the structure specified
# The file is renamed to the current date and time

structure=$1
sourcePath=$(cat .env | grep SCREENSHOT_SOURCE_DIR= | sed 's/^.*=//')
sourceFile=$(ls $sourcePath | grep .png | tail -1)

destinationPath=$(echo "./TrainingData/$structure") 
destinationFile=${structure}_$(date +%Y-%m-%d_%H%M%S).png

echo $sourceFile
echo $sourcePath
echo $destinationPath

mkdir --parents $destinationPath
mv "$sourcePath\\$sourceFile" "$destinationPath/$destinationFile"
