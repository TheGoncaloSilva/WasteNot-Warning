from flask import Flask
import queries
app = Flask(__name__)

databaseInteraction = queries.DatabaseInteraction()


@app.route('/')
def hello_geek():
    return '<h1>Hello from Flask & Docker</h2>'

@app.route('/users')
def get_users():
    print(databaseInteraction.get_users())
    return databaseInteraction.get_users()


if __name__ == "__main__":
    app.run(debug=True)