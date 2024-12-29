function F_new = affineColorSpecification(F,F_intensity,F_intensity_new,varargin)
%AFFINECOLORSPECIFICATION tranfer colors based on change of intensity
%images
%
%   INPUT
%       F               : original color image
%       F_intensity     : original intensity image
%       F_intensity_new : new intensity image
%       alpha           : (optional) parameter in [0,1] 
%                         (0: additive model, 1: multiplicative model)
%
%   OUTPUT
%       F_new           : new color image
%
%--------------------------------------------------------------------------
% Mila Nikolova ~ RGB_HP_ENHANCE ~ 2014/10/20 ~ last edited: 2015/02/10 (Sören Häuser)

% parse input arguments
ip = inputParser;
addRequired(ip,'F');
addRequired(ip,'F_intensity');
addRequired(ip,'F_intensity_new');
addOptional(ip,'alpha',1);
addParameter(ip,'L',256); %number of gray values
% validate all by the parser
parse(ip, F,F_intensity, F_intensity_new, varargin{:});
par = ip.Results;

%simplify variables
alpha = par.alpha;
L = par.L;

%init F_new
F_new = F;

%old colors
R = F(:,:,1);
G = F(:,:,2);
B = F(:,:,3);

%minima and maxima
mm = min(min(R,G),B);
M = max(max(R,G),B);

%new colors
VR = zeros(size(F_intensity));
VG = zeros(size(F_intensity));
VB = zeros(size(F_intensity));

%% case 1 
VR(F_intensity == M) = F_intensity_new(F_intensity == M);
VG(F_intensity == M) = F_intensity_new(F_intensity == M);
VB(F_intensity == M) = F_intensity_new(F_intensity == M);

VR(F_intensity == mm) = F_intensity_new(F_intensity == mm);
VG(F_intensity == mm) = F_intensity_new(F_intensity == mm);
VB(F_intensity == mm) = F_intensity_new(F_intensity == mm);

%% case 2
a = ones(size(F_intensity));
a(F_intensity>0) = (alpha*F_intensity_new(F_intensity>0) + (1-alpha)*F_intensity(F_intensity>0))./F_intensity(F_intensity>0);

GM = a.*(M-F_intensity) + F_intensity_new;
IM = (GM>L-1);

Gm = a.*(mm-F_intensity) + F_intensity_new;
Im = (Gm<0);

I = (Gm >= 0 | GM <=L-1);

%% case 2i
VR(I == 1) = a(I == 1) .*(R(I == 1) - F_intensity(I == 1)) + F_intensity_new(I == 1);
VG(I == 1) = a(I == 1) .*(G(I == 1) - F_intensity(I == 1)) + F_intensity_new(I == 1);
VB(I == 1) = a(I == 1) .*(B(I == 1) - F_intensity(I == 1)) + F_intensity_new(I == 1);

%% case 2ii
aM = ones(size(F_intensity));
aM(IM == 1) = (L-1 - F_intensity_new(IM == 1))./(M(IM == 1) - F_intensity(IM == 1));

VR(IM == 1) = aM(IM==1).*(R(IM==1) - F_intensity(IM==1)) + F_intensity_new(IM==1);
VG(IM == 1) = aM(IM==1).*(G(IM==1) - F_intensity(IM==1)) + F_intensity_new(IM==1);
VB(IM == 1) = aM(IM==1).*(B(IM==1) - F_intensity(IM==1)) + F_intensity_new(IM==1);

%% case 2iii
am = ones(size(F_intensity));
am(Im == 1) = F_intensity_new(Im == 1)./(F_intensity(Im == 1)-mm(Im == 1));

VR(Im == 1) = am(Im==1).*(R(Im==1) - F_intensity(Im==1)) + F_intensity_new(Im==1);
VG(Im == 1) = am(Im==1).*(G(Im==1) - F_intensity(Im==1)) + F_intensity_new(Im==1);
VB(Im == 1) = am(Im==1).*(B(Im==1) - F_intensity(Im==1)) + F_intensity_new(Im==1);

%% final result
F_new(:,:,1) = VR;
F_new(:,:,2) = VG;
F_new(:,:,3) = VB;