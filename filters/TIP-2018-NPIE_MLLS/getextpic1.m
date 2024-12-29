function output=getextpic1(im,win_size)
    [h,w,c]=size(im);
    extpic=zeros(h+2*win_size,w+2*win_size,c);
    extpic(win_size+1:win_size+h,win_size+1:win_size+w,:)=im;
    for i=1:win_size%extense row
        extpic(win_size+1-i,win_size+1:win_size+w,:)=extpic(win_size+1+i,win_size+1:win_size+w,:);%top edge
        extpic(h+win_size+i,win_size+1:win_size+w,:)=extpic(h+win_size-i,win_size+1:win_size+w,:);%botom edge
    end
    for i=1:win_size%extense column
        extpic(:,win_size+1-i,:)=extpic(:,win_size+1+i,:);%left edge
        extpic(:,win_size+w+i,:)=extpic(:,win_size+w-i,:);%right edge
    end
    output=extpic;
end