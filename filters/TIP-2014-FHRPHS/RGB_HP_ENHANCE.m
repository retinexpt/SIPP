function [F_new,R] = RGB_HP_ENHANCE(F,varargin)
%RGB_HP_ENHANCE(F,lrh,intervals,varargin) Hue and Range Preserving RGB Image Enhancement
%   with consideration of large pixels, i.e., connected components of same
%   or similar gray value in the intensity image.
%
%   INPUT
%       F         : original RGB or gray-value image, up to now as double in the range [0,L-1]
%       lrh       : target histogram parameter
%       intervals : two-column matrix with interval boundaries of large pixels
%
%   OUTPUT
%       F_new     : specified image
%       R         : (struct) intermediate results and other data
%
%   OPTIONAL PARAMETERS
%       see PDF documentation and list below
%
%   EXAMPLE
%       % read the image as double (values in [0,255])
%       F = double(imread(imagename));
%
%       % the specified image can then be computed as
%       F_new = RGB_HP_ENHANCE(F);
%       % this is the same as calling
%       F_new = RGB_HP_ENHANCE(F,[exp(-9/2),exp(-9/2),1/2]);
%   
%       % to decrease the influence of the original histogram call
%       F_new = RGB_HP_ENHANCE(F,1/3);
%       % or specify only (l,r) directly as (note that lambda = 1/2 as default)
%       F_new = RGB_HP_ENHANCE(F,[0.8,0.2,0]);
% 
%       % for additional averaging call
%       F_new = RGB_HP_ENHANCE(F,'Average',1);
% 
%       % to compute the enhanced image we propose in general two options
%       F_new1 = RGB_HP_ENHANCE(F);
%       % or
%       F_new2 = RGB_HP_ENHANCE(F,'Average',1);
%       % where the first one is usually brighter and the latter one is closer to the original image.
%       % Which one is more suitable, i.e., provides the ``better'' result, 
%       % depends on the contrast and the brightness of the original image.
%
%   SEE ALSO
%       GUI/RGB_HP_ENHANCE_GUI.m
%       
%       M. Nikolova and G. Steidl. Fast Hue and Range Preserving Histogram: Specification:
%       Theory and New Algorithms for Color Image Enhancement. IEEE Transactions on Image
%       Processing, 23(9):4087-4100, 2014.
%
%       M. Nikolova and G. Steidl. Fast Ordering Algorithm for Exact Histogram Specification.
%       IEEE Transactions on Image Processing, 23(12):5274-5283, 2014.
%
% -------------------------------------------------------------------------
% Sören Häuser ~ RGB_HP_ENHANCE ~ 2013/03/05 ~ last edited: 2015/02/25 (Sören Häuser)

%% init parse input arguments
%TODO: add input checker functions
% create input parser
ip = inputParser;

% required
addRequired(ip,'F'); % specify validation functions after main function or use global ones

% optional input variables
l = exp(-9/2);
r = exp(-9/2);
lambda = 1/2;
addOptional(ip,'lrh',[l,r,lambda]);
addOptional(ip,'intervals',[]);

% parameters
addParameter(ip,'L',256, @(x) x>0); %number of gray values
addParameter(ip,'Stretch',1); %(over)stretch image
addParameter(ip,'StretchParameters',struct('Thresh',0.01,'MaxNonZero',10,'UpperStretching',1),@isstruct);
addParameter(ip,'OrderingParameters',struct('Alpha1',0.05,'Alpha2',0.05,'Beta',0.1,'K',5),@isstruct); %odering parameters
addParameter(ip,'Average',0); %1 for averaging final and orginal image, 0 otherwise
addParameter(ip,'LargePixel',1); %1 for considering large pixels, 0 to ignore them
addParameter(ip,'LargePixelParameters',struct('MinSizeLargePixel',0.05,'MedianFilterRadius',0),@isstruct);
addParameter(ip,'SpikeParameters',struct('MinJumpHeight',0.01,'MaxSpikeWidth',5),@isstruct);
addParameter(ip,'Visualization',0); %1: plot all intermediate steps

