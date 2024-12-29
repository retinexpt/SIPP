% Instructions:
% ------------
% The channel division function can be call like this:
%   [O] = chanDiv(I, varargin)
% where:
%   O is intensity matrix from 0~1
%   I should be uint8
% Optional parameters
%   thresh:   threshold for the contrast pairs. (Default 10.)
%   val:      value used to accumulate the trains. Minimum step accumulation.
%             (Default is 25.)
%   step:     distance to compute the neighbors.
%   k:        controls how much of the transformation is used, rest comes 
%             from identity. Bigger values gives brighter results.
%   sigmas:   [drk mdl sat] sigmas values for each channel. (Default [3 1 1/2])
%   bounds:   [d s] thresholds for the different regions. (Defaults are [1/3 2/3].)
%   convert:  whether to convert the output to uint8, 0 to 255. (Default is true.)
% 
% Disclaimer:
% The (preliminary) code provided here (chanDiv.p) is encrypted as we are not 
% ready to release the full code yet. We expect to release it soon (check for 
% changes in the download page). Anyhow, the code here is for test purposes 
% only, and is give it as it is. Morevoer, note that the MATLAB version is 
% slower than the C/C++ version.
%
% If you use this code, please cite the paper:
%
% Ramirez Rivera, A.; Ryu, B.; Chae, O.; , "Content-Aware Dark Image Enhancement 
% through Channel Division," Image Processing, IEEE Transactions on, vol.21, no.9, pp.3967-3980, Sept. 2012
% doi: 10.1109/TIP.2012.2198667
% URL: http://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=6198348&isnumber=4358840
%

clear all
close all

%% Read
if exist('filename','var') ~= 1
    [filename, user_canceled] = imgetfile;
    if user_canceled, error('canceled'); end;
end
I = imread(filename);

%% Enhance
HSV = rgb2hsv(I);
O = HSV;
J = uint8(HSV(:,:,3).*255);

O(:,:,3) =chanDiv(J,'val',100,'thresh',10,'k',0.8,'sigmas',[3 1 1/2],'bounds',[1/3 2/3],'convert',false);

figure('name','Original'), imshow(I);
figure('name','Enhanced'), imshow(hsv2rgb(O));