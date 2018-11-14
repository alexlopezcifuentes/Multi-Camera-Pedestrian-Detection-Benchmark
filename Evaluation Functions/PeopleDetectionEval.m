function [Blobs,Precision,Recall,F1Score,labels,scores,tp,fp,tn,fn,num_blobs_gt_out, blob_asignados_gt, blob_asignados_test]...
    = PeopleDetectionEval(GTBlobs,TestBlobs,num_frames, Sampling)


Blobs={};
tp=0;
fp=0;
tn=0;
fn=0;

predictions = [];
labels = [];
scores = [];
num_blobs_gt_out = 0;

for frame = 1 : Sampling : num_frames
    if(frame>size(GTBlobs,2))
        num_blobs_gt=0;
        GTBlobs{frame}=[];
    else
        num_blobs_gt=size(GTBlobs{frame},2);
    end
    if(frame>size(TestBlobs,2))
        num_blobs_test=0;
        TestBlobs{frame}=[];
    else
        num_blobs_test=size(TestBlobs{frame},2);
    end

    [blob_asignados_gt{frame},blob_asignados_test{frame}]=BlobsAssigment(GTBlobs{frame},TestBlobs{frame});
    
    num_blobs_asignados=size(blob_asignados_gt{frame},2);
    num_blobs_test_noasignados=num_blobs_test-num_blobs_asignados;
    num_blobs_gt_noasignados=num_blobs_gt-num_blobs_asignados;

    tp_temp=num_blobs_asignados;
    fp_temp=num_blobs_test_noasignados;
    fn_temp=num_blobs_gt_noasignados;
    num_blobs_gt_temp=num_blobs_gt;
    
    
    Blobs{frame}=[];
    %%Blobs de salida
    for i=1:num_blobs_gt
        blob=GTBlobs{frame}(i);
        blob_aux.x=blob.x;
        blob_aux.y=blob.y;
        blob_aux.w=blob.w;
        blob_aux.h=blob.h;
        blob_aux.score=-1;
        if(isempty(find(blob_asignados_gt{frame} == i)))%%blob no detectado
            blob_aux.color=[0 0 255];%azul de falso negativo
            Blobs{frame}=[Blobs{frame} blob_aux]; 
        end 
    end
    
    for i=1:num_blobs_test
        blob=TestBlobs{frame}(i);
        blob_aux.x=blob.x;
        blob_aux.y=blob.y;
        blob_aux.w=blob.w;
        blob_aux.h=blob.h;
        blob_aux.score=blob.score;
     
        if(~isempty(find(blob_asignados_test{frame}==i)))%%Blob acertado
            blob_aux.color=[0 255 0];%verde de acierto
            predictions=[predictions 1];
            labels=[labels 1];
            scores=[scores blob.score];
        else%%Blob fallado
            blob_aux.color=[255 0 0];%rojo de falso positivo
            predictions=[predictions 1];
            labels=[labels 0];
            scores=[scores blob.score];
        end
        Blobs{frame}=[Blobs{frame} blob_aux];
    end
    
    tp=tp+tp_temp;
    fp=fp+fp_temp;
    fn=fn+fn_temp;
    num_blobs_gt_out=num_blobs_gt_out+num_blobs_gt_temp;

    if(num_blobs_gt~=(tp_temp+fn_temp))
        print('Error num_blobs_gt en PeopleDetectionEval');
        pause;
    end
    if(num_blobs_test~=(tp_temp+fp_temp))
        print('Error num_blobs_test en PeopleDetectionEval');
        pause;
    end
    
    
end

Precision=tp/(tp+fp);
if isnan(Precision)
    Precision=1;
end
Recall=tp/(tp+fn);
F1Score=2*(Precision*Recall)/(Precision+Recall);



