function varargout = spl_BioEnhance(option,imgSrc, imgName,varargin)
% Interface function
% *************************

% @article{yang2020a,
% 	title="A Biological Vision Inspired Framework for Image Enhancement in Poor Visibility Conditions",
% 	author="Kai-Fu {Yang} and Xian-Shi {Zhang} and Yong-Jie {Li}",
% 	journal="IEEE Transactions on Image Processing",
% 	volume="29",
% 	pages="1493--1506",
% 	notes="Sourced from Microsoft Academic - https://academic.microsoft.com/paper/2976733039",
% 	year="2020"
% }

if strcmpi(option,'ui_name')==1
    varargout{1} = 'Trans Image Processing\2020-BioEnhance';
    return;
end

if strcmpi(option,'get_parameter')==1
    varargout{1} = [];
    return;
end

if strcmpi(option,'run')==1
    tic;
    imgSrc = im2double(imgSrc);
    I = LumGIEhsv(imgSrc);
    varargout{1} = I;
    
    elap_time = toc;
    title = sprintf('%s - %f-- s', 'BioEnhance',elap_time);
    varargout{2} = title;
    %%%
end