% undocumented parameters
addParameter(ip,'Alpha',1); %0 for additive, 1 for multiplicative algorithm
addParameter(ip,'idx_ordered',[]);
addParameter(ip,'LargePixelResults',[]);

% validate all by the parser
parse(ip, F, varargin{:});
par = ip.Results;

% simplify variables
alpha = par.Alpha;
L = par.L;

% extend lrh
if isempty(par.lrh) %empty vector is given
    par.lrh = [l,r,lambda];
elseif length(par.lrh) == 1 % only lambda is given
    par.lrh = [l,r,par.lrh];
elseif length(par.lrh) == 2 % only (l,r) are given
    par.lrh = [par.lrh lambda];
end

% show input image
if(par.Visualization)
   figure,
   imagesc(uint8(F))
   axis image off
   title('original image')
end

% results struct
if nargout > 1
    R = struct();
    if ~isempty(par.idx_ordered)
        R.idx_ordered = par.idx_ordered;
    end
    if ~isempty(par.LargePixelResults) && par.LargePixel
        R.LargePixel.Results = par.LargePixelResults;
    end
end

%% stretch image
if par.Stretch
    par.StretchParameters.L = L;
    if nargout > 1
        par.StretchParameters.R = R;
        [F,R] = stretchImage(F,par.StretchParameters);
    else
        F = stretchImage(F,par.StretchParameters);
    end
end

%% compute intensity image
F = double(F);
if max(F(:)) < 1
    F = F * (par.L-1);
end

if size(F,3) == 3
    F_intensity = 1/3 * sum(F,3);
elseif ismatrix(F)
    F_intensity = F;
else
    error('Wrong image type.')
end

if nargout > 1
   R.originalIntensity = F_intensity; 
end

[m,n] = size(F_intensity);

%% shake the intensity image
if isempty(par.idx_ordered) 
    [~,idx_ordered] = orderImage(F_intensity,par.OrderingParameters);
else
    idx_ordered = par.idx_ordered;
end

