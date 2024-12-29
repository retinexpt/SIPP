function mappic=ThreeStep(pic)
%     kp=zeros(1,3);%keypoint
%     [m,n]=size(pic);
% %     %找出50%元素分割点
% %     scale=0:255;
% %     [count, scale]=imhist(uint8(pic));
% %     sumPoint=0;
% %     dl=256; %dividing line
% %     while (sumPoint<m*n*0.5)
% %         sumPoint=sumPoint+count(dl);
% %         dl=dl-1;
% %     end
%     kp(1)=min(pic(:));
% %     kp(2)=dl;
%     kp(2)=100;
%     kp(3)=max(pic(:));
%     
%     newpoint=[64,191,255];
%     sigma1=8;
%     sigma2=8;
%     sigma3=8;
%     r1=exp(-abs(pic-kp(1))/sigma1^2);
%     r2=exp(-abs(pic-kp(2))/sigma2^2);
%     r3=exp(-abs(pic-kp(3))/sigma3^2);
%     total=r1+r2+r3;
%     mappic=r1*newpoint(1)+r2*newpoint(2)+r3*newpoint(3);
%     mappic=mappic./total;
% %     mappic=mappic./max(mappic(:));



%     pic=double(pic);
%     pic=pic/255;
%     ltag=pic<0.5;
%     pl=sqrt(2*pic)*0.5;
%     pr=((2*(pic-0.5)).^2+1)*0.5;
%     low=80;
%     mappic=pl.*ltag+pr.*(~ltag);
%     mappic=low+mappic*(255-low);

    
    
    %根据jnd变化得来
    list=0:255;
    tag=list<=127;
    fsmall=17*(1-sqrt(list/127))+3;%the small part
    flarge=3/128*(list-127)+3;%the large part
    jnd=fsmall.*tag+flarge.*(~tag);
    mlist=0:255;
%     mlist(1)=127;
    mlist(1)=145;
    for i=2:256
        previous=round(mlist(i-1));
        if mlist(i-1)>255
            mlist(i-1)=255;
            break;
        end
%         mlist(i)=mlist(i-1)+jnd(previous)/jnd(i)*0.63;
        mlist(i)=mlist(i-1)+jnd(previous)/jnd(i)*0.51;
    end
    mlist(i:end)=mlist(i-1);
    mappic=mlist(round(pic+1));
end