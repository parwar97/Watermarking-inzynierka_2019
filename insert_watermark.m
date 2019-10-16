function [ S ] = insert_watermark( S,watermark, alfa )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

S = S+alfa.*watermark;

end

