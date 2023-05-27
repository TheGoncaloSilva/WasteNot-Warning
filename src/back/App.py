from flask import Flask
from flask_cors import CORS
import queries
app = Flask(__name__)
CORS(app)

databaseInteraction = queries.DatabaseInteraction()


@app.route('/')
def hello_geek():
    return '<h1>Hello from Flask & Docker</h2>'

@app.route('/users')
def get_users():
    return databaseInteraction.get_users()


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)