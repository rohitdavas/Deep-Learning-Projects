%%just like the library ,import alexnet into a variable deepnet
deepnet = alexnet;
%get some image files
img1 = imread('10.png'); 
img2 = imread('58.png');
img3 = imread('49.png');

% show them out
figure;
imshow(img1)
figure;
imshow(img2)
figure;
imshow(img3)
%%resize the images to the standard input size of alexnet input layer
img1 = imresize(img1,[227 227]);
figure;
imshow(img1)

img2 = imresize(img2,[227 227]);
figure;
imshow(img2)

img3 = imresize(img3,[227 227]);
figure;
imshow(img3)


%% finally what the alexnet predicts
pd1 = classify(deepnet, img1)
pd2 = classify(deepnet,img2)
pd3 = classify(deepnet,img3)

%%in future files ,will look for more methods 
