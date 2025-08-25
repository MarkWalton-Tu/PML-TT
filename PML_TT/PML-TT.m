%{ Note: The multi-label classifier is not provided for copyright reasons.

If you find the code useful in your research, please consider citing our paper:
Qian, Wenbin, Yanqiang Tu, Jin Qian, and Wenhao Shu. "Partial multi-label learning via three-way decision-based tri-training." Knowledge-Based Systems (2023): 110743.

If you have any other questions, please contact: yanqiang_tu@163.com

%}


clear ;clc
warning off;


load('xxx.mat');

%bagging
N=3;
nb=size(clean_data,1);
[sample1,Label1,sample2,Label2,sample3,Label3] = bagging(clean_data,clean_target,N,nb);


CrossValIndices = crossvalind('Kfold',size(data,1),10);
testIndices = (CrossValIndices==1); 
trainIndices = ~testIndices;
test_data = data(testIndices,:);
test_target = target(:,testIndices);
noisy_data = data(trainIndices,:);
noisy_label = partial_labels(:,trainIndices);


[Centroids,Sigma_value,Weights,~] = repeat(sample1,Label1,sample2,Label2,sample3,Label3,test_data,test_target,noisy_data,noisy_label);

[Outputs1,~,~]=ML_classifier_test(test_data,test_target,Centroids{1},Sigma_value{1},Weights{1});
[Outputs2,~,~]=ML_classifier_test(test_data,test_target,Centroids{2},Sigma_value{2},Weights{2});
[Outputs3,~,~]=ML_classifier_test(test_data,test_target,Centroids{2},Sigma_value{2},Weights{2});




