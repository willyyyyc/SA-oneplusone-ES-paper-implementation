function nFunctionCalls = oneplusoneES(dimension, startingX, ...
    functionChoice, surrogateToggle)
% nFunctionCalls: Performs (1+1)-ES algorithm and returns the total number
% of objective function calls. Value of surrogateToggle decides whether or
% not it is SA(1+1)-ES.

    % Nonnegative constants c1, c2, c3 to adapt stepsize. p.9
    % Magnitude of step size, D. p.8
    % sigma = 1 initally; see main.m.
    sigma = 1;
    C1 = 0.05;
    C2 = 0.2;
    C3 = 0.6;
    D = sqrt(1 + dimension);
    % Store computation in constant to avoid repeated calculation.
    STEPSIZE_UPDATE_1 = exp(-C1 ./ D);   
    STEPSIZE_UPDATE_2 = exp(-C2 ./ D);
    STEPSIZE_UPDATE_3 = exp(C3 ./ D);
    STEPSIZE_ES_DEC = exp(-0.2 ./ D);
    STEPSIZE_ES_INC = exp(0.8 ./ D);
    
    % "The training set consists of the 40 most recently evaluated 
    % candidate solutions." p. 10
    MAX_TRAINING_POINT_COUNT = 40;
    trainingPoints = startingX;
    evaluatedPoints = objectiveFunction(startingX, functionChoice);
    nFunctionCalls = 1;
    x = startingX;
    fX = evaluatedPoints(1);

    % "Runs are terminated when a solution with objective function value 
    % below 10−8 has been found." p.10
    while fX > 10e-8
        % Generate single offspring candidate solution, p.3-4.
        z = randn(1, dimension);
        y = x + sigma .* z;

        % Perform (1+1)-ES or Surrogate Model Assisted (1+1)-ES (but only
        % after an archive of 40 most recent training points has been
        % created). 
        % Fig.3., p.8
        if surrogateToggle == 0 || ...
                size(trainingPoints, 1) < MAX_TRAINING_POINT_COUNT     
            fY = objectiveFunction(y, functionChoice);
            nFunctionCalls = nFunctionCalls + 1;
            if fY >= fX
                sigma = sigma .* STEPSIZE_ES_DEC;
            else
                x = y;
                fX = fY;
                sigma = sigma .* STEPSIZE_ES_INC;
            end
            trainingPoints = [trainingPoints; y];
            evaluatedPoints = [evaluatedPoints, fY];
            if size(trainingPoints, 1) > MAX_TRAINING_POINT_COUNT
                trainingPoints = trainingPoints(2:end, :);
                evaluatedPoints = evaluatedPoints(2:end);
            end
        else
            feY = surrogateEstimate(y, trainingPoints, evaluatedPoints,...
                sigma, dimension);
            if feY >= fX
                sigma = sigma .* STEPSIZE_UPDATE_1;
            else
                fY = objectiveFunction(y, functionChoice);
                nFunctionCalls = nFunctionCalls + 1;
                if fY >= fX
                    sigma = sigma .* STEPSIZE_UPDATE_2;
                else
                    x = y;
                    fX = fY;
                    sigma = sigma .* STEPSIZE_UPDATE_3;
                end
                trainingPoints = [trainingPoints; y];
                evaluatedPoints = [evaluatedPoints, fY];
                trainingPoints = trainingPoints(2:end, :);
                evaluatedPoints = evaluatedPoints(2:end);
            end
        end
    end
end




