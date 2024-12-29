function varargout = hsi2rgb(varargin)
%hsi2rgb(HSI) convert image from HSI to RGB
%   convert RGB image to HSI colorspace based on Gonzalez/Woods "Digital
%   Image Processing"
%
%   INPUT
%       HSI image or three channels separately
%
%   OUTPUT
%       RGB image or separate channels
%
%--------------------------------------------------------------------------
% Sören Häuser ~ RGB_HP_ENHANCE ~ 2014/11/26 ~ last edited: 2014/11/26 (Sören Häuser)

% TODO: 
% - error trapping
% - keep class (double/uint8)

%% HSI channels
if(nargin == 1)
    H = varargin{1}(:,:,1) * 2 * pi;
    S = varargin{1}(:,:,2);
    I = varargin{1}(:,:,3);
elseif(nargin == 3)
    H = varargin{1} * 2 * pi;
    S = varargin{2};
    I = varargin{3};
end

%% init
R = zeros(size(H));
G = zeros(size(H));
B = zeros(size(H));

%% RG Sector (0<= H < 2*pi/3)
idx = (H>=0) & (H <2*pi/3);
B(idx) = I(idx) .* (1-S(idx));
R(idx) = I(idx) .* (1 + S(idx).*cos(H(idx))./cos(pi/3-H(idx)));
G(idx) = 3*I(idx) - (R(idx)+B(idx));

%% BG Sector (2*pi/3 <= H < 4*pi/3)
idx = (2*pi/3<=H) & (H<4*pi/3);
R(idx) = I(idx) .* (1-S(idx));
G(idx) = I(idx) .* (1 + S(idx).*cos(H(idx)-2*pi/3)./cos(pi-H(idx)));
B(idx) = 3*I(idx) - (R(idx)+G(idx));

%% BR Sector (4*pi/3 <= H < 2*pi)
idx = (4*pi/3<=H) & (H<2*pi);
G(idx) = I(idx) .* (1-S(idx));
B(idx) = I(idx) .* (1+S(idx).*cos(H(idx)-4*pi/3)./cos(5*pi/3-H(idx)));
R(idx) = 3*I(idx) - (G(idx)+B(idx));

%% clip to [0,1]
R = max(min(R,1),0);
G = max(min(G,1),0);
B = max(min(B,1),0);

%% output
if nargout == 1
    varargout{1} = cat(3,R,G,B);
elseif nargout == 3
    varargout{1} = R;
    varargout{2} = G;
    varargout{3} = B;
end


end