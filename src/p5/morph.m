function out = morph(sourceImg, targetImg, sourceFeaturePositions, targetFeaturesPositions, timestep )
%MORPH Summary of this function goes here
%   @param sourceImg (M x N x 3) color image
%   @param targetImg (M x N x 3) color image
%   @param sourceFeaturePositions triangle indices
%   @param targetFeaturesPositions triangle indices
%   @param timestep
    
    % indices of fragments in source image
    sourceFragmentsIdxs = delaunay(sourceFeaturePositions(:,1),...
                                   sourceFeaturePositions(:,2));
    out = zeros(size(sourceImg,1),size(sourceImg,2),3);
    % foreach fragment: replace this loop by a reshape                        
    for fragIdx = 1:length(sourceFragmentsIdxs)
        % get indices of spanning vertices of fragIdx-th fragment
        fragmentIdxs = sourceFragmentsIdxs(fragIdx,:);
        
        % 1st row: all x coordinates, 2nd row all y coordinates
        % x_source_p1 x_source_p2 x_source_p3
        % y_source_p1 y_source_p2 y_source_p3
        % 1           1           1
        T_source = [sourceFeaturePositions(fragmentIdxs,:)'; ones(1,3)];
        T_target = [targetFeaturesPositions(fragmentIdxs,:)';ones(1,3)];
        
        % interpolated triangle: p_k = (1-t)a_k + t*b_k 
        T_p = (1-timestep)*T_source + timestep*T_target;
        T_p_source = T_source/T_p;
        T_p_target = T_target/T_p;
        
        % bounding box enclosing the current fragment
        boundingBox = getBoundingBoxAround(T_p);
        
        % masking pixel coordinates using the bounding box
        mask = rasterize(T_p(1:2,:),boundingBox);
        
        % select pixels in bounding box
        pixels = boundingBox .* repmat(mask,2,1);
        takenPixelsIdxs = pixels>0;
        numberOfMaskedPixels = sum(mask);
        pixels = reshape(pixels(takenPixelsIdxs),2, numberOfMaskedPixels);
        pixels(3,:) = ones(1, size(pixels, 2));
        
        % get interpolated positions of pixels used for interpolation
        % colors using alpha blending.
        sourcePixels = T_p_source*pixels;
        targetPixels = T_p_target*pixels;
        
        interpolSourceColors = getBilinearInterpolatedColors(sourceImg, sourcePixels);
        interpolTargetColors = getBilinearInterpolatedColors(targetImg, targetPixels);
        
        interpolatedColor = (1-timestep)*interpolSourceColors + timestep*interpolTargetColors;
        
        % fill image
        for k=1:length(pixels)
            out(pixels(2,k), pixels(1,k),:) = interpolatedColor(:,k);
        end
    end           
end