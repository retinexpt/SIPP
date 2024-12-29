function cutpic=CutWhitePoint(pic,ratio)
    [m,n,k]=size(pic);
    scale=0:99;
    [count, scale]=imhist(uint8(floor(pic*99)));
    sumPoint=0;
    dl=99; %dividing line
    while (sumPoint<m*n*ratio)
        sumPoint=sumPoint+count(dl);
        dl=dl-1;
    end
    dlbool=floor(pic*99)>dl;
    pic(dlbool)=dl/99;
    cutpic=(pic-min(pic(:)))/(max(pic(:))-min(pic(:)))*99;
end