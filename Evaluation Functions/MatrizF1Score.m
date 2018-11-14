function matriz=MatrizF1Score(GTBlobs,TestBlobs)

%%Matriz f1score de los blobs
num_blobs_gt=size(GTBlobs,2);
num_blobs_test=size(TestBlobs,2);
matriz=zeros(num_blobs_gt,num_blobs_test);
blob_asignados_gt=[];
blob_asignados_test=[];
if(num_blobs_gt~=0 && num_blobs_test~=0)
    for i=1:num_blobs_gt
        for j=1:num_blobs_test
            blob_gt=[GTBlobs(i).x GTBlobs(i).y GTBlobs(i).w GTBlobs(i).h];
            blob_test=[TestBlobs(j).x TestBlobs(j).y TestBlobs(j).w TestBlobs(j).h];
            areaint = rectint(blob_gt,blob_test);

            area = blob_test(3)*blob_test(4);
            areaGT = blob_gt(3)*blob_gt(4);

            precision = areaint/area;
            recall = areaint/areaGT;

            f1 = 2*(precision*recall)/(precision+recall);
            if isnan(f1)
                f1 = 0;
            end;
            matriz(i,j)=f1;
        end
    end
end