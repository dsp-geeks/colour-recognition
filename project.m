% Step 1: Image Preprocessing
image = imread('./test01.jpg'); % Load the image
image = im2double(image); % Convert to double precision

% Step 2: Color-Based Segmentation
targetColor = [0, 1, 1]; % Red color (in RGB format)
tolerance = 0.3; % Tolerance value for color matching

reshapedImage = reshape(image, [], 3); % Reshape image to a 2D matrix (pixels x RGB channels)

% Find the indices of pixels within the tolerance range of the target color
distances = sqrt(sum((reshapedImage - targetColor).^2, 2));
mask = distances <= tolerance;


% Step 3: Image Segmentation
labeledImage = reshape(mask, size(image, 1), size(image, 2)); % Reshape back to original image size
labeledImage = logical(labeledImage); % Label connected components
regions = regionprops(labeledImage, 'Area', 'BoundingBox', 'Centroid');

% Step 4: Shape Analysis
minAreaThreshold = 100; % Minimum area to filter out small shapes
filteredRegions = regions([regions.Area] > minAreaThreshold); % Filter regions based on area

% Step 5: Mask the other regions
maskedImage = image; % Create a copy of the original image
maskedImage(repmat(~mask, [1, 1, size(image, 3)])) = 0; % Set non-red regions to zero


% Step 6: Highlight or Extract the Selected Shapes
highlightedShapes = insertShape(image, 'rectangle', cat(1, filteredRegions.BoundingBox), 'LineWidth', 50, 'Color', 'black');


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