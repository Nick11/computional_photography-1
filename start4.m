% Computational Photography Project 4
% Turned in by <Michael Single>
% Legi: 08-917-445

clc
clear all;
close all;
addpath('util/');
addpath('src/p4/');


%% task 1.2 Seamless Cloning

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

out = seamlessCloning(target, source, mask);
figure('Position', [100, 100, 1024, 800], ...
       'name', 'Seamless Cloning: Output')
imshow(out)


%% task 1.3: Gradient Mixing.
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

out = gradientMixing(target, source, mask);
figure('name', 'Gradient Mixing: Output')
imshow(out)


%% task 1.4: Highligh Removal
alpha = 1.2;

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

out = highlightRemoval(target, mask, alpha);
figure('name', strcat('Highlight Removal: Output using alpha= ', num2str(alpha) ))
imshow(out)

%% task 2.1
