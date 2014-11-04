function [ out ] = highlightRemovalGammaCompression(target, mask, alpha, beta)
%HIGHLIGHTREMOVAL remove highlights in a given target image by applying
%gamma compression on the gradients of the target image.
%   @param target image that contains a certain spot/area
%          which is supposed to be too bright (e.g. specular spot).
%          this spot is windowed by the mask and its brightness is adjusted
%          by applying alpha compression.
%   @param mask determines the boundary for the unknown pixels which should
%          be solved for using our poisson solver.
%   @param alpha real number determing the compression factor used for
%          gamma compression.
%   @param beta real number determing the compression factor used for
%          gamma compression.
%   @return out image with adjusted brightness.
%   Detailed explanation goes here

    gradField = img2gradfield(target);
    

    dotProdOfGradField = (gradField(:,:,1,:).^2 + gradField(:,:,2,:).^2);
    
    % gradients can be negative valued. When taking the power to a rational
    % number the result may become complex valued. thus take only their real part.
    % take the maximum between dotProdOfGradField and 1E-30 since
    % (0^-something) will result in NaN.
    averageGradFieldNormScaled = (alpha^beta)*real(max(dotProdOfGradField, 1E-30).^(-0.5*beta));
    
    % reasign the gradient field
    gradField(:,:,1,:) = averageGradFieldNormScaled(:,:,1,:) .* gradField(:,:,1,:);
    gradField(:,:,2,:) = averageGradFieldNormScaled(:,:,1,:) .* gradField(:,:,2,:);

    M = size(target,1); N = size(target,2);
    figureText = 'Gamma Compression: dx (left) and dy (right) of gradient taken from target';
    showGradientFieldImgs(gradField, figureText, M, N); 
    
    out = zeros(M,N,3);
    tic
    parfor k=1:3
        out(:,:,k) = poissonSolver(target(:,:,k), gradField(:,:,:,k), mask(:,:,k));
    end
    toc
    out = mat2Img(out(:,:,1),out(:,:,2),out(:,:,3));

end

