function output=getlocalsum(pic,win)%快速
    [m,n]=size(pic);
    output=zeros(m,n);
    extpic=getextpic(pic,win);
    hv=zeros(1,n+2*win);
    for i=1:n+2*win
        hv(i)=sum(extpic(1:2*win,i));%此处少一列，为了后面处理的方便
    end
    vv=zeros(1,m+2*win);
    for i=1:m+2*win
        vv(i)=sum(extpic(i,1:2*win));%此处少一列，为了后面处理的方便
    end
    m_modual=sum(vv(1:2*win));%此处少一列，为了后面处理的方便
    for i=1+win:m+win
        m_modual=m_modual+vv(i+win);
        modual=m_modual;
        hv=hv+extpic(i+win,:);
        for j=1+win:n+win
            modual=modual+hv(j+win);
            output(i-win,j-win)=modual;
            modual=modual-hv(j-win);
        end
        hv=hv-extpic(i-win,:);
        m_modual=m_modual-vv(i-win);
    end
end