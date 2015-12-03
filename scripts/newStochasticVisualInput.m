%Wrapper program to test the effects of varying visual input strength 
%This time, we plot average accuracy as a function of the same prime
%durations as tested in typical simulations. The goal is to compare this
%plot to the plot which generates variable accuracies through assuming a
%noisy process of deciding which racer finishes first. 

clear oInput
n = 10;
durations = [17,50,150,400,2000];
noiseSDs = 0:.01:.2;

%%%we store latency and accuracy values in matrices
%%%the first dimension corresponds to the trial #
%%%the second dimension corresponds to the prime duration
%%%the third dimension corresponds to the prime type
%%%the fourth dimension corresponds to the noise SD
targetLatencies = zeros(n,length(durations),2,length(noiseSDs));
foilLatencies = zeros(n,length(durations),2,length(noiseSDs));
accuracies = zeros(n,length(durations),2,length(noiseSDs));

TARGET = 1;
FOIL = 2;
%Setting o.stochasticVisualInput to 1 causes visual input weights to be
%drawn from a normal distribution centered around 1 with SD given by
%o.visualInputSD
oInput.stochasticVisualInput = 0;
oInput.visualInputSD = .2;
oInput.useNoise = 1;
oInput.targStrength = .56; %threshold target input strength for 75% accuracy

for i=1:n
    for cd=1:length(noiseSDs)
        for cd2 = 1:length(durations)
            %individual function call
            %nROUSE_simple has default values for all o parameters
            %any provided by this program are used to override defaults
            oInput.noiseSD = noiseSDs(cd);
            o = nROUSE_simple(oInput);
            targetLatencies(i,cd2,:,cd) = o.targ_lat(1,:);
            foilLatencies(i,cd2,:,cd) = o.foil_lat(1,:);
            accuracies(i,cd2,:,cd) = o.accs(1,:);
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
latAccs = zeros(2,length(durations),2,length(noiseSDs));
for i=1:n
    for j=1:length(durations)
        for k = 1:2
            for l = 1:length(noiseSDs)
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

meanAccuracies = mean(accuracies,1);
figure
hold on
plot(durations,meanAccuracies(1,:,1,1));
s1 = 'Target prime, noiseSD = 0';
plot(durations,meanAccuracies(1,:,2,1));
s2 = 'Foil prime, noiseSD = 0';
plot(durations,meanAccuracies(1,:,1,length(noiseSDs)));
s3 = 'Target prime, noiseSD = 2';
plot(durations,meanAccuracies(1,:,2,1));
s4 = 'Foil prime, noiseSD = 2';
xlabel('Prime duration (ms)');
ylabel('Accuracy');
legend(s1,s2,s3,s4);
hold off
%%plotting mean accuracy as a function of prime duration, with separate
%%curves for target and foil.

figure
hold on
plot(noiseSDs,propCorrectTarget);
plot(noiseSDs,propCorrectFoil);
legend('Target prime','Foil prime');
xlabel('Prime duration (ms)');
ylabel('Proportion correct');



