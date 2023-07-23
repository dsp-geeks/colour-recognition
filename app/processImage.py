import cv2
import numpy as np
import base64


def color_based_segmentation(image_data, target_color, tolerance, min_area_threshold=100):
    # Step 1: Image Preprocessing
   # Decode the base64-encoded image data
    image = base64.b64decode(image_data)
    nparr = np.frombuffer(image, np.uint8)
    image = cv2.imdecode(nparr, cv2.IMREAD_COLOR) / 255.0

    # Step 2: Color-Based Segmentation
    reshaped_image = image.reshape(-1, 3)  # Reshape image to a 2D matrix (pixels x RGB channels)

    # Find the Euclidean distances between each pixel's color and the target color
    distances = np.linalg.norm(reshaped_image - target_color[::-1], axis=1)
    mask = distances <= tolerance  # Mask the pixels within the tolerance range
    mask = mask.reshape(image.shape[:2])  # Reshape back to the original image size

    # Step 3: Image Segmentation using connectedComponentsWithStats
    num_labels, labeled_image, stats, centroids = cv2.connectedComponentsWithStats(mask.astype(np.uint8))

    # Step 4: Shape Analysis
    filtered_regions = []
    for label in range(1, num_labels):  # Skip the background label (0)
        area = stats[label, cv2.CC_STAT_AREA]
        if area > min_area_threshold:
            filtered_regions.append(label)

    # Step 5: Mask the other regions
    masked_image = np.copy(image)  # Create a copy of the original image
    masked_image[~mask] = 0  # Set non-red regions to zero

    # Step 6: Draw boundary boxes around filtered regions with different colors
    highlighted_shapes = np.copy(image)  # Initialize an array for the highlighted shapes
    for label in filtered_regions:
        minr, minc, maxr, maxc = stats[label, cv2.CC_STAT_TOP], stats[label, cv2.CC_STAT_LEFT], \
                                 stats[label, cv2.CC_STAT_HEIGHT] + stats[label, cv2.CC_STAT_TOP], \
                                 stats[label, cv2.CC_STAT_WIDTH] + stats[label, cv2.CC_STAT_LEFT]
        color = (255, 255, 255)  # Set the boundary box color to blue (you can change this to any color)
        cv2.rectangle(highlighted_shapes, (minc, minr), (maxc, maxr), color, 20)  # Draw boundary box

    return masked_image, highlighted_shapes

