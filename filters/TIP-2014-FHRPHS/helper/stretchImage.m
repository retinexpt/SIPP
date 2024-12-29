function [F_stretch,varargout] = stretchImage(F,varargin)
%stretchImage(F,varargin) stretch histogram to interval [0,L]
%   pixels below tresh will be set to zero
%
%   INPUT
%       F           : original RGB image
%       Thresh      : (optional) ratio of pixels that should be ignored (default 1%)
%       MaxNonZero  : (optional) number of (target) gray values (default 256)
%
%   OUTPUT
%       F_stretch   : stretched image
%       R           : (struct) additional information
%
%--------------------------------------------------------------------------
% Sören Häuser ~ RGB_HP_ENHANCE ~ 2014/10/20 ~ last edited: 2014/12/17 (S�ren H�user)

if nargin == 2 && isstruct(varargin{1})
    par = varargin{1};
else
    ip = inputParser;
    addRequired(ip,'F');
    addOptional(ip,'Thresh',0.01);
    addOptional(ip,'MaxNonZero',10);
    addParameter(ip,'UpperStretching',1);
    addParameter(ip,'L',256); %number of gray values
    addParameter(ip,'R',[]);
    % validate all by the parser
    parse(ip, F, varargin{:});
    par = ip.Results;
end

%create intensity image
if size(F,3) == 3
    F_intensity = sum(F,3)/3;
elseif ismatrix(F)
    F_intensity = F;
end

%upper and lower treshold
if(length(par.Thresh) == 1)
    par.Thresh = [par.Thresh par.Thresh];
end

if(length(par.MaxNonZero) == 1)
    par.MaxNonZero = [par.MaxNonZero par.MaxNonZero];
end

%find relative min value in intensity image
if verLessThan('matlab', '8.4')
    h = hist(F_intensity(:),0:1:par.L-1);
else
    h = histcounts(F_intensity(:),-0.5 + 0:par.L);
end
C = cumsum(h)/numel(F_intensity);

%count number of non zeros added
H_zero = cumsum(h>0);

%stretching towards 0
idx_low = find( (C <= par.Thresh(1)) .* (H_zero <= par.MaxNonZero(1)), 1, 'last');
%stretching towards L-1
if par.UpperStretching
    idx_high = find( (C >= 1 - par.Thresh(2)) .* (H_zero >= H_zero(end) - par.MaxNonZero(2)),1 , 'first');
else
    idx_high = [];
end

%circumvent empty indices and convert indices to gray values (minus 1)
if isempty(idx_low)
    idx_low = 0;
else
    idx_low = idx_low - 1;
end
if isempty(idx_high)
    idx_high = par.L - 1;
else
    idx_high = idx_high - 1;
end

%stretch image
F_stretch = (F - idx_low) * (par.L - 1) / (idx_high - idx_low);

%store lower and uppper gammut pixels
if nargout > 1
    Stretching.lowerGamut = squeeze(sum(sum(F_stretch<0)));
    Stretching.upperGamut = squeeze(sum(sum(F_stretch>(par.L - 1))));
    Stretching.newMin = idx_low;
    Stretching.newMax = idx_high;
    Stretching.Thresh = par.Thresh;
    Stretching.MaxNonZero = par.MaxNonZero;
    Stretching.originalImage = F;
    Stretching.originalHistogram = h/numel(F_intensity);
end

%project image to [0,L-1]
F_stretch = min(max(F_stretch,0),par.L-1);

if nargout > 1
    Stretching.stretchedImage = F_stretch;
    if size(F_stretch,3) == 3
        F_stretch_intensity = sum(F_stretch,3)/3;
    elseif ismatrix(F)
        F_stretch_intensity = F_stretch;
    end
    if verLessThan('matlab', '8.4')
        h = hist(F_stretch_intensity(:),0:1:par.L-1);
    else
        h = histcounts(F_stretch_intensity(:),-0.5 + 0:par.L);
    end
    Stretching.stretchedHistogram = h/numel(F_intensity);    
    
    if isfield(par,'R')
        par.R.Stretching = Stretching;    
        varargout{1} = par.R;
    else
        varargout{1} = Stretching;
    end
end