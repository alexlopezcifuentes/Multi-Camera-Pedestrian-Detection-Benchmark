function [] = sendData2Table(Data, Detectors, App, file)
% Set numbers to the table
App.UITableResults.Data = Data;

% Define row names depending on the selected files
RowNames = cell(size(file,2), 1);
Counter = 1;
for i = 1 : size(Detectors,1)
    index = cell2mat(Detectors(i,3));
    for j = 1 : Detectors{i,2}
        RowNames{Counter,1} = [Detectors{i,1} ' Camera ' num2str(index(j))];
        Counter = Counter + 1; 
    end
end
% Set row names
App.UITableResults.RowName = RowNames;

App.UITableResults.Position(1,4) = 150;
end

