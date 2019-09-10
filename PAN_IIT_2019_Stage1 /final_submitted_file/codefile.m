%%%%-----------------------------------------------------------------------
%%LANGUAGE : MATLAB--------------------------------------
%please copy this FILE code into a live script to work well.







%%---------------------------------------------------------------------------  
%           Code to extract data from csv file into seprate folder by labels

%           UNCOMMENT /COMMENT THIS SECTION AS WE NEED TO USE ONLY ONE TIME IN
%           BEGINNING  OR DON'T RUN THIS SECTION AGAIN AND AGAIN extracting data from the CSV file code 



% for j = 1:6
%     cat  = solution.category == j %assigning the category label 
%     cat1 = solution(cat ,'id') %% accessing id
%    %    [row2, col2] = find(solution == '2')
%    cat1_array = cat1.id %% converting the table into array to ease of access in matlab
%   
% 
%    i = 1;
%    while i<size(cat1_array,1)
%         x = cat1_array(i,1);
%         
% %adding numeric and string in matlab dir = x + ".png"
% 
%         movefile(x + ".png" , 'j','f'); %%move the image to specified label folder already made by me
%                                         %%f for force writing over so if some problem occurs     
%         i = i + 1;
%    end
% end      
        
%---------------------------------------------------------------------------



nnet = googlenet; %%load the googlenet .
% analyzeNetwork(nnet);

% load the training images intoa imagedatastore
trainimg = imageDatastore('C:\Users\Lenovo\Desktop\pan iit hackathon\training_2\training\','IncludeSubfolders',true,'LabelSource', 'foldernames')
numClasses = numel(categories(trainimg.Labels));  % no of labels

% GET THE INPUT SIZE INTO FIRST LAYER
layers = nnet.Layers; 
inlayer = layers(1)
insize = inlayer.InputSize

%THIS PART OF CODE IS NOT PART OF FINAL CODE , THIS IS JUST FOR TESTING THE
%DATA TRAINED EFFICENCY BY OURSELVES

%--------------------------------------------------------------------------------------
% % % % [trainimg ,testimg] = splitEachLabel(imds,750);
% % % % Augmenter = imageDataAugmenter( 'RandRotation',[-50,50],'RandYShear',[0 45]);
% % 
% % %%'RandXTranslation',[-3 3],'RandYTranslation',[-3 3],'RandXReflection',true,'RandYReflection',true,'RandXScale',[0.5 1],'RandYScale',[0.5 3],'RandXShear',[0 40]
%---------------------------------------------------------------------------------------


% [trainImgs,testImgs] = splitEachLabel(auds,750);
%%replacing layers
if isa(nnet,'SeriesNetwork') 
  lgraph = layerGraph(layers); 
else
  lgraph = layerGraph(nnet);
end 

[learnableLayer,classLayer] = findLayersToReplace(lgraph) %% FINDLAYERS TO REPLACE IS A DEFINED FUNCTION ,ATTACHED.
[learnableLayer,classLayer]  % watch out which layers you are replacing 


%% replace layer specified according to the type : FullyConnectedLayer or Convolution2DLayer 
if isa(learnableLayer,'nnet.cnn.layer.FullyConnectedLayer')
    newLearnableLayer = fullyConnectedLayer(numClasses,'Name','new_fcn','WeightLearnRateFactor',10,'BiasLearnRateFactor',10);
    
elseif isa(learnableLayer,'nnet.cnn.layer.Convolution2DLayer')
    newLearnableLayer = convolution2dLayer(1,numClasses, 'Name','new_conv','WeightLearnRateFactor',10,'BiasLearnRateFactor',10);
end

lgraph = replaceLayer(lgraph,learnableLayer.Name,newLearnableLayer); %% replace the layers with new learned layers,defined function by packages.

newClassLayer = classificationLayer('Name','new_classoutput'); %% give the name as new_classoutput
lgraph = replaceLayer(lgraph,classLayer.Name,newClassLayer);  %% replace layer is a package defined function

%plot the graph of connected layers  to see if they are connected. 
figure('Units','normalized','Position',[0.3 0.3 0.4 0.4]);
plot(lgraph)
ylim([0,10])


%freeze initial weights  
layers = lgraph.Layers;
connections = lgraph.Connections;

layers(1:10) = freezeWeights(layers(1:10));
lgraph = createLgraphUsingConnections(layers,connections);

%%data & image augmentation
pixelRange = [-30 30];
scaleRange = [0.9 1.1];
imageAugmenter = imageDataAugmenter('RandXReflection',true, 'RandXTranslation',pixelRange,'RandXScale',scaleRange,'RandYScale',scaleRange,'RandRotation',[-30 30]);
% imageAugmenter = imageDataAugmenter('RandXReflection',true,'RandYReflection',true, 'RandXTranslation',pixelRange, 'RandXScale',scaleRange,'RandYScale',scaleRange,'RandRotation',[-30 30],'RandXShear',[0 20],'RandYShear',[0 20]);

atrainimg  = augmentedImageDatastore([224 224 3],trainimg, 'DataAugmentation',imageAugmenter);




options = trainingOptions('sgdm','InitialLearnRate', 0.001); %% 'name', value pairs value of alpha , the learning rate


options = trainingOptions('sgdm','MiniBatchSize',10,'InitialLearnRate',0.001, 'Shuffle','every-epoch','Verbose',true,'Plots','training-progress');

trained_net = trainNetwork(atrainimg, lgraph, options) %% trainNetwork takes the lgraph and options  




%-----------------------------------------------
% this is a part of code used for testing our trained model and hence NOT A PART OF MAIN CODE


% testpreds = classify(trained_net,testImgs)
% % plot(info.TrainingLoss)
% % 
% % grid on
% % atestimg = augmentedImageDatastore([224 224 3], testimg)
% % [test_prediction ,probs] = classify(trained_net,atestimg)

% figure
% for i = 1:numel(test_prediction)
%     subplot(2,2,i)
%     I = readimage(testimg,test_pediction(i));
%     label = test_prediction(i);
%     imshow(I)
%     title(char(label))
% end

% % atestimg_actual = testimg.Labels
% % numCorrect = nnz(test_prediction == atestimg_actual)
% % fraccorrect = numCorrect/numel(test_prediction)
% % confusionchart(testimg.Labels , test_prediction)

%---------------------------------------------------------

%-------------------------------------------------------------------------
% % THIS CODE MAKE SURE THAT THE IMAGES GO IN ASCENDING ORDER OF FILENAME, 
%    USED A CODE TO ENSURE IT THAT THE OUTPUT IS ALSO IN THE FORM 
%    OF A ARRAY WHICH CORRESPONDS ARRAY(i) = LABEL OF ith IMAGE NAME.

D = 'C:\Users\Lenovo\Desktop\pan iit hackathon\testing.40k\testing\';
S = dir(fullfile(D,'*.png'))
N = natsortfiles({S.name})

F = cellfun(@(n)fullfile(D,n),N,'uni',0)
F = F'




%---------------------------------------------

% GET THE PREDICTION OUTPUT

pimds =  imageDatastore(F)
apimds = augmentedImageDatastore([224 224 3], pimds)
preds_out = classify(trained_net,apimds)

%%%% STORED INTO A CSV FILE MANUALLY


     
     
   

  
     
     
     
     
     
     
     
     
     



