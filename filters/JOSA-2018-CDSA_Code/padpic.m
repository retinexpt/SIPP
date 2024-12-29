function padp=padpic(pic,blkwin)
    [m,n,q]=size(pic);
    padm=blkwin-m+floor(m/blkwin)*blkwin;%²¹³äµÄ±ß
    padn=blkwin-n+floor(n/blkwin)*blkwin;
    padp=zeros(m+padm,n+padn,q);
%     if k==1
%         padp=zeros(m+padm,n+padn);
%         padp(1:m,1:n)=pic;
%         %¼Ó±ß
%         for i=m+1:m+padm
%             padp(i,:)=padp(2*m-i+1,:);
%         end
%         for j=n+1:n+padn
%             padp(:,j)=padp(:,2*n-j+1);
%         end
%     else
        for k=1:q
            padp(1:m,1:n,k)=pic(:,:,k);
            %¼Ó±ß
            for i=m+1:m+padm
                padp(i,:,k)=padp(2*m-i+1,:,k);
            end
            for j=n+1:n+padn
                padp(:,j,k)=padp(:,2*n-j+1,k);
            end
        end
%     end
end