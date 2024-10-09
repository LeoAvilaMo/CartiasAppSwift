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
    'DB_HOST': '100.80.80.7',
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

# Obtener un evento
@app.route("/event/<int:event_id>", methods=['GET'])
def get_event(event_id):
    """
    Retrieve event information by event ID.
    ---
    parameters:
      - name: event_id
        in: path
        type: integer
        required: true
        description: The ID of the event to retrieve
    responses:
      200:
        description: Returns event data as JSON
        content:
          application/json:
            schema:
              type: object
              properties:
                id:
                  type: integer
                  description: The event ID
                name:
                  type: string
                  description: Name of the event
                description:
                  type: string
                  description: Description of the event
      404:
        description: Event not found
      500:
        description: Server error
    """
    event_data = MSSql.sql_read_where('EVENTOS', {'ID_EVENTO': event_id})
    if event_data:
        return make_response(jsonify(event_data)), 200
    else:
        return jsonify({"error": "Event not found"}), 404

# Obtener lista de eventos
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
        description: No se encontraron eventos
      500:
        description: Error del servidor
    """
    try:
        event_data = MSSql.sql_read_all('EVENTOS')
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
                CONTRASENA:
                  type: string
                  description: The user's password
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
        description: User not found
      500:
        description: Server error
    """
    user_data = MSSql.sql_read_where('USUARIOS', {'ID_USUARIO': usuario_id})
    if user_data:
        return make_response(jsonify(user_data)), 200
    else:
        return jsonify({"error": "User not found"}), 404

# Obtener información del usuario por su correo
@app.route("/usuario/<string:email>", methods=['GET'])
def get_usuario_by_email(email):
    """
    Retrieve user information by email.
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
                CONTRASENA:
                  type: string
                  description: The user's password
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
        description: User not found
      500:
        description: Server error
    """
    user_data = MSSql.sql_read_where('USUARIOS', {'EMAIL': email})
    if user_data:
        return make_response(jsonify(user_data)), 200
    else:
        return jsonify({"error": "User not found"}), 404

# Obtener lista de beneficios
@app.route("/all-benefits", methods=['GET'])
def get_all_benefits():
    """
    Obtener todos los beneficios disponibles en la base de datos
    ---
    responses:
      200:
        description: Retornar todos los beneficios disponibles
        content:
          application/json:
            schema:
              type: array
              items:
                type: object
                properties:
                  id:
                    type: integer
                    description: ID de beneficio
                  name:
                    type: string
                    description: Nombre del beneficio
                  description:
                    type: string
                    description: Descripcion del beneficio
      404:
        description: No se encontraron beneficios
      500:
        description: Error del servidor
    """
    try:
        benefit_data = MSSql.sql_read_all('BENEFICIOS')
        if benefit_data:
            return make_response(jsonify(benefit_data)), 200
        else:
            return jsonify({"error": "No se encontraron beneficios"}), 404
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# Obtener detalles de un beneficio
@app.route("/beneficio/<int:beneficio_id>", methods=['GET'])
def obtener_detalle_beneficio(beneficio_id):
    """
    Obtener los detalles de un beneficio.
    ---
    parameters:
      - name: beneficio_id
        in: path
        type: integer
        required: true
        description: El ID del beneficio a obtener
    responses:
      200:
        description: Detalles del beneficio
        content:
          application/json:
            schema:
              type: object
              properties:
                ID_BENEFICIO:
                  type: integer
                  description: El ID del beneficio
                NOMBRE:
                  type: string
                  description: El nombre del beneficio
                DESCRIPCION:
                  type: string
                  description: La descripción del beneficio
      404:
        description: Beneficio no encontrado
      500:
        description: Error en el servidor
    """
    benefit_data = MSSql.sql_read_where('BENEFICIOS', {'ID_BENEFICIO': beneficio_id})
    if benefit_data:
        return make_response(jsonify(benefit_data)), 200
    else:
        return jsonify({"error": "Beneficio no encontrado"}), 404

