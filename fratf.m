function [y, m] = fratf(x)
% FRATF  Finite Radon Transform
%
%       [y, m] = fratf(x)
%
% Input:
%       x:      a P by P matrix.  P is a prime.
%
% Output:
%       y:      a P by (P+1) matrix.  One projection per each column.
%       m:      (optional), normalized mean of the input matrix.
%               In that case, the mean is subtracted from each column of x.
%
% Note:		This version use FFT2
%
% See also:     FRAT

if ndims(x) ~= 2
    error('Input must be a matrix of 2 dimensions');
end

p = size(x, 1);
if (size(x, 2) ~= p) | ~isprime(p)
    error('Input must be a P by P matrix, P is a prime number')
end

% Go to Fourier domain
fx = fft2(x);

if nargout == 2
    % Save and remove the DC component
    m = fx(1, 1) / p;
    fx(1, 1) = 0;
end

% Compute the best sequence of directions
M = bestdir(p);

% Fourier slices are: (k, l) = <t*(a, b)>
t = [0:p-1]';

K = mod(t * M(1, :), p);
L = mod(t * M(2, :), p);

% Fourier transform of FRAT projections
fy = fx(1 + K + p * L);

% Back to the spatial domain, IFFT to each column
y = real(ifft(fy));

% l2-norm normalization
y = y / sqrt(p);
