% Step 1: Image Preprocessing
image = imread('../../../Desktop/FOLDERS/SCHOOL/FINAL YEAR/2ND SEMESTER/DSP/PROJECT/test01.jpg'); % Load the image
image = im2double(image); % Convert to double precision
hsvImage = rgb2hsv(image); % Convert to HSV color space

% Step 2: Color Thresholding
colorName = input('Enter the color name: ', 's'); % Prompt the user to enter the color name
selectedColorRGB = colournames('natural', colorName); % Get the RGB values of the selected color
selectedColorHSV = rgb2hsv(selectedColorRGB); % Convert the selected color to HSV
hueThreshold = [selectedColorHSV(1) - 0.05, selectedColorHSV(1) + 0.05]; % Hue range around the selected color
saturationThreshold = [selectedColorHSV(2) - 0.2, selectedColorHSV(2) + 0.2]; % Saturation range around the selected color
valueThreshold = [selectedColorHSV(3) - 0.2, selectedColorHSV(3) + 0.2]; % Value range around the selected color

redMask = (hsvImage(:,:,1) >= hueThreshold(1) & hsvImage(:,:,1) <= hueThreshold(2)) ...
    & (hsvImage(:,:,2) >= saturationThreshold(1) & hsvImage(:,:,2) <= saturationThreshold(2)) ...
    & (hsvImage(:,:,3) >= valueThreshold(1) & hsvImage(:,:,3) <= valueThreshold(2));

% Step 3: Image Segmentation
labeledImage = logical(redMask); % Label connected components
regions = regionprops(labeledImage, 'Area', 'BoundingBox', 'Centroid');

% Step 4: Shape Analysis
minAreaThreshold = 100; % Minimum area to filter out small shapes
filteredRegions = regions([regions.Area] > minAreaThreshold); % Filter regions based on area

% Step 5: Highlight or Extract the Selected Shapes
highlightedShapes = insertShape(image, 'rectangle', cat(1, filteredRegions.BoundingBox), 'LineWidth', 2, 'Color', 'white');

% Display the original image and the highlighted shapes
figure;
subplot(1, 2, 1);
imshow(image);
title('Original Image');
subplot(1, 2, 2);
imshow(highlightedShapes);
title('Highlighted Shapes');
