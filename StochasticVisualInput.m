%Wrapper program to test the effects of varying visual input strength 

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
for i=1:n
    for j=1:2
        for k = 1:2
            if latDiffs(i,j,k)>0
                latAccs(1,j,k) = latAccs(1,j,k)+1;
            end
            if latDiffs(i,j,k)<0
                latAccs(2,j,k) = latAccs(2,j,k)+1;
            end
            
        end
    end
end


%%RT plots
figure
%short target prime
subplot(2,2,1)
plot(1:n,RTs(:,1,1))
xlabel('Trial #');
ylabel('Reaction time (ms)');

%long target prime
subplot(2,2,2)
plot(1:n,RTs(:,2,1))
xlabel('Trial #');
ylabel('Reaction time (ms)');

%short foil prime
subplot(2,2,3)
plot(1:n,RTs(:,1,2))
xlabel('Trial #');
ylabel('Reaction time (ms)');

%long foil prime
subplot(2,2,4)
plot(1:n,RTs(:,2,2))
xlabel('Trial #');
ylabel('Reaction time (ms)');


%%Latency difference plots
figure
%short target prime
subplot(2,2,1)
plot(1:n,latDiffs(:,1,1))
xlabel('Trial #');
ylabel('Latency difference (ms)');

%long target prime
subplot(2,2,2)
plot(1:n,latDiffs(:,2,1))
xlabel('Trial #');
ylabel('Latency difference (ms)');

%short foil prime
subplot(2,2,3)
plot(1:n,latDiffs(:,1,2))
xlabel('Trial #');
ylabel('Latency difference (ms)');

%long foil prime
subplot(2,2,4)
plot(1:n,latDiffs(:,2,2))
xlabel('Trial #');
ylabel('Latency difference (ms)');

%%Plots of accuracy as determined by latency difference 
figure
%short target prime
h1 = subplot(2,2,1);
bar(latAccs(:,1,1))
xlabel('Accuracy');
ylabel('Occurence');
title('50 ms target prime');
h1.XTickLabel = {'Correct','Incorrect'};

%long target prime
h2 = subplot(2,2,2);
bar(latAccs(:,2,1))
xlabel('Accuracy');
ylabel('Occurence');
title('400 ms target prime');
h2.XTickLabel = {'Correct','Incorrect'};

%short foil prime
h3 = subplot(2,2,3);
bar(latAccs(:,1,2))
xlabel('Accuracy');
ylabel('Occurence');
title('50 ms foil prime');
h3.XTickLabel = {'Correct','Incorrect'};

%long foil prime
h4 = subplot(2,2,4);
bar(latAccs(:,2,2))
xlabel('Accuracy');
ylabel('Occurence');
title('400 ms foil prime');
h4.XTickLabel = {'Correct','Incorrect'};




