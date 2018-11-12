function [answer] = promptSaveDialog()

% Create file dialog to input name to save evaluation
prompt = {'Enter evaluation filename to save the file. Press cancel to skip saving.'};
title = 'Evaluation saving';
dims = [1 60];
definput = {'EvaluationName.mat'};
answer = inputdlg(prompt, title, dims, definput);

end

