close all, clear all, clc

path1 = 'D:\Etf\KV\HOG\Masks\imagedb\trainimg';
path2 = 'D:\Etf\KV\HOG\Masks\imagedb\testimg';
traindb = imageDatastore(path1,'IncludeSubfolders',true,'LabelSource','foldernames');
testdb = imageDatastore(path2,'IncludeSubfolders',true,'LabelSource','foldernames');
%%
% determine size of features 
img = readimage(traindb,33);
% img = imread('image196.png');
CS = [16,16]; %cell size
BS = [2,2];  %block size
BO = ceil(BS(1,1)/2)*ones(2,1); %block overlap
NB = 10;  %number of bins
[hogfv,hogvis] = extractHOGFeatures(img,'CellSize',CS,'BlockSize',BS,'BlockOverlap',BO,'NumBins',NB);
hogfeaturesize = length(hogfv);
totaltrainimages = numel(traindb.Files);
trainingfeatures = zeros(totaltrainimages,hogfeaturesize,'single');
% 
% figure, imshow(img), hold on 
% plot(hogvis)
% title('HOG obelezja lica bez maske');
%% extract HOG features for all images from training data set
for i = 1:totaltrainimages
    img = readimage(traindb,i);
    trainingfeatures(i,:) = extractHOGFeatures(img,'CellSize',CS,'BlockSize',BS,'BlockOverlap',BO,'NumBins',NB);
end
traininglabels = traindb.Labels;

% extracting HOG features for test data 
totaltestimages = numel(testdb.Files);
testfeatures = zeros(totaltestimages,hogfeaturesize,'single');

for i = 1:totaltestimages
    imgt = readimage(testdb,i);
    testfeatures(i,:) = extractHOGFeatures(imgt,'CellSize',CS,'BlockSize',BS,'BlockOverlap',BO,'NumBins',NB);
end
testlabels = testdb.Labels;

%build classifier

%% Gentle AdaBoost    
classifier = fitcensemble(trainingfeatures,traininglabels,'Method','GentleBoost');
%%
% testing classifier 
predictedlabels = predict(classifier,testfeatures);
accuracy = (sum(predictedlabels == testlabels)/numel(testlabels))*100
figure
plotconfusion(testlabels,predictedlabels);

%%  SVM 
classifier_svm = fitcsvm(trainingfeatures, traininglabels);
predictedlabels_svm = predict(classifier_svm,testfeatures);
figure
plotconfusion(testlabels,predictedlabels_svm);
accuracy_svm = (sum(predictedlabels_svm == testlabels)/numel(testlabels))*100
%%  discrete testing
[filename,pathname] = uigetfile('*.*','Select Input Image');
filewithpath = strcat(pathname,filename);
imgt = imread(filewithpath);
[hogfvt,hogvist] = extractHOGFeatures(imgt,'CellSize',CS,'BlockSize',BS,'BlockOverlap',BO,'NumBins',NB);
% predictedLabel = predict(classifier_svm,hogfvt);
predictedLabel = predict(classifier,hogfvt);
figure
imshow(imgt), hold on, plot(hogvist)
if (predictedLabel=='with_mask')
    class = 'with mask';
else 
    class = 'without mask';
end
title(['Person on the picture is recognized as ' class])

%%
% sv = classifier.SupportVectors;
% figure
figure,
X = trainingfeatures;
y = traininglabels;
gscatter(X(:,1),X(:,2),y)
hold on
title
% % plot(sv(:,1),sv(:,2),'ko','MarkerSize',10)
% legend('with_mask','without_mask','Support Vector')
% hold off


