function varargout = rgb2hsi(varargin)
%rgb2hsi(RGB) convert image from RGB to HSI
%   convert RGB image to HSI colorspace based on Gonzalez/Woods "Digital
%   Image Processing"
%
%   INPUT
%       RGB image or three channels separately
%
%   OUTPUT
%       HSI image or separate channels
%
%--------------------------------------------------------------------------
% Sören Häuser ~ RGB_HP_ENHANCE ~ 2014/11/14 ~ last edited: 2014/11/14 (Sören Häuser)

% TODO: 
% - error trapping
% - keep class (double/uint8)

%% RGB channels
if(nargin == 1)
    R = varargin{1}(:,:,1);
    G = varargin{1}(:,:,2);
    B = varargin{1}(:,:,3);
elseif(nargin == 3)
    R = varargin{1};
    G = varargin{2};
    B = varargin{3};
end

%% compute intensity
I = (R + G + B)/3;

%% compute hue
nom = 0.5*( (R - G) + (R - B) );
% denom = sqrt((R-G).^2+(R-B).*(G-B)))+eps);
denom = (0.5 * ( (R - G).^2 + (R - B).^2 + (G - B).^2 )).^(1/2);

H = acos(nom./denom);

% set hue of gray pixels to zero
M = max(max(R,G),B);
m = min(min(R,G),B);

H(m == M) = 0;

% angular adjustment
H(B>G) = 2*pi - H(B>G);

% normalize to [0,1]
H = H/(2*pi);

%% compute saturation
S = 1 - m./I;
S(I==0) = 0;

%% output
if nargout == 1
    varargout{1} = cat(3,H,S,I);
elseif nargout == 3
    varargout{1} = H;
    varargout{2} = S;
    varargout{3} = I;
end