% Step 1: Image Preprocessing
image = imread('../../../Desktop/FOLDERS/SCHOOL/FINAL YEAR/2ND SEMESTER/DSP/PROJECT/test01.jpg'); % Load the image
image = im2double(image); % Convert to double precision
hsvImage = rgb2hsv(image); % Convert to HSV color space


% Step 2: Color Thresholding
colorName = input('Enter color name: ', 's'); % Prompt user for color name

% Convert color name to HSV thresholds
[hueThreshold, saturationThreshold, valueThreshold] = colorNameToThresholds(colorName);

% Check if the color name is valid
if isempty(hueThreshold) || isempty(saturationThreshold) || isempty(valueThreshold)
    error('Invalid color name.');
end

mask = (hsvImage(:,:,1) >= hueThreshold(1) & hsvImage(:,:,1) <= hueThreshold(2)) ...
    & (hsvImage(:,:,2) >= saturationThreshold(1) & hsvImage(:,:,2) <= saturationThreshold(2)) ...
    & (hsvImage(:,:,3) >= valueThreshold(1) & hsvImage(:,:,3) <= valueThreshold(2));

% Step 3: Image Segmentation
labeledImage = logical(mask); % Label connected components
regions = regionprops(labeledImage, 'Area', 'BoundingBox', 'Centroid');

% Step 4: Shape Analysis
minAreaThreshold = 100; % Minimum area to filter out small shapes
filteredRegions = regions([regions.Area] > minAreaThreshold); % Filter regions based on area

% Step 5: Mask the other regions
maskedImage = image; % Create a copy of the original image
maskedImage(repmat(~mask, [1, 1, size(image, 3)])) = 0; % Set non-red regions to zero

% Step 6: Highlight or Extract the Selected Shapes
highlightedShapes = insertShape(image, 'rectangle', cat(1, filteredRegions.BoundingBox), 'LineWidth', 3, 'Color', 'white');

% Display the original image, the masked image, and the highlighted shapes
figure;
subplot(1, 3, 1);
imshow(image);
title('Original Image');
subplot(1, 3, 2);
imshow(maskedImage);
title('Masked Image');
subplot(1, 3, 3);
imshow(highlightedShapes);
title('Highlighted Shapes');