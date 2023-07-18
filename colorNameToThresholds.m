function [hueThreshold, saturationThreshold, valueThreshold] = colorNameToThresholds(colorName)
    % Convert color name to HSV thresholds
    
    colorName = lower(colorName); % Convert color name to lowercase for case-insensitive comparison
    
    switch colorName
        case 'red'
            hueThreshold = [0, 0.05];
            saturationThreshold = [0.6, 1];
            valueThreshold = [0.6, 1];
        case 'green'
            hueThreshold = [0.25, 0.4];
            saturationThreshold = [0.6, 1];
            valueThreshold = [0.6, 1];
        case 'blue'
            hueThreshold = [0.55, 0.7];
            saturationThreshold = [0.6, 1];
            valueThreshold = [0.6, 1];
        case 'yellow'
            hueThreshold = [0.11, 0.17];
            saturationThreshold = [0.6, 1];
            valueThreshold = [0.6, 1];
        case 'orange'
            hueThreshold = [0.05, 0.11];
            saturationThreshold = [0.6, 1];
            valueThreshold = [0.6, 1];
        case 'purple'
            hueThreshold = [0.7, 0.8];
            saturationThreshold = [0.6, 1];
            valueThreshold = [0.6, 1];
        otherwise
            hueThreshold = [];
            saturationThreshold = [];
            valueThreshold = [];
    end
end
