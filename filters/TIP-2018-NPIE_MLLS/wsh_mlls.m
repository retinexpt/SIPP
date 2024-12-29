function varargout = wsh_mlls(imgSrc,varargin)

tic;
%%%
rslt = NPIE_MLLS(imgSrc);
varargout{1} = rslt;

elap_time = toc;
title = sprintf('%s - %f s', 'wsh_mlls',elap_time);
varargout{2} = title;
%%%

% cform2lab = makecform('srgb2lab');
% LAB =applycform(imgSrc,cform2lab);
% L=LAB(:,:,1);
% LAB(:,:,1) = adapthisteq(L,'ClipLimit',0.02);
% cform2srgb = makecform('lab2srgb');
% varargout{1} = applycform(LAB, cform2srgb);
% varargout{2} = 'clahe';