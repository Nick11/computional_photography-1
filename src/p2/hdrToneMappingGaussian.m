function [ out ] = hdrToneMappingGaussian(hdrImg, output_range )
%HDRTONEMAPPINGGAUSSIAN Summary of this function goes here
%   Detailed explanation goes here

    eps = 0.0001;
    R = hdrImg(:,:,1);
    G = hdrImg(:,:,2);
    B = hdrImg(:,:,3);
    
    intensities = (R*20 + G*40 + B)/61;
    intensities = max(intensities, eps);
    
    r = (R ./ intensities);
    g = (G ./ intensities);
    b = (B ./ intensities);
    
    log_intensities = log(intensities);
    
    log_base = imfilter(log_intensities, fspecial('gaussian', 21, 8));
    log_detail = log_intensities - log_base;
    
    compressionF = log(output_range)/(max(log_base(:))-min(log_base(:)));
    log_offset = -max(log_base(:))*compressionF;
    
    log_output_intensitiy = log_base*compressionF + log_offset+log_detail;
    
    R_output = r .* exp(log_output_intensitiy);
    G_output = g .* exp(log_output_intensitiy);
    B_output = b .* exp(log_output_intensitiy);
    
       
    out = mat2Img(R_output, G_output, B_output );
end

