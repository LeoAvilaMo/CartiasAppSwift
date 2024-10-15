from flask import Flask, jsonify, make_response, request
from flasgger import Swagger
import os
import ssl
# import mssql_functions as MSSql
import sql_functions as MSSql
import hashlib
from dotenv import load_dotenv

# Set up logging
try:
    import logging
    import logging.handlers
    import os

    LOG_PATH = '/home/user01/mnt/api_https/logs'  # Or an appropriate directory
    LOGFILE = os.path.join(LOG_PATH, 'api_https.log')


    # Ensure the log directory exists
    if not os.path.exists(LOG_PATH):
        os.makedirs(LOG_PATH)

    logformat = '%(asctime)s.%(msecs)03d %(levelname)s: %(message)s'
    formatter = logging.Formatter(logformat, datefmt='%d-%b-%y %H:%M:%S')
    loggingRotativo = False
    DEV = True

    if loggingRotativo:
        # Logging rotativo
        LOG_HISTORY_DAYS = 3
        handler = logging.handlers.TimedRotatingFileHandler(
            LOGFILE,
            when='midnight',
            backupCount=LOG_HISTORY_DAYS)
    else:
        handler = logging.FileHandler(filename=LOGFILE)

    handler.setFormatter(formatter)
    my_logger = logging.getLogger("api_http")
    my_logger.addHandler(handler)

    if DEV:
        my_logger.setLevel(logging.DEBUG)
    else:
        my_logger.setLevel(logging.INFO)

except Exception as e:
    print("Failed to initialize logger:", e)
    my_logger = None  # Fallback in case logger fails

# Remove 'Server' from header
from gunicorn.http import wsgi
class Response(wsgi.Response):
    def default_headers(self, *args, **kwargs):
        headers = super(Response, self).default_headers(*args, **kwargs)
        return [h for h in headers if not h.startswith('Server:')]
wsgi.Response = Response

app = Flask(__name__)
@app.after_request
def add_header(r):
    import secure

    secure_headers = secure.Secure()
    secure_headers.framework.flask(r)
    # r.headers['X-Frame-Options'] = 'SAMEORIGIN' # ya lo llena 'secure'
    r.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
    r.headers["Content-Security-Policy"] = "default-src 'none'"
    r.headers["Shakira"] = "rocks!"
    # r.headers["Expires"] = "0"
    return r

app = Flask(__name__)
Swagger(app, template={
    "info": {
        "title": "API TC2007B",
        "description": "REST API for TC2007B Course",
        "version": "1.0.0"
    }
})
# Load environment variables from .env file
load_dotenv()

# Now the variables can be accessed using os.getenv()
mssql_params = {
    'DB_HOST': os.getenv('DB_HOST'),
    'DB_NAME': os.getenv('DB_NAME_IB'),
    'DB_USER': os.getenv('DB_USER'),
    'DB_PASSWORD': os.getenv('DB_PASSWORD')
}

# Establish database connection
try:
    MSSql.cnx = MSSql.mssql_connect(mssql_params)
except Exception as e:
    print("Cannot connect to MSSQL server:", e)
    exit()

def log_route_access(route_name):
    """
    Logs access to a specific route with the remote address and user agent.
    :param route_name: The name of the route being accessed
    """
    if my_logger:
        my_logger.info("({}) Accessing route: {}".format(request.remote_addr, route_name))
        my_logger.debug("({}) Accessing route: {} - User agent: {}".format(request.remote_addr, route_name, request.user_agent))
    else:
        print("Logger is not available. Using print instead.")
        print("({}) Accessing route: {}".format(request.remote_addr, route_name))
        print("({}) Accessing route: {} - User agent: {}".format(request.remote_addr, route_name, request.user_agent))


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
    log_route_access("/event/<int:event_id>")
    event_data = MSSql.sql_read_where('EVENTOS', {'ID_EVENTO': event_id})
    if event_data:
        return make_response(jsonify(event_data)), 200
    else:
        return jsonify({"error": "Event not found"}), 404

