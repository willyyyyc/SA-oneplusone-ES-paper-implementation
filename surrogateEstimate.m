function feY = surrogateEstimate(y, trainingPoints, evaluatedPoints, sigma, ...
    dimension)
% surrogateEstimate: generates surrogate model using previously evaluated
% training points. Returns an estimated result for y, the offspring 
% candidate solution.

    % Perform Gaussian process using the squared exponential kernel.
    % "For surrogate models, as B¨uche et al. [4], we employ Gaussian 
    % processes. We use a squared exponential kernel and for simplicity set
    % the length scale parameter of that kernel to 8σ√n, where σ is the 
    % step size parameter of the evolution strategy." p.10
    theta = 8 * sigma * sqrt(dimension);
    d1 = pdist2(trainingPoints, trainingPoints, 'euclidean');
    d2 = pdist2(trainingPoints, y, 'euclidean');
    
    k = exp(-(d1/theta).^2/2);
    ks = exp(-(d2/theta).^2/2);
    
    inverseK = inv(k);
    % Perform normalization.
    feY = (ks.' * inverseK * (evaluatedPoints - ...
        min(evaluatedPoints)).').' + min(evaluatedPoints);
end