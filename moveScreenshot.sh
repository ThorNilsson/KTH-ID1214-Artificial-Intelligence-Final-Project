#Not really working, but the idea is to move the last screenshot to the training data folder
structure="monument"
source= find "C:\Users\thor7\OneDrive\Bilder\Skärmbilder" | tail -1
echo $source

destination="./TrainingData/$structure/"

mkdir --parents $destination; mv $source $destination
