function [F_ordered,idx] = orderImage(f,varargin)
%SHAKEIMAGE shake and sort the image
%
%   INPUT
%       F         : original intensity image
%
%   OUTPUT
%       F_shake   : shaked image
%       idx       : indices of shaked and sorted image
%
%--------------------------------------------------------------------------
% Sören Häuser ~ RGB_HP_ENHANCE ~ 2014/11/24 ~ last edited: 2015/01/14 (Sören Häuser)

if nargin == 2 && isstruct(varargin{1})
    par = varargin{1};
else
    ip = inputParser;
    addRequired(ip,'f'); % specify validation functions after main function or use global ones
    addParameter(ip,'Alpha1',0.05);
    addParameter(ip,'Alpha2',0.05);
    addParameter(ip,'Beta',0.1);
    addParameter(ip,'K',6);
    % validate all by the parser
    parse(ip, f, varargin{:});
    par = ip.Results;
end

alpha1 = par.Alpha1;
alpha2 = par.Alpha2;
beta = par.Beta;
K = par.K;

u = f;
[m,n] = size(f);

for k = 1:K
    u_old = u;
    
    t = diff(u_old);
    t = t./(alpha1+abs(t));
    u = [zeros(1,n);t] - [t;zeros(1,n)];
            
    t = (diff(u_old'))';
    t = t./(alpha1+abs(t));
    u = u + [zeros(m,1),t] - [t,zeros(m,1)];
           
    u = beta*u; 
    u = f - u*alpha2./(1 - abs(u));
end
F_ordered = u;

[~,idx] = sort(F_ordered(:));



