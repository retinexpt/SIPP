function varargout = spl_robustretinex(option,imgSrc, imgName,varargin)
% Interface function
% *************************
% @Article{li2018structure,
%   author    = {Li, Mading and Liu, Jiaying and Yang, Wenhan and Sun, Xiaoyan and Guo, Zongming},
%   journal   = {IEEE Transactions on Image Processing},
%   title     = {Structure-revealing low-light image enhancement via robust retinex model},
%   year      = {2018},
%   number    = {6},
%   pages     = {2828--2841},
%   volume    = {27},
%   publisher = {IEEE},
% }

if strcmpi(option,'ui_name') == 1
    varargout{1} = 'Trans Image Processing\2018-RobustRetinex(imgsize<1200)';
    return;
end

if strcmpi(option,'get_parameter')==1
    param(1).name='epsilon_stop_L';
    param(1).value='1e-3';
    
    param(2).name='epsilon_stop_R'
    param(2).value='1e-3';
    
    param(3).name='epsilon';
    param(3).value='0.0392';%=10/255;
    
    param(4).name='u';
    param(4).value='1';
    
    param(5).name='ro';
    param(5).value='1.5';
    
    param(6).name='lambda';
    param(6).value='5';
    
    param(7).name='beta';
    param(7).value='0.01';
    
    param(8).name='omega';
    param(8).value='0.01';
    
    param(9).name='delta';
    param(9).value='10';
    
    varargout{1} = param;
    return;
end

if strcmpi(option,'run')==1
    
    if isempty(varargin) == 1
        inputtitle='Input the cell parameters';
        parameters={'epsilon_L','epsilon_R','epsilon',...
            'u','ro','lamda','beta','omega','delta'};
        
        lines=1;
        default={'1e-3','1e-3','0.0392','1','1.5','5','0.01','0.01','10'};
        para_set = inputdlg(parameters,inputtitle,lines,default);      
        if isempty(para_set)
			varargout{1} = [];
			varargout{2} = [];
			return;
        end		
    else
        para_set = varargin{1};       
    end
    
    para.epsilon_stop_L = str2double(para_set{1});
    para.epsilon_stop_R = str2double(para_set{2});
    para.epsilon = str2double(para_set{3});
    para.u = str2double(para_set{4});
    para.ro = str2double(para_set{5});
    para.lambda = str2double(para_set{6});
    para.beta = str2double(para_set{7});
    para.omega = str2double(para_set{8});
    para.delta = str2double(para_set{9});
    
    tic;
    dimg = double(imgSrc);
    [R, L, N] = lowlight_enhancement(dimg, para);
    gamma = 2.2;
    rslt = R.*(L.^(1/gamma));
      
    varargout{1} = uint8(rslt*255);
    
    elap_time = toc;
    title = sprintf('%s - %f s', 'RobustRetinex',elap_time);
    varargout{2} = title;
    
end


