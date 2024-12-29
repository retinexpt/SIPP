function map_F=Illumination_Modify(F,sizechange)   
    %daytime prior
    p=[1294.75414748187,-2713.68523841986,1493.35807097634,-309.408936331282,228.341462306966];
    p_light=[-323.911133578029,599.713581415139,-310.027762122558,114.170739523336,175.368221301063];
    
    range=p(1)*sizechange.^4+p(2)*sizechange.^3+p(3)*sizechange.^2+p(4)*sizechange.^1+p(5);
    light=p_light(1)*sizechange.^4+p_light(2)*sizechange.^3+p_light(3)*sizechange.^2+p_light(4)*sizechange.^1+p_light(5);
    
    F=F+255-max(F(:));
    [counts,list] = imhist(uint8(F));
    total=sum(counts);
    
    F=F/255;
    list=list/255;
    range=range/255;
    light=light/255;
    Fmin=min(F(:));
    Fmax=max(F(:));
    
    range_in=Fmax-Fmin;
    
    last_dir=0; %direction, indicates increase and decrease of r
    step=0.2;
    r=1;
    r_min=1/10;
    r_max=10;
    delta=5/255;
    
    %the first time
    g_list=list.^r;
    g_Fmax=Fmax^r;
    g_Fmin=Fmin^r;
    
    
    
    if Fmax-Fmin>range
        map_list=(g_list-g_Fmin)/((g_Fmax-g_Fmin)+~(g_Fmax-g_Fmin))*range+(1-range);
    else
        map_list=(g_list-g_Fmin)/((g_Fmax-g_Fmin)+~(g_Fmax-g_Fmin))*range_in+(1-range_in);
    end
        
    
    aver_light=sum(map_list.*counts)/total;
    inter_num=0;
    while abs(aver_light-light)>delta && inter_num<30 %(r>r_min && r<r_max) && 
        g_list=list.^r;
        g_Fmax=Fmax^r;
        g_Fmin=Fmin^r;
        
        if Fmax-Fmin>range
            map_list=(g_list-g_Fmin)/((g_Fmax-g_Fmin)+~(g_Fmax-g_Fmin))*range+(1-range);
        else
            map_list=(g_list-g_Fmin)/((g_Fmax-g_Fmin)+~(g_Fmax-g_Fmin))*range_in+(1-range_in);
        end
        

        aver_light=sum(map_list.*counts)/total;

        if aver_light>light && last_dir~=-1
            r=r+step;
            last_dir=1;
        elseif aver_light>light && last_dir==-1
            step=step/2;
            r=r+step;
            last_dir=1;    
        elseif aver_light<light && last_dir~=1
            r=r-step;
            last_dir=-1;
        elseif aver_light<light && last_dir==1
            step=step/2;
            r=r-step;
            last_dir=-1;
        end
        r=min(max(r,r_min),r_max);

        inter_num=inter_num+1;
    end
    
    map_F=map_list(round(F*255)+1)*255;
    
end