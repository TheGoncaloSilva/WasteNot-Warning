from flask import Flask, request, make_response
from flask_cors import CORS
import queries
app = Flask(__name__)
CORS(app)

databaseInteraction = queries.DatabaseInteraction()


@app.route('/')
def hello_geek():
    return '<h1>Hello from Flask & Docker</h2>'

"""
Users
"""
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

@app.route('/user/last_events', methods=['GET'])
def get_last_user_events():
    user_id = request.args.get('user_id', type=int)
    nevents = request.args.get('nevents', type=int)
    
    return databaseInteraction.get_user_last_events(user_id,nevents)

@app.route('/user/restricted_areas_by_user', methods=['GET'])
def get_areas_restritas_by_user():
    user_id = request.args.get('user_id', type=int)
    
    return databaseInteraction.get_user_restricted_areas(user_id)

"""
Events
"""
@app.route('/events')
def get_events():
    return databaseInteraction.get_events()

@app.route('/events/get_events_count_by_category', methods=['GET'])
def get_events_count_by_category():
    
    return databaseInteraction.get_events_count_by_category()

@app.route('/events/get_number_of_events_in_excluded_time', methods=['GET'])
def get_number_of_events_in_excluded_time():
    return databaseInteraction.get_number_of_events_in_excluded_time()

@app.route('/events/get_number_of_events_in_maintenance', methods=['GET'])
def get_number_of_events_in_maintenance():
    return databaseInteraction.get_number_of_events_in_maintenance()

@app.route('/events/get_number_of_events_in_active_schedule', methods=['GET'])
def get_number_of_events_in_active_schedule():
    return databaseInteraction.get_number_of_events_in_active_schedule()

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)