function out=BiFltL1(img)
    img=double(uint8(img));
    
    win=7;
    [m,n]=size(img);

    localmax=getlocalmax(img,win);
    
    win=15;
    extimg=getextpic(img,win);
    extmin=getextpic(localmax,win);
    sigmar=3;

    
    gn=256;
    coef=zeros(gn,gn);
    coev=zeros(gn,gn);
    for i=1:gn
        rg=i:gn;
        coef(i,rg)=exp((i-rg)/(2*sigmar^2));
        coev(i,rg)=coef(i,rg).*rg;
    end
    rimg=zeros(m,n);
    
    for i=win+1:win+m
        for j=win+1:win+n
            r=coef(extimg(i,j)+1,extmin(i-win:i+win,j-win:j+win)+1);
            v=coev(extimg(i,j)+1,extmin(i-win:i+win,j-win:j+win)+1);
            rimg(i-win,j-win)=sum(r(:));
            img(i-win,j-win)=sum(v(:));
        end
    end
    out=img./rimg-1;
    out=round(out);
end