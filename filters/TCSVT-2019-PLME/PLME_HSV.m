function varargout = PLME_HSV(imgSrc,varargin)
% This is an implementation of the following paper
% @article{yu2019low,
%   title={Low-illumination image enhancement algorithm based on a physical lighting model},
%   author={Yu, Shun-Yuan and Zhu, Hong},
%   journal={IEEE Transactions on Circuits and Systems for Video Technology},
%   volume={29},
%   number={1},
%   pages={28--37},
%   year={2019},
%   publisher={IEEE}
% }
% The original source code was written by Pranoy Mukherjee[19EC65R12] and Yash
% Gupta[19EC65R16]. 
% 
% Tian Pu modified its parameter settings and fixed some bugs to improve performance.
% 

[height,width,page]=size(imgSrc);

if page == 1
	imgIn(:,:,1) = imgSrc;
	imgIn(:,:,2) = imgSrc;
	imgIn(:,:,3) = imgSrc;
else
	imgIn = imgSrc;
end

Ahsv = rgb2hsv(imgIn);

a=zeros(height,width,3);

a(:,:,1) = Ahsv(:,:,3);

sigma = 10;
Ker=fspecial('gaussian',floor(6*sigma+1),sigma);
l=a;
l(:,:,1)=xfilter2(Ker, a(:,:,1));

lin=l;
iter=0.9/.05;
Nth=0.05*15*15;
up=0;
cou=0;
down=0;

[rows, columns, numberOfColorChannels] = size(a);

T=ones(rows,columns,3).*0.1;

flag1=1;

row1=1;
col1=1;
row2=1;
col2=1;
flag=1;
Nloss=0;
flagr=1;

numberOfColorChannels = 1;


while(row1<rows && row2<rows && flagr)
	row2=row1+15;
	if row2>rows
		row2=rows;
		flagr=0;
	end
	flag=1;
	col1=1;
	col2=1;
	while(col1<columns && col2<columns && flag)
		flagr=1;
		col2=col1+15;
		if col2>columns
			col2=columns;
			flag=0;
        end	
		
		up=0;
		down=0;
		flag1=1;
		for i=1:iter
			if flag1==0
				break;
			end
			for t=1:numberOfColorChannels
				
				up=0;
				down=0;
				for j=row1:row2
					for k=col1:col2
						
						pixel=((a(j,k,t))-((l(j,k,t))/255))/T(j,k,t) + (l(j,k,t)/255);
						
						
						if pixel>1
							up=up+1;
						end
						if pixel<0
							down=down+1;
						end
					end
                end				

				Nloss=up+down;				
				
				if Nloss>Nth
					
					
					for cc=1:numberOfColorChannels
						for j=row1:row2
							for k=col1:col2
								T(j,k,cc)=T(j,k,cc)+0.05;
								lste=(128-l(j,k,cc))/iter;
								if up>down
									l(j,k,cc)=l(j,k,cc)+lste;
									
								else
									l(j,k,cc)=l(j,k,cc)-lste;
								end
							end
							
						end
					end					
					
				else
					flag1=0;
					
					break;
				end
			end
			
		end
		
		col1=col2+1;
	end
	
	row1=row2+1;
		
end

f=a(:,:,1);

param_set = varargin{1};
wd = param_set.width;
if wd>height || wd>width
	wd = min(height,width);
end

bm=imguidedfilter(T(:,:,1),f,'NeighborhoodSize',[wd wd],'DegreeOfSmoothing', 0.01*diff(getrangefromclass(f)).^2);
ll=imguidedfilter(l(:,:,1),f,'NeighborhoodSize',[wd wd],'DegreeOfSmoothing', 0.01*diff(getrangefromclass(f)).^2);

r = (a(:,:,1)-ll./255)./bm+ll./255;

Ahsv(:,:,3)  = r;

RGB = hsv2rgb(Ahsv);

varargout{1}=RGB;


