function varargout = spl_cvc(option,imgSrc, imgName,varargin)
% Interface function
% *************************
% 
% @ARTICLE{5773086,
%   author={Celik, Turgay and Tjahjadi, Tardi},
%   journal={IEEE Transactions on Image Processing}, 
%   title={Contextual and Variational Contrast Enhancement}, 
%   year={2011},
%   volume={20},
%   number={12},
%   pages={3431-3441},
%   keywords={Histograms;Image quality;Brightness;Algorithm design and analysis;Face recognition;Image enhancement;Contrast enhancement;face recognition;histogram equalization;image-quality enhancement},
%   doi={10.1109/TIP.2011.2157513}
%   }
  
if strcmpi(option,'ui_name')==1
	varargout{1} = 'Trans Image Processing\2011-CVC';
	return;
end

if strcmpi(option,'get_parameter')==1
% 	varargout{1} = [];
	
	param(1).para = 'para';
    param(1).value = '2.5';    
    
    varargout{1} = param;	
	return;
end

if strcmpi(option,'run')==1

	if isempty(varargin) == 1
		
		tic;
		
		[in_Y, in_U, in_V] = rgb2yuv(imgSrc(:,:,1), imgSrc(:,:,2), imgSrc(:,:,3));
		in_Y = double(in_Y);	
		
		I = CVC(in_Y);	
		
		[R,C,~] = size(imgSrc);
		CVC_Y = zeros(R,C);
		for j=1:R
			for i=1:C
				CVC_Y(j,i) = round( I(in_Y(j,i)+1,1) );
			end
		end
		I = yuv2rgb(CVC_Y, in_U, in_V);
	
	else
		
				
		
		tic;
		
		[in_Y, in_U, in_V] = rgb2yuv(imgSrc(:,:,1), imgSrc(:,:,2), imgSrc(:,:,3));
		in_Y = double(in_Y);
		I = CVC(in_Y);	
		
		[R,C,~] = size(imgSrc);
		CVC_Y = zeros(R,C);
		for j=1:R
			for i=1:C
				CVC_Y(j,i) = round( I(in_Y(j,i)+1,1) );
			end
		end
		I = yuv2rgb(CVC_Y, in_U, in_V);
	end

	
	varargout{1} = uint8(I);
		
	elap_time = toc;
	title = sprintf('%s - %f s', 'CVC',elap_time);
	varargout{2} = title;
	%%%
end


