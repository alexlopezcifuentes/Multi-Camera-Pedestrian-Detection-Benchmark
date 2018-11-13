function [BlobStructure, BlobStructureGT, Detectors] = processEvaluationFile(app, file, counter, datasetFiles, GeneralDataPath)

% --------------------------------------- %
%               File Loading              %
% --------------------------------------- %
disp('-----------------------------------')
disp('     Loading evaluation file...    ')
load(file)

PopUpMenu = Detectors(:,1);
PopUpMenu{end+1,1} = 'All';
app.DropDownDetectors.Items = PopUpMenu;

% --------------------------------------- %
%           Draw Bounding Boxes           %
% --------------------------------------- %
% Colours
Colors = distinguishable_colors(30);

CenitalPlane = imread(fullfile(GeneralDataPath, 'RGBComplete.png'));
for i = 1 : 3
    CenitalPlane = displayFrame(i, counter, datasetFiles{1,i}(counter), app, Detectors, BlobStructure, BlobStructureGT, GeneralDataPath, CenitalPlane);
end
imshow(CenitalPlane, 'Parent', app.UIAxesCenital);

% --------------------------------------- %
%             Draw ROC Curve              %
% --------------------------------------- %
[~] = getROCCurve(Detectors, Precision, Recall);

% --------------------------------------- %
%           Set Values to Table           %
% --------------------------------------- %
disp('-----------------------------------')
disp('       Printing Results...         ')
disp('-----------------------------------')

Data = createDataMatrix(Precision, Recall, F1Score, AUC, NMODA, NMODP, umbral);
sendData2Table(Data, Detectors, app, file)

end

