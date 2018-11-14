function [] = sendData2Table(Data, Detectors, App, file)

% Delete zero rows
Data( ~any(Data,2), : ) = [];

% Set numbers to the table
App.UITableResults.Data = Data;

% Define row names depending on the selected files
RowNames = cell(size(Data,1), 1);
Counter = 1;
for i = 1 : size(Detectors,1)
    for j = cell2mat(Detectors(i,3))
        RowNames{Counter,1} = [Detectors{i,1} ' Camera ' num2str(j)];
        Counter = Counter + 1; 
    end
end
% Set row names
App.UITableResults.RowName = RowNames;

App.UITableResults.Position(1,4) = 150;
end

