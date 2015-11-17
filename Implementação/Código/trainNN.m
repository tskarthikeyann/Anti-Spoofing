%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BEFORE RUNNING THIS SCRIPT, MAKE SURE YOU HAVE SETUP THE ENVIRONMENT PROPERLY.%
% RUNNING 'setupInputImages.m' and 'generateTextureDescriptors.m' SHOULD BE     %
% ENOUGH.                                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;
clear all;
clc;

[inputDataSet, targetsSet] = setDataSet();

if exist('net/', 'dir') ~= 7
    mkdir('net/');
end

best_perform = Inf;
minERROR = Inf;
best_i = 0;
best_j = 0;

for i = 10:20
    
    net = feedforwardnet(i);
    net = configure(net, inputDataSet, targetsSet);
    net.layers{1}.transferFcn = 'tansig';
    net.layers{2}.transferFcn = 'tansig';
%     net.divideParam.trainRatio = 0.33;
%     net.divideParam.valRatio = 0.33;
%     net.divideParam.testRatio = 0.34;
    net.trainParam.epochs = 1000;
%     net.divideFcn = 'dividerand';
%     net.divideFcn = 'divideint';
    
    for j = 1:20
        net = init(net);
        
        net.divideParam.trainRatio = 0.33;
        net.divideParam.valRatio = 0.33;
        net.divideParam.testRatio = 0.34;
        net.divideFcn = 'dividerand';
%         net.divideFcn = 'divideint';
        
        net.trainParam.showWindow = false;
        [net, tr] = train(net, inputDataSet, targetsSet);
        netTestOutputs = net(inputDataSet(:, tr.testInd));
        ERROR = sum(abs(netTestOutputs-targetsSet(:, tr.testInd)))/length(tr.testInd);
        
        if tr.best_tperf < best_perform
            best_perform = tr.best_tperf;
            best_i = i;
            best_j = j;
            minERROR = ERROR;
            save('net/nnet.mat', 'net', 'tr', 'inputDataSet', 'targetsSet', 'netTestOutputs');
        end
        
        clc
        fprintf('===== Current =====\nNeurons: %d\nTraining attempt: %d\nERROR: %f\nPerformance: %f\n===== Best =====\nNeurons: %d\nTraining attempt: %d\nERROR: %f\nPerformance: %f', i, j, ERROR, tr.best_tperf, best_i, best_j, minERROR, best_perform);
        
    end
end

%% Visualizing data
load net/nnet.mat;

plot(targetsSet(tr.testInd), net(inputDataSet(:, tr.testInd)), 'ro')
xlabel('Expected')
ylabel('Predicted')
grid on

[netTestOutputs ; targetsSet(tr.testInd)]'