from flask import Flask, request, make_response, jsonify
from flask_cors import CORS
from flask_jwt_extended import JWTManager,create_access_token, jwt_required, get_jwt_identity
import security

import queries
import os
import json

db_reset_flag = os.environ.get('DB_RESET_FLAG')


RESET_DB = False
if db_reset_flag and db_reset_flag.lower() == "true":
    RESET_DB = True


app = Flask(__name__)
app.config['JWT_SECRET_KEY'] = 'super_secret_key'
jwt = JWTManager(app)
CORS(app)

databaseInteraction = queries.DatabaseInteraction(RESET_DB)

@app.route('/login', methods=['POST'])
def login():
    telefone = request.json.get('telefone')
    password = request.json.get('password')
    
    users = databaseInteraction.get_user(telefone)
    
    if len(users) == 0:
        return jsonify({'message': 'Invalid credentials'}), 401
    else:
        user = users[0]
        hash = security.find_hash(password, user["Salt"])

        if hash == user["PW_Hash"]:
            access_token = create_access_token(identity=telefone)
            return jsonify({'access_token': access_token}), 200
        
        else:
            return jsonify({'message': 'Invalid credentials'}), 401
        
    
    

@app.route('/')
def hello_geek():
    return '<h1>Hello from Flask & Docker</h2>'

"""
Users
"""
@app.route('/users')
@jwt_required()
def get_users():
    return databaseInteraction.get_users()

@app.route('/users', methods=['POST'])
@jwt_required()
def add_user():
    user_data = request.get_json()
    
    salt = security.generate_salt()
    
    pw_hash = security.find_hash(
        user_data["Password"],
        salt
    )
    
    databaseInteraction.add_user(user_data["DataNascimento"],user_data["NivelPermissao_Nivel"],user_data["Nome"],pw_hash,salt,int(user_data["Telefone"]))
    return user_data

@app.route('/users/<int:user_id>', methods=['DELETE'])
@jwt_required()
def delete_user(user_id):
    databaseInteraction.remove_user(user_id)
    response = make_response()
    response.status_code = 200
    return response

@app.route('/user/last_events', methods=['GET'])
@jwt_required()
def get_last_user_events():
    user_id = request.args.get('user_id', type=int)
    nevents = request.args.get('nevents', type=int)
    
    return databaseInteraction.get_user_last_events(user_id,nevents)

@app.route('/user/restricted_areas_by_user', methods=['GET'])
@jwt_required()
def get_areas_restritas_by_user():
    user_id = request.args.get('user_id', type=int)
    
    return databaseInteraction.get_user_restricted_areas(user_id)

"""
Events
"""
@app.route('/events')
@jwt_required()
def get_events():
    return databaseInteraction.get_events()

@app.route('/events/get_events_count_by_category', methods=['GET'])
@jwt_required()
def get_events_count_by_category():
    
    return databaseInteraction.get_events_count_by_category()

@app.route('/events/get_number_of_events_in_excluded_time', methods=['GET'])
@jwt_required()
def get_number_of_events_in_excluded_time():
    return databaseInteraction.get_number_of_events_in_excluded_time()

@app.route('/events/get_number_of_events_in_maintenance', methods=['GET'])
@jwt_required()
def get_number_of_events_in_maintenance():
    return databaseInteraction.get_number_of_events_in_maintenance()

@app.route('/events/get_number_of_events_in_active_schedule', methods=['GET'])
@jwt_required()
def get_number_of_events_in_active_schedule():
    return databaseInteraction.get_number_of_events_in_active_schedule()

@app.route('/events/get_next_maintenance', methods=['GET'])
@jwt_required()
def get_next_maintenance():
    return databaseInteraction.get_next_maintenance()

@app.route('/restricted-areas', methods=['GET'])
@jwt_required()
def get_restricted_areas():
    return databaseInteraction.get_restricted_areas()

@app.route('/restricted-area/last-repairs', methods=['GET'])
@jwt_required()
def get_last_repairs():
    raid = request.args.get('restricted_area', type=int)
    mrow = request.args.get('maxrows', type=int)
    return databaseInteraction.get_last_repairs_of_a_restricted_area(raid,mrow)

@app.route('/restricted-area/devices', methods=['GET'])
@jwt_required()
def get_device_list_by_restricted_area():
    raid = request.args.get('restricted_area', type=int)
    return databaseInteraction.get_device_list_of_a_restricted_area(raid)


@app.route('/restricted-area/horario', methods=['GET'])
@jwt_required()
def get_horario_by_restricted_area():
    raid = request.args.get('restricted_area', type=int)
    #return databaseInteraction.get_horarios_monitorizacao_by_restricted_area(raid)
    obj = databaseInteraction.get_horarios_monitorizacao_by_restricted_area(raid)
    serialized_object = json.dumps(obj, default=str)
    return serialized_object


@app.route('/events/get_number_of_events', methods=['GET'])
@jwt_required()
def get_number_of_events():
    return databaseInteraction.get_number_of_events()

@app.route('/events/get_number_of_areas', methods=['GET'])
@jwt_required()
def get_number_of_areas():
    return databaseInteraction.get_number_of_areas()

@app.route('/events/get_number_of_devices', methods=['GET'])
@jwt_required()
def get_number_of_devices():
    return databaseInteraction.get_number_of_devices()

@app.route('/events/list_events', methods=['GET'])
@jwt_required()
def list_events():
    return databaseInteraction.list_events()

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)