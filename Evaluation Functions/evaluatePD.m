function [Precision, Recall, F1Score, AUC, NMODA, NMODP] = evaluatePD(BlobStructure, BlobStructureGT, N, Sampling, Detectors)

f = waitbar(0,'Evaluating...');
thresholds = linspace(0, 1, N);

TotalCameraNumber = max(cell2mat(Detectors(:,2)));

% General matrices for saving results
Precision = zeros(size(Detectors,1), TotalCameraNumber, size(thresholds,2));
Recall    = zeros(size(Detectors,1), TotalCameraNumber, size(thresholds,2));
F1Score   = zeros(size(Detectors,1), TotalCameraNumber, size(thresholds,2));
NMODA     = zeros(size(Detectors,1), TotalCameraNumber, size(thresholds,2));
NMODP     = zeros(size(Detectors,1), TotalCameraNumber, size(thresholds,2));
fp        = zeros(size(Detectors,1), TotalCameraNumber, size(thresholds,2));
tp        = zeros(size(Detectors,1), TotalCameraNumber, size(thresholds,2));
tn        = zeros(size(Detectors,1), TotalCameraNumber, size(thresholds,2));
fn        = zeros(size(Detectors,1), TotalCameraNumber, size(thresholds,2));

TotalIterations = sum(cell2mat(Detectors(:,2))) * N;
barCounter = 1;
for k = 1 : size(Detectors,1)
    for p = cell2mat(Detectors(k,3))
        for j = 1 : N
            % For the first threshold get number of blobs and normalize scores
            if j == 1
                waitbar(barCounter/TotalIterations, f,...
                    ['Normalizing ' Detectors{k} ' Camera ' num2str(p) ' Scores...']);
                disp(['Evaluating ' Detectors{k} ' Camera ' num2str(p) '...'])
                num_frame_gt = size(BlobStructureGT.(['BlobsCamera' num2str(p) '_GT']), 2);
                
                % Normalize scores
                disp('   Normalizing Scores...')
                [Blobs_total_people, Scores_total_people] ...
                    = NormalizeScores(BlobStructure.(['Blobs' Detectors{k} 'Camera' num2str(p)]),...
                    BlobStructure.(['Scores' Detectors{k} 'Camera' num2str(p)]), Detectors{k});
                
                SortedScores = sort(Scores_total_people);
                Parts = floor(size(SortedScores,2)/N);
                
                SelectedSortedScores = SortedScores;
                disp('   Assigning bounding boxes to ground-truth')
                barCounter = barCounter + 1;
            else
                SelectedSortedScores = SortedScores(Parts*j:end);
            end
            waitbar(barCounter/TotalIterations, f, ['Evaluating ' Detectors{k} ' Camera ' num2str(p) '...']);
            barCounter = barCounter + 1;
            
            % Select the blobs for the evaluation depending on the score
            PDBlobs = Blobs_Threshold(Blobs_total_people, SelectedSortedScores);
            
            % Extract minimum number of frames
            num_frame_PD = size(PDBlobs,2);
            num = [num_frame_gt num_frame_PD];
            num_frames = min(num);
            
            % Extract statistics
            [Blobs, Precision(k,p,j), Recall(k,p,j), F1Score(k,p,j),...
                labels, scores, tp(k,p,j), fp(k,p,j), tn(k,p,j),...
                fn(k,p,j), NumBlobsGT, asignadosGT, asignadosPD] = ...
                PeopleDetectionEval(BlobStructureGT.(['BlobsCamera' num2str(p) '_GT']), PDBlobs, num_frames, Sampling);
            
            % Compute NMODA
            NMODA(k,p,j) = computeNMODA( fn(k,p,j), fp(k,p,j), NumBlobsGT );
            
            % Compute NMODP
            NMODP(k,p,j) = computeNMODP( BlobStructureGT.(['BlobsCamera' num2str(p) '_GT'])(1,1:num_frames), asignadosGT, PDBlobs, asignadosPD, Sampling );
        end
    end
end

% Close waitbar
close(f)

[AUC] = getROCCurve(Detectors, Precision, Recall);