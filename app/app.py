from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/')
def home():
    return '''
    <html>
        <body style="font-family: Arial; text-align: center; padding: 50px; background: #f4f4f4;">
            <h1 style="color: #1F4E79;">DevOps Challenge App</h1>
            <p style="font-size: 18px;">Deployed by <strong>Victor Samuel</strong></p>
            <p>Running on AWS EC2 with Docker</p>
            <p>CI/CD powered by GitHub Actions</p>
            <a href="/api/v1/status" style="color: #2E74B5;">Check API Status</a>
        </body>
    </html>
    '''

@app.route('/health')
def health():
    return jsonify({"status": "healthy"}), 200

@app.route('/api/v1/status')
def status():
    return jsonify({
        "service": "devops-challenge-api",
        "version": "1.0.0",
        "environment": "production",
        "status": "running"
    }), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
