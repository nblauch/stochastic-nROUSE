%%Wrapper program to call the nROUSE function in order to make
%%distributions of calls

%%%4 conditions: combination of short/long and foil/target prime
%%%for each, we want a plot of target & foil latencies
%%%would be nice to store connection weights for each trial
%%%latencies and accuracies will be stored in nx2x2 3D matrices
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
%%%weights will be stored in a 10000x2 2D matrix.
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

    for cd=1:2
        %individual function call
        %nROUSE_nick has default values for all o parameters
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
        weights(i,1) = o.targetConnectionWeight;
        weights(i,2) = o.foilConnectionWeight;
        
        
    end


end

targetWeightZscore = zscore(weights(:,1));
foilWeightZscore = zscore(weights(:,2));
%%RT corresponds the shorter latency 
RTs = min(foilLatencies,targetLatencies);

figure
subplot(2,2,1)
hold on
plot(targetWeightZscore-foilWeightZscore,RTs(:,SHORT,TARGET),'x')
set(gca,'yscale','log');
xlabel('Z-score (target - foil)');
ylabel('Decision time (ms)');
title('Short Target Prime');
hold off

subplot(2,2,2);
hold on
plot(targetWeightZscore-foilWeightZscore,RTs(:,SHORT,FOIL),'x')
set(gca,'yscale','log');
xlabel('Z-score (target - foil)');
ylabel('Decision time (ms)');
title('Short Foil Prime');
hold off

subplot(2,2,3);
hold on
plot(targetWeightZscore-foilWeightZscore,RTs(:,LONG,TARGET),'x')
set(gca,'yscale','log');
xlabel('Z-score (target - foil)');
ylabel('Decision time (ms)');
title('Long Target Prime');
hold off

subplot(2,2,4);
hold on
plot(targetWeightZscore-foilWeightZscore,RTs(:,LONG,FOIL),'x')
set(gca,'yscale','log');
xlabel('Z-score (target - foil)');
ylabel('Decision time (ms)');
title('Long Foil Prime');
hold off


%%%plots for each condition

figure
subplot(2,2,1);
hold on
plot(targetWeightZscore-foilWeightZscore,targetLatencies(:,SHORT,TARGET),'x');
plot(targetWeightZscore-foilWeightZscore,foilLatencies(:,SHORT,TARGET),'x');
set(gca,'yscale','log');
xlabel('Z-score (target - foil)');
ylabel('Latency (ms)');
legend('target','foil');
title('Short Target Prime');
hold off

subplot(2,2,2);
hold on
plot(targetWeightZscore-foilWeightZscore,targetLatencies(:,1,2),'x');
plot(targetWeightZscore-foilWeightZscore,foilLatencies(:,1,2),'x');
set(gca,'yscale','log');
xlabel('Z-score (target - foil)');
ylabel('Latency (ms)');
legend('target','foil');
title('Short Foil Prime');
hold off

subplot(2,2,3);
hold on
plot(targetWeightZscore-foilWeightZscore,targetLatencies(:,2,1),'x');
plot(targetWeightZscore-foilWeightZscore,foilLatencies(:,2,1),'x');
set(gca,'yscale','log');
xlabel('Z-score (target - foil)');
ylabel('Latency (ms)');
legend('target','foil');
title('Long Target Prime');
hold off

subplot(2,2,4);
hold on
plot(targetWeightZscore-foilWeightZscore,targetLatencies(:,2,2),'x');
plot(targetWeightZscore-foilWeightZscore,foilLatencies(:,2,2),'x');
set(gca,'yscale','log');
xlabel('Z-score (target - foil)');
ylabel('Latency (ms)');
legend('target','foil');
title('Long Foil Prime');
hold off

%%%difference plots

figure
subplot(2,2,1);
hold on
plot(targetWeightZscore-foilWeightZscore,targetLatencies(:,1,1)-foilLatencies(:,1,1),'x');
xlabel('Z-score (target - foil)');
ylabel('target - foil latency (ms)');
title('Short Target Prime');
hold off

subplot(2,2,2);
hold on
plot(targetWeightZscore -foilWeightZscore,targetLatencies(:,1,2)-foilLatencies(:,1,2),'x');
xlabel('Z-score (target - foil)');
ylabel('target - foil latency (ms)');
title('Short Foil Prime');
hold off

subplot(2,2,3);
hold on
plot(targetWeightZscore -foilWeightZscore,targetLatencies(:,2,1)-foilLatencies(:,2,1),'x');
xlabel('Z-score (target - foil)');
ylabel('target - foil latency (ms)');
title('Long Target Prime');
hold off

subplot(2,2,4);
hold on
plot(targetWeightZscore -foilWeightZscore,targetLatencies(:,2,2)-foilLatencies(:,2,2),'x');
xlabel('Z-score (target - foil)');
ylabel('target - foil latency (ms)');
title('Long Foil Prime');
hold off

%%%accuracy plots
figure
subplot(2,2,1);
hold on
plot(targetWeightZscore -foilWeightZscore,accuracy(:,1,1),'x');
xlabel('Z-score (target - foil)');
ylabel('accuracy');
title('Short Target Prime');
hold off

subplot(2,2,2);
hold on
plot(targetWeightZscore -foilWeightZscore,accuracy(:,1,2),'x');
xlabel('Z-score (target - foil)');
ylabel('accuracy');
title('Short Foil Prime');
hold off

subplot(2,2,3);
hold on
plot(targetWeightZscore -foilWeightZscore,accuracy(:,2,1),'x');
xlabel('Z-score (target - foil)');
ylabel('accuracy');
title('Long Target Prime');
hold off

subplot(2,2,4);
hold on
plot(targetWeightZscore -foilWeightZscore,accuracy(:,2,2),'x');
xlabel('Z-score (target - foil)');
ylabel('accuracy');
title('Long Foil Prime');
hold off


