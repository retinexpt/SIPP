function varargout = spl_pmea_hsv(option, imgSrc, imgName,varargin)
% Interface function
% *************************
% @article{https://doi.org/10.1049/iet-cvi.2017.0259,
% author = {Pu, Tian and Wang, Shuhang},
% title = {Perceptually motivated enhancement method for non-uniformly illuminated images},
% journal = {IET Computer Vision},
% volume = {12},
% number = {4},
% pages = {424-433},
% keywords = {brightness, optical transfer function, visibility, image enhancement, perceptually motivated enhancement method, nonuniformly illuminated images, low visibility, dark areas, Weber contrast model, perceptually inspired image enhancement method, luminance mapping transfer function, LM transfer function, contrast measure transfer function, CM transfer function, human visual system, neural model, contrast enhancement, visual fidelity preservation},
% doi = {https://doi.org/10.1049/iet-cvi.2017.0259},
% url = {https://ietresearch.onlinelibrary.wiley.com/doi/abs/10.1049/iet-cvi.2017.0259},
% eprint = {https://ietresearch.onlinelibrary.wiley.com/doi/pdf/10.1049/iet-cvi.2017.0259},
% year = {2018}
% }

if strcmpi(option,'ui_name')==1
	varargout{1} = 'IET CV\2018_PMEA_HSV';
	return;
end

if strcmpi(option,'get_parameter')==1   
    varargout{1} = [];
    
    return;
end

if strcmpi(option,'run')==1
	tic;	
    imgOut = pmea_hsv(imgSrc);
	elap_time = toc;
    
    title = sprintf('%s - %f s', 'PMEA-hsv',elap_time);
        
	varargout{1} = imgOut;
	varargout{2} = title;
end

