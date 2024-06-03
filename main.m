% "Runs are initialized by sampling the starting point from a Gaussian 
% distribution with zero mean and unit covariance matrix and setting the 
% initial step size to σ = 1." (ten-dimensional test problems). p.9
DIMENSION = 10;

% "We conduct 101 runs for each problem, both for the surrogate model 
% assisted (1+1)-ES and for the strategy that does not use model 
% assistance." p.9
RUNS = 101;
startingXValues = randn(RUNS, DIMENSION);

% Perform runs. Each run performs the (1+1)-ES algorithm with and without
% the surrogate model (which is a Gaussian process using the squared
% exponential kernel, p.10). Number of objective function calls are 
% recorded for each run.
nFunctionCallsNoModel = zeros(5, RUNS);
nFunctionCallsModel = zeros(5, RUNS);
for iRun = 1:RUNS
    startingX = startingXValues(iRun, :);
    % Test each of the five problems and store number of objective function
    % calls.
    for functionChoice = 1:5  
        % Perform (1+1)-ES with and without surrogate model.
        nFunctionCalls = oneplusoneES(DIMENSION, startingX, ...
            functionChoice, 0);
        nFunctionCallsNoModel(functionChoice, iRun) = nFunctionCalls;
        
        nFunctionCalls = oneplusoneES(DIMENSION, startingX, ...
            functionChoice, 1);
        nFunctionCallsModel(functionChoice, iRun) = nFunctionCalls;
    end
end

% Compute mean function calls with and without surrogate model and compute
% speed-up (the former divided by the later for all functions. Return
% results as a table.
meanFunctionCallsNoModel = round(mean(nFunctionCallsNoModel, 2));
meanFunctionCallsModel = round(mean(nFunctionCallsModel, 2));
speedUp = round(meanFunctionCallsNoModel ./ ...
    meanFunctionCallsModel, 1);

functionLabels = {'linear sphere'; ...
                  'quadratic sphere'; ...
                  'cubic sphere'; ...
                  'Schwefel''s function'; ...
                  'quartic function'};

T = table(functionLabels, ...
    meanFunctionCallsNoModel, ...
    meanFunctionCallsModel, ...
    speedUp,...
    'VariableNames', {'black-box functions', ...
                      'mean function calls without surrogate model', ...
                      'mean function calls with surrogate model', ...
                      'speed-up'});
disp(T);