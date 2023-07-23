from flask import Flask, request, jsonify
import matlab.engine

app = Flask(__name__)

# Start the MATLAB Engine
eng = matlab.engine.start_matlab()

# Define the route to handle the colorBasedSegmentation request
@app.route('/colorBasedSegmentation', methods=['POST'])
def color_based_segmentation():
    try:
        # Get input parameters from the JSON data sent by the client
        data = request.get_json()
        imageData = data['imageData']
        targetColor = data['targetColor']

        # Call the MATLAB function
        maskedImage, highlightedShapes = eng.colorBasedSegmentation(imageData, targetColor)

        # Close the MATLAB Engine (you can also keep it open if you expect frequent requests)
        # eng.quit()

        # Return the results as JSON responses
        response = {
            'maskedImage': maskedImage,
            'highlightedShapes': highlightedShapes
        }
        return jsonify(response)
    except Exception as e:
        return jsonify({'error': str(e)}), 400

if __name__ == '__main__':
    app.run()
