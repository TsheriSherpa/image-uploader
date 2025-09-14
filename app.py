from flask import Flask, request, render_template
import boto3, os
from werkzeug.utils import secure_filename

app = Flask(__name__)

# AWS S3 config
S3_BUCKET = os.environ.get("S3_BUCKET")
s3 = boto3.client("s3")

@app.route("/", methods=["GET", "POST"])
def upload():
    if request.method == "POST":
        if "file" not in request.files:
            return "No file part"
        file = request.files["file"]
        if file.filename == "":
            return "No selected file"
        
        filename = secure_filename(file.filename)
        s3.upload_fileobj(file, S3_BUCKET, filename)
        return f"Uploaded {filename} to S3!"
    return render_template("index.html")


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)