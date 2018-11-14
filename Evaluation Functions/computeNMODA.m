function [ NMODA ] = computeNMODA( Misses, FalsePositives, NGroundTruth )
% This functions computes the Normalize Multiple Object Detection
% Accuracy(MODA) measure for an entire sequence to
% measure system performance

Cm = 1;
Cf = 1;

Numerator = (Cm .* Misses + Cf .* FalsePositives);

NMODA = 1 - (Numerator / NGroundTruth);

if(NMODA < 0)
    NMODA = 0;
end

end

