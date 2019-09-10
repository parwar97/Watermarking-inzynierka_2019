function [r, l, m] = frit(a, n, wname)
% FRIT	Finite ridgelet transform
%	[r, l, m] = frit(a, n, wname)
%
% Input:
%	a:	image matrix of size P by P, P is a prime number
%	n:	number of wavelet decomposition levels
%	wname:	wavelet name
%
% Output:
%	r:	ridgelet coefficients in a matrix, one column 
%		for each direction (there is P+1 directions)
%	l:	structure of the wavelet decomposition that is
%		needed for reconstruction
%	m:	normalized mean value of the image
%
% Note:
%	This is general version of finite ridgelet transform
%	Due to non-dyadic length, there could be more ridgelet
%	coefficients than number of input image pixels.
%
% See also:	IFRIT, FRITO, FRAT, WAVEDECC, WAVEINFO

if ndims(a) ~= 2
    error('Input must be a matrix of 2 dimensions');
end

[p, q] = size(a);
if (p ~= q) | ~isprime(p)
    error('Input must be a P by P matrix, P is a prime number')
end

% Subtract the DC component
m = mean(a(:));
a = a - m;

% Normalize for unit norm
m = p * m;

% Finite Radon transform
ra = frat(a);

% 1D wavelet transform at each column of the Radon transform 
% -> "Ridgelets"
[r, l] = wavedecc(ra, n, wname);
