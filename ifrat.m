function f = ifrat(r, m)
% IFRAT  Inverse Finite Radon Transform
%
%	   f = ifrat(r, [m])
%
% Input:
%	r:	Radon coefficients in P by (P+1) matrix.
%		One projection per each column.  P is a prime.
%	m:	(optional), normalized mean of the recontructed matrix.
%		In this case, r is supposed to has zero-mean in each column.
%
% Output:
%
% 	f:	reconstructed matrix.
%
% See also:	FRAT

% Test the existance of the MEX file
if exist('ifratc') ~= 3
    % If not, use the Fourier version (which is slower)
    if exist('m', 'var')
	f = ifratf(r, m);
    else
	f = ifratf(r);
    end
    
    return;
end


if ndims(r) ~= 2
    error('Input must be a matrix of 2 dimensions');
end

p = size(r, 1);
if (size(r, 2) ~= (p + 1)) | ~isprime(p)
    error('Input must be a P by P matrix, P is a prime number')
end

% Compute the best sequence of directions
s = bestdir(p);

% Calling the MEX file that does the actual computation of IFRAT
if exist('m', 'var')
    f = ifratc(r, s, m);
else
    f = ifratc(r, s);
end
