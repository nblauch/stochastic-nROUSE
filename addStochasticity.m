%designed to take a variable with value newMean and add normal-distributed
%variation centered around newMean with standard deviation SD for
%sample size given by nSimulations.oInput is the set of variables required
%to run nROUSE_simple.m
function newMean = addStochasticity(newMean, SD, nSimulations)
    mean = newMean;
    newMean = zeros(nSimulations);
    for i=1:nSimulations
        newMean(i) = normrnd(mean,SD);
    end
end