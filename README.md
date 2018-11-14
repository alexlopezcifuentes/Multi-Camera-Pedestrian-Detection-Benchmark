# Multi-Camera Pedestrian Detection Benchmark Application
![Main App Interface](https://github.com/alexlopezcifuentes/Multi-Camera-Pedestrian-Detection-Benchmark/blob/master/Doc/App%20Example.png)

## Introduction
This application creates an interative framework to perform two different task:
1. Evaluating at the same time different multi-camera pedestrian detection algorithms. The following measures are extracted:
    * Precision
    * Recall
    * F-Score
    * Area Under the Curve
    * N-MODA
    * N-MODP
2. Visualizing both obtained results and ground-truth on dataset images and ground-plane.

## Requirements
### Files
In order to perform evaluation and visualization with the application the following files are needed:
1. Dataset: RGB frames and homography matrices from maximum 3 different cameras. Besides, if cenital plane visualization is desired a cenital image is needed. Homography matrices should be in the following format:
    ```
    0.6174778372 -0.4836875683 147.00510919005 
    0.5798503075 3.8204849039 -386.096405131 
    0.0000000001 0.0077222239 -0.01593391935
    ```
2. Ground-Truth Files: Ground-truth .idl files to perform evaluation. Example line from ground-truth .idl format:
    ```
    "/CameraFRAME.jpg"; (x, y, w, h):1, (x, y, w, h):1, 
    "/Camera10351.jpg"; (55, 14, 42, 91):1, (1, 120, 12, 166):1, 
    ```
3. Pedestrian Detection files: Pedestrian detection .idl files from the different algorithms to evaluate (maximum 3 cameras per algorithm at the same time). Example line from an algorithm pedestrian detection .idl file:
    ```
    "/CameraFRAME.jpg"; (x, y, w, h):SCORE, (x, y, w, h):SCORE, 
    "/Camera10351.jpg"; (55, 14, 42, 91):1, (1, 120, 12, 166):1, 
    ```
### Folder Structure
An example of the needed folder and filenames structure for a 3 camera evaluation with DPM and Faster-RCNN algorithms is the following:
```
* Dataset/
  * Camera 1/
  * Camera 2/
  * Camera 3/
  * Homography 1.txt
  * Homography 2.txt
  * Homography 3.txt
  * RGBComplete.png
* GT Files/
  * Cam1_GT.idl
  * Cam2_GT.idl
  * Cam3_GT.idl
* Pedestrian Detections/
  * DPM_Cam1.idl
  * DPM_Cam2.idl
  * DPM_Cam3.idl
  * FasterRCNN_Cam1.idl
  * FasterRCNN_Cam2.idl
  * FasterRCNN_Cam3.idl
```
  
## Example
Download the code from the following link:

[App 1.1-alpha](https://github.com/alexlopezcifuentes/Multi-Camera-Pedestrian-Detection-Benchmark/archive/1.1-alpha.zip)

To download example files (EPFL Terrace Dataset, ground-truth, pedestrian detection files and evaluation sample) and to create the requiered folder structure run the following script:
   ```
   downloadExamples.m
   ```
Once everything has been downloaded run main script:
   ```
   main.m
   ```
The code has been tested on
- [X] Windows Matlab 2018b

## Usage
Once the user has fulfill the files requirement and the folder structure has been created the application has two different options:
1. Opening pedestrian detection files:
    * The user should select the files desidered from Pedestrian Detections folder. 
    * Then choose the number of thresholds and the frame sampling to perform evaluation
    * Choose a name to save the evaluation into a .mat file so it can be after loaded.
    
2. Opening a presaved "Evaluation.mat" file so quantitative and qualitative can be displayed without the need of performing again the evaluation.

After both options the application displays all the qualitative and quantitative results and permits the user to:
* Move forward or backward in the video sequence
* Jump to a desired frame number
* Select the pedestrain detectors to be displayed
* Enable ground-truth displaying
* Set global threshold for all the cameras
* Set individual treshold for each camera (WARNING: The checkbox PD Global Treshold should not be checked)

## TODO
- [ ] Include mean metric values in the table for each algorithm.
- [ ] Set up application as a stand-alone framework.
