function pic=ColorCorrect(pic)%颜色校正
        pic=double(pic);
        minpic=min(pic(:,:,1),min(pic(:,:,2),pic(:,:,3)));
        [count, scale]=imhist(uint8(minpic));
        sumPoint=0;
        dl=256; %dividing line
        totaln=sum(count(:));
        while (sumPoint<totaln*0.01)
            sumPoint=sumPoint+count(dl);
            dl=dl-1;
        end
        dlbool=minpic>=dl;
        AR=double(dlbool).*pic(:,:,1);
        AG=double(dlbool).*pic(:,:,2);
        AB=double(dlbool).*pic(:,:,3);%提取天空区
        AR=sum(AR(:))/sum(dlbool(:));%得到三个通道的天空亮度
        AG=sum(AG(:))/sum(dlbool(:));   
        AB=sum(AB(:))/sum(dlbool(:));
        pic(:,:,1)=pic(:,:,1)/AR;
        pic(:,:,2)=pic(:,:,2)/AG;
        pic(:,:,3)=pic(:,:,3)/AB;
        pic=uint8(pic/max(pic(:))*255);
end