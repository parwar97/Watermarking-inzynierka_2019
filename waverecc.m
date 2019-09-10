function a = waverecc(c, l, wname)
% WAVERECC Multi-level column-wise 1-D wavelet reconstruction.
%
% Same as apply WAVEREC for each column.
%
% See also:	WAVEDECC, WAVEREC

rmax = length(l);
nmax = rmax - 2;

[LoF_R, HiF_R] = wfilters(wname, 'r');

% Initialization.
a = c(1:l(1), :);

% Iterated reconstruction.
imax = rmax + 1;
for k = nmax:-1:1
    d = detcoefc(c, l, k);		% extract detail
    a = idwtc(a, d, LoF_R, HiF_R, l(imax-k));
end


%----------------------------------------------------------------------------%
% Internal Function(s)
%----------------------------------------------------------------------------%
function d = detcoefc(c, l, n)
% Same as DETCOEF for column-wise.

rmax = length(l);
nmax = rmax - 2;

% Extract detail coefficients.
k     = rmax - n;
first = sum(l(1:k-1)) + 1;
last  = first + l(k) - 1;
d     = c(first:last, :);
%----------------------------------------------------------------------------%
