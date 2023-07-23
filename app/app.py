import cv2
import numpy as np
from flask import Flask, request, jsonify
import base64
from processImage import color_based_segmentation
from flask_cors import CORS  # Import the CORS extension

app = Flask(__name__)
CORS(app)

@app.route('/process_image', methods=['POST'])
def process_image():
    # Get the JSON data from the request
    data = request.get_json()

    # Get the image data and target color from the JSON data
    image_data = data.get('imageData')
    target_color = data.get('targetColor')
    tolerance = data.get('tolerance')

    if not image_data or not target_color:
        return jsonify({'error': 'Missing image data or target color'}), 400

    # Perform color-based segmentation on the uploaded image
    masked_image, highlighted_shapes = color_based_segmentation(image_data, target_color,tolerance)

    # Encode the processed images to base64 strings
    _, mask_encoded = cv2.imencode('.png', (masked_image * 255).astype(np.uint8))
    mask_base64 = base64.b64encode(mask_encoded).decode('utf-8')

    _, highlighted_encoded = cv2.imencode('.png', (highlighted_shapes * 255).astype(np.uint8))
    highlighted_base64 = base64.b64encode(highlighted_encoded).decode('utf-8')

    return jsonify({
        'maskedImage': mask_base64,
        'highlightedShapes': highlighted_base64
    })

if __name__ == '__main__':
    app.run(debug=True)