function [out] = demosaicBayer(img)
%DEMOSAICBAYER Summary of this function goes here
%   Detailed explanation goes here
    
    % get bayer color channel masks from given image dimensions
    [m, n] = size(img);
    [red_mask, green_mask, blue_mask] = getMasks(m,n);

    % get color contribution
    red_contribution = img.*red_mask;
    green_contribution = img.*green_mask;
    blue_contribution = img.*blue_mask;

    I3x3 = ones(3);
    interpolated_red_contribution = conv2(red_contribution, I3x3, 'same');
    interpolated_green_contribution = conv2(green_contribution, I3x3, 'same');
    interpolated_blue_contribution = conv2(blue_contribution, I3x3, 'same');

    % normalized color according to their neighborhood.
    norm_red = interpolated_red_contribution ./ conv2(red_mask, I3x3, 'same');
    norm_green = interpolated_green_contribution ./ conv2(green_mask, I3x3, 'same');
    norm_blue = interpolated_blue_contribution ./ conv2(blue_mask, I3x3, 'same');
    
    % color contribution of final channels.
    red_channel = (norm_red.* ~red_mask) + red_contribution;
    green_channel = (norm_green.* ~green_mask) + green_contribution;
    blue_channel = (norm_blue.* ~blue_mask) + blue_contribution;

    color_pile = [red_channel green_channel blue_channel ];

    out = reshape(color_pile,m,n,3);
end

