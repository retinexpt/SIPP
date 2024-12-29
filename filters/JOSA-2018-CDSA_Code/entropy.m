function out=entropy(pic)
    [m,n]=size(pic);
    scale=0:255;
    [count, scale]=imhist(uint8(round(pic)));
    p=count/(m*n);
    out=-sum(p.*log2(p+~p));
end