function [blob_asignados_1,blob_asignados_2,blob_noasignados_1,blob_noasignados_2]=BlobAssigment(Blobs1,Blobs2)
%%Matriz f1score de los blobs
num_blobs_1=size(Blobs1,2);
num_blobs_2=size(Blobs2,2);
matriz=zeros(num_blobs_1,num_blobs_2);
blob_asignados_1=[];
blob_asignados_2=[];
blob_noasignados_1=[];
blob_noasignados_2=[];
if(num_blobs_1~=0 && num_blobs_2~=0)

    matriz=MatrizF1Score(Blobs1,Blobs2);

    %%realizamos asignacion de blobs según f1score >=0.3
    [maximos_filas,posiciones_filas]=max(matriz);
    %eliminamos duplicados
    maximos_temp = unique(maximos_filas);
    %%eliminamos los ceros
    maximos=[];
    for i=1:size(maximos_temp,2)
        if(maximos_temp(i)~=0)
            maximos=[maximos maximos_temp(i)];
        end
    end



    for i=1:size(maximos,2)
        matriz_aux=matriz/maximos(i);
        [index_fila,index_columna]=find(matriz_aux==1);
        flag_asignacion=1;
        for j=1:size(index_fila,2)
            index=find(matriz_aux(index_fila(j),:)>1);
            if(~isempty(index))
                flag_asignacion=0;
               
            end
            index=find(matriz_aux(:,index_columna(j))>1);
            if(~isempty(index))
                flag_asignacion=0;
                
            end
            %%F1Score minimo de 0.3
            if(matriz(index_fila(j),index_columna(j))<0.3)
                flag_asignacion=0;
                
            end
            if(flag_asignacion==1)
                %%comprobar que el centro del gt esta dentro del blob de
                %%si ambos centros no estan dentro pero el blob de test
                %%practicamente engloba al de gt es una asignación
                %%f1<0.7
                blob_12=[Blobs1(index_fila(j)).x Blobs1(index_fila(j)).y Blobs1(index_fila(j)).w Blobs1(index_fila(j)).h];
                blob_22=[Blobs2(index_columna(j)).x Blobs2(index_columna(j)).y Blobs2(index_columna(j)).w Blobs2(index_columna(j)).h];
                areaint = rectint(blob_12,blob_22);
                area = blob_22(3)*blob_22(4);
                areaGT = blob_12(3)*blob_12(4);
                precision = areaint/area;
                recall = areaint/areaGT;
                f1 = 2*(precision*recall)/(precision+recall);

                blob_1=Blobs1(index_fila(j));
                blob_2=Blobs2(index_columna(j));
                center_1.x=blob_1.x+(blob_1.w/2);
                center_1.y=blob_1.y+(blob_1.h/2);
                center_2.x=blob_2.x+(blob_2.w/2);
                center_2.y=blob_2.y+(blob_2.h/2);
%                 if(f1<0.5 && (center_1.x<blob_2.x || center_2.x<blob_1.x || center_1.x>(blob_2.x+blob_2.w) || center_2.x>(blob_1.x+blob_1.w)))
%                     flag_asignacion=0;
%                     
%                 end
%                 if(f1<0.5 && (center_1.y<blob_2.y || center_2.y<blob_1.y || center_1.y>(blob_2.y+blob_2.h) || center_2.y>(blob_1.y+blob_1.h)))
%                     flag_asignacion=0;
%                    
%                 end

                
            end
            if flag_asignacion==1
                blob_asignados_1=[blob_asignados_1 index_fila(j)];
                blob_asignados_2=[blob_asignados_2 index_columna(j)];
            end
        end
    end
end

for i=1:num_blobs_1
    if(isempty(find(blob_asignados_1==i)) && isempty(find(blob_noasignados_1==i)))
        blob_noasignados_1=[blob_noasignados_1 i];
    end    
end
for i=1:num_blobs_2
    if(isempty(find(blob_asignados_2==i)) && isempty(find(blob_noasignados_2==i)))
        blob_noasignados_2=[blob_noasignados_2 i];
    end    
end

