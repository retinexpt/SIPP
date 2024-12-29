function output=getlocalmax(pic,win)
    [m,n]=size(pic);
    extpic=getextpic(pic,win);
    output=zeros(m,n);
    for i=1+win:m+win
        for j=1+win:n+win
            modual=extpic(i-win:i+win,j-win:j+win);
            output(i-win,j-win)=max(modual(:));
        end
    end
end

% function output=getlocalmax(pic,win)%¿ìËÙ
%     [m,n]=size(pic);
%     output=zeros(m,n);
%     extpic=getextpic(pic,win);
%     for i=1+win:m+win
%         for j=1+win:n+win
%             vector=extpic(i+win,j-win:j+win);
%             rowlocal(i-win,j-win)=max(vector);
%         end
%     end
%     extrl=getextpic(rowlocal,win);
%     for i=1+win:m+win
%         for j=1+win:n+win
%             vector=extrl(i-win:i+win,j+win);
%             output(i-win,j-win)=max(vector);
%         end
%     end
% end