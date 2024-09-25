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

if __name__ == '__main__':
    # SSL context setup
    import ssl
    context = ssl.SSLContext(ssl.PROTOCOL_TLSv1_2)
    context.load_cert_chain('/home/user01/mntleo/api_https/SSL/a00835641.tc2007b.tec.mx.cer',
                            '/home/user01/mntleo/api_https/SSL/a00835641.tc2007b.tec.mx.key')
    app.run(host='0.0.0.0', port=10201, ssl_context=context, debug=True)