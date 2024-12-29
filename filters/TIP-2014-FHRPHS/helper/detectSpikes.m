function intervals = detectSpikes(F,varargin)
%DETECTSPIKES detect spikes in signal/histogram
%
%   INPUT
%       F               : original intensity image
%       MinJumpHeight   : (optional) minimal jump height (default: 0.02*L)
%       MaxSpikeWidth   : (optional) maximal spike width (default: 5)
%
%   OUTPUT
%       intervals       : two column matrix with intervals of spikes
%
%   SEE ALSO
%       note that the Matlab function "findpeaks" does not detect peaks at the
%       end points what is crucial in the histogram case
%       [pks,locs,w,p] = findpeaks(h,'Threshold',0.01,'MaxPeakWidth',5);
%
%--------------------------------------------------------------------------
% Sören Häuser ~ RGB_HP_ENHANCE ~ 2014/10/20 ~ last edited: 2015/02/10 (Sören Häuser)

if nargin == 2 && isstruct(varargin{1})
    par = varargin{1};
else
    ip = inputParser;
    addRequired(ip,'F'); % specify validation functions after main function or use global ones
    addOptional(ip,'MinJumpHeight',0.05);
    addOptional(ip,'MaxSpikeWidth',5);
    addParameter(ip,'L',256); %number of gray values
    % validate all by the parser
    parse(ip, F, varargin{:});
    par = ip.Results;
end

if isempty(par.MinJumpHeight)
    par.MinJumpHeight = round(0.02 * par.L);
end

%convert to intensity image if necessary
if size(F,3) == 3
    F_intensity = sum(F,3)/3;
elseif ismatrix(F)
    F_intensity = F;
end

%compute histogram
if verLessThan('matlab', '8.4')
    h = hist(F_intensity(:),0:1:par.L-1);
else
    h = histcounts(F_intensity(:),-0.5 + 0:par.L);
end

%normalize histogram
h_normalized = h/numel(F_intensity);

%compute differences
diff_h = diff(h_normalized);

%find increasing and decreasing parts
idx_up = find(diff_h >= par.MinJumpHeight);
idx_down = find(diff_h <= -par.MinJumpHeight);

%init intervals
%length cannot be estimated
intervals = [];

%find large pixel at the beginning (no increase)
if min(idx_down) <= par.MaxSpikeWidth
    if isempty(idx_up) %no increases
        intervals(1,1:2) = [1, max(idx_down(idx_down <= par.MaxSpikeWidth)) + 0.5];
    elseif min(idx_down) <= min(idx_up) %decrease before increase
        intervals(1,1:2) = [1, max(idx_down(idx_down <= par.MaxSpikeWidth & idx_down <=  min(idx_up))) + 0.5];
    end
end

%save largest right index
max_right = 1;

%iterate through all increases
for i = 1:length(idx_up)
    idx = idx_up(i);
    if idx < max_right
        continue;
    end
    idx2 = idx_down-idx;

    idx_left = idx + 1;
    idx_right = max(idx_down( (idx2 >= 0) & (idx2 <= par.MaxSpikeWidth)));
    
    if ~isempty(idx_right)
        max_right = max(max_right, idx_right);
        
        intervals(end+1,1:2) = [idx_left - 0.5, idx_right+0.5];
    end
end

% large pixel at the end (no decrease)
if max(idx_up) > (par.L - par.MaxSpikeWidth)
    if isempty(idx_down) % no decrease
        intervals(end+1,1:2) = [min(idx_up(idx_up >= (par.L - par.MaxSpikeWidth))) + 0.5, par.L];
    elseif max(idx_down) <= max(idx_up) %increase without following decrease
        intervals(end+1,1:2) = [min(idx_up(idx_up >= (par.L - par.MaxSpikeWidth) & idx_up >= max(idx_down))) + 0.5, par.L];
    end
end

%indices to gray values
intervals = intervals - 1; %gray values