%% large pixels
if par.LargePixel 
    if isempty(par.LargePixelResults)
        % find spikes
        if isempty(par.intervals)
            par.SpikeParameters.L = L;
            intervals = detectSpikes(F,par.SpikeParameters);
        else
            intervals = par.intervals;
        end

        if nargout > 1
            R.intervals = intervals;
        end

        % extend scalar to interval
        if isscalar(intervals)
            intervals = [intervals, intervals];
        end

        % number of spikes ( = rows of intervals)
        numOfSpikes = size(intervals,1);

        % save all centers of large pixels
        C_idx = [];
        pixel_idx = {};

        % iterate through spikes
        numLargePixels = zeros(1,numOfSpikes);
        for s = 1 : numOfSpikes
            % check order of interval boundaries
            if intervals(s,1) > intervals(s,2)
                intervals(s,:) = intervals(s,[2 1]);
            end

            % create binary image
            F_val = (F_intensity>=intervals(s,1)) .* (F_intensity<=intervals(s,2));

            if par.Visualization %show binary image
                figure, imagesc(F_val), axis image off
                title(sprintf('Binary image for interval [%.1f,%.1f]',intervals(s,1), intervals(s,2)))
            end

            % apply median filtering (not by default)
            if isfield(par.LargePixelParameters,'MedianFilterRadius') && par.LargePixelParameters.MedianFilterRadius > 0
                F_med = medfilt2(F_val,[par.LargePixelParameters.MedianFilterRadius, par.LargePixelParameters.MedianFilterRadius]); 
            else
                F_med = F_val;
            end

            if par.Visualization %show median filtered binary image
                figure, imagesc(F_med), axis image off
                title(sprintf('Median filtered binary image for interval [%.1f,%.1f]',intervals(s,1), intervals(s,2)))
            end

            % compute connected components
            CC = bwconncomp(F_med);

            % number of pixels per component
            numPixels = cellfun(@numel,CC.PixelIdxList);

            % sort components descending by number of pixels
            [~,idx] = sort(numPixels,'descend');
            CC.PixelIdxList = CC.PixelIdxList(idx);

            % number of large pixels
            numLargePixels(s) = sum(numPixels >= (par.LargePixelParameters.MinSizeLargePixel*m*n));

            % show data of connected components
            if par.Visualization
                fprintf('Interval [%.1f,%.1f]:\n', intervals(s,1), intervals(s,2))
                if CC.NumObjects == 0
                    fprintf('No connected component found.\n\n');
                    continue;
                else
                    fprintf('Number of connected components: %d\n', CC.NumObjects);
                end

                if numLargePixels(s) == 0
                    fprintf('No large pixel found.\n')
                    fprintf('Further information: %d connected components found.\n', CC.NumObjects)
                    fprintf('Largest connected component has %d pixels that is %.2f%%%% of all pixels.\n\n',length(CC.PixelIdxList{1}),length(CC.PixelIdxList{1})/m/n*100)
                    continue;
                else
                    fprintf('Number of large pixels: %d\n\n', numLargePixels(s));
                end
            end

            % color connected components (only large pixels)
            conn = zeros(size(F_intensity));
            for p = 1 : numLargePixels(s)
                conn(CC.PixelIdxList{p}) = p;
            end
            if par.Visualization
                figure, imagesc(conn), axis image off; colorbar
                title(sprintf('Connected components for interval [%.1f,%.1f]', intervals(s,1), intervals(s,2)));
            end

            if nargout > 1
                if numOfSpikes > 1
                    R.LargePixel.imageConnectedComponents{s} = conn;
                else
                    R.LargePixel.imageConnectedComponents = conn;
                end
            end

            % iterate through large pixels
            for p = 1 : numLargePixels(s)
                idx_largePixel = CC.PixelIdxList{p};

                pixel_idx{s,p} = idx_largePixel;

                %keep first pixel inside image for specification
                C_idx(s,p) = idx_largePixel(1);

                %idx_largePixel = setdiff(idx_largePixel,C_idx,'stable');
                idx_largePixel(idx_largePixel == C_idx(s,p)) = [];

                %remove indices of large pixel
                idx_ordered = setdiff(idx_ordered,idx_largePixel,'stable');
            end
        end

        if nargout > 1
            R.LargePixel.numLargePixels = numLargePixels;
            R.LargePixel.intervals = intervals;

            if numOfSpikes > 0
                R.LargePixel.connectedComponents = CC;
            else
                R.LargePixel.connectedComponents = struct();
            end

            R.idx_ordered = idx_ordered;

            R.LargePixel.Results.numOfSpikes = numOfSpikes;
            R.LargePixel.Results.numLargePixels = numLargePixels;
            R.LargePixel.Results.pixel_idx = pixel_idx;
            R.LargePixel.Results.C_idx = C_idx;
        end
    else
        numOfSpikes = par.LargePixelResults.numOfSpikes;
        numLargePixels = par.LargePixelResults.numLargePixels;
        pixel_idx = par.LargePixelResults.pixel_idx;
        C_idx = par.LargePixelResults.C_idx;
    end
end

%% compute target histogram
%compute original histogram (without large pixels)
if verLessThan('matlab', '8.4')
    h_original = hist(F_intensity(idx_ordered),0:1:L-1);
else
    h_original = histcounts(F_intensity(idx_ordered),-0.5 + 0:L)';
end
h_original = h_original/sum(h_original);

if nargout > 1
    R.histogramWithoutLargePixel = h_original/numel(F_intensity);
end

if par.Visualization
    if verLessThan('matlab', '8.4')
        hh = hist(F_intensity,0:1:L-1);
    else
        hh = histcounts(F_intensity,-0.5 + 0:L)';
    end
    hh = hh/sum(hh);
    figure, bar(0:L-1,hh), title('original histogram')
    xlim([0,L-1])
    
    figure, bar(0:L-1,h_original), title('original histogram without large pixels')
    xlim([0,L-1])
end

