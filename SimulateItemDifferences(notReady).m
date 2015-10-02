%%Wrapper program to call the nROUSE function in order to make
%%distributions of calls

%%%4 conditions: combination of short/long and foil/target prime
%%%for each, we want a plot of target & foil latencies
%%%would be nice to store connection weights for each trial
%%%latencies will be stored in a 10000x2x2 3D matrix.
n = 100;
targetLatencies = zeros(n,2,2);
foilLatencies = zeros(n,2,2);
%%%the first dimension corresponds to the trial
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

%%Modifying connection weights
oInput.targetConnectionWeight = addStochasticity(1,.1,n);
oInput.foilConnectionWeight = addStochasticity(1,.1,n);
oInput.OrthSem=eye(2); 
oInput.OrthSem(:,1) = oInput.OrthSem(:,1).*oInput.targetFeedUpWeight(:);
oInput.OrthSem(:,2) = oInput.OrthSem(:,2).*oInput.foilFeedUpWeight(:);
%%should the feedback weights be equal to the feedforward weights?
% oInput.targetFeedbackWeight = addStochasticity(1,.1,n);
% oInput.foilFeedbackWeight = addStochasticity(1,.1,n);
oInput.OrthSem=eye(2); 
oInput.OrthSem(:,1) = oInput.OrthSem(:,1).*oInput.targetConnectionWeight(:);
oInput.OrthSem(:,2) = oInput.OrthSem(:,2).*oInput.foilConnectionWeight(:);


for i=1:n


    for durationCond=1:2
        %individual function call
        %nROUSE_nick has default values for all o parameters
        %any provided by this program are used to override defaults
        switch durationCond
            case 1
            oInput.durations = 50;
            o = nROUSE_simple(oInput);
            targetLatencies(i,1,:) = o.Latency(:,TARGET);
            foilLatencies(i,1,:) = o.Latency(:,FOIL);

            case 2
            oInput.durations = 400;
            o = nROUSE_simple(oInput);
            targetLatencies(i,2,:) = o.Latency(:,TARGET);
            foilLatencies(i,2,:) = o.Latency(:,FOIL);

        end
        weights(i,1) = o.targetFeedUpWeight;
        weights(i,2) = o.foilFeedUpWeight;
        
        
    end


end
%%accuracy determined by latency difference
accuracy = sign(foilLatencies - targetLatencies);
targetWeightZscore = zscore(weights(:,1));
foilWeightZscore = zscore(weights(:,2));
for i=1:length(accuracy)
    
end

%%%plots for each condition

figure
subplot(2,2,1);
hold on
plot(1:n,targetLatencies(:,1,1));
plot(1:n,foilLatencies(:,1,1));
set(gca,'yscale','log');
xlabel('trial');
ylabel('Latency (ms)');
legend('target','foil');
title('Short Target Prime');
hold off

subplot(2,2,2);
hold on
plot(1:n,targetLatencies(:,1,2));
plot(1:n,foilLatencies(:,1,2));
set(gca,'yscale','log');
xlabel('trial');
ylabel('Latency (ms)');
legend('target','foil');
title('Short Foil Prime');
hold off

subplot(2,2,3);
hold on
plot(1:n,targetLatencies(:,2,1));
plot(1:n,foilLatencies(:,2,1));
set(gca,'yscale','log');
xlabel('trial');
ylabel('Latency (ms)');
legend('target','foil');
title('Long Target Prime');
hold off

subplot(2,2,4);
hold on
plot(1:n,targetLatencies(:,2,2));
plot(1:n,foilLatencies(:,2,2));
set(gca,'yscale','log');
xlabel('trial');
ylabel('Latency (ms)');
legend('target','foil');
title('Long Foil Prime');
hold off

%%%plots for each condition

figure
subplot(2,2,1);
hold on
plot(1:n,targetLatencies(:,1,1)-foilLatencies(:,1,1));
xlabel('trial');
ylabel('target - foil latency (ms)');
title('Short Target Prime');
hold off

subplot(2,2,2);
hold on
plot(1:n,targetLatencies(:,1,2)-foilLatencies(:,1,2));
xlabel('trial');
ylabel('target - foil latency (ms)');
title('Short Foil Prime');
hold off

subplot(2,2,3);
hold on
plot(1:n,targetLatencies(:,2,1)-foilLatencies(:,2,1));
xlabel('trial');
ylabel('target - foil latency (ms)');
title('Long Target Prime');
hold off

subplot(2,2,4);
hold on
plot(1:n,targetLatencies(:,2,2)-foilLatencies(:,2,2));
xlabel('trial');
ylabel('target - foil latency (ms)');
title('Long Foil Prime');
hold off

%%%accuracy plots
figure
subplot(2,2,1);
hold on
plot(targetWeightZscore,accuracy(:,1,1));
xlabel('trial');
ylabel('accuracy');
title('Short Target Prime');
hold off

subplot(2,2,2);
hold on
plot(foilWeightZscore,accuracy(:,1,2));
xlabel('trial');
ylabel('accuracy');
title('Short Foil Prime');
hold off

subplot(2,2,3);
hold on
plot(targetWeightZscore,accuracy(:,2,1));
xlabel('trial');
ylabel('accuracy');
title('Long Target Prime');
hold off

subplot(2,2,4);
hold on
plot(foilWeightZscore,accuracy(:,2,2));
xlabel('trial');
ylabel('accuracy');
title('Long Foil Prime');
hold off


