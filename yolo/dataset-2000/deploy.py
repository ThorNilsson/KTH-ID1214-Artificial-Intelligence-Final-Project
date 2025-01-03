import roboflow

rf = roboflow.Roboflow(api_key="ALNo3vbINJUm3Dgjy1Pj")
project = rf.workspace().project("minecraft-structure-classifier")

#can specify weights_filename, default is "weights/best.pt"
version = project.version(2)
version.deploy("yolov11", "/mnt/c/Users/vladi/Desktop/KTH-ID1214-Artificial-Intelligence-Final-Project/yolo/dataset-2000/runs/detect/train", "weights/best.pt")