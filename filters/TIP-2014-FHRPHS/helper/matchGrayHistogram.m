function [F,ha] = matchGrayHistogram(h, m, n, idx)
%MATCHGRAYHISTOGRAM intensity histogram specification
%
%   INPUT
%       h     : target histogram
%       m     : rows of target image
%       n     : columns of target image
%       idx   : sorted list of indices
%
%   OUTPUT
%       F     : specificed image
%       ha    : best approximation of target histogram
%
%   SEE ALSO
%       HistMatch_Ordering.m - Youwei WEN, 01 August 2012 
%       Histogram2GrayLevel.m - Youwei WEN, 04 October 2010 
%
%--------------------------------------------------------------------------
% Mila Nikolova ~ RGB_HP_ENHANCE ~ 2013/03/05 ~ last edited: 2015/02/10 (Sören Häuser)

% parse input arguments
ip = inputParser;
addRequired(ip,'h');
addRequired(ip,'m');
addRequired(ip,'n');
addRequired(ip,'idx');
% validate all by the parser
parse(ip, h, m, n, idx);

% organize inputs
h = h(:);
L = length(h);
% h=m*n*h/sum(h);
h = length(idx) * h / sum(h);
ha = floor(h);
hb = h - ha;

R = length(idx) - sum(ha);

% Redistribute residuals according to their magnitude
[~,ix] = sort(hb,'descend');
ha(ix(1:R)) = ha(ix(1:R))+1;

% Do column vector
ha = ha(:);

% Convert the histogram to raw intensity samples
F = zeros(n*m,1); %x=u;
ix = cumsum(ha);
for i=1:L
    if i==1
        F(idx(1:ix(i))) = i-1;
    else
        F(idx(ix(i-1)+1:ix(i))) = i-1;
    end
end
F = reshape(F,m,n);
