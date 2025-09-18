# app/routes.py
from flask import Blueprint, jsonify, request

# Create a blueprint
bp = Blueprint('main', __name__)

# Simple health check endpoint
@bp.route('/ping', methods=['GET'])
def ping():
    return jsonify({'message': 'pong'}), 200

# Example: upload endpoint
@bp.route('/upload', methods=['POST'])
def upload_file():
    if 'file' not in request.files:
        return jsonify({'error': 'No file part'}), 400

    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No selected file'}), 400

    # Here you would save the file or process it
    # e.g., file.save(os.path.join(UPLOAD_FOLDER, file.filename))

    return jsonify({'message': f'File {file.filename} uploaded successfully!'}), 201
