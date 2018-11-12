function [ Blobs_total_people, Scores_total_people ] = NormalizeScores(Blobs_total_people_nonorm, Scores_total_people_nonorm, PD_algorithm)

load(fullfile('Evalaution Functions Definitiva', 'Score Distributions', ['PDF_' PD_algorithm, '.mat']))
NParams = size(BestD.Params, 2);

if(NParams == 2)
    for i = 1 : size(Blobs_total_people_nonorm, 2)
        for j = 1 : size(Blobs_total_people_nonorm{i}, 2)
            Blobs_total_people_nonorm{i}(j).score = cdf(BestD.DistName, Blobs_total_people_nonorm{i}(j).score, BestD.Params(1), BestD.Params(2));
        end
    end
    Scores_total_people = cdf(BestD.DistName, Scores_total_people_nonorm, BestD.Params(1), BestD.Params(2));
else
    for i = 1 : size(Blobs_total_people_nonorm, 2)
        for j = 1 : size(Blobs_total_people_nonorm{i}, 2)
            Blobs_total_people_nonorm{i}(j).score = cdf(BestD.DistName, Blobs_total_people_nonorm{i}(j).score, BestD.Params(1), BestD.Params(2), BestD.Params(3));
        end
    end
    Scores_total_people = cdf(BestD.DistName, Scores_total_people_nonorm, BestD.Params(1), BestD.Params(2), BestD.Params(3));
end
Blobs_total_people = Blobs_total_people_nonorm;
end

