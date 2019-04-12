function imgout = poisson_blend(im_s, mask_s, im_t)

[imh, imw, nb] = size(im_t);
V = zeros(imh, imw);
[mask_y, mask_x] = find(mask_s > 0);
num_pixels = sum(sum(mask_s));
for i = 1:num_pixels
    V(mask_y(i),mask_x(i)) = i;
end
solution = {};

for imc= 1:nb
    A = sparse([],[],[], num_pixels, num_pixels);
    b =zeros(num_pixels, 1);
    e = 1;
    for i= 1:num_pixels
        y = mask_y(i);
        x = mask_x(i);
        A(e, V(y, x)) =4;
   
        if(mask_s(y-1 , x)==1)
            A(e, V(y-1, x)) = -1;
            b(e) = b(e) + im_s(y, x, imc) - im_s(y-1, x, imc);
        else
            b(e) = b(e) + im_t(y-1, x, imc);
        end
        
        if(mask_s(y+1 , x)==1)
            A(e, V(y+1, x)) = -1;
            b(e) = b(e) + im_s(y, x, imc) - im_s(y+1, x, imc);
        else
            b(e) = b(e) + im_t(y+1, x, imc);
        end
        
        if(mask_s(y, x-1)==1)
            A(e, V(y, x-1)) = -1;
            b(e) = b(e) + im_s(y, x, imc) - im_s(y, x-1, imc);
        else
            b(e) = b(e) + im_t(y, x-1, imc);
        end
        
        if(mask_s(y, x+1)==1)
            A(e, V(y, x+1)) = -1;
            b(e) = b(e) + im_s(y, x, imc) - im_s(y, x+1, imc);
        else
            b(e) = b(e) + im_t(y, x+1, imc);
        end
        e = e + 1;
    end
    solution{imc} = A \b;
    error = sum(abs(A*solution{imc}-b));
    disp(error)
end

imgout = im_t;
for i= 1:num_pixels
    for imc= 1:nb
        y = mask_y(i);
        x = mask_x(i);
        imgout(y, x, imc) = solution{imc}(i);
    end
end
end



