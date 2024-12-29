function jnd=getjnd()
        bg=0:255;
        tag=bg<=127;
        fsmall=17*(1-sqrt(bg/127))+3;%the small part
        flarge=3/128*(bg-127)+3;%the large part
        jnd=fsmall.*tag+flarge.*(~tag);%存储各个灰度级对应的JND
end