# obtener puntos usuario
@app.route("/usuario/<int:usuario_id>/puntos", methods=['GET'])
def get_puntos_usuario(usuario_id):
    """
    Retrieve points for a user by user ID.
    ---
    parameters:
      - name: usuario_id
        in: path
        type: integer
        required: true
        description: The ID of the user to retrieve points for
    responses:
      200:
        description: Returns the user's points as JSON
        content:
          application/json:
            schema:
              type: object
              properties:
                puntos:
                  type: integer
                  description: The user's points
      404:
        description: User not found
      500:
        description: Server error
    """
    log_route_access("/usuario/<int:usuario_id>/puntos")
    try:
        puntos = MSSql.obtener_puntos_usuario(usuario_id)

        if puntos is not None:
            return jsonify({"puntos": puntos}), 200
        else:
            return jsonify({"error": "User not found"}), 404
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
        # Get the JSON data from the request
        data = request.json
        usuario_id = data.get('usuario_id')
        beneficio_id = data.get('beneficio_id')

        # Validate the input data
        if usuario_id is None or beneficio_id is None:
            return jsonify({"error": "Invalid input data"}), 400

        # Call the stored procedure to redeem the benefit
        cursor = MSSql.cnx.cursor()

        # Execute the stored procedure 'AddUsuarioBeneficio'
        cursor.callproc('AddUsuarioBeneficio', [beneficio_id, usuario_id])

        # Commit the transaction
        MSSql.cnx.commit()
        cursor.close()

        return jsonify({"message": "Benefit redeemed successfully"}), 201

    except Exception as e:
        # Handle exceptions and return an appropriate error message
        return jsonify({"error": str(e)}), 500

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
    log_route_access("/all-events")
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
    log_route_access("/usuario/<int:usuario_id>")
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
    log_route_access("/usuario/<string:email>")
    try:
        user_data = MSSql.sql_read_where('USUARIOS', {'EMAIL': email})

        if user_data:
            # Convert ID_TIPO_USUARIO and ID_USUARIO to integers
            user_data[0]['ID_TIPO_USUARIO'] = int(user_data[0]['ID_TIPO_USUARIO'])
            user_data[0]['ID_USUARIO'] = int(user_data[0]['ID_USUARIO'])

            return make_response(jsonify(user_data[0])), 200
        else:
            return jsonify({"error": "User not found"}), 404
    except Exception as e:
        return jsonify({"error": str(e)}), 500

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
    log_route_access("/all-benefits")
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
    log_route_access("/beneficio/<int:beneficio_id>")
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
    log_route_access("/get-attendance-events/<int:usuario_id>/<int:evento_id>")
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
    log_route_access("/register-event-attendance")
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
def hash_password_with_pepper(password, pepper=os.getenv('PEPPER')):
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
    log_route_access("/login")
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
    log_route_access("/get-challenge-completion/<int:usuario_id>/<int:reto_id>")
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
    log_route_access("/register-challenge-completion")
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

	# Route to get pending challenges for a user
