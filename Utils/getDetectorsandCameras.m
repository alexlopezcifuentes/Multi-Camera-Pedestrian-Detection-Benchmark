function [Detectors] = getDetectorsandCameras(file)

% Decode filenames to extract the Pedestrian Detectors and the number of
% cameras of each one

nFiles = size(file, 2);
PD = cell(1,1);
for i = 1 : nFiles
    % Filename
    filename = file{1,i};
    
    
    % Pedestrian detector
    PDIndex = strfind(filename,'_');
    PDName = filename(1:PDIndex-1);
    PD{i,1} = PDName;
    
    % Camera Number
    CameraIndex = strfind(filename,'_Cam');
    PointIndex = strfind(filename,'.');
    Camera = filename(CameraIndex+4:PointIndex-1);
    PD{i,2} = str2num(Camera);
end

Detectors = unique(PD(:,1));
nDetectors = size(Detectors,1);

for i = 1 : nDetectors
    Index = strfind(PD(:,1), Detectors{i,1});
    Cameras = [];
    Counter = 1;
    for j = 1 : size(Index,1)
        if(Index{j})
            Cameras(Counter) = PD{j, 2};
            Counter = Counter + 1;
        end
    end
    Detectors{i,2} = numel(Cameras);
    Detectors{i,3} = Cameras;
end

end

