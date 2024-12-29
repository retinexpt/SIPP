% function output=getspecialmean(fpic,pic,win)
%     [m,n,k]=size(pic);
%     output=zeros(m,n);
%     extfpic=getextpic(fpic,win);
%     extpic=getextpic(pic,win);
%     for i=1+win:m+win
%         for j=1+win:n+win
%             modf=extfpic(i-win:i+win,j-win:j+win);
%             mod=extpic(i-win:i+win,j-win:j+win);
%             tag=abs(mod-extpic(i,j))<5;
%             modf=modf(tag);
%             output(i-win,j-win)=mean(modf(:));
%         end
%     end
% end


function output=getspecialmean(fpic,pic,win)
    [m,n,k]=size(pic);
    output=zeros(m,n);
    extfpic=getextpic(fpic,win);
    extpic=getextpic(pic,win);
    delta=16;
    for i=1+win:m+win
        for j=1+win:n+win
            modf=extfpic(i-win:i+win,j-win:j+win);
            mod=extpic(i-win:i+win,j-win:j+win,:);
            tag=(abs(mod(:,:,1)-extpic(i,j,1))<delta)&(abs(mod(:,:,2)-extpic(i,j,2))<delta)&(abs(mod(:,:,3)-extpic(i,j,3))<delta);
            modf=modf(tag);
            output(i-win,j-win)=mean(modf(:));
        end
    end
end


% function output=getspecialmean(fpic,pic,win)
%     [m,n,k]=size(pic);
%     output=zeros(m,n);
%     extfpic=getextpic(fpic,win);
%     extpic=getextpic(pic,win)+1;
%     
%     sigma=4;
%     gn=256;
%     list=1:gn;
%     eff=zeros(gn,gn);
%     for i=1:gn
%         eff(i,:)=exp(-abs(list-i).^2/sigma);
%     end
%     
%     for i=1+win:m+win
%         for j=1+win:n+win
%             modf=extfpic(i-win:i+win,j-win:j+win);
%             mod=extpic(i-win:i+win,j-win:j+win);
%             e=eff(extpic(i,j),mod(:));
%             result=modf(:).*e'/sum(e(:));
%             output(i-win,j-win)=sum(result(:));
%         end
%     end
% end

