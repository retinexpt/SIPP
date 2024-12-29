function varargout = spl_cdim(option, imgSrc, imgName,varargin)
% Interface function
% *************************
% 
% @article{rivera2012content,
%   title={Content-aware dark image enhancement through channel division},
%   author={Rivera, Adin Ramirez and Ryu, Byungyong and Chae, Oksam},
%   journal={IEEE transactions on image processing},
%   volume={21},
%   number={9},
%   pages={3967--3980},
%   year={2012},
%   publisher={IEEE}
% }

if strcmpi(option,'ui_name')==1
	varargout{1} = 'Trans Image Processing\2012-ChannelDivision';
	return;
end

if strcmpi(option,'get_parameter')==1  
    varargout{1} = []; 
    
    return;
end

if strcmpi(option,'run')==1

    tic;
	
	HSV = rgb2hsv(imgSrc);
	O = HSV;
	J = uint8(HSV(:,:,3).*255);

	O(:,:,3) = chanDiv(J,'val',100,'thresh',10,'k',0.8,'sigmas',[3 1 1/2],'bounds',[1/3 2/3],'convert',false);
	
	varargout{1} = hsv2rgb(O);
	
	elap_time = toc;
	title = sprintf('%s - %f s','Channel division result',elap_time);
	varargout{2} = title;
end
