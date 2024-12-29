% function h=eqkernel(pic1,pic2,pic3)
%         [h1,count]=imhist(uint8(pic1));
%         [h2,count]=imhist(uint8(pic2));
%         [h3,count]=imhist(uint8(pic3));
%         h=h1+h2+h3;
function h=eqkernel(pic)
        [h,count]=imhist(uint8(pic(:)));
        
        jnd=ceil(getjnd());
        totaln=sum(h(:));
        N=256;
        ratio=2;
        
        while(1)
            maph=h; %maph用于存储映射后的变化值
            for i=2:N;
                maph(i)=maph(i-1)+maph(i);
            end
            maph=round(maph/totaln*255);
            clip=(jnd(maph+1))'*ratio;
            step=floor(h/totaln*255); %相对上一灰度级的步长
            atag=step>clip;   %找到需要clip的灰度级
            if(sum(atag))==0
                break;
            end
            lasth=h;
            h=min(h,floor(clip/255*totaln));
            excess=sum(lasth-h);
            mexcess=floor(excess/N);

            for i=1:N %均衡分配多余的部分
                if step(i)<clip(i)-floor(mexcess/totaln*255)
                    h(i)=h(i)+mexcess;
                    excess=excess-mexcess;
                elseif step(i)<clip(i)
                        excess=excess-floor(clip(i)/255*totaln)+h(i);
                        h(i)=floor(clip(i)/255*totaln);
                end
            end

            while excess>0 %小步调整
                for i=1:N              
                    if h(i)<floor(clip/255*totaln)
                        h(i)=h(i)+1;
                        excess=excess-1;
                    end
                    if excess<=0
                        break;
                    end
                end
            end
        end

end