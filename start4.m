% Computational Photography Project 4
% Turned in by <Michael Single>
% Legi: 08-917-445

clc
clear all;
close all;
addpath('util/');
addpath('src/p4/');


%% Task 1.2 Seamless Cloning

% determines boundary
mask = imread('imgs/p4/seamless_cloning/mask.png');
mask = im2double(mask);

% patch we place into target
source = imread('imgs/p4/seamless_cloning/source.png');
source = im2double(source);

% image that gets modified
target = imread('imgs/p4/seamless_cloning/target.png');
target = im2double(target);

title = 'Seamless Cloning: Input';
labels = {'Target' 'Source' 'Mask'};
imgs = zeros(size(source,1), size(source,2), 3, 3);
imgs(:,:,:,1) = target(:,:,:);
imgs(:,:,:,2) = source(:,:,:);
imgs(:,:,:,3) = mask(:,:,:);

showImgSeries(title, imgs, labels);

%out = seamlessCloning(target, source, mask);
figure('Position', [100, 100, 1024, 800], ...
       'name', 'Seamless Cloning: Output')
%imshow(out)


%% Task 1.3: Gradient Mixing.
source = imread('imgs/p4/gradient_mixing/i1.png');
source = im2double(source);

target = imread('imgs/p4/gradient_mixing/i2.png');
target = im2double(target);

M = size(target, 1); N = size(target, 2);

mask = zeros(M,N);
mask(1:end, 1) = 1;
mask(1:end, end) = 1;
mask(1, 1:end) = 1;
mask(end, 1:end) = 1;
mask = mat2Img(mask(:,:), mask(:,:), mask(:,:));

title = 'Gradient Mixing: Input';
labels = {'Target' 'Source' 'Mask'};
imgs = zeros(size(source,1), size(source,2), 3, 3);
imgs(:,:,:,1) = target(:,:,:);
imgs(:,:,:,2) = source(:,:,:);
imgs(:,:,:,3) = mask(:,:,:);

showImgSeries(title, imgs, labels);

%out = gradientMixing(target, source, mask);
figure('name', 'Gradient Mixing: Output')
%imshow(out)


%% Task 1.4: Highlight Removal


target = imread('imgs/orange.jpg');
target = im2double(target);
mask = imread('imgs/orange_mask.jpg');
mask = im2double(mask);

title = 'Highlight Removal: Input';
labels = {'Target' 'Mask'};
imgs = zeros(size(target,1), size(target,2), 3, 2);
imgs(:,:,:,1) = target(:,:,:);
imgs(:,:,:,2) = mask(:,:,:);

showImgSeries(title, imgs, labels);

alpha = 1.2;
out = highlightRemoval(target, mask, alpha);;
figure('name', strcat('Alpha Compression: Highlight Removal: Output using alpha= ', num2str(alpha) ))
imshow(out)

alpha = 0.005;
beta = 0.4;
out = highlightRemovalGammaCompression(target, mask, alpha, beta);
figure('name', strcat('Gamma Compression: Highlight Removal: Output using alpha= ', num2str(alpha), ' and beta= ', num2str(beta) ))
imshow(out)

%% Task 2 Image segmentation using Graph Cut Optimization
clc
img = imread('imgs/nils.jpg');
img = im2double(img);

% get fore-and background separating masks.
[fmask, bmask] = selectionForeAndBackground(img);

FM = mat2Img(fmask(:,:), fmask(:,:), fmask(:,:));
BM = mat2Img(bmask(:,:), bmask(:,:), bmask(:,:));

title = 'Foreground (left) and background mask(right)';
labels = {'Foreground Mask' 'Background Mask'};
imgs = zeros(size(fmask,1), size(fmask,2), 3, 2);

imgs(:,:,:,1) = FM(:,:,:);
imgs(:,:,:,2) = BM(:,:,:);

showImgSeries(title, imgs, labels);
clc

% extract fore-and background colors from masked selection
[fcolors, bcolors, colors] = extractBackAndForeGroundColors(img, fmask, bmask);

% Fit a Gaussian mixture distribution (gmm) to data: foreground an background
componentCount = 2;
gmmForeground = fitgmdist(fcolors', componentCount);
gmmBackground = fitgmdist(bcolors', componentCount);
    
figure('name', 'foreground');
for k = 1:componentCount,
    subplot(1,componentCount, k);
    foregroundMeanColor = reshape(gmmForeground.mu(k,:,:),1,1,3);
    imshow(imresize(foregroundMeanColor, [150,150]));
end
    
figure('name', 'background');
for k = 1:componentCount,
    subplot(1,componentCount, k);
    backgroundMeanColor = reshape(gmmBackground.mu(k,:,:),1,1,3);
    imshow(imresize(backgroundMeanColor, [150,150]));
end

% Calculate probability density functions
foregroundPDF = pdf(gmmForeground, colors');
backgroundPDF = pdf(gmmBackground, colors');

figure('name', 'Probability pixel belongs to foreground (brigther means higher probability)');
density = reshape(foregroundPDF, size(img,1), size(img,2));
density = mat2normalied(density);
imshow(density);

figure('name', 'Probability pixel belongs to background (brigther means higher probability)');
density = reshape(backgroundPDF, size(img,1), size(img,2));
density = mat2normalied(density);
imshow(density);
