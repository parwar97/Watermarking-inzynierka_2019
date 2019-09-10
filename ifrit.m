function a = ifrit(r, l, m, wname)
% IFRIT	Inverse finite ridgelet transform
%	a = ifrit(r, l, m, wname)
%
% Input:
%	r:	ridgelet coefficients in a matrix, one column 
%		for each direction (there is P+1 directions)
%	l:	structure of the wavelet decomposition that is
%		needed for reconstruction
%	m:	normalized mean value of the image
%	wname:	wavelet name
%
% Output:
%	a:	reconstructed image
%
% See also:	FRIT

% Back to Radon domain.
ra = waverecc(r, l, wname);

% Inverse the finite Radon transform with the mean corrected
a = ifrat(ra, 0);

% Add back the DC component
a = a + m / (size(r, 2) - 1);