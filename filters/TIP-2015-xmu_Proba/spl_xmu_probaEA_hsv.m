function varargout = spl_xmu_probaEA_hsv(option, imgSrc, imgName,varargin)
% Interface function
% *************************
% @article{tip2015-XA,
%   title={A Probabilistic Method for Image Enhancement with Simultaneous Illumination and Reflectance Estimation},
%   author={X. Fu and Y. Liao and D. Zeng and Y. Huang and X. Zhang and X. Ding},
%   journal={IEEE Transactions on Image Processing},
%   volume={24},
%   number={12},
%   pages={4965-4977},
%  year={2015},
% }

if strcmpi(option,'ui_name')==1
    varargout{1} = 'Trans Image Processing\2015-Probability_hsv';
    return;
end

if strcmpi(option,'get_parameter')==1
    param(1).name = 'alpha';
    param(1).value = '1000';
    
    param(2).name = 'beta';
    param(2).value = '0.01';
    
    param(3).name = 'gamma';
    param(3).value = '0.1';
    
    param(4).name = 'lambda';
    param(4).value = '10';
    
    varargout{1} = param;
    return;
end

if strcmpi(option,'run')==1
    if isempty(varargin) == 1
        inputtitle='Input the cell parameters';
        parameters={'alpha','beta','gamma','lambda'};
        
        lines=1;
        default={'1000','0.01','0.1','10'};
        para_set = inputdlg(parameters,inputtitle,lines,default);
        
        if isempty(para_set)
            varargout{1} = [];
            varargout{2} = [];
            return;
        end
        
    else
        para_set = varargin{1};
    end
    
    alpha = str2double(para_set{1});
    beta = str2double(para_set{2});
    gamma = str2double(para_set{3});
    lambda = str2double(para_set{4});
    
    tic;
    
    % 	alpha = 1000;  beta= 0.01;  gamma = 0.1;  lambda = 10; % set parameters
    
    error_R = 10; error_I = 10;  % initial stopping criteria error_R and error_I
    stop = 0.1;  % stopping criteria
    
    HSV = rgb2hsv( double(imgSrc) );   % RGB space to HSV  space
    S = HSV(:,:,3);       % V layer
    
    [ R, I, error_R, error_I ] = processing( S, alpha, beta, gamma, lambda, error_R, error_I, stop);
    
    % Gamma correction
    gamma1 = 2.2;
    I_gamma = 255 * ( (I/255).^(1/gamma1) );
    enhanced_V = R .* I_gamma;
    HSV(:,:,3) = enhanced_V;
    enhanced_result = hsv2rgb(HSV);  %  HSV space to RGB space
    enhanced_result = cast(enhanced_result, 'uint8');
    
    varargout{1} = enhanced_result;
    
    elap_time = toc;
    title = sprintf('%s - %f s','XMU Probabilistic_hsv result',elap_time);
    varargout{2} = title;
end

