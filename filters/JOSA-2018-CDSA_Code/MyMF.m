function out=MyMF(ratio, value)% my mean filter
    img=value;
    [m,n]=size(img);
%     localmin=cdark(img,win);%获取粗糙的暗通道 coarse dark     %     localmin=getlocalmin(img,win);
    localmin=ratio;%获取粗糙的暗通道 coarse dark     %     localmin=getlocalmin(img,win);

    win=20;
    extimg=getextpic(img,win);
    extmin=getextpic(localmin,win);
    sigmar=1;
    gn=256;
    coef=zeros(gn,gn);
    coev=zeros(gn,gn);
    for i=1:gn
        rg=1:i;
        coef(i,rg)=exp(-abs(rg-i)/(2*sigmar^2));%%%%%%%%%%%%%%???????????
        coev(i,rg)=coef(i,rg).*rg;
    end
    rimg=zeros(m,n);

    for i=win+1:win+m
        for j=win+1:win+n%精确化最小值
            dx=extimg(i,j)+1;
            dy=extmin(i-win:i+win,j-win:j+win)+1;
            rimg(i-win,j-win)=sum(coef(dx,dy));
            img(i-win,j-win)=sum(coev(dx,dy));
        end
    end
    out=img./rimg;
end



