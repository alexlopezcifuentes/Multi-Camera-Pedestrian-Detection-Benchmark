function [Data] = createDataMatrix(Precision, Recall, F1Score, AUC, NMODA, NMODP, umbral)

% Create the data matrix with values for the statistics
Data = zeros(size(Precision,1) * size(Precision,2), 6);

Counter = 1;
for  i = 1 : size(Precision,1)
    for j = 1 : size(Precision,2)
        % Precision
        Data(Counter,1) = Precision(i,j,umbral(i,j));
        % Recall
        Data(Counter,2) = Recall(i,j,umbral(i,j));
        % F-Score
        Data(Counter,3) = F1Score(i,j,umbral(i,j));
        % AUC
        Data(Counter,4) = AUC(i,j);
        % N-MODA
        Data(Counter,5) = NMODA(i,j,umbral(i,j));
        % N-MODP
        Data(Counter,6) = NMODP(i,j,umbral(i,j));
        Counter = Counter + 1;
    end
end
end

