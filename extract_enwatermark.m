function [ EW ] = extract_enwatermark( Sp, D, alfa )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

EW = D - Sp.S;
EW = EW./alfa;

end