@app.route("/user-challenges/<int:user_id>", methods=['GET'])
def get_user_challenges(user_id):
    """
    Get pending challenges for a user by their ID.
    ---
    parameters:
      - name: user_id
        in: path
        type: integer
        required: true
        description: The ID of the user to retrieve challenges for
    responses:
      200:
        description: Returns the user's pending challenges
        content:
          application/json:
            schema:
              type: array
              items:
                type: object
                properties:
                  ID_RETO:
                    type: integer
                    description: The challenge ID
                  NOMBRE:
                    type: string
                    description: The name of the challenge
                  DESCRIPCION:
                    type: string
                    description: The description of the challenge
                  PUNTAJE:
                    type: integer
                    description: The score for completing the challenge
      404:
        description: User or challenges not found
      500:
        description: Server error
    """
    log_route_access("/user-challenges/<int:user_id>")
    try:
        cursor = MSSql.cnx.cursor(as_dict=True)
        cursor.callproc('GetPendingUserChallenges', (user_id,))
        challenges = cursor.fetchall()
        cursor.close()

        # Convert ID_RETO and PUNTAJE to integers
        for challenge in challenges:
            challenge['ID_RETO'] = int(challenge['ID_RETO'])
            challenge['PUNTAJE'] = int(challenge['PUNTAJE'])

        if challenges:
            return make_response(jsonify(challenges)), 200
        else:
            return jsonify({"error": "No pending challenges found for user"}), 404

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route("/usuario/<int:id_usuario>/retos", methods=['GET'])
def get_usuario_reto_stats(id_usuario):
    """
    Get total retos and completed retos for a user.
    ---
    parameters:
      - name: id_usuario
        in: path
        type: integer
        required: true
        description: The ID of the user to retrieve reto stats for
    responses:
      200:
        description: Returns total retos and completed retos
        content:
          application/json:
            schema:
              type: object
              properties:
                TotalRetos:
                  type: integer
                  description: Total number of retos
                CompletedRetos:
                  type: integer
                  description: Number of completed retos by the user
      404:
        description: User not found
      500:
        description: Server error
    """
    log_route_access("/usuario/<int:id_usuario>/retos")
    try:
        cursor = MSSql.cnx.cursor(as_dict=True)
        
        # Call the stored procedure with the user ID
        cursor.callproc('GetRetoStats', (id_usuario,))
        
        # Fetch the result (total retos and completed retos)
        reto_stats = cursor.fetchone()  # Stored procedure returns one row
        cursor.close()

        if reto_stats:
            return jsonify({
                'TotalRetos': int(reto_stats['TotalRetos']),
                'CompletedRetos': int(reto_stats['CompletedRetos'])
            }), 200
        else:
            return jsonify({"error": "User not found"}), 404
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route("/usuario/<int:id_usuario>/datos-fisicos", methods=['GET'])
def get_recent_datos_fisicos(id_usuario):
    """
    Get the 5 most recent 'Datos Fisicos' for a user.
    ---
    parameters:
      - name: id_usuario
        in: path
        type: integer
        required: true
        description: The ID of the user to retrieve 'Datos Fisicos' for
    responses:
      200:
        description: Returns the 5 most recent 'Datos Fisicos'
        content:
          application/json:
            schema:
              type: array
              items:
                type: object
                properties:
                  ID:
                    type: integer
                    description: The record ID
                  ID_USUARIO:
                    type: integer
                    description: The user ID
                  PESO:
                    type: float
                    description: The weight of the user
                  ALTURA:
                    type: float
                    description: The height of the user
                  IMC:
                    type: number
                    description: The BMI of the user
                  GLUCOSA:
                    type: number
                    description: The glucose level of the user
                  FECHA_ACTUALIZACION:
                    type: string
                    format: date-time
                    description: The date when the record was updated
      404:
        description: User not found or no records found
      500:
        description: Server error
    """
    log_route_access("/usuario/<int:id_usuario>/datos-fisicos")
    try:
        cursor = MSSql.cnx.cursor(as_dict=True)
        cursor.callproc('GetRecentDatosFisicosByUsuario', (id_usuario,))
        datos_fisicos = cursor.fetchall()
        cursor.close()

        if datos_fisicos:
            # Ensure correct data types are returned in JSON
            for record in datos_fisicos:
                record['ID'] = int(record['ID'])
                record['ID_USUARIO'] = int(record['ID_USUARIO'])
                record['PESO'] = float(record['PESO'])
                record['ALTURA'] = float(record['ALTURA'])
                record['IMC'] = float(record['IMC'])
                record['GLUCOSA'] = float(record['GLUCOSA'])
                record['FECHA_ACTUALIZACION'] = str(record['FECHA_ACTUALIZACION'])  # Leave as string

            return jsonify(datos_fisicos), 200
        else:
            return jsonify({"error": "No records found for the user"}), 404
    except Exception as e:
        return jsonify({"error": str(e)}), 500
