function [CenitalPlane] = displayFrame(Camera, Counter, imageStruct, App,...
    Detectors, BlobStructure, BlobStructureGT, GeneralDataPath, CenitalPlane)

img = imread([imageStruct.folder '/' imageStruct.name]);

Colors = distinguishable_colors(size(Detectors, 1)+1);

HomographyPath = (fullfile(GeneralDataPath, ['Homography ' num2str(Camera) '.txt']));
Homography = readHomographyFile(HomographyPath);
tform = projective2d(Homography');

if(App.PDGlobalThFlag.Value)
    ScoreThresholdDraw = App.PDTh.Value;
else
    ScoreThresholdDraw = App.(['PDThCam' num2str(Camera)]).Value;
    App.(['PDThInputCam' num2str(Camera)]).Value = ScoreThresholdDraw;
end

imshow(img, 'Parent', App.(['UIAxesCam' num2str(Camera)]));
hold(App.(['UIAxesCam' num2str(Camera)]));

% Groundtruth bounding boxes
if(App.CheckBoxGT.Value)
    GTBlobs = BlobStructureGT.(['BlobsCamera' num2str(Camera) '_GT']);
    GTBlobs = GTBlobs{1, Counter};
    for n = 1 : size(GTBlobs,2)
        Blob = GTBlobs(n);
        rectangle('Position', [Blob.x, Blob.y, Blob.w, Blob.h],...
            'EdgeColor', Colors(1,:), 'LineWidth', 2, ...
            'Parent', App.(['UIAxesCam' num2str(Camera)]));
        
        % Drow Position on Cenital Plane
        PointsX = Blob.x + (Blob.w/2);
        PointsY = Blob.y + Blob.h;
        
        [ProjectedPointsX, ProjectedPointsY] = transformPointsForward(tform, PointsX, PointsY);
        ProjectedPointsX = round(ProjectedPointsX);
        ProjectedPointsY = round(ProjectedPointsY);
        
        if(ProjectedPointsX > 0 && ProjectedPointsY > 0 && ProjectedPointsX <= size(CenitalPlane,1) && ProjectedPointsY <= size(CenitalPlane,2))
            % Print bb
            CenitalPlane = insertShape(CenitalPlane, 'FilledCircle',...
                [ProjectedPointsX ProjectedPointsY 10], 'LineWidth', 5, 'Color', Colors(1,:)*255);
        end
    end
end

if(strcmp('All', App.DropDownDetectors.Value))
    for j = 1 : size(Detectors, 1)
        Blobs = BlobStructure.(['Blobs' Detectors{j,1} 'Camera' num2str(Camera)]);
        Blobs = Blobs{1, Counter};
        for n = 1 : size(Blobs,2)
            Blob = Blobs(n);
            if(Blob.score > ScoreThresholdDraw)
                rectangle('Position', [Blob.x, Blob.y, Blob.w, Blob.h],...
                    'EdgeColor', Colors(j+1,:), 'LineWidth', 2, ...
                    'Parent', App.(['UIAxesCam' num2str(Camera)]));
                
                % Drow Position on Cenital Plane
                PointsX = Blob.x + (Blob.w/2);
                PointsY = Blob.y + Blob.h;
                
                [ProjectedPointsX, ProjectedPointsY] = transformPointsForward(tform, PointsX, PointsY);
                ProjectedPointsX = round(ProjectedPointsX);
                ProjectedPointsY = round(ProjectedPointsY);
                
                if(ProjectedPointsX > 0 && ProjectedPointsY > 0 && ProjectedPointsX <= size(CenitalPlane,1) && ProjectedPointsY <= size(CenitalPlane,2))
                    % Print bb
                    CenitalPlane = insertShape(CenitalPlane, 'FilledCircle',...
                        [ProjectedPointsX ProjectedPointsY 10], 'LineWidth', 5, 'Color', Colors(j+1,:)*255);
                end
            end
        end
    end
else
    DetectorName = App.DropDownDetectors.Value;
    DetectorIndex = find(contains(Detectors(:,1),DetectorName));
    
    Blobs = BlobStructure.(['Blobs' DetectorName 'Camera' num2str(Camera)]);
    Blobs = Blobs{1, Counter};
    for n = 1 : size(Blobs,2)
        Blob = Blobs(n);
        if(Blob.score > ScoreThresholdDraw)
            % Draw Image Bounding Box
            rectangle('Position', [Blob.x, Blob.y, Blob.w, Blob.h],...
                'EdgeColor', Colors(DetectorIndex+1,:), 'LineWidth', 2, ...
                'Parent', App.(['UIAxesCam' num2str(Camera)]));
            
            % Drow Position on Cenital Plane
%             HomographyPath = (fullfile(GeneralDataPath, ['Homography ' num2str(Camera) '.txt']));
%             Homography = readHomographyFile(HomographyPath);
%             tform = projective2d(Homography');
            
            PointsX = Blob.x + (Blob.w/2);
            PointsY = Blob.y + Blob.h;
            
            [ProjectedPointsX, ProjectedPointsY] = transformPointsForward(tform, PointsX, PointsY);
            ProjectedPointsX = round(ProjectedPointsX);
            ProjectedPointsY = round(ProjectedPointsY);
            
            if(ProjectedPointsX > 0 && ProjectedPointsY > 0 && ProjectedPointsX <= size(CenitalPlane,1) && ProjectedPointsY <= size(CenitalPlane,2))
                % Print bb
                CenitalPlane = insertShape(CenitalPlane, 'FilledCircle',...
                    [ProjectedPointsX ProjectedPointsY 10], 'LineWidth', 5, 'Color', Colors(DetectorIndex+1,:)*255);
            end
        end
    end
end