# LOGIN MIO
# @app.route("/login", methods=['POST'])
# def login():
#     """
#     Look for a user's password in the database to log in to the app.
#     ---
#     tags:
#       - User Authentication
#     consumes:
#       - application/json
#     parameters:
#       - in: body
#         name: user_credentials
#         description: The email and password of the user
#         required: true
#         schema:
#           type: object
#           required:
#             - usuario_email
#             - usuario_contrasena
#           properties:
#             usuario_email:
#               type: string
#               description: The email of the user
#             usuario_contrasena:
#               type: string
#               description: The password of the user
#     responses:
#       200:
#         description: Returns a boolean whether the passwords match or not.
#         content:
#           application/json:
#             schema:
#               type: object
#               properties:
#                 login:
#                   type: boolean
#                   description: Whether the password matched or didn't
#       404:
#         description: No record found for this user email.
#       500:
#         description: Server error.
#     """
#     data = request.json
#     usuario_email = data.get('usuario_email')
#     usuario_contrasena = data.get('usuario_contrasena')
    
#     hashed_password = hashlib.sha256(usuario_contrasena.encode()).hexdigest()

#     # Dummy check (Replace with actual database check)
#     if usuario_email == "example@email.com" and usuario_contrasena == "correctpassword":
#         return jsonify(login=True), 200
#     else:
#         return jsonify(login=False), 404  # Assuming not found, though this should be 401 for unauthorized
    
