function [BlobStructure, BlobStructureGT, Detectors] = processFiles(app, file, counter, datasetFiles, GeneralDataPath)
tic

% --------------------------------------- %
%              Initialization             %
% --------------------------------------- %
disp('-----------------------------------')
disp('        Initialization...          ')

% Check if only one file has been selected and convert char to cell
if(ischar(file))
    fileAux{1,1} = file;
    file = fileAux;
end

% Get number of files
nFiles = size(file, 2);
% Get detectors and number of cameras
Detectors = getDetectorsandCameras(file);

if(max(cell2mat(Detectors(:,2))) > 3)
    disp(['You have selected more than 3 cameras for the evaluation.'...
        'At the moment more than 3 cameras are not supported.'])
    exit()
end

PopUpMenu = Detectors(:,1);
PopUpMenu{end+1,1} = 'All';
app.DropDownDetectors.Items = PopUpMenu;

% --------------------------------------- %
%              Decode files               %
% --------------------------------------- %
disp('-----------------------------------')
disp('         File Decoding...          ')
disp('-----------------------------------')
disp('Decoding bounding box files')
[BlobStructure, BlobStructureGT] = decodeFiles(Detectors, file);


% --------------------------------------- %
%                Evaluation               %
% --------------------------------------- %
disp('-----------------------------------')
disp(' Evaluating pedestrian detectors...')
disp('-----------------------------------')
% Select the number of threshold and the frame sampling to be evaluated
prompt = {'Enter the number of threshold to evaluate:','Enter frame sampling:'};
title = 'Evaluation configuration';
dims = [1 45; 1 25];
definput = {'20','1'};
answer = inputdlg(prompt,title,dims,definput);

NThresholds = str2double(answer{1,1});
Sampling = str2double(answer{2,1});

% Evaluate pedestrian detection files
[Precision, Recall, F1Score, AUC, NMODA, NMODP] =...
    evaluatePD(BlobStructure, BlobStructureGT, NThresholds, Sampling, Detectors);

% Extract the maximum FScore
[~, umbral] = max(F1Score,[],3);

% Create Data Matrix to be displayed in the GUI table
Data = createDataMatrix(Precision, Recall, F1Score, AUC, NMODA, NMODP, umbral);

disp('Evaluation finished.')

% --------------------------------------- %
%           Draw Bounding Boxes           %
% --------------------------------------- %
% Colours
Colors = distinguishable_colors(30);

CenitalPlane = imread(fullfile(GeneralDataPath, 'Dataset', 'RGBComplete.png'));
for i = 1 : 3
    CenitalPlane = displayFrame(i, counter, datasetFiles{1,i}(counter), app, Detectors, BlobStructure, BlobStructureGT, GeneralDataPath, CenitalPlane);
end
imshow(CenitalPlane, 'Parent', app.UIAxesCenital);


% --------------------------------------- %
%           Set Values to Table           %
% --------------------------------------- %
disp('-----------------------------------')
disp('       Printing Results...         ')

sendData2Table(Data, Detectors, app, file)

% --------------------------------------- %
%             Time Statistics             %
% --------------------------------------- %
disp('-----------------------------------')
disp('         Time Statistics           ')
disp('-----------------------------------')
disp(['Elapsed time for the evaluation: ' num2str(toc/60) ' minutes']);

% --------------------------------------- %
%             Save Evaluation             %
% --------------------------------------- %
disp('-----------------------------------')
disp('              Saving               ')
disp('-----------------------------------')
disp(['Saving file...']);
[answer] = promptSaveDialog();
if(~isempty(answer))
    save(answer{1,1}, 'BlobStructure', 'BlobStructureGT', 'Data', 'Detectors',...
        'file', 'Precision', 'Recall', 'F1Score', 'AUC', 'NMODA', 'NMODP', 'umbral');
end
disp(['File saved.']);
end