# Get eventos completados por un usuario
@app.route("/user/<int:usuario_id>/completed-events", methods=['GET'])
def get_user_completed_events(usuario_id):
    """
    Get all events that the user has attended (ASISTIO = 1).
    ---
    parameters:
      - name: usuario_id
        in: path
        type: integer
        required: true
        description: The ID of the user to retrieve attended events for
    responses:
      200:
        description: Returns the user's attended events
        content:
          application/json:
            schema:
              type: array
              items:
                type: object
                properties:
                  ID_EVENTO:
                    type: integer
                    description: The event ID
                  NOMBRE:
                    type: string
                    description: The event name
                  DESCRIPCION:
                    type: string
                    description: The event description
                  FECHA_EVENTO:
                    type: string
                    format: date-time
                    description: The date of the event
                  NUM_MAX_ASISTENTES:
                    type: integer
                    description: Maximum number of attendees
                  PUNTAJE:
                    type: integer
                    description: Points for attending the event
      404:
        description: No events found for this user
      500:
        description: Server error
    """
    log_route_access("/user/<int:usuario_id>/completed-events")
    try:
        cursor = MSSql.cnx.cursor(as_dict=True)
        cursor.callproc('GetUserCompletedEvents', (usuario_id,))
        events = cursor.fetchall()
        cursor.close()

        if events:
            return jsonify(events), 200
        else:
            return jsonify({"error": "No completed events found for user"}), 404

    except Exception as e:
        return jsonify({"error": str(e)}), 500

# Get completed retos by a user
@app.route("/user/<int:usuario_id>/completed-retos", methods=['GET'])
def get_user_completed_retos(usuario_id):
    """
    Get all retos (challenges) that the user has completed (COMPLETADO = 1).
    ---
    parameters:
      - name: usuario_id
        in: path
        type: integer
        required: true
        description: The ID of the user to retrieve completed challenges for
    responses:
      200:
        description: Returns the user's completed challenges
        content:
          application/json:
            schema:
              type: array
              items:
                type: object
                properties:
                  ID_RETO:
                    type: integer
                    description: The challenge ID
                  NOMBRE:
                    type: string
                    description: The challenge name
                  DESCRIPCION:
                    type: string
                    description: The challenge description
                  PUNTAJE:
                    type: integer
                    description: The challenge score
      404:
        description: No completed challenges found for this user
      500:
        description: Server error
    """
    log_route_access("/user/<int:usuario_id>/completed-retos")
    try:
        cursor = MSSql.cnx.cursor(as_dict=True)
        cursor.callproc('GetUserCompletedRetos', (usuario_id,))
        retos = cursor.fetchall()
        cursor.close()

        # Ensure ID_RETO and PUNTAJE are integers
        for reto in retos:
            reto['ID_RETO'] = int(reto['ID_RETO'])
            reto['PUNTAJE'] = int(reto['PUNTAJE'])

        if retos:
            return jsonify(retos), 200
        else:
            return jsonify({"error": "No completed retos found for user"}), 404

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route("/user/<int:usuario_id>/total-points", methods=["GET"])
def get_user_total_points(usuario_id):
    """
    Get the total points for a user based on completed events, completed retos, and benefits.
    ---
    parameters:
      - name: usuario_id
        in: path
        type: integer
        required: true
        description: The ID of the user to retrieve total points for
    responses:
      200:
        description: Returns the user's total points
        content:
          application/json:
            schema:
              type: object
              properties:
                TotalPoints:
                  type: number
                  description: The user's final total points
      404:
        description: No points data found for this user
      500:
        description: Server error
    """
    try:
        cursor = MSSql.cnx.cursor(as_dict=True)
        
        # Call the stored procedure, expecting a single value: TotalPoints
        cursor.callproc("GetUserTotalPoints", (usuario_id,))
        points_data = cursor.fetchone()
        cursor.close()

        if points_data and "TotalPoints" in points_data:
            return jsonify({"TotalPoints": points_data["TotalPoints"]}), 200
        else:
            return jsonify({"error": "No points data found for user"}), 404

    except Exception as e:
        return jsonify({"error": str(e)}), 500
        
