function [r, m] = frat(f)
% FRAT  Finite Radon Transform
%
%       [r, m] = frat(f)
%
% Input:
%       f:      a P by P matrix.  P is a prime.
%
% Output:
%       r:      a P by (P+1) matrix.  One projection per each column.
%       m:      (optional), normalized mean of the input matrix.
%               In this case, the mean is subtracted from each column of r.
%  
% See also:     IFRAT

% Test the existance of the MEX file
if exist('fratc') ~= 3
    % If not, use the Fourier version (which is slower)
    if nargout == 2
	[r, m] = fratf(f);
    else
	r = fratf(f);
    end
    
    return;
end

if ndims(f) ~= 2
    error('Input must be a matrix of 2 dimensions');
end

p = size(f, 1);
if (size(f, 2) ~= p) | ~isprime(p)
    error('Input must be a P by P matrix, P is a prime number')
end

% Compute the best sequence of directions
s = bestdir(p);

% Make sure the input for the MEX function is of type double
f = double(f);

% Calling the MEX file that does the actual computation of FRAT
if nargout == 2
    [r, m] = fratc(f, s);
else
    r = fratc(f, s);
end
