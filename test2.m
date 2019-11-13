%{
Examples with Orthogonal Matching Pursuit (OMP) 
and Compressive Sampling Matching Pursuit (CoSaMP)
Also verifies that the codes are working on your computer;
see OMP.m and CoSaMP.m
Stephen Becker, Aug 1 2011
  small update, Oct 7 2011 (add the "oracle" solution for comparison)
%}
% -- Decide if we want real or complex-valued data
COMPLEX = true;
% COMPLEX = false;
% -- Measurement matrix "A"
N   = 2^10;
M   = round(N/2);
randn('state',239234);
rand( 'state',239234);
A   = randn(M,N)/sqrt(M);
if COMPLEX, A =  (sqrt(M)*A + 1i*randn(M,N))/sqrt(2*M); end
% CoSaMP sometimes breaks down if the columns of M are highly correlated
% To see this effect, uncomment this line:
% rho = .9; M2  = floor(M/2); A(:, end -M2+1:end )  = rho*A(:,1:M2) + (1-rho)*randn(M,M2)/sqrt(M);
% (for rho = .9, this still works great with CoSaMP if it is noiseless,
%   but if you add a bit of noise, then it breaks down ).
% It is not necessary for "A" to have unit-normed columns,
%   but sometimes it helps. This line shows you what the column norms are:
 norms   = sqrt( sum( abs(A).^2 ) );
Af  = @(x) A*x;
At  = @(x) A'*x;
% -- Sparse signal "x"
K   = round(M/5);
T   = randperm(N);
T   = T(1:K);
x   = zeros(N,1);
x(T)= randn(K,1);
if COMPLEX, x(T) = x(T) + 1i*randn(K,1); end
errFcn      = @(a) norm(a-x)/norm(x);
clc;
%% Add some noise:
NOISE_LEVEL = 1;  % choose
b   = A*x;
randn('state',94350);
switch NOISE_LEVEL
    case 1
        sigma   = 0;              % noiseless
        disp('-------- Noiseless setting ----------');
    case 2
        sigma   = .3*norm(b)/sqrt(M); % noisy
        disp('-------- Noisy setting --------------');
    case 3
        sigma   = .9*norm(b)/sqrt(M); % extremely noisy
        disp('-------- Very noisy setting ---------');
end
z   = sigma*randn(M,1); if COMPLEX, z = (z + 1i*sigma*randn(M,1))/sqrt(2); end
b   = b + z;
% For the noisy cases, we can't expect perfect recovery,
% so we will compare to an "oracle" solution which uses
% knowledge of the true support.
x_oracle    = zeros(N,1);
x_oracle(T) = A(:,T)\b;     % if we know true support, then do least-squares
er_oracle   = norm(x_oracle-x)/norm(x);
fprintf('Oracle error is %.2e\n', norm(x_oracle-x)/norm(x) );
disp('-------------------------------------');
%% Test 1: OMP
% -- Choose the sparsity...
% K_target    = K;    % this is 'cheating' since "K" is typically unknown
% K_target    = 30;   % for extremely noisy case, this is better (or specify a residual)
%  ... or, specify a target residual. This is usually a better option,
%   especially when you have noisy data.  To tell the OMP code that we are
%   specifiying a residual, we wrap the number in cell brackets { }.
K_target    = { sigma*sqrt(M) };
%{
Explanation:
"slowMode": if this is true, then we can compute a valid
    estimate at *every iteration* (useful for plotting), but at the cost of 
    much slower computation as k grows.
%}
%for slowMode = 0:1
    disp(   '-----------------------------------------');
    if slowMode, fprintf('OMP, "slow/testing mode" ----------------\n\n');
    else, fprintf('OMP, "normal mode" ---------------------\n\n');
    end
    tic
    opts = [];
    opts.slowMode = 0;
    opts.printEvery     = 25;
    [xk] = OMP( A, b, K_target, errFcn,opts);
    toc
    fprintf('Error is %.2e\t(oracle error is %.2e)\n\n', norm(xk-x)/norm(x), er_oracle );
%end