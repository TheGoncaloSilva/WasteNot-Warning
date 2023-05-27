from flask import Flask, request, make_response
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

@app.route('/users', methods=['POST'])
def add_user():
    # Retrieve the data from the request body
    user_data = request.get_json()
    databaseInteraction.add_user(user_data["DataNascimento"],user_data["NivelPermissao_Nivel"],user_data["Nome"],user_data["Password"],int(user_data["Telefone"]))
    return user_data

@app.route('/users/<int:user_id>', methods=['DELETE'])
def delete_user(user_id):
    databaseInteraction.remove_user(user_id)
    response = make_response()
    response.status_code = 200
    return response

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)