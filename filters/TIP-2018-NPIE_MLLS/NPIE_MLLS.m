function ehcpic=NPIE_MLLS(pic)    %Saturation_based Dehazing         
        % important parameters mentioned in the paper
        ratio=0.8; % down-sampling factor=1/ratio
        
        % other parameters
        illu_min=10; % the minimum illumination
        
        [m,n,k]=size(pic); % m and n indicate the size of the image
        pichsv=rgb2hsv(pic);
        
        picV=pichsv(:,:,3);
        picV=round((picV-min(picV(:)))/(max(picV(:))-min(picV(:)))*255);
        prelum=BiFltL1(picV);% F_0
        
        % R-the high-frequency component by decomposing the original image directly
        ro(:,:,1)=picV./max(prelum,illu_min);
            
        layer=1;
        % sc-the relative size change of the new layer to the original image size
        % [m, n]->[sc*m, sc*n]
        sc=1-ratio^layer; 
        prelum=Illumination_Modify(round(prelum),sc);% F_1
        r=1;
        while 1
            postlum=imresize(prelum,ratio);
            postlum=BiFltL1(postlum); 
            
            % resize the illumination to the same size as the original
            % image, to calculate the reflectance
            pre=imresize(prelum,[m,n]); % F_i
            post=min(255,max(0,imresize(postlum,[m,n])));% F_i+1
            r=r.*(pre./max(post,illu_min));% R_i+1
            
            layer=layer+1;
            if (max(postlum(:))-min(postlum(:)))<=3
                break;
            end
            
            prelum=postlum;
            sc=1-ratio^layer;
            prelum=Illumination_Modify(round(prelum),sc);
        end
       
        % post-the low-frequency component of the last layer
        if max(post)==min(post)
            post=255;
        else
            sc=1-ratio^layer;
            post=Illumination_Modify(round(post),sc);
        end
        
        ehcV=ro;
        ehcV=ehcV.*r.*post;
        pichsv(:,:,3)=ehcV/max(ehcV(:));
        ehcpic=hsv2rgb(pichsv);
end