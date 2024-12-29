function varargout = spl_gamma_hsv(option, imgSrc, imgName,varargin)
% Interface function
% *************************
% gamma transform 
% imgOut = 255.(imgIn/255).^gamma
% 


if strcmpi(option,'ui_name')==1
	varargout{1} = 'Gamma Transform\Gamma_HSV';
	return;
end

if strcmpi(option,'get_parameter')==1  
    param(1).name = 'Gamma';
    param(1).value = '0.6';
    
    varargout{1} = param;    
    return;
end

if strcmpi(option,'run')==1
% 	global structArray;
% 	imgSrc = structArray(varargin{2}).imgArray;
	
    [height,width,page] = size(imgSrc);
    if page == 1
        imgIn(:,:,1) = imgSrc;
        imgIn(:,:,2) = imgSrc;
        imgIn(:,:,3) = imgSrc;
    else
        imgIn = imgSrc;
    end

    Ahsv = rgb2hsv(imgIn);
    imgArray = Ahsv(:,:,3)*255;  
    
    gamma = 1/2.5;
	if isempty(varargin) == 1
		inputtitle='Input the cell parameters';
		parameters={'gamma\original 1/2.2'};
		
		lines=1;
		default={'0.6'};
		para_set = inputdlg(parameters,inputtitle,lines,default);
		
		gamma = str2double(para_set{1});		
		
		tic;
        W=255;
		imgOut = W*(imgArray/W).^gamma;  
    else
        gamma = str2double(varargin{1});
        tic;
        W=255;
        imgOut = W*(imgArray./W).^gamma;
    end
    
    Ahsv(:,:,3) = imgOut./255;
    RGB = hsv2rgb(Ahsv);
    imgOut = uint8(RGB*255);
	
    elap_time = toc;
	
    varargout{1} = imgOut;
    title = sprintf('%s - g-%f %f s', 'Gamma',gamma,elap_time);
	varargout{2} = title;
end

