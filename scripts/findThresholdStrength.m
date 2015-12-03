%Script to find the threshold visual target input for 75% unprimed
%identification, assuming a stochastic process of deciding which racer
%finished first.

clear oInput
n = 10;
durations = 50; %duration is irrelevant
inputStrengths = 0:.01:1;

targetLatencies = zeros(length(inputStrengths),length(durations));
foilLatencies = zeros(length(inputStrengths),length(durations));
accuracy = zeros(length(inputStrengths),length(durations));
%%%the first dimension corresponds to the input strength
%%%the second dimension corresponds to the prime duration

oInput.stochasticVisualInput = 0;
oInput.noPrime = 1;
oInput.measureThreshold = 1;
oInput.noWrapper = 0;
oInput.useNoise = 0;

for index = 1:length(inputStrengths)
    for cd = 1:length(durations)
    oInput.targStrength = inputStrengths(index);
    oInput.durations = durations(cd);
    o = nROUSE_simple(oInput);
    accuracy(index,cd) = o.accs(1);
    end
end

indexOfThresh = 0;
for index = 1:length(inputStrengths)
    if accuracy(index,1) > .75
       indexOfThresh = index;
       break
    end
end

thresholdStrength = inputStrengths(indexOfThresh);
%Threshold strength is .56! 
