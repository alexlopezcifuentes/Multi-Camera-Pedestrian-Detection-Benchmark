function [ NMODP ] = computeNMODP( GT, AsignadosGT, Detections, AsignadosPD, Sampling )
% This funciton computes the N-MODP for an entire sequence
% The N-MODP hence gives the detection accuracy
% for the entire sequence

NFrames = size(AsignadosGT,2);

Counter = 1;
for Frame = 1 : Sampling : NFrames
    NMapped = size(AsignadosGT{Frame},2);
    if(NMapped >0)
        OverlapRatio = 0;
        for Mapped = 1 : NMapped
            IndexGt = AsignadosGT{Frame}(Mapped);
            IndexPD = AsignadosPD{Frame}(Mapped);
            BBGT = [GT{Frame}(IndexGt).x GT{Frame}(IndexGt).y GT{Frame}(IndexGt).w GT{Frame}(IndexGt).h];
            BBDetection = [Detections{Frame}(IndexPD).x Detections{Frame}(IndexPD).y Detections{Frame}(IndexPD).w Detections{Frame}(IndexPD).h];
            OverlapRatio = OverlapRatio + bboxOverlapRatio(BBGT, BBDetection);
        end
        MODP(Frame) = OverlapRatio / NMapped;
    else
        MODP(Frame) = 1;
    end
    Counter = Counter + 1;
end
NMODP = sum(sum(MODP)) ./ Counter;
end

