%Program to test the individual effects of noise at each visual display
%block


%%%latencies and accuracies will be stored in nx2x2 matrices
n = 100;
durations = [17,50,150,400,2000];
targetLatencies = zeros(n,length(durations),2,4);
foilLatencies = zeros(n,length(durations),2,4);
accuracy = zeros(n,length(durations),2,4);
%%%the first dimension corresponds to the latency value
%%%the second dimension corresponds to the prime duration
%%%the third dimension corresponds to the prime type 
%%the fourth dimension corresponds to the block w/ stochastic visual input
TARGET = 1;
FOIL = 2;
%Setting o.stochasticVisualInput to 1 causes visual input weights to be
%drawn from a normal distribution centered around 1 with SD given by
%o.visualInputSD (in the blocks specified
oInput.stochasticVisualInput = 1;
oInput.visualInputSD = .35;
for block = 1:4
    switch block
        case 1
            oInput.stochasticPrime = 1;
            oInput.stochasticTarget = 0;
            oInput.stochasticMask = 0;
            oInput.stochasticChoices = 0;
        case 2
            oInput.stochasticPrime = 0;
            oInput.stochasticTarget = 1;
            oInput.stochasticMask = 0;
            oInput.stochasticChoices = 0;
        case 3
            oInput.stochasticPrime = 0;
            oInput.stochasticTarget = 0;
            oInput.stochasticMask = 1;
            oInput.stochasticChoices = 0;
        case 4
            oInput.stochasticPrime = 0;
            oInput.stochasticTarget = 0;
            oInput.stochasticMask = 0;
            oInput.stochasticChoices = 1;
    end
    for i=1:n
        %cd is a looping variable determining prime duration
        for cd=1:5
            %individual function call
            %nROUSE_simple has default values for all o parameters
            %any provided by this program are used to override defaults
            switch cd
                case 1
                oInput.durations = 17;
                case 2
                oInput.durations = 50;
                case 3
                oInput.durations = 150;
                case 4
                oInput.durations = 400;
                case 5
                oInput.durations = 2000;
             end
            o = nROUSE_simple_5node(oInput);
            targetLatencies(i,cd,:,block) = o.targ_lat(1,:);
            foilLatencies(i,cd,:,block) = o.foil_lat(1,:);
            accuracy(i,cd,:,block) = o.accs(1,:);
        end
    end
end

%first racer to reach peak output determines choice
%positive indicates correct, negative indicates incorrect
latDiffs = foilLatencies - targetLatencies;
%accuracies (as determined by winner of horse race) stored in a 2x2x2 matrix
%first dimension holds the number of true (1) or false (2) answers for the
%task determined by dimensions 2 (prime duration) and 3 (prime type)
latAccs = zeros(2,5,2,4);
for i=1:n
    for j=1:5
        for k = 1:2
            for l = 1:4
                if latDiffs(i,j,k,l)>0
                    latAccs(1,j,k,l) = latAccs(1,j,k,l)+1;
                end
                if latDiffs(i,j,k,l)<0
                    latAccs(2,j,k,l) = latAccs(2,j,k,l)+1;
                end
            end
            
        end
    end
end
fractionCorrect = latAccs(1,:,:,:)./n;
propCorrectTarget = fractionCorrect(1,:,1,:);
propCorrectFoil = fractionCorrect(1,:,2,:);
propCorrectTargetStochasticRacers = mean(accuracy(:,:,1,:),1);
propCorrectFoilStochasticRacers = mean(accuracy(:,:,2,:),1);

%block 1, prime
figure
subplot(2,1,1)
hold on
plot(durations,propCorrectTarget(1,:,1,1));
plot(durations,propCorrectFoil(1,:,1,1));
legend('Target prime','Foil prime');
xlabel('Prime duration (ms)');
ylabel('Proportion correct');
title('Stochastic visual input for prime block');
%set(gca,'xscale','log')


subplot(2,1,2)
hold on
plot(durations,propCorrectTargetStochasticRacers(1,:,1,1));
plot(durations,propCorrectFoilStochasticRacers(1,:,1,1));
legend('Target prime','Foil prime');
xlabel('Prime duration (ms)');
ylabel('Proportion correct');
title('Variability in race-winner detection, prime block vis input');
%set(gca,'xscale','log')


%block 2, target
figure
subplot(2,1,1)
hold on
plot(durations,propCorrectTarget(1,:,1,2));
plot(durations,propCorrectFoil(1,:,1,2));
legend('Target prime','Foil prime');
xlabel('Prime duration (ms)');
ylabel('Proportion correct');
title('Stochastic visual input for target block');
%set(gca,'xscale','log')


subplot(2,1,2)
hold on
plot(durations,propCorrectTargetStochasticRacers(1,:,1,2));
plot(durations,propCorrectFoilStochasticRacers(1,:,1,2));
legend('Target prime','Foil prime');
xlabel('Prime duration (ms)');
ylabel('Proportion correct');
title('Variability in race-winner detection, target block vis input');
%set(gca,'xscale','log')


%block 3, mask
figure
subplot(2,1,1)
hold on
plot(durations,propCorrectTarget(1,:,1,3));
plot(durations,propCorrectFoil(1,:,1,3));
legend('Target prime','Foil prime');
xlabel('Prime duration (ms)');
ylabel('Proportion correct');
title('Stochastic visual input for mask block');
%set(gca,'xscale','log')


subplot(2,1,2)
hold on
plot(durations,propCorrectTargetStochasticRacers(1,:,1,3));
plot(durations,propCorrectFoilStochasticRacers(1,:,1,3));
legend('Target prime','Foil prime');
xlabel('Prime duration (ms)');
ylabel('Proportion correct');
title('Variability in race-winner detection, mask block vis input');
%set(gca,'xscale','log')


%block 4, choices
figure
subplot(2,1,1)
hold on
plot(durations,propCorrectTarget(1,:,1,4));
plot(durations,propCorrectFoil(1,:,1,4));
legend('Target prime','Foil prime');
xlabel('Prime duration (ms)');
ylabel('Proportion correct');
title('Stochastic visual input for choice block');
%set(gca,'xscale','log')


subplot(2,1,2)
hold on
plot(durations,propCorrectTargetStochasticRacers(1,:,1,4));
plot(durations,propCorrectFoilStochasticRacers(1,:,1,4));
legend('Target prime','Foil prime');
xlabel('Prime duration (ms)');
ylabel('Proportion correct');
title('Variability in race-winner detection, choice block vis input');
%set(gca,'xscale','log')



