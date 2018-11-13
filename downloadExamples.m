clc;
clear all;
close all;

% Script that downloads the following example files to run the application
% Dataset               -> Example dataset (EPFL Terrace). Contains RGB
%                          images and homography matrices
% GT Files              -> Contains ground-truth bounding boxes for 
%                          the example dataset
% Pedestrain Detections -> Contains examples results from two different
%                          algorithms
% Evaluation.mat        -> Contains a precomputed sample evaluation

% Download Dataset
disp('Downloading example dataset...')
outfilename = websave('Terrace Dataset.zip', ...
'https://www.dropbox.com/s/ybunm9g0gbhtl54/Terrace%20Dataset.zip?dl=1');
disp('Dataset downlaoded, unziping...')
exampleFiles = unzip('Terrace Dataset.zip', 'Dataset');
p = genpath('Dataset');
addpath(p)
delete('Terrace Dataset.zip')

% Download GT Files
disp('Downloading example ground-truth files...')
outfilename = websave('GT.zip', ...
'https://drive.google.com/uc?export=download&id=1Ajhc0rf2LvYj23X3No4niMzlOpOlMxMk');
exampleFiles = unzip('GT.zip', 'GT Files');
addpath('GT Files')
delete('GT.zip')

% Download Pedestrian Detections
disp('Downloading example pedestrian files...')
outfilename = websave('Pedestrian Detections.zip', ...
'https://drive.google.com/uc?export=download&id=1nZ11yWiFOJ1NVdrcJUAcTcabUzdU-H81');
exampleFiles = unzip('Pedestrian Detections.zip', 'Pedestrian Detections');
addpath('Pedestrian Detections')
delete('Pedestrian Detections.zip')

% Download Evaluation.mat
disp('Downloading example evaluation file...')
outfilename2 = websave('Evaluation.mat', ...
    'https://drive.google.com/uc?export=download&id=17YNXhFw4nlhcbQOW5gB2kNprmPUbxr_U');

% Start Graphical User Interface
% PedestrianDetectionAPP