% Image reconstruction from second-order derivatives
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
b = zeros(imh*imw+4, 1);
e = 1;

% Fill the elements in A and b, for each pixel in the image
for y = 1:imh
    for x = 1:imw
        A(e, V(y, x)) = 4;
        
        if(y == 1)
            if(x == 1 || x == imw)
                A(e, V(y, x)) = 0; 
                b(e) = b(e) + 0;
            else
                A(e, V(y, x-1)) = 1;
                A(e, V(y, x)) = -1;
                b(e) = b(e) + imgin(y, x-1) - imgin(y, x);
            end
        elseif(y == imh)
            if(x == 1 || x == imw)
                A(e, V(y, x)) = 0;
                b(e) = b(e) + 0;
            else
                A(e, V(y, x-1)) = 1;
                A(e, V(y, x)) = -1;
                b(e) = b(e) + imgin(y, x-1) - imgin(y, x);
            end
        elseif(x == 1 || x == imw)
            if(y ~= 1 && y ~= imh)
                A(e, V(y - 1, x)) = 1;
                A(e, V(y, x)) = -1;
                b(e) = b(e) + imgin(y - 1, x) - imgin(y, x);
            end
        else
            A(e, V(y - 1, x)) = -1;
            b(e) = b(e) - imgin(y - 1, x) + imgin(y, x);
            A(e, V(y + 1, x)) = -1;
            b(e) = b(e) + imgin(y, x) - imgin(y + 1, x);
            A(e, V(y, x-1)) = -1;
            b(e) = b(e) + imgin(y, x) - imgin(y, x - 1);
            A(e, V(y, x + 1)) = -1;
            b(e) = b(e) + imgin(y, x) - imgin(y, x + 1);
        end 
        e = e + 1;
    end 
end
                       
% Add extra constraints
A(e+3, V(imh, imw)) = 1;
b(e+3) = b(e+3) + imgin(imh, imw);
A(e, V(1, 1)) = 1;
b(e) = b(e) + imgin(1, 1);
A(e+1, V(1, imw)) = 1;
b(e + 1) = b(e+1)+imgin(1, imw);
A(e+2, V(imh, 1)) = 1;
b(e+2) = b(e+2)+ imgin(imh, 1);

% Solve the equation
solution = A \b;

error = sum(abs(A*solution-b));
disp(error)
imgout = reshape(solution,[imh,imw]);
imwrite(imgout,'output.png');
figure(), hold off, imshow(imgout);

