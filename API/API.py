from flask import Flask, jsonify, make_response, request
from flasgger import Swagger
import ssl
import mssql_functions as MSSql

app = Flask(__name__)
Swagger(app, template={
    "info": {
        "title": "API TC2007B",
        "description": "REST API for TC2007B Course",
        "version": "1.0.0"
    }
})

# Database connection parameters
mssql_params = {
    'DB_HOST': '100.80.80.1',
    'DB_NAME': 'iborregos',
    'DB_USER': 'SA',
    'DB_PASSWORD': 'Shakira123.'
}

# Establish database connection
try:
    MSSql.cnx = MSSql.mssql_connect(mssql_params)
except Exception as e:
    print("Cannot connect to MSSQL server:", e)
    exit()

#Obtener lista de evento
@app.route("/all-events", methods=['GET'])
def get_all_events():
    """
   Obtener todos los eventos disponibles en la base de datos
    ---
    responses:
      200:
        description: Retornar todos los eventos disponibles
        content:
          application/json:
            schema:
              type: array
              items:
                type: object
                properties:
                  id:
                    type: integer
                    description: ID de evento
                  name:
                    type: string
                    description: Nombre del evento
                  description:
                    type: string
                    description: Descripcion del evento
      404:
        description: Descripcion del evento
      500:
        description: Error del servidor
    """
    try:
        event_data = MSSql.sql_read_all('Eventos')
        if event_data:
            return make_response(jsonify(event_data)), 200
        else:
            return jsonify({"error": "No se encontraron eventos"}), 404
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# Obtener información del usuario por su ID
@app.route("/usuario/<int:usuario_id>", methods=['GET'])
def get_usuario_id(usuario_id):
    """
    Retrieve user information by user ID.
    ---
    parameters:
      - name: usuario_id
        in: path
        type: integer
        required: true
        description: The ID of the user to retrieve
    responses:
      200:
        description: Returns user data as JSON
        content:
          application/json:
            schema:
              type: object
              properties:
		A_MATERNO:
		  type: string
		  description: The user's second family name
		A_PATERNO:
		  type: string
		  description: The user's last name
		CONTRAENA:
		  type: string
		  descritpion: The user's password
		EMAIL:
		  type: string
		  description: The user's email
		ID_TIPO_USUARIO:
		  type: integer
		  description: The user type
		ID_USUARIO:
		  type: integer
		  description: The user's unique identifier
		NOMBRE:
		  type: string
		  description: The user's name
      404:
        description: Event not found
      500:
        description: Server error
    """
    event_data = MSSql.sql_read_where('USUARIOS', {'ID_USUARIO': usuario_id})
    if event_data:
        return make_response(jsonify(event_data)), 200
    else:
        return jsonify({"error": "Event not found"}), 404

# Obtener datos del usuario por su correo
@app.route("/usuario/<string:email>", methods=['GET'])
def get_usuario_by_email(email):
    """
    Retrieve user information by user ID.
    ---
    parameters:
      - name: email
        in: path
        type: string
        required: true
        description: The email of the user to retrieve
    responses:
      200:
        description: Returns user data as JSON
        content:
          application/json:
            schema:
              type: object
              properties:
		A_MATERNO:
		  type: string
		  description: The user's second family name
		A_PATERNO:
		  type: string
		  description: The user's last name
		CONTRAENA:
		  type: string
		  descritpion: The user's password
		EMAIL:
		  type: string
		  description: The user's email
		ID_TIPO_USUARIO:
		  type: integer
		  description: The user type
		ID_USUARIO:
		  type: integer
		  description: The user's unique identifier
		NOMBRE:
		  type: string
		  description: The user's name
      404:
        description: Event not found
      500:
        description: Server error
    """
    event_data = MSSql.sql_read_where('USUARIOS', {'EMAIL': email})
    if event_data:
        return make_response(jsonify(event_data)), 200
    else:
        return jsonify({"error": "Event not found"}), 404

# Obtener lista de beneficios
@app.route("/all-benefits", methods=['GET'])
def get_all_benefits():
    """
   Obtener todos los eventos disponibles en la base de datos
    ---
    responses:
      200:
        description: Retornar todos los eventos disponibles
        content:
          application/json:
            schema:
              type: array
              items:
                type: object
                properties:
                  id:
                    type: integer
                    description: ID de evento
                  name:
                    type: string
                    description: Nombre del evento
                  description:
                    type: string
                    description: Descripcion del evento
      404:
        description: Descripcion del evento
      500:
        description: Error del servidor
    """
    try:
        event_data = MSSql.sql_read_all('Beneficios')
        if event_data:
            return make_response(jsonify(event_data)), 200
        else:
            return jsonify({"error": "No se encontraron eventos"}), 404
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    # SSL context setup
    import ssl
    context = ssl.SSLContext(ssl.PROTOCOL_TLSv1_2)
    context.load_cert_chain('/home/user01/mntleo/api_https/SSL/a00835641.tc2007b.tec.mx.cer',
                            '/home/user01/mntleo/api_https/SSL/a00835641.tc2007b.tec.mx.key')
    app.run(host='0.0.0.0', port=10201, ssl_context=context, debug=True)
