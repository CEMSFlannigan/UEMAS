function [new_img] = MedFiltImg(orig_img, dim)

new_img = zeros(size(orig_img));
size_x = size(orig_img,1);
size_y = size(orig_img,2);
x1 = 0;
x2 = 0;
y1 = 0;
y2 = 0;

if isempty(dim)
    dim = 3;
end

for i = 1:size(orig_img,1)
    for j = 1:size(orig_img,2)
        if i <= dim
            x1 = 1;
        else
            x1 = i-dim;
        end
        if j <= dim
            y1 = 1;
        else
            y1 = j - dim;
        end
        
        if size_x - i <= dim
            x2 = size_x;
        else
            x2 = i + dim;
        end
        
        if size_y - j <= dim
            y2 = size_y;
        else
            y2 = j + dim;
        end
        
        data_look = orig_img(x1:x2, y1:y2);
        new_img(i,j) = median(data_look(:));
    end
end

end