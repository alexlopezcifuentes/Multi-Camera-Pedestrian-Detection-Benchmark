function [AUC] = getROCCurve(Detectors, Precision, Recall)

% Get ROC Curve and Area Under the Curve metric
% Colours
Colors = distinguishable_colors(30);

figure()
Counter = 1;
for k = 1 : size(Detectors,1)
    for p = 1 : cell2mat(Detectors(k,2))
        Precision_aux = squeeze(Precision(k,p,:));
        Recall_aux = squeeze(Recall(k,p,:));

        % Vectors for ROC curve
        PrecisionGraph = [0 Precision_aux'];
        RecallGraph = [Recall_aux(1) Recall_aux'];
        FScore = 2 * (PrecisionGraph .* RecallGraph) ./ (PrecisionGraph + RecallGraph);
        
        aux = 0;
        ejey = RecallGraph;
        ejex = 1 - PrecisionGraph;
        ejex = fliplr(ejex);
        ejey = fliplr(ejey);
        
        for n = 1 : size((ejex), 2) - 1
            aux = aux + ((ejey(n) + ejey(n+1))) / 2 * (ejex(n + 1) - ejex(n));
        end
        AUC(k, p) = aux;
        
        % Representation of curves
        hold on
        plot([RecallGraph 0], [PrecisionGraph 1], '-', 'LineWidth', 2, 'Color', Colors(Counter,:))
        legendVector{1, Counter} = [Detectors{k,1} ' Camera ' num2str(p)];
        Counter = Counter + 1;
    end
end
xlim([0 1]);
ylim([0 1]);
xlabel('Recall')
ylabel('Precision')
title('Precision - Recall Curve')
legend(legendVector,'Position',[0.17 0.16 0.31 0.23])
end