@app.route("/register-event-completion", methods=['POST'])
def register_event_completion():
    """
    Register a user's attendance completion for an event.
    ---
    tags:
      - Event Completion
    consumes:
      - application/json
    parameters:
      - in: body
        name: completion
        description: The completion data with user and event information
        required: true
        schema:
          type: object
          required:
            - usuario_id
            - evento_id
            - event_name
            - event_code
          properties:
            usuario_id:
              type: integer
              description: The ID of the user
            evento_id:
              type: integer
              description: The ID of the event
            event_name:
              type: string
              description: The name of the event
            event_code:
              type: string
              description: The code provided for the event
    responses:
      201:
        description: Attendance registered/updated successfully
      400:
        description: Invalid input data or event code
      500:
        description: Server error
    """
    log_route_access("/register-event-completion")
    try:
        # Get the JSON data from the request
        data = request.json
        usuario_id = data.get('usuario_id')
        evento_id = data.get('evento_id')
        event_name = data.get('event_name')
        provided_event_code = data.get('event_code')

        # Validate the input data
        if not usuario_id or not evento_id or not event_name or not provided_event_code:
            return jsonify({"error": "Invalid input data"}), 400

        # Generate the event code by hashing the event name and taking the first 5 characters
        generated_event_code = hashlib.sha256(event_name.encode('utf-8')).hexdigest()[:5]

        # Check if the provided event_code matches the generated event_code
        if provided_event_code != generated_event_code:
            return jsonify({"error": "Invalid event code"}), 400

        # Execute the stored procedure to register or update attendance
        try:
            cursor = MSSql.cnx.cursor(as_dict=True)
            cursor.callproc('RegisterOrUpdateAttendance', (usuario_id, evento_id))
            MSSql.cnx.commit()
            cursor.close()

            return jsonify({"message": "Attendance registered/updated successfully"}), 201
        except Exception as e:
            return jsonify({"error": str(e)}), 500

    except Exception as e:
        return jsonify({"error": str(e)}), 500
  
# Route to get unredeemed benefits (premios) for a specific user
@app.route("/user/<int:usuario_id>/unclaimedpremios", methods=['GET'])
def get_unclaimed_premios(usuario_id):
    """
    Get all unredeemed benefits (premios) for a user.
    ---
    parameters:
      - name: usuario_id
        in: path
        type: integer
        required: true
        description: The ID of the user to retrieve unredeemed benefits (premios) for
    responses:
      200:
        description: Returns the user's unredeemed benefits (premios)
        content:
          application/json:
            schema:
              type: array
              items:
                type: object
                properties:
                  ID_BENEFICIO:
                    type: integer
                    description: The benefit ID
                  NOMBRE:
                    type: string
                    description: The benefit name
                  DESCRIPCION:
                    type: string
                    description: The benefit description
                  PUNTOS:
                    type: integer
                    description: The points associated with the benefit
      404:
        description: No unredeemed benefits (premios) found for this user
      500:
        description: Server error
    """
    try:
        # Execute the stored procedure to get unredeemed benefits
        cursor = MSSql.cnx.cursor(as_dict=True)
        cursor.callproc('GetUnredeemedBenefitsByUserId', (usuario_id,))
        benefits = cursor.fetchall()
        cursor.close()

        # DEBUG: Log the stored procedure result
        print("Stored Procedure Output:", benefits)

        # Check if benefits were returned
        if not benefits:
            return jsonify({"error": "No unredeemed benefits found for user"}), 404

        # Process and remove 'CANJEADO' from the response
        processed_benefits = []
        for benefit in benefits:
            if 'ID_BENEFICIO' in benefit:
                processed_benefits.append({
                    'ID_BENEFICIO': int(benefit.get('ID_BENEFICIO', 0)),
                    'NOMBRE': benefit.get('NOMBRE', ''),
                    'DESCRIPCION': benefit.get('DESCRIPCION', ''),
                    'PUNTOS': int(benefit.get('PUNTOS', 0))
                })
        
        return jsonify(processed_benefits), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

# SSL context setup using environment variables
ssl_cert_path = os.getenv('SSL_CERT_PATH')
ssl_key_path = os.getenv('SSL_KEY_PATH')

if __name__ == '__main__':
    # SSL context setup
    import ssl
    context = ssl.SSLContext(ssl.PROTOCOL_TLSv1_2)
    context.load_cert_chain(ssl_cert_path, ssl_key_path)
    app.run(host=os.getenv('HOST'), port=os.getenv('PORT'), ssl_context=context, debug=False)