# Check user attendance for an event
@app.route("/get-attendance-events/<int:usuario_id>/<int:evento_id>", methods=['GET'])
def check_attendance(usuario_id, evento_id):
    """
    Check if a user attended a specific event.
    ---
    parameters:
      - name: usuario_id
        in: path
        type: integer
        required: true
        description: The ID of the user
      - name: evento_id
        in: path
        type: integer
        required: true
        description: The ID of the event
    responses:
      200:
        description: Returns attendance status (asistio) as JSON
        content:
          application/json:
            schema:
              type: object
              properties:
                asistio:
                  type: integer
                  description: Attendance status (1 for attended, 0 for not attended)
      404:
        description: No record found for this user and event combination
      500:
        description: Server error
    """
    try:
        # Query the attendance status based on usuario_id and evento_id
        attendance_data = MSSql.sql_read_where('USUARIOS_EVENTOS', {
            'USUARIO': usuario_id,
            'EVENTO': evento_id
        })

        if attendance_data and len(attendance_data) > 0:
            asistio_key = next((key for key in attendance_data[0] if key.lower() == 'asistio'), None)
            if asistio_key:
                return make_response(jsonify({"asistio": attendance_data[0][asistio_key]})), 200
            else:
                return jsonify({"error": "Attendance status (asistio) not found in the record"}), 404
        else:
            return jsonify({"error": "Not registered"}), 404
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
# Register a user for an event
@app.route("/register-event-attendance", methods=['POST'])
def register_attendance():
    """
    Register a user's attendance for an event.
    ---
    tags:
      - Attendance
    consumes:
      - application/json
    parameters:
      - in: body
        name: attendance
        description: The attendance data with user and event information
        required: true
        schema:
          type: object
          required:
            - usuario_id
            - evento_id
          properties:
            usuario_id:
              type: integer
              description: The ID of the user
            evento_id:
              type: integer
              description: The ID of the event
            asistio:
              type: boolean
              description: Whether the user attended the event (defaults to False if not provided)
    responses:
      201:
        description: Attendance registered successfully
      200:
        description: Attendance already registered
      400:
        description: Invalid input data
      500:
        description: Server error
    """
    try:
        # Get the JSON data from the request
        data = request.json
        usuario_id = data.get('usuario_id')
        evento_id = data.get('evento_id')
        asistio = data.get('asistio', False)  # Default to False (0) if not provided

        # Validate the input data
        if usuario_id is None or evento_id is None:
            return jsonify({"error": "Invalid input data"}), 400

        # Check if the user is already registered for the event
        existing_registration = MSSql.sql_read_where('USUARIOS_EVENTOS', {
            'USUARIO': usuario_id,
            'EVENTO': evento_id
        })

        if existing_registration:
            return jsonify({"message": "User already registered for this event"}), 200

        # Prepare the data for insertion, 'asistio' defaults to 0 (False)
        attendance_data = {
            'USUARIO': usuario_id,
            'EVENTO': evento_id,
            'ASISTIO': 1 if asistio else 0
        }

        # Insert the attendance record into the database
        MSSql.sql_insert_row_into('USUARIOS_EVENTOS', attendance_data)

        return jsonify({"message": "Attendance registered successfully"}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# Login
# Función para hashear contraseñas con pepper
def hash_password_with_pepper(password, pepper="Shakira123"):
    # Append the pepper to the password
    peppered_password = password + pepper
    
    # Hash the peppered password usando SHA-256
    hash_object = hashlib.sha256(peppered_password.encode('utf-8'))
    hashed_password = hash_object.hexdigest()
    
    return hashed_password

@app.route("/login", methods=['POST'])
def login():
    """
    Verificar las credenciales de un usuario.
    ---
    parameters:
      - name: body
        in: body
        required: true
        description: Credenciales del usuario
        schema:
          type: object
          properties:
            email:
              type: string
              description: El correo electrónico del usuario
              example: "example@domain.com"
            contrasena:
              type: string
              description: La contraseña del usuario
              example: "password123"
    responses:
      200:
        description: Login exitoso
        content:
          application/json:
            schema:
              type: object
              properties:
                message:
                  type: string
                  example: "Login successful"
                user_id:
                  type: integer
                  example: 1
      401:
        description: Credenciales incorrectas
        content:
          application/json:
            schema:
              type: object
              properties:
                error:
                  type: string
                  example: "Invalid email or password"
      500:
        description: Error del servidor
    """
    data = request.json
    email = data.get('email')
    contrasena = data.get('contrasena')

    if not email or not contrasena:
        return jsonify({"error": "Email and password are required"}), 400

    try:
        # Buscar usuario por correo en la base de datos
        usuario_data = MSSql.sql_read_where('USUARIOS', {'EMAIL': email})

        if usuario_data:
            # Hashear la contraseña enviada por el usuario con el pepper
            hashed_input_password = hash_password_with_pepper(contrasena)

            # Verificar si la contraseña hasheada coincide con la almacenada en la base de datos
            if usuario_data[0]['CONTRASENA'] == hashed_input_password:
                return jsonify({"message": "Login successful", "user_id": usuario_data[0]['ID_USUARIO']}), 200
            else:
                return jsonify({"error": "Invalid email or password"}), 401
        else:
            return jsonify({"error": "Invalid email or password"}), 401

    except Exception as e:
        return jsonify({"error": str(e)}), 500
  
# Check if a user has completed a specific challenge
@app.route("/get-challenge-completion/<int:usuario_id>/<int:reto_id>", methods=['GET'])
def check_challenge_completion(usuario_id, reto_id):
    """
    Check if a user has completed a specific challenge.
    ---
    parameters:
      - name: usuario_id
        in: path
        type: integer
        required: true
        description: The ID of the user
      - name: reto_id
        in: path
        type: integer
        required: true
        description: The ID of the challenge
    responses:
      200:
        description: Returns completion status (completado) as JSON
        content:
          application/json:
            schema:
              type: object
              properties:
                completado:
                  type: integer
                  description: Completion status (1 for completed, 0 for not completed)
      404:
        description: No record found for this user and challenge combination
      500:
        description: Server error
    """
    try:
        # Query the completion status based on usuario_id and reto_id
        completion_data = MSSql.sql_read_where('USUARIOS_RETOS', {
            'ID_USUARIO': usuario_id,
            'ID_RETO': reto_id
        })

        if completion_data and len(completion_data) > 0:
            completado_key = next((key for key in completion_data[0] if key.lower() == 'completado'), None)
            if completado_key:
                return make_response(jsonify({"completado": completion_data[0][completado_key]})), 200
            else:
                return jsonify({"error": "Completion status (completado) not found in the record"}), 404
        else:
            return jsonify({"error": "Not registered"}), 404
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# Register a user completion for a challenge
@app.route("/register-challenge-completion", methods=['POST'])
def register_challenge_completion():
    """
    Register a user's completion for a challenge.
    ---
    tags:
      - Challenge Completion
    consumes:
      - application/json
    parameters:
      - in: body
        name: completion
        description: The completion data with user and challenge information
        required: true
        schema:
          type: object
          required:
            - usuario_id
            - reto_id
          properties:
            usuario_id:
              type: integer
              description: The ID of the user
            reto_id:
              type: integer
              description: The ID of the challenge
            completado:
              type: boolean
              description: Whether the user completed the challenge (defaults to False if not provided)
    responses:
      201:
        description: Completion registered successfully
      200:
        description: Completion already registered
      400:
        description: Invalid input data
      500:
        description: Server error
    """
    try:
        # Get the JSON data from the request
        data = request.json
        usuario_id = data.get('usuario_id')
        reto_id = data.get('reto_id')
        completado = data.get('completado', False)  # Default to False (0) if not provided

        # Validate the input data
        if usuario_id is None or reto_id is None:
            return jsonify({"error": "Invalid input data"}), 400

        # Check if the user is already registered for the challenge
        existing_registration = MSSql.sql_read_where('USUARIOS_RETOS', {
            'ID_USUARIO': usuario_id,
            'ID_RETO': reto_id
        })

        if existing_registration:
            return jsonify({"message": "User already registered for this challenge"}), 200

        # Prepare the data for insertion, 'completado' defaults to 0 (False)
        completion_data = {
            'ID_USUARIO': usuario_id,
            'ID_RETO': reto_id,
            'COMPLETADO': 1 if completado else 0
        }

        # Insert the completion record into the database
        MSSql.sql_insert_row_into('USUARIOS_RETOS', completion_data)

        return jsonify({"message": "Completion registered successfully"}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route("/redeem-benefit", methods=['POST'])
def redeem_benefit():
    """
    Redeem a benefit for a user.
    ---
    tags:
      - Benefits
    consumes:
      - application/json
    parameters:
      - in: body
        name: benefit
        description: The benefit redemption data with user and benefit information
        required: true
        schema:
          type: object
          required:
            - usuario_id
            - beneficio_id
          properties:
            usuario_id:
              type: integer
              description: The ID of the user
            beneficio_id:
              type: integer
              description: The ID of the benefit
    responses:
      201:
        description: Benefit redeemed successfully
      400:
        description: Invalid input data
      404:
        description: Benefit not found or insufficient points
      500:
        description: Server error
    """
    try:
        data = request.json
        usuario_id = data.get('usuario_id')
        beneficio_id = data.get('beneficio_id')

        if usuario_id is None or beneficio_id is None:
            return jsonify({"error": "Invalid input data"}), 400

        benefit_data = MSSql.sql_read_where_attribute("BENEFICIOS", {"ID_BENEFICIO": beneficio_id}, attributes=["PUNTOS"])

        if not benefit_data:
            return jsonify({"error": "Benefit not found"}), 404
        
        points_required = benefit_data[0]['PUNTOS']

        total_points = MSSql.obtener_puntos_usuario(usuario_id)

        if total_points < points_required:
            return jsonify({"error": "Insufficient points to redeem this benefit"}), 404

        redemption_data = {
            'USUARIO': usuario_id,
            'BENEFICIO': beneficio_id,
            'CANJEADO': 1  
        }

        #insertar beneficio
        MSSql.sql_insert_row_into('USUARIOS_BENEFICIOS', redemption_data)

        return jsonify({"message": "Benefit redeemed successfully"}), 201

    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route("/usuario/puntos", methods=['GET'])
def get_usuario_puntos():
    """
        Obtiene los puntos de un usuario específico
        ---
        parameters:
          - name: userId
            in: query
            required: true
            description: ID del usuario
        responses:
            200:
                description: application/json "Puntos del usuario"
            400:
                description: "Solicitud incorrecta"
            404:
                description: "Usuario no encontrado"
    """
    userId = request.args.get('userId', None)
    if userId is None:
        return make_response(jsonify({'error': 'Missing userId'}), 400)

    try:
        #puntos usuario
        puntos = get_usuario_puntos_db(userId)

        if puntos is None:
            return make_response(jsonify({'error': 'User not found'}), 404)

        return make_response(jsonify({'puntos': puntos}), 200)
        

if __name__ == '__main__':
    # SSL context setup
    import ssl
    context = ssl.SSLContext(ssl.PROTOCOL_TLSv1_2)
    context.load_cert_chain('/home/user01/mnt/api_https/SSL/iborregos.tc2007b.tec.mx.cer', 
                            '/home/user01/mnt/api_https/SSL/iborregos.tc2007b.tec.mx.key')
    app.run(host='0.0.0.0', port=10206, ssl_context=context, debug=True)
