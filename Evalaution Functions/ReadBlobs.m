function [Blobs, Scores] = ReadBlobs(filename, video_name, min_dtdp_score, max_dtdp_score, threshold)
% Function created by Alvaro Garcia from the Video Processing and
% Understanding Lab

if nargin < 5
    threshold=-inf;
end

fid=fopen(filename);
cadena=fgets(fid);
num_frame=1;
Blobs={};
Scores=[];
Blobs{num_frame}=[];
flag=0;
while( size(cadena,2)>4 )
    inicios=find(cadena=='(');
    separadores=find(cadena=='/');
    puntos=find(cadena==':');
    num_blobs=size(inicios,2);
    
    if(num_blobs>0)
        aux=sprintf('/%s%%d.jpg":',video_name);
        num_frame1=sscanf(cadena(1,separadores(end):puntos(1)),aux);
        aux=sprintf('/frame%%d.jpeg":',video_name);
        num_frame2=sscanf(cadena(1,separadores(end):puntos(1)),aux);
        
        %         aux=sprintf('/vlcsnap-2014-12-22-%%d.png":');
        %         num_frame1=sscanf(cadena(1,separadores(end):puntos(1)),aux);
        %         aux=sprintf('/frame%%d.png":',video_name);
        %         num_frame2=sscanf(cadena(1,separadores(end):puntos(1)),aux);
        
        if isempty(num_frame1)
            num_frame=num_frame2;
        else
            num_frame=num_frame1;
        end
        if(num_frame==0)
            flag=1;
        end
        if(flag)
            num_frame=num_frame+1;
        end
        
        Temp=sscanf(cadena(1,inicios(1):end),'(%d, %d, %d, %d):%f, ');
        Blobs{num_frame}=[];
        for i=1:num_blobs
            X1=Temp((i-1)*5+1);
            Y1=Temp((i-1)*5+2);
            X2=Temp((i-1)*5+3);
            Y2=Temp((i-1)*5+4);
            Score=Temp((i-1)*5+5);
            if X1<0
                blob.x=0;
            else
                blob.x=X1;
            end
            if Y1<0
                blob.y=0;
            else
                blob.y=Y1;
            end
            %             blob.w=abs(X1-X2)*4;
            %             blob.h=abs(Y1-Y2)*4;
            blob.w=abs(X2);
            blob.h=abs(Y2);
            blob.num_frame=num_frame;
            blob.score=Score;
            
            if nargin >= 5
                blob.score=(0.95/(max_dtdp_score-min_dtdp_score))*(Score-min_dtdp_score)+0.05;
            end
            
            %%eliminamos blobs fura de la maskara de procesamiento
            center.x=blob.x+blob.w/2;
            center.y=blob.y+blob.h/2;
            if(Score>threshold)
                Blobs{num_frame}=[Blobs{num_frame} blob];
                Scores=[Scores Score];
            end
        end
    end
    
    
    cadena=fgets(fid);
    
end

fclose(fid);