%determine target histogram or respective parameters
if length(par.lrh) == 3 %compute averaged histogram
    % compute gaussian
    h_G = histogramGauss(par.lrh(1),par.lrh(2));
    h_G = h_G/sum(h_G);
    
    h_target = par.lrh(3) * h_original(:) + (1-par.lrh(3)) * h_G(:);
    
    if par.Visualization
        figure, bar(0:L-1,h_G), title('Gaussian histogram')
        xlim([0,L-1])
    end
elseif min(size(par.lrh,1),size(par.lrh,2)) == 3  %compute intensity histogram of reference image as target histogram
    if size(par.lrh,3) == 3 %RGB
        ref_intensity = 1/3*sum(par.lrh,3);
    else %gray
        ref_intensity = par.lrh;
    end
    if verLessThan('matlab', '8.4')
        h_target = hist(ref_intensity,0:1:L-1);
    else
        h_target = histcounts(ref_intensity,-0.5 + 0:L)';
    end
elseif isvector(par.lrh)
    h_target = par.lrh(:);
end
h_target = h_target/sum(h_target);

if nargout > 1
    R.targetHistogram = h_target;
end

if(par.Visualization)
    figure, bar(0:L-1,h_target), title('target histogram')
    xlim([0,L-1])
end

%% specify intensity image
F_intensity_mod = matchGrayHistogram(h_target,m,n,idx_ordered);

%% set large pixels back to respective value
if par.LargePixel
    for s = 1 : numOfSpikes
        for p = 1 : numLargePixels(s)
            F_intensity_mod(pixel_idx{s,p}) = F_intensity_mod(C_idx(s,p));
        end
    end
end

if nargout > 1
    R.specifiedIntensity = F_intensity_mod;
end

%% average with original image
if(par.Visualization)
    figure, imagesc(F_intensity_mod), axis image off, colormap gray
    title('Modified/specified intensity image with large pixel')
end

if(par.Average)
    F_intensity_mod_avg = 1/2 * (F_intensity_mod + F_intensity);
    
    if nargout > 1
        R.averagedIntensity = F_intensity_mod_avg;
    end
    
    if(par.Visualization)
       figure, imagesc(F_intensity_mod_avg), axis image off, colormap gray
        title('Averaged modified/specified intensity image with large pixel')
    end
end


%% colorize intensity image
if size(F,3) == 3
    F_new = affineColorSpecification(double(F),F_intensity,F_intensity_mod,alpha);
elseif ismatrix(F)
    F_new = F_intensity_mod;
end

if(par.Average)
    if size(F,3) == 3
        F_new_avg = affineColorSpecification(double(F),F_intensity,F_intensity_mod_avg,alpha);
    elseif ismatrix(F)
        F_new_avg = F_intensity_mod_avg;
    end
end
    
if(par.Visualization)
    figure, imagesc(uint8(F_new)), axis image off
    title('Color image with large pixel')
    
    if(par.Average)
        figure, imagesc(uint8(F_new_avg)), axis image off
        title('Color image with large pixel (averaged intensity image)')
    end
end

if nargout > 1
    R.specifiedColorImageWithoutMix = max(min(F_new,255),0);
end

%return averaged
if(par.Average)
    F_new = F_new_avg;
end

%% gammut problems
if max(F_new(:)) > L-1
%     warning('number of pixels larger than %d: %d\n',L-1,sum(F_new(:) > L-1))
    if nargout > 1
        R.upperGamut = sum(F_new(:) > L-1);
    end
    
    F_new = min(F_new,L-1);
end

if min(F_new(:)) < 0
%     warning('number of pixels smaller than 0: %d\n',sum(F_new(:) < 0))
    if nargout > 1
        R.lowerGamut = sum(F_new(:) < 0);
    end
    
    F_new = max(F_new,0);
end

if nargout > 1
    R.specifiedColorImageWithMix = F_new;
end

%% final intensity histogram
if verLessThan('matlab', '8.4')
    h_final = hist(1/3*sum(F_new,3),0:1:L-1);
else
    h_final = histcounts(1/3*sum(F_new,3),-0.5 + 0:L)';
end
h_final = h_final/sum(h_final(:));

if nargout > 1
    R.finalHistogram = h_final;
end