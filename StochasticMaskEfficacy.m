%Wrapper function to test the effects of stochastic mask efficacy
%%%latencies and accuracies will be stored in nx2x2 matrices
n = 1000;
targetLatencies = zeros(n,2,2);
foilLatencies = zeros(n,2,2);
accuracy = zeros(n,2,2);
%%%the first dimension corresponds to the latency value
%%%the second dimension corresponds to the prime duration
SHORT = 1;
LONG = 2;
%%%the third dimension corresponds to the prime type 
TARGET = 1;
FOIL = 2;
%Setting o.stochasticVisualInput to 1 causes visual input weights to be
%drawn from a normal distribution centered around 1 with SD given by
%o.visualInputSD
oInput.stochasticVisualInput = 1;
oInput.visualInputSD = .35;
for i=1:n

    %cd is a looping variable determining prime duration
    for cd=1:2
        %individual function call
        %nROUSE_simple has default values for all o parameters
        %any provided by this program are used to override defaults
        switch cd
            case 1
            oInput.durations = 50;
            o = nROUSE_simple(oInput);
            targetLatencies(i,cd,:) = o.targ_lat(1,:);
            foilLatencies(i,cd,:) = o.foil_lat(1,:);
            accuracy(i,cd,:) = o.accs(1,:);

            case 2
            oInput.durations = 400;
            o = nROUSE_simple(oInput);
            targetLatencies(i,cd,:) = o.targ_lat(1,:);
            foilLatencies(i,cd,:) = o.foil_lat(1,:);
            accuracy(i,cd,:) = o.accs(1,:);
        end
    end
end

%%RT corresponds to the shorter latency 
RTs = min(foilLatencies,targetLatencies);
%first racer to reach peak output determines choice
%positive indicates correct, negative indicates incorrect
latDiffs = foilLatencies - targetLatencies;
%accuracies (as determined by winner of horse race) stored in a 2x2x2 matrix
%first dimension holds the number of true (1) or false (2) answers for the
%task determined by dimensions 2 (prime duration) and 3 (prime type)
latAccs = zeros(2,2,2);