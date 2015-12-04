%%Wrapper program to simulate the effects of Item Differences

clear all
%%%4 conditions: combination of short/long and foil/target prime
%%%latencies and accuracies will be stored in nx2x2 matrices
n = 100;
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
%%%weights will be stored in a nx2 matrix.
%%%the first dimension corresponds to the trial
%%%the second dimension corresponds to the prime type 
weights = zeros(n,2);

for i=1:n
    %%Modifying connection weights
    oInput.targetConnectionWeight = normrnd(1,.1);
    oInput.foilConnectionWeight = normrnd(1,.1);
    oInput.OrthSem=eye(2); 
    oInput.OrthSem(:,1) = oInput.OrthSem(:,1)*oInput.targetConnectionWeight;
    oInput.OrthSem(:,2)= oInput.OrthSem(:,2)*oInput.foilConnectionWeight;
    %%set the feedback weights equal to the feedforward weights
    oInput.SemOrth=oInput.OrthSem; 

    for cond=1:2
        %individual function call
        %nROUSE_nick has default values for all o parameters
        %any provided by this program are used to override defaults
        switch cond
            case 1
            oInput.durations = 50;
            o = nROUSE_simple_5node(oInput);
            targetLatencies(i,cond,:) = o.targ_lat(1,:);
            foilLatencies(i,cond,:) = o.foil_lat(1,:);
            accuracy(i,cond,:) = o.accs(1,:);

            case 2
            oInput.durations = 400;
            o = nROUSE_simple_5node(oInput);
            targetLatencies(i,cond,:) = o.targ_lat(1,:);
            foilLatencies(i,cond,:) = o.foil_lat(1,:);
            accuracy(i,cond,:) = o.accs(1,:);


        end
        weights(i,1) = o.targetConnectionWeight;
        weights(i,2) = o.foilConnectionWeight;
        
        
    end


end

targetWeightZscore = zscore(weights(:,1));
foilWeightZscore = zscore(weights(:,2));
%%RT corresponds the shorter latency 
RTs = min(foilLatencies,targetLatencies);



