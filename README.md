# Multi-Camera Pedestrian Detection Benchmark Application
![Main App Interface](https://github.com/alexlopezcifuentes/Multi-Camera-Pedestrian-Detection-Benchmark/blob/master/Doc/App%20Example.png)

## Intorduction
This application creates an interative framework to perform two different task:
1. Evaluate at the same time different multi-camera pedestrian detection algorithms. The following measures are extracted:
    * Precision
    * Recall
    * F-Score
    * Area Under the Curve
    * N-MODA
    * N-MODP
2. Visualize both obtained results and ground-truth on dataset images and ground-plane.

## Requirements
In order to perform evaluation and visualization with the application the following files are needed:
1. Dataset: RGB frames and homography matricies from maximum 3 different cameras. Besides, if cenital plane visualization is desired a cenital image is needed. Homography matrices should be in the following format:
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

An example of the needed folder and filenames structure for a 3 camera evaluation with DPM and Faster-RCNN algorithms is the following:
* /Dataset/
  * /Camera 1/
  * /Camera 2/
  * /Camera 3/
  * Homography 1.txt
  * Homography 2.txt
  * Homography 3.txt
  * RGBComplete.png
* /GT Files/
  * Cam1_GT.idl
  * Cam2_GT.idl
  * Cam3_GT.idl
* /Pedestrian Detections/
  * DPM_Cam1.idl
  * DPM_Cam2.idl
  * DPM_Cam3.idl
  * FasterRCNN_Cam1.idl
  * FasterRCNN_Cam2.idl
  * FasterRCNN_Cam3.idl
  
## Example
Download the code from the following link:

[Application a1.0](https://github.com/alexlopezcifuentes/Multi-Camera-Pedestrian-Detection-Benchmark/archive/a1.0.zip)

To download example files (dataset, ground-truth, pedestrian detection files and evaluation sample) the run the following script:

    downloadExamples.m

The code has been tested on Windows Matlab 2018b

## Usage
The application has two different ways of working:
1. Open pedestrian detection files

2. Open a presaved "Evaluation.mat" file so quantitative and qualitative can be displayed without the need of performing again the evaluation.

## TODO
- [ ] Include mean metric values in the table for each algorithm.
- [ ] Set up application as a stand-alone framework.
