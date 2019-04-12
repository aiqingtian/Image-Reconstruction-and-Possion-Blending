% Image reconstruction from first-order derivatives
clc;
clear;
close all;

imgin = im2double(imread('target.jpg'));

[imh, imw, nb] = size(imgin);
% Image is grayscale
assert(nb==1);
V = zeros(imh, imw);
V(1:imh*imw) = 1:imh*imw;

% Initialize counter, A (sparse matrix) and b.
A = sparse([],[],[]);
b = [];
e = 1;

% Fill the elements in A and b, for each pixel in the image
for y = 1:imh
    for x = 1:imw-1
        A(e, V(y, x)) = 1;
        A(e, V(y, x+1)) = -1;
        b(e) = imgin(y, x) - imgin(y, x+1);
        e = e + 1;
    end
end

for y = 1:imh-1
    for x = 1:imw
        A(e, V(y, x)) = 1;
        A(e, V(y+1,x)) = -1;
        b(e) = imgin(y, x) - imgin(y+1, x);
        e = e + 1;
    end
end

% Add extra constraints
A(e, V(1, 1)) = 1;
b(e) = imgin(1, 1);

% Solve the equation
b = b.';
solution = A \b;

error = sum(abs(A*solution-b));
disp(error)
imgout = reshape(solution,[imh,imw]);
imwrite(imgout,'output.png');
figure(), hold off, imshow(imgout);

