clc;
clear;
close all;

im_background = im2double(imread('b11.jpg'));
im_object = im2double(imread('s3.jpg'));

% Get source region mask from the user
objmask = get_mask(im_object);

% Align im_s and mask_s with im_background
[im_s, mask_s] = align_source(im_object, objmask, im_background);

% Blend
disp('start');
im_blend = poisson_blend(im_s, mask_s, im_background);
disp('end');

imwrite(im_blend,'output.png');
figure(), hold off, imshow(im_blend);
