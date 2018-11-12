function [BlobStructure, BlobStructureGT] = decodeFiles(Detectors, file)

BlobStructure = struct();
Counter = 1;
for i = 1 : size(Detectors,1)
    index = cell2mat(Detectors(i,3));
    for j = 1 : Detectors{i,2}
        disp(['   Decoding ' Detectors{i,1} ' Camera ' num2str(index(j))])
        [Blobs, Scores] = ReadBlobs(file{Counter}, ['Camera' num2str(index(j))]);
        BlobStructure.(['Blobs' Detectors{i,1} 'Camera' num2str(index(j))]) = Blobs;
        BlobStructure.(['Scores' Detectors{i,1} 'Camera' num2str(index(j))]) = Scores;
        Counter = Counter + 1;
    end
end

disp('Decoding ground-truth bounding box files')
BlobStructureGT = struct();

index = cell2mat(Detectors(1,3));
for j = 1 : Detectors{i,2}
    disp(['   Decoding Camera' num2str(index(j)) ' GT'])
    
    GTFile = fullfile('GT Files',...
        [file{j}(strfind(file{j}, '_')+1 : strfind(file{j}, '.idl')-1) '_GT.idl']);
    
    [Blobs, Scores] = ReadBlobs(GTFile, ['Camera' num2str(index(j))]);
    BlobStructureGT.(['BlobsCamera' num2str(index(j)) '_GT']) = Blobs;
    BlobStructureGT.(['ScoresCamera' num2str(index(j)) '_GT']) = Scores;
end

end

