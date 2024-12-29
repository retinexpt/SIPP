function varargout = spl_wahe(option,imgSrc, imgName,varargin)
% Interface function
% *************************
% @ARTICLE{4895264,
%   author={Arici, Tarik and Dikbas, Salih and Altunbasak, Yucel},
%   journal={IEEE Transactions on Image Processing}, 
%   title={A Histogram Modification Framework and Its Application for Image Contrast Enhancement}, 
%   year={2009},
%   volume={18},
%   number={9},
%   pages={1921-1935},
%   keywords={Histograms;Dynamic range;Pixel;Cost function;White noise;Noise level;Noise robustness;Design optimization;Digital photography;Histogram equalization;histogram modification;image/video quality enhancement},
%   doi={10.1109/TIP.2009.2021548}}
% -------------------------------------------------------------------------
% An implementation of "Weighted Approximated Histogram Equalization."
%   T. Arici, S. Dikbas, and Y. Altunbasak, "A histogram modification
%   framework and its application for image contrast enhancement," IEEE
%   Trans. Image Process., vol. 18, no. 9, pp. 1921-1935, Sep. 2009.
%

if strcmpi(option,'ui_name')==1
    varargout{1} = 'Trans Image Processing\2009-WAHE';
    return;
end

if strcmpi(option,'get_parameter')==1
    param(1).para = 'para';
    param(1).value = '1.5';
    
    varargout{1} = param;
    return;
end

if strcmpi(option,'run')==1
    
    if isempty(varargin) == 1
        inputtitle='Input the cell parameters';
        parameters={'para\original 1.5'};
        
        lines=1;
        default={'1.5'};
        para_set = inputdlg(parameters,inputtitle,lines,default);
        
        para = str2double(para_set{1});    
        
    else
        para_set = varargin{1};        
        para = str2double(para_set{1});        
    end
    
    tic;
    
    [in_Y, in_U, in_V] = rgb2yuv(imgSrc(:,:,1), imgSrc(:,:,2), imgSrc(:,:,3));
    in_Y = double(in_Y);
    I = WAHE(in_Y, para);
    
    [R,C,~] = size(imgSrc);
    WAHE_Y = zeros(R,C);
    for j=1:R
        for i=1:C
            WAHE_Y(j,i) = round( I(in_Y(j,i)+1,1) );
        end
    end
    I = yuv2rgb(WAHE_Y, in_U, in_V);
    
    varargout{1} = uint8(I);
    
    elap_time = toc;
    title = sprintf('%s - %f s', 'WAHE',elap_time);
    varargout{2} = title;
    %%%
end


