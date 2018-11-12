function Blobs_out=Blobs_Threshold_FasterRCNN(Blobs,SelectedSortedScores)

MaxScore = max(SelectedSortedScores);
MinScore = min(SelectedSortedScores);
for i= 1 : size(Blobs,2)
    Blobs_out{i}=[];
    for j=1:size(Blobs{i},2)
        if(Blobs{i}(j).score >= MinScore && Blobs{i}(j).score <= MaxScore)
            Blobs_out{i}=[Blobs_out{i},Blobs{i}(j)];
        end
    end
end