function h=eqkernel_global(pic,maxv)
        [h,count]=imhist(uint8(pic(:)));
        jnd=ceil(getjnd());
        totaln=sum(h(:)); %总count
        N=256;
        ratio=1+(1-getentropy(h)/8);
        
        while(1)
            maph=h; %maph用于存储映射后的变化值
            for i=2:N;
                maph(i)=maph(i-1)+maph(i);
            end
            maph=round(maph/totaln*maxv);%新映射
            clip=(jnd(maph+1))'*ratio;
            step=floor(h/totaln*maxv); %现有的component高度
            atag=step>clip;   %找到需要clip的灰度级
            if(sum(atag))==0
                break;
            end
            lasth=h;
            h=min(h,floor(clip/maxv*totaln));
            excess=sum(lasth-h);
            mexcess=floor(excess/N);

            for i=1:N %均衡分配多余的部分
                if step(i)<clip(i)-floor(mexcess/totaln*maxv)
                    h(i)=h(i)+mexcess;
                    excess=excess-mexcess;
                elseif step(i)<clip(i)
                        excess=excess-floor(clip(i)/255*totaln)+h(i);
                        h(i)=floor(clip(i)/255*totaln);
                end
            end

            while excess>0 %小步调整
                for i=1:N              
                    if h(i)<floor(clip/maxv*totaln)
                        h(i)=h(i)+1;
                        excess=excess-1;
                    end
                    if excess<=0
                        break;
                    end
                end
            end
        end

        
        %新增插值
        list=h;
        tag=list==0;%找出为0的灰度级
        tag(1)=0;
        tag(256)=0;
        list=list/sum(list(:));
        for k=2:256
            list(k)=list(k-1)+list(k)*maxv;
        end

        for k=1:256
            if tag(k)%找到为0的灰度级对其进行插值
                for ii=k:-1:1
                    if(~tag(ii))
                        s=ii;
                        break;
                    end
                end
                for ii=k:256
                    if(~tag(ii))
                        e=ii;
                        break;
                    end
                end
                list(k)=list(e)*(k-s)/(e-s)+list(s)*(e-k)/(e-s);
            end
        end
        h=list(pic+1);
end