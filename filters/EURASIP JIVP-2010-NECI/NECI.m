function output=NECI(pic)%Saturation_based Dehazing
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
    set(sd_f,'name','NECI');%?GUI?????????
    set(sd_f,'Visible','on');%?GUI??
    set([sd_f,ha,run_bt,exit_bt,apath_bt,pathedit],'Units','normalized');
    %output=pic;
    function runbutton_Callback(source,eventdata)
        [m,n,k]=size(pic);
        global tpic
        tpic=double(pic);%change to double
        picLCH=colorspace('rgb->Lch',pic);
        picL=log(picLCH(:,:,1)+1);
        key=exp(mean(picL(:)))-1;
        picL=picLCH(:,:,1);

        Iorig=picL/max(picL(:));
        if key<=50
            r=3*log(key/10);
            r=max(min(r,1.4),1);
            x0=r;
            y0=0;
            Igm=y0+sqrt(r^2-(Iorig-x0).^2);
        elseif key>=60
            r=3*log(10-key/10);
            r=max(min(r,1.4),1);
            x0=0;
            y0=r;
            Igm=y0-sqrt(r^2-(Iorig-x0).^2);
        else
            Igm=Iorig;
        end
        
%         if key<=50
%             y1=0.15;
%             x1=x0-sqrt(r^2-(y1-y0)^2);
%             gama=log(y1)/log(x1);
%             Igm(Iorig>y1)=Iorig(Iorig>y1).^gama;
%         end
        
        
        k=floor(max(m,n)/8);

        Imask=mask(Igm,k);
        
        Ienh=Igm./(log10(Imask*100+1)+1);
        Ienh=Ienh/max(Ienh(:));
        Mref=Ienh./(picL/(max(picL(:)))+0.01);
        
        
        picLCH(:,:,1)=CutWhitePoint(Ienh,0.01);
        picLCH(:,:,2)=picLCH(:,:,2).*Mref;
        tpic=colorspace('Lch->rgb',picLCH);
        figure,imshow(tpic);
%         Im=conv2(Igm,Fr,'same');
    end
    function exitbutton_Callback(source,eventdata)
        close(sd_f);
    end
    function apathbutton_Callback(source,eventdata)
        global pathname
        pathname=strcat(get(pathedit,'String'),'\');
%         [filename,pathname] = uigetfile({'*.jpg';'*.bmp';'*.gif';'*.tif';'*.png';'*.*'},'File Selector',pathname);
		[filename,pathname] = uigetfile({'*.bmp;*.tiff;*.tif;*.jpg;*.jpeg;','image files(*.bmp,*.tif,*.tiff,*.jpg,*.jpeg)'},'Choose the image file');
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
                uiputfile({'*.jpg';'*.bmp';'*.gif';'*.tif';'*.png';'*.*'},'File Selector',pathname);
             imwrite(tpic,strcat(pathname,filename));
        else
            [filename,pathname]=...
                uiputfile({'*.jpg';'*.bmp';'*.gif';'*.tif';'*.png';'*.*'},'File Selector');
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
                uigetfile({'*.jpg';'*.bmp';'*.gif';'*.tif';'*.png';'*.*'},'File Selector',pathname);
            pic=imread(strcat(pathname,filename));
            imshow(pic);
        else
            [filename,pathname]=...
                uigetfile({'*.jpg';'*.bmp';'*.gif';'*.tif';'*.png';'*.*'},'File Selector');
            pic=imread(strcat(pathname,filename));
            imshow(pic);
        end
    end
end
