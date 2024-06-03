function val = objectiveFunction(x, functionChoice)
% objectiveFunction: evaluate the objective function at vector x and return
% the result.

    % "... we use a set of five ten-dimensional test problems: sphere functions
    % f(x) = (x'x)^(alpha/2) for alpha E {1,2,3} that we refer to as linear,
    % quadratic, and cubic spheres, Schwefel's Problem 1.2 ... Rosenbrock
    % function [beta = 1 rather than 100]". p.9
    % Each function obtains a minimum at 0.
    val = 0;
    switch functionChoice
        case 1
            % Linear Sphere
            val = (sum(x.^2))^(1/2);
        case 2
            % Quadratic Sphere
            val = sum(x.^2); 
        case 3
            % Cubic Sphere
            val = (sum(x.^2))^(3/2);
        case 4
            % Schwefel's function
            for i = 1:length(x)
                innerSum = sum(x(1:i));
                val = val + innerSum.^2;
            end
        case 5
            % Quartic function
            % Rosenbrock function if beta = 100
            beta = 1;
            for i = 1:length(x)-1
                term1 = beta * (x(i+1) - x(i)^2)^2;
                term2 = (1 - x(i))^2;
                val = val + term1 + term2;
            end
        otherwise
            disp('Error in choice of objective function.');
    end
end