%Wrapper program to test the effects of varying visual input strength 
%This time, we plot average accuracy as a function of the same prime
%durations as tested in typical simulations. The goal is to compare this
%plot to the plot which generates variable accuracies through assuming a
%noisy process of deciding which racer finishes first. 

%%%latencies and accuracies will be stored in nx2x2 matrices
n = 1000;
durations = [17,50,150,400,2000];
durations = [50,400];
targetLatencies = zeros(n,length(durations),2);
foilLatencies = zeros(n,length(durations),2);
accuracy = zeros(n,length(durations),2);
%%%the first dimension corresponds to the latency value
%%%the second dimension corresponds to the prime duration
%%%the third dimension corresponds to the prime type 
TARGET = 1;
FOIL = 2;
%Setting o.stochasticVisualInput to 1 causes visual input weights to be
%drawn from a normal distribution centered around 1 with SD given by
%o.visualInputSD
oInput.stochasticVisualInput = 0;
oInput.stochasticPrime = 0;
oInput.stochasticTarget = 0;
oInput.stochasticMask = 0;
oInput.stochasticChoices = 1;

oInput.visualInputSD = .35;
for i=1:n

    %cd is a looping variable determining prime duration
    for cd=1:length(durations)
        %individual function call
        %nROUSE_simple has default values for all o parameters
        %any provided by this program are used to override defaults
        oInput.durations = durations(cd);
        o = nROUSE_simple_5node(oInput);
        targetLatencies(i,cd,:) = o.targ_lat(1,:);
        foilLatencies(i,cd,:) = o.foil_lat(1,:);
        accuracy(i,cd,:) = o.accs(1,:);
        
    end
end

%%RT corresponds to the shorter latency 
RTs = min(foilLatencies,targetLatencies);
RTsTargPrime = RTs(:,:,1);
RTsFoilPrime = RTs(:,:,2);
clear RTs
%first racer to reach peak output determines choice
%positive indicates correct, negative indicates incorrect
latDiffs = foilLatencies - targetLatencies;
%accuracies (as determined by winner of horse race) stored in a 2x2x2 matrix
%first dimension holds the number of true (1) or false (2) answers for the
%task determined by dimensions 2 (prime duration) and 3 (prime type)
latAccs = zeros(2,length(durations),2);
for i=1:n
    for j=1:length(durations)
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
fractionCorrect = latAccs(1,:,:)./n;
propCorrectTarget = fractionCorrect(1,:,1);
propCorrectFoil = fractionCorrect(1,:,2);
propCorrectTargetStochasticRacers = mean(accuracy(:,:,1),1);
propCorrectFoilStochasticRacers = mean(accuracy(:,:,2),1);

%%plotting mean accuracy as a function of prime duration, with separate
%%curves for target and foil.

figure
hold on
semilogx(durations,propCorrectTarget);
semilogx(durations,propCorrectFoil);
legend('Target prime','Foil prime');
xlabel('Prime duration (ms)');
ylabel('Proportion correct');
title('No variability in race-winner detection');

figure
hold on
semilogx(durations,propCorrectTargetStochasticRacers);
semilogx(durations,propCorrectFoilStochasticRacers);
legend('Target prime','Foil prime');
xlabel('Prime duration (ms)');
ylabel('Proportion correct');
title('Variability in race-winner detection');


figure
hold on
index = 1;
s = zeros(1);
plot(1:length(RTsTargPrime(:,1)),RTsTargPrime(:,1));
s1 = 'T-Prime 1';
index = index+1;
plot(1:length(RTsTargPrime(:,1)),RTsTargPrime(:,2));
s2 = 'T-Prime 2';
index = index+1;
plot(1:length(RTsTargPrime(:,1)),RTsTargPrime(:,3));
s3 = 'T-Prime 3';
index = index+1;
plot(1:length(RTsTargPrime(:,1)),RTsTargPrime(:,4));
s4 = 'T-Prime 4';
index = index+1;
plot(1:length(RTsTargPrime(:,1)),RTsTargPrime(:,5));
s5 = 'T-Prime 5';
index = index+1;
plot(1:length(RTsFoilPrime(:,1)),RTsFoilPrime(:,1),'--');
s6 = 'F-Prime 1';
index = index+1;
plot(1:length(RTsFoilPrime(:,1)),RTsFoilPrime(:,2),'--');
s7 = 'F-Prime 2';
index = index+1;
plot(1:length(RTsFoilPrime(:,1)),RTsFoilPrime(:,3),'--');
s8 = 'F-Prime 3';
index = index+1;
plot(1:length(RTsFoilPrime(:,1)),RTsFoilPrime(:,4),'--');
s9 = 'F-Prime 4';
index = index+1;
plot(1:length(RTsFoilPrime(:,1)),RTsFoilPrime(:,5),'--');
s10 = 'F-Prime 5';

%plot(durations,latDiffs);
legend(s1,s2,s3,s4,s5,s6,s7,s8,s9,s10);
xlabel('Trial');
ylabel('Decision time (ms)');




%Want RT plots, but until I see Kevin's plot, I won't be sure what to plot.


