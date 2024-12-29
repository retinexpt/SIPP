function SaturationContrast(pic)%Saturation_Contrast
    sd_f=figure('Tag','ssrgui',...
        'Visible','off',...
        'Color',[1.0,0.949,0.867],...
        'Position',[120,125,800,520],...
        'WindowStyle','normal',...
        'Menubar','none',...
        'Name','Saturation_based Dehazing',...
        'numbertitle','off');
    f = uimenu('Label','File');
        uimenu(f,'Label','Import Picture','callback',@ImportPicture_Callback);
        uimenu(f,'Label','Save','callback',{@save_Callback});
        uimenu(f,'Label','Quit','callback',{@quit_Callback});
    ha=axes('Units','normalized','Position',[0.3,0.16,0.56,0.7]);
    run_bt=uicontrol('Style','pushbutton',...
        'String',{'Run'},...
        'Position',[20,55,70,25],...
        'callback',{@runbutton_Callback});
    exit_bt=uicontrol('Style','pushbutton',...
        'String',{'exit'},...
        'Position',[105,55,70,25],...
        'callback',{@exitbutton_Callback});
    apath_bt=uicontrol('Style','pushbutton',...
        'String',{'Assign pathname'},...
        'Position',[20,20,155,25],...
        'callback',{@apathbutton_Callback});
    pathedit = uicontrol('Style','edit',...
        'HorizontalAlignment','left',...
        'Position',[185,20,185,25]);
    set(sd_f,'name','Saturation Contrast');%?GUI?????????
    set(sd_f,'Visible','on');%?GUI??
    set([sd_f,ha,run_bt,exit_bt,apath_bt,pathedit],'Units','normalized');
    %output=pic;
    function runbutton_Callback(source,eventdata)
        global tpic
        tpic=ColorCorrect(pic);
        tpic=double(tpic);%change to double 

% tpic=double(pic);

        maxpic=round((tpic(:,:,1)+tpic(:,:,2)+tpic(:,:,3))/3);
        pichsv=rgb2hsi(uint8(tpic));
%         blkwin=48;
        blkwin=30;
%         ehcpic=CLHE(tpic,blkwin);
        ehcpic=CLHE_new(tpic,blkwin);
        ehcmax=round((ehcpic(:,:,1)+ehcpic(:,:,2)+ehcpic(:,:,3))/3);
        figure,imshow(uint8(ehcmax));
        
        win=5;
        max1=getlocalmax(maxpic,win);
        min1=getlocalmin(maxpic,win);
        max2=getlocalmax(ehcmax,win);
        min2=getlocalmin(ehcmax,win);
        delta1=(max1-min1)./(max1+~max1);
        delta2=(max2-min2)./(max2+~max2); 
        climit=0.2; %contrast limit---不能太小也不能太大
        tag=delta1<climit;
        ratio=(delta2+(climit-delta1).*tag)./(delta1.*(~tag)+climit.*tag);
        blkwin=30;%消去artifacts
        ratio=getspecialmean(ratio,tpic,blkwin);    %reshape ratio
        
        pichsv(:,:,3)=ehcmax/255;
        pichsv(:,:,2)=pichsv(:,:,2).*ratio;
        tpic=hsi2rgb(pichsv);
        figure,imshow(tpic);
    end
    function exitbutton_Callback(source,eventdata)
        close(sd_f);
    end
    function apathbutton_Callback(source,eventdata)
        global pathname
        pathname=strcat(get(pathedit,'String'),'\');
        [filename,pathname]=...
                uigetfile({'*.jpg';'*.bmp';'*.gif';'*.tiff';'*.png';'*.*'},'File Selector',pathname);
        if filename~=0
            pic=imread(strcat(pathname,filename));
            imshow(pic);
        end
    end
    function save_Callback(source,eventdata)

        global tpic
        global pathname
        if pathname~=0
             [filename,pathname]=...
                uiputfile({'*.jpg';'*.bmp';'*.gif';'*.tiff';'*.png';'*.*'},'File Selector',pathname);
             imwrite(tpic,strcat(pathname,filename));
        else
            [filename,pathname]=...
                uiputfile({'*.jpg';'*.bmp';'*.gif';'*.tiff';'*.png';'*.*'},'File Selector');
            imwrite(tpic,strcat(pathname,filename));
        end
    end
    function quit_Callback(source,eventdata)
        close(fsr_f);
    end
    function ImportPicture_Callback(source, eventdata)
        global pathname
        if pathname~=0
            [filename,pathname]=...
                uigetfile({'*.jpg';'*.bmp';'*.gif';'*.tiff';'*.png';'*.*'},'File Selector',pathname);
            pic=imread(strcat(pathname,filename));
            imshow(pic);
        else
            [filename,pathname]=...
                uigetfile({'*.jpg';'*.bmp';'*.gif';'*.tiff';'*.png';'*.*'},'File Selector');
            pic=imread(strcat(pathname,filename));
            imshow(pic);
        end
    end
end