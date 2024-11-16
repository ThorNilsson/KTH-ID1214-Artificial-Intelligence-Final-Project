#Not really working, but the idea is to move the last screenshot to the training data folder
#structure="monument"
structure=$1
#sourcePath="C:\Users\thor7\OneDrive\Bilder\Skärmbilder"
sourcePath="C:\Users\thor7\Pictures\Screenshots"
sourceFile=$(ls $sourcePath | grep .png | tail -1)

destinationPath=$(echo "./TrainingData/$structure") 
destinationFile=$structure_$(date +%Y-%m-%d_%H%M%S).png # Not used yet

echo $sourceFile
echo $sourcePath
echo $destinationPath

mkdir --parents $destinationPath
mv "$sourcePath\\$sourceFile" "$destinationPath/$sourceFile"
