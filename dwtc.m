function [a, d] = dwtc(x, LoF_D, HiF_D)
% DWTC 	Same as DWT for column-wise.

% Shift and Extension.
dwtATTR = dwtmode('get');
shift   = dwtATTR.shift1D;
dwtEXTM = dwtATTR.extMode;

% Compute sizes.
[lx, kx] = size(x);
lf = length(LoF_D);

% Extend, Decompose &  Extract coefficients.
flagPer = isequal(dwtEXTM, 'per');
y = wextend('2D', dwtEXTM, x, lf-1, ['b', 'n']);
a = convdownc(y, LoF_D, lx, kx, lf, shift, flagPer);
d = convdownc(y, HiF_D, lx, kx, lf, shift, flagPer);


%----------------------------------------------------------------------------%
% Internal Function(s)
%----------------------------------------------------------------------------%
function y = convdownc(x, f, lx, kx, lf, shift, flagPer)
% Convolution and downsample column-wise.

y = wconv('c', x, f);
y = wkeep(y, [lx+lf-1, kx]);
y = dyaddown(y, 'r', shift);
if flagPer , y = wkeep(y, [ceil(lx/2),kx], [1,1]); end
%----------------------------------------------------------------------------%