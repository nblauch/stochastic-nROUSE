%%To plot, first load the relevant .mat file to your workspace.

%load() %uncomment and insert file name to be loaded

durations = [50 400];

targetWeightZscore = zscore(weights(:,1));
foilWeightZscore = zscore(weights(:,2));
%%RT corresponds the shorter latency 
RTs = min(foilLatencies,targetLatencies);
RTsTargPrime = RTs(:,:,1);
RTsFoilPrime = RTs(:,:,2);
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
fractionCorrect = latAccs(1,:,:)./n;
propCorrectTarget = fractionCorrect(1,:,1);
propCorrectFoil = fractionCorrect(1,:,2);
propCorrectTargetStochasticRacers = mean(accuracy(:,:,1),1);
propCorrectFoilStochasticRacers = mean(accuracy(:,:,2),1);


figure
hold on
plot(durations,propCorrectTarget);
plot(durations,propCorrectFoil);
legend('Target prime','Foil prime');
xlabel('Prime duration (ms)');
ylabel('Proportion correct');
title('No variability in race-winner detection');

figure
hold on
plot(durations,propCorrectTargetStochasticRacers);
plot(durations,propCorrectFoilStochasticRacers);
legend('Target prime','Foil prime');
xlabel('Prime duration (ms)');
ylabel('Proportion correct');
title('Variability in race-winner detection');



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
plot(targetWeightZscore-foilWeightZscore,foilLatencies(:,1,1) - targetLatencies(:,1,1),'x');
xlabel('Z-score (target - foil)');
ylabel('foil - target latency (ms)');
title('Short Target Prime');
hold off


subplot(2,2,2);
hold on
plot(targetWeightZscore -foilWeightZscore,foilLatencies(:,1,2) - targetLatencies(:,1,2),'x');
xlabel('Z-score (target - foil)');
ylabel('foil - target latency (ms)');
title('Short Foil Prime');
hold off

subplot(2,2,3);
hold on
plot(targetWeightZscore -foilWeightZscore,foilLatencies(:,2,1) - targetLatencies(:,2,1),'x');
xlabel('Z-score (target - foil)');
ylabel('foil - target latency (ms)');
title('Long Target Prime');
hold off

subplot(2,2,4);
hold on
plot(targetWeightZscore -foilWeightZscore,foilLatencies(:,2,2) - targetLatencies(:,2,2),'x');
xlabel('Z-score (target - foil)');
ylabel('foil - target latency (ms)');
title('Long Foil Prime');
hold off


%%%accuracy plots
figure
subplot(2,2,1);
hold on
plot(targetWeightZscore -foilWeightZscore,accuracy(:,1,1),'x');
xlabel('Z-score (target - foil)');
ylabel('accuracy (w/ stochastic race detection)');
title('Short Target Prime');
hold off

subplot(2,2,2);
hold on
plot(targetWeightZscore -foilWeightZscore,accuracy(:,1,2),'x');
xlabel('Z-score (target - foil)');
ylabel('accuracy (w/ stochastic race detection)');
title('Short Foil Prime');
hold off

subplot(2,2,3);
hold on
plot(targetWeightZscore -foilWeightZscore,accuracy(:,2,1),'x');
xlabel('Z-score (target - foil)');
ylabel('accuracy (w/ stochastic race detection)');
title('Long Target Prime');
hold off

subplot(2,2,4);
hold on
plot(targetWeightZscore -foilWeightZscore,accuracy(:,2,2),'x');
xlabel('Z-score (target - foil)');
ylabel('accuracy (w/ stochastic race detection)');
title('Long Foil Prime');
hold off

%RT quantiles
figure
subplot(2,2,1);
hold on
qqplot(RTs(:,1,1));
title('Short Target Prime');
hold off

subplot(2,2,2);
hold on
qqplot(RTs(:,1,2));
title('Short Foil Prime');
hold off

subplot(2,2,3);
hold on
qqplot(RTs(:,2,1));
title('Long Target Prime');
hold off

subplot(2,2,4);
hold on
qqplot(RTs(:,2,2));
title('Long Foil Prime');
hold off

%histogram plots
figure
ax1 = subplot(2,2,1);
hold on
hist(targetLatencies(:,1,1),100);
title('Short Target Prime');
xlabel('Decision time (ms)');
hold off

ax2 = subplot(2,2,2);
hold on
hist(targetLatencies(:,1,2),100);
title('Short Foil Prime');
xlabel('Decision time (ms)');
hold off

ax3 = subplot(2,2,3);
hold on
hist(targetLatencies(:,2,1),100);
title('Long Target Prime');
xlabel('Decision time (ms)');
hold off

ax4 = subplot(2,2,4);
hold on
hist(targetLatencies(:,2,2),100);
title('Long Foil Prime');
xlabel('Decision time (ms)');
hold off
linkaxes([ax1,ax2,ax3,ax4],'x')

%histogram plots
figure
subplot(2,2,1);
hold on
hist(targetLatencies(:,1,1));
title('Short Target Prime');
xlabel('Decision time (ms)');
hold off

subplot(2,2,2);
hold on
hist(targetLatencies(:,1,2));
title('Short Foil Prime');
xlabel('Decision time (ms)');
hold off

subplot(2,2,3);
hold on
hist(targetLatencies(:,2,1));
title('Long Target Prime');
xlabel('Decision time (ms)');
hold off

subplot(2,2,4);
hold on
hist(targetLatencies(:,2,2));
title('Long Target Prime');
xlabel('Decision time (ms)');

hold off

