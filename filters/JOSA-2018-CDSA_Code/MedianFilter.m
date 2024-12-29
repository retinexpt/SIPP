function mf=MedianFilter(pic,win)%¾ùÖµÂË²¨
    [m,n]=size(pic);
    pic=double(pic);
    extpic=getextpic(pic,win);
    mf=zeros(m,n);
%     mflow=zeros(m,n);
%     mfhigh=zeros(m,n);
    for i=1+win:m+win
        for j=1+win:n+win
            modual=extpic(i-win:i+win,j-win:j+win);
            mf(i-win,j-win)=median(modual(:));
%              mflow(i-win,j-win)=min(modual(:));
%              mfhigh(i-win,j-win)=max(modual(:));
        end
    end
%     tag=(mfhigh-pic)<(pic-mflow);
%     mf=mfhigh.*tag+mflow.*(~tag);
end