function x = idwtc(a, d, LoF_R, HiF_R, lx)
% IDWTC	Same as IDWT for column-wise.

% Shift and Extension.
dwtATTR = dwtmode('get');
shift   = dwtATTR.shift1D;
dwtEXTM = dwtATTR.extMode;

flagPer = isequal(dwtEXTM, 'per');

% Reconstructed Approximation.
x = upsaconvc(a, LoF_R, lx, shift, dwtEXTM, flagPer)+ ...   % Approximation.
    upsaconvc(d, HiF_R, lx, shift, dwtEXTM, flagPer);       % Detail.


%----------------------------------------------------------------------------%
% Internal Function(s)
%----------------------------------------------------------------------------%
function y = upsaconvc(x, f, l, shift, dwtEXTM, flagPer)
% Upsample and convolution column-wise.

% Compute sizes.
[lx, kx] = size(x);
lf = length(f);

if flagPer
    lm  = floor((lf - 1) / 2);
    I   = [1:lx , 1:lm];
    if lf > 2*lx
	I  = mod(I, lx);
	I(I==0) = lx;
    end
    x = x(I, :);
end

y = wconv('c', dyadup(x, 0, 'r'), f);

shift = mod(shift, 2);

if flagPer
    y = wkeep(y, [l, kx], 'c');    
    if shift ~= 0
	y = wshift('2d', y, [shift, 0]); 
    end 
else
    y = wkeep(y, [l, kx], 'c', [shift, 1]);
end
%----------------------------------------------------------------------------%
