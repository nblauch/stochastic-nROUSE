%%To plot, first load the relevant .mat file to your workspace.

%%durations may not have been saved properly, in which case they should be
%%specified here by uncommenting the line below.

%durations = [50 400];


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
plot(targetWeightZscore-foilWeightZscore,foilLatencies(:,2,2) - targetLatencies(:,2,2),'x');
xlabel('Z-score (target - foil)');
ylabel('foil - target latency (ms)');
title('Short Target Prime');
hold off


subplot(2,2,2);
hold on
plot(targetWeightZscore -foilWeightZscore,foilLatencies(:,2,2) - targetLatencies(:,2,2),'x');
xlabel('Z-score (target - foil)');
ylabel('foil - target latency (ms)');
title('Short Foil Prime');
hold off

subplot(2,2,3);
hold on
plot(targetWeightZscore -foilWeightZscore,foilLatencies(:,2,2) - targetLatencies(:,2,2),'x');
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