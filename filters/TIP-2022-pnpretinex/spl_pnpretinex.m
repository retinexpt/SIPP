function varargout = spl_pnpretinex(option, imgSrc, imgName,varargin)
% Interface function
% *************************
% @Article{lin2022low,
%   author    = {Lin, Yi-Hsien and Lu, Yi-Chang},
%   journal   = {IEEE Transactions on Image Processing},
%   title     = {Low-light enhancement using a plug-and-play Retinex model with shrinkage mapping for illumination estimation},
%   year      = {2022},
%   pages     = {4897--4908},
%   volume    = {31},
%   publisher = {IEEE},
% }

if strcmpi(option,'ui_name')==1
    varargout{1} = 'Trans Image Processing\2022-PnPRetinex';
    return;
end

if strcmpi(option,'get_parameter')==1
    param(1).name = 'alpha';
    param(1).value = '0.3';
    
    param(2).name = 'beta';
    param(2).value = '0.1';
    
    param(3).name = 'phi';
    param(3).value = '0.01';
    
    param(4).name = 'delta';
    param(4).value = '0.01';
    
    param(5).name = 'ro';
    param(5).value = '1.5';
    
    param(6).name = 'lpnorm';
    param(6).value = '0.4';
    
    param(7).name = 'epsilon';
    param(7).value = '1e-3';
    
    param(8).name = 'u';
    param(8).value = '1';
    
    param(9).name = 'max_itr';
    param(9).value = '50';
    
    varargout{1} = param;
    
    return;
end

if strcmpi(option,'run')==1
    % 	global structArray;
    % 	imgSrc = structArray(varargin{2}).imgArray;
    
    if isempty(varargin) == 1
        inputtitle='Input the cell parameters';
        parameters={'alpha','beta','phi','delta','ro','lpnorm','epsilon','u','max_itr'};
        
        lines=1;
        default={'0.3','0.1','0.01','0.01','1.5','0.4','1e-3','1','50'};
        para_set = inputdlg(parameters,inputtitle,lines,default);
        if isempty(para_set)
            varargout{1} = [];
            varargout{2} = [];
            return;
        end
    else
        para_set = varargin{1};
    end
    
    param.alpha = str2double(para_set{1});
    param.beta = str2double(para_set{2});
    param.phi = str2double(para_set{3});
    param.delta = str2double(para_set{4});
    param.ro = str2double(para_set{5});
    param.lpnorm = str2double(para_set{6});
    param.epsilon = str2double(para_set{7});
    param.u = str2double(para_set{8});
    param.max_itr = str2double(para_set{9});
    
    tic;
    img = im2double(imgSrc);
    %  		img = img/255;
    hsv = rgb2hsv(img);
    gamma = 2.2;
    
    [L, R] = PnPRetinex(hsv(:,:,3),param);
    
    L = min(max(L,0),max(max(L)));
    R = min(max(R,0),max(max(R)));
    % 		hsv(:,:,3) = R;
    % 		R_rgb = hsv2rgb(hsv);
    hsv(:,:,3) = R.*(L.^(1/gamma));
    
    eIm = hsv2rgb(hsv);
    % convert Im and eIm to uint8
    %         Im = uint8(Im*255);
    imgOut = uint8(eIm*255);
    
    varargout{1} = imgOut;
    elap_time = toc;
    title = sprintf('%s - %f s', 'PnPRetinex',elap_time);
    varargout{2} = title;
end

