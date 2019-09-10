function [c, l] = wavedecc(x, n, wname)
% WAVEDECC Multi-level column-wise 1-D wavelet decomposition.
%
% Same as apply WAVEDEC for each column of X
%
% See also:	WAVEDEC

[LoF_D, HiF_D] = wfilters(wname, 'd');

% Initialization.
c = [];
l = [size(x, 1)];

% Iterated decomposition.
for k = 1:n
    [x, d] = dwtc(x, LoF_D, HiF_D);	% decomposition (column-wise)
    c = [d ; c];			% store detail
    l = [size(d, 1) l];			% store length
end

% Last approximation.
c = [x ; c];
l = [size(x, 1) l];
