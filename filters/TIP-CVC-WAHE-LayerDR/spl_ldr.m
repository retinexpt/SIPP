function varargout = spl_ldr(option,imgSrc, imgName,varargin)
% Interface function
% *************************

% @ARTICLE{6615961,
%   author={Lee, Chulwoo and Lee, Chul and Kim, Chang-Su},
%   journal={IEEE Transactions on Image Processing}, 
%   title={Contrast Enhancement Based on Layered Difference Representation of 2D Histograms}, 
%   year={2013},
%   volume={22},
%   number={12},
%   pages={5372-5384},
%   keywords={Histograms;Vectors;Optimization;Equations;Dynamic range;Heuristic algorithms;Educational institutions;Image enhancement;contrast enhancement;histogram equalization;2D histogram;layered difference representation;constrained optimization},
%   doi={10.1109/TIP.2013.2284059}
%   }

if strcmpi(option,'ui_name')==1
	varargout{1} = 'Trans Image Processing\2013-layerDR';
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
		inputtitle='Input the cell parameters';
		parameters={'para\original 2.5'};
		
		lines=1;
		default={'2.5'};
		para_set = inputdlg(parameters,inputtitle,lines,default);
		
		para = str2double(para_set{1});		
		
		tic;
		
		[in_Y, in_U, in_V] = rgb2yuv(imgSrc(:,:,1), imgSrc(:,:,2), imgSrc(:,:,3));
		in_Y = double(in_Y);	
		
		I = LDR(in_Y, para);	
		
		[R,C,~] = size(imgSrc);
		LDR_Y = zeros(R,C);
		for j=1:R
			for i=1:C
				LDR_Y(j,i) = round( I(in_Y(j,i)+1,1) );
			end
		end
		I = yuv2rgb(LDR_Y, in_U, in_V);
	
	else
		para_set = varargin{1};
		
		para = str2double(para_set{1});
				
		
		tic;
		
		[in_Y, in_U, in_V] = rgb2yuv(imgSrc(:,:,1), imgSrc(:,:,2), imgSrc(:,:,3));
		in_Y = double(in_Y);
		I = LDR(in_Y, para);	
		
		[R,C,~] = size(imgSrc);
		LDR_Y = zeros(R,C);
		for j=1:R
			for i=1:C
				LDR_Y(j,i) = round( I(in_Y(j,i)+1,1) );
			end
		end
		I = yuv2rgb(LDR_Y, in_U, in_V);
	end

	
	varargout{1} = uint8(I);
		
	elap_time = toc;
	title = sprintf('%s - %f s', 'LayerDR',elap_time);
	varargout{2} = title;
	%%%
end


