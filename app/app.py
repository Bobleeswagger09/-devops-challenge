from flask import Flask

app = Flask(__name__)

@app.route('/')
def home():
    return '''
    <html>
        <body style="font-family: Arial; text-align: center; padding: 50px;">
            <h1>🚀 DevOps Challenge App</h1>
            <p>Deployed by Victor Samuel</p>
            <p>Running on AWS EC2 with Docker</p>
        </body>
    </html>
    '''

@app.route('/health')
def health():
    return {"status": "healthy"}, 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
