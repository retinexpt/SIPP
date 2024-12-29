function pic=mask(pic,win)
    [m,n,k]=size(pic);
    modual=zeros(2*win+1,2*win+1);
    Fr=modual;
    for i=1:2*win+1
        for j=1:2*win+1
            modual(i,j)=(win+1-i)^2+(win+1-j)^2;
        end
    end
    for i=1:floor(log2(win))
        Fr=Fr+exp(-modual/(2^(2*i)));
    end
    Fr=Fr/sum(Fr(:));
    
    extpic=getextpic(pic,win);
    extpic=conv2(extpic,Fr,'same');
    pic=extpic(1+win:m+win,1+win:n+win);
%     for i=1+win:m+win
%         for j=1+win:n+win
%             modual=extpic(i-win:i+win,j-win:j+win);
%             modual=modual.*Fr;
%             pic(i-win,j-win)=sum(modual(:));
%         end
%     end
    
end