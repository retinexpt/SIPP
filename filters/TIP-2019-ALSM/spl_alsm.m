function varargout = spl_alsm(option,imgSrc, imgName,varargin)
% Interface function
% *************************
% 
% @article{wang2019low,
% 	title="Low-Light Image Enhancement via the Absorption Light Scattering Model",
% 	author="Yun-Fei {Wang} and He-Ming {Liu} and Zhao-Wang {Fu}",
% 	journal="IEEE Transactions on Image Processing",
% 	volume="28",
% 	number="11",
% 	pages="5679--5690",
% 	notes="Sourced from Microsoft Academic - https://academic.microsoft.com/paper/2951051324",
% 	year="2019"
% }


if strcmpi(option,'ui_name')
	varargout{1} = 'Trans Image Processing\2019-ALSM';
	return;
end

if strcmpi(option,'get_parameter')
	param(1).name = 'T';
    param(1).value = '6';
    
    param(2).name = 'N';
    param(2).value = '225';    
 
    varargout{1} = param;
	return;
end

if strcmpi(option,'run')	

	if isempty(varargin) == 1
		inputtitle='Input the cell parameters';
		parameters={'T','N'};
		
		lines=1;
		default={'6','225'};
		para_set = inputdlg(parameters,inputtitle,lines,default);	
        if isempty(para_set)
			varargout{1} = [];
			varargout{2} = [];
			return;
        end		
	else
		para_set = varargin{1};	
	end

	T = str2double(para_set{1});
	n = str2double(para_set{2});
				
	tic;
	dimg = im2double(imgSrc);
	rslt = IM(dimg,T, n);	
		
	varargout{1} = uint8(rslt*255);
	
	elap_time = toc;
	title = sprintf('%s - %f s', 'ALSM',elap_time);
	varargout{2} = title;	
end


