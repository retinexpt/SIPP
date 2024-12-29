function output=getlocalmax1(pic,win)
    [m,n]=size(pic);
    extpic=getextpic1(pic,win);
    output=zeros(m,n);
    for i=1+win:m+win
        for j=1+win:n+win
            modual=extpic(i-win:i+win,j-win:j+win);
            output(i-win,j-win)=max(modual(:));
        end
    end
end