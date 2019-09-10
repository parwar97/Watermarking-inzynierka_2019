function x = ifratf(y, m)
% IFRATF  Inverse Finite Radon Transform
%
%       x = ifratf(y, [m])
%
% Input:
%       y:      a P by (P+1) matrix.  One projection per each column.
%       m:      (optional), normalized mean of the recontructed matrix.
%               In this case, y is supposed to has zero-mean in each column.
%
% Output:
%       x:      reconstructed matrix of size P by P.  P is a prime.
%
% Note:		This version use FFT2 and projection slice theorem
%
% See also:     FRATF

if ndims(y) ~= 2
    error('Input must be a matrix of 2 dimensions');
end

p = size(y, 1);
if (size(y, 2) ~= (p+1)) | ~isprime(p)
    error('Input must be a P by (P+1) matrix, P is a prime number')
end

% l2-norm re-normalization
y = y * sqrt(p);

% Take each projection to Fourier domain
fy = fft(y);

% Compute the best sequence of directions
M = bestdir(p);

% Fourier slices are: (k, l) = <t*(a, b)>
t = [0:p-1]';

K = mod(t * M(1, :), p);
L = mod(t * M(2, :), p);

% Fourier transform of the reconstructed image
fx = zeros(p, p);
fx(1 + K + p * L) = fy;

if nargin == 2
    % Assign back the DC component
    fx(1, 1) = m * p; 
end

% Finally, inverse the Fourier transform
x = real(ifft2(fx));
