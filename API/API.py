from flask import Flask, jsonify, make_response, request
import mysql.connector
import sys
import os

# Variables de alumno
DB_NAME = os.environ['DB_NAME']
API_PORT = os.environ['API_PORT']
# MySQL params
mysql_params = {}
mysql_params['DB_HOST'] = '100.80.80.2'
mysql_params['DB_NAME'] = DB_NAME
mysql_params['DB_USER'] = 'admin'
mysql_params['DB_PASSWORD'] = 'user1234'

try:
    cnx = mysql.connector.connect(
        user=mysql_params['DB_USER'],
        password=mysql_params['DB_PASSWORD'],
        host=mysql_params['DB_HOST'],
        database=mysql_params['DB_NAME'], 
        auth_plugin='mysql_native_password'
        )
except Exception as e:
    print("Cannot connect to MySQL server!: {}".format(e))
    sys.exit()

def read_user_data(table_name, username):
    global cnx
    try:
        try:
            cnx.ping(reconnect=True, attempts=1, delay=3)
        except:
            cnx = mysql.connector.connect(
                user=mysql_params['DB_USER'],
                password=mysql_params['DB_PASSWORD'],
                host=mysql_params['DB_HOST'],
                database=mysql_params['DB_NAME'], 
                auth_plugin='mysql_native_password'
            )
        cursor = cnx.cursor(dictionary=True)
        read = 'SELECT * FROM {} WHERE username = "{}"'.format(table_name, username)
        cursor.execute(read)
        a = cursor.fetchall()
        cnx.commit()
        cursor.close()
        return a
    except Exception as e:
        raise TypeError("read_user_data:%s" % e)

app = Flask(__name__)

@app.route("/hello")
def hello():
    return "Shakira rocks!\n"

@app.route("/user")
def user():
    username = request.args.get('username', None)
    d_user = read_user_data('users', username)
    return make_response(jsonify(d_user))

API_CERT = '/home/user01/mntiborregos/api_https/SSL/iborregos.tc2007b.tec.mx.cer'
API_KEY = '/home/user01/mntiborregos/api_https/SSL/iborregos.tc2007b.tec.mx.key'

if __name__ == '__main__':
    import ssl
    context = ssl.SSLContext(ssl.PROTOCOL_TLSv1_2)
    context.load_cert_chain(API_CERT, API_KEY)
    print ("Running API...")
    app.run(host='0.0.0.0', port= 10201, ssl_context = context, debug=True)

