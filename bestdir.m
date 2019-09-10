function M = bestdir(p)
% BESTDIR  Compute the best sequence of directions for FRAT
%
% Input:
%	p:	size of the transform, p is a prime.
%
% Output:
%	M:	best sequence of directions.
%		M = [a_0, a_1, ..., a_p;
%		     b_0, b_1, ..., b_p]
%
% See also:	FRAT, FRATF

p2 = floor(p/2);

% Construct the matrix of points (k, l) that belong to slices
% l = km in the Fourier domain, m is a direction.

k = [-p2:-1, 1:p2]';	% don't include point (k, l) = (0, 0)
m = [1:p-1];		% add horizontal and vertical slices later

K = k(:, ones(1, p-1));

% l = km
L = k * m;

% Centralize L mod p
L = L - p * round(L/p);

% Put in polar coordinate
P = K + i*L;

% Objective: Find the pair (k,l) for each slices that has
% minimum max(abs(k), abs(l)) and postive ANGLE
D = max(abs(K), abs(L));

% Eliminate points with negative angle
D(find(angle(P) < 0)) = NaN;

% In case of equal D favor min ABS(P) and min ABS(K)
epsilon = 1e-6;
[Y, I] = min(D + epsilon * abs(P) + epsilon^2 * abs(K));
% [Y, I] = min(D);

% Retrieve those points and put them in a set of directions
J = [0:p-2];
M = [K(I + (p-1)*J); L(I + (p-1)*J)];

% Add horizontal and vertical slices
M = [M, [1;0], [0;1]];

% Sort those directions in ascending order of angles
[Y, I] = sort(angle(M(1,:) + i*M(2,:)));

M = M(:,I);


%%% TO PLOT THE RESULT
% p = 7; M = bestdir(p);
% clf, line([zeros(1,p+1); M(1,:)], [zeros(1,p+1); M(2,:)]);
% axis equal, grid on
