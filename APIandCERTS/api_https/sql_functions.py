cnx = None
mssql_params = {}

def mssql_connect(sql_creds):
    import pymssql
    cnx = pymssql.connect(
        server=sql_creds['DB_HOST'],
        user=sql_creds['DB_USER'],
        password=sql_creds['DB_PASSWORD'],
        database=sql_creds['DB_NAME'])
    return cnx


def sql_read_all(table_name):
    import pymssql
    global cnx, mssql_params
    
    allowed_tables = [
        "BENEFICIOS", "USUARIOS_BENEFICIOS", "USUARIOS_RETOS",
        "RETOS", "EVENTOS", "USUARIOS_EVENTOS", "USUARIOS_PREMIOS",
        "USUARIOS", "DATOS_FISICOS", "DATOS_FISICO", "HISTORICO", "TIPO_USUARIO"
    ]

    if table_name not in allowed_tables:
        raise ValueError("Nombre de tabla no válido")

    # Construir la consulta según el nombre de la tabla
    if table_name == "BENEFICIOS":
        query = "SELECT * FROM BENEFICIOS"
    elif table_name == "USUARIOS_BENEFICIOS":
        query = "SELECT * FROM USUARIOS_BENEFICIOS"
    elif table_name == "USUARIOS_RETOS":
        query = "SELECT * FROM USUARIOS_RETOS"
    elif table_name == "RETOS":
        query = "SELECT * FROM RETOS"
    elif table_name == "EVENTOS":
        query = "SELECT * FROM EVENTOS"
    elif table_name == "USUARIOS_EVENTOS":
        query = "SELECT * FROM USUARIOS_EVENTOS"
    elif table_name == "USUARIOS_PREMIOS":
        query = "SELECT * FROM USUARIOS_PREMIOS"
    elif table_name == "USUARIOS":
        query = "SELECT * FROM USUARIOS"
    elif table_name == "DATOS_FISICOS":
        query = "SELECT * FROM DATOS_FISICOS"
    elif table_name == "DATOS_FISICO":
        query = "SELECT * FROM DATOS_FISICO"
    elif table_name == "HISTORICO":
        query = "SELECT * FROM HISTORICO"
    elif table_name == "TIPO_USUARIO":
        query = "SELECT * FROM TIPO_USUARIO"
    else:
        raise ValueError("Nombre de tabla no válido")

    try:
        cursor = cnx.cursor(as_dict=True)
        cursor.execute(query)
        result = cursor.fetchall()
        cursor.close()
        return result
    except pymssql._pymssql.InterfaceError:
        print("Reconnecting...")
        cnx = mssql_connect(mssql_params)
        cursor = cnx.cursor(as_dict=True)
        cursor.execute(query)
        result = cursor.fetchall()
        cursor.close()
        return result
    except Exception as e:
        raise TypeError(f"sql_read_all: {e}")


def sql_read_where(table_name, d_where):
    import pymssql
    global cnx, mssql_params
    
    allowed_tables = {
        "BENEFICIOS": "SELECT * FROM BENEFICIOS WHERE ",
        "USUARIOS_BENEFICIOS": "SELECT * FROM USUARIOS_BENEFICIOS WHERE ",
        "USUARIOS_RETOS": "SELECT * FROM USUARIOS_RETOS WHERE ",
        "RETOS": "SELECT * FROM RETOS WHERE ",
        "EVENTOS": "SELECT * FROM EVENTOS WHERE ",
        "USUARIOS_EVENTOS": "SELECT * FROM USUARIOS_EVENTOS WHERE ",
        "USUARIOS_PREMIOS": "SELECT * FROM USUARIOS_PREMIOS WHERE ",
        "USUARIOS": "SELECT * FROM USUARIOS WHERE ",
        "DATOS_FISICOS": "SELECT * FROM DATOS_FISICOS WHERE ",
        "DATOS_FISICO": "SELECT * FROM DATOS_FISICO WHERE ",
        "HISTORICO": "SELECT * FROM HISTORICO WHERE ",
        "TIPO_USUARIO": "SELECT * FROM TIPO_USUARIO WHERE "
    }
    
    if table_name not in allowed_tables:
        raise ValueError("Nombre de tabla no válido")

    base_query = allowed_tables[table_name]
    
    conditions = []
    params = []

    for k, v in d_where.items():
        if v is not None:
            if isinstance(v, bool):
                conditions.append(f"{k} = %s")
                params.append(int(v == True))
            else:
                conditions.append(f"{k} = %s")
                params.append(v)
        else:
            conditions.append(f"{k} IS NULL")

    where_clause = " AND ".join(conditions)
    query = base_query + where_clause
    try:
        try:
            cursor = cnx.cursor(as_dict=True)
            cursor.execute(query, params)
        except pymssql._pymssql.InterfaceError:
            print("Reconnecting...")
            cnx = mssql_connect(mssql_params)
            cursor = cnx.cursor(as_dict=True)
            cursor.execute(query, params)
        result = cursor.fetchall()
        cursor.close()
        return result
    except Exception as e:
        raise TypeError(f"sql_read_where: {e}")


def sql_read_where_attribute(table_name, d_where, attributes=None):
    import pymssql
    global cnx, mssql_params

    if attributes is None:
        attributes_str = "*"
    else:
        attributes_str = ", ".join(attributes)

    conditions = []
    params = []

    for k, v in d_where.items():
        if v is not None:
            if isinstance(v, bool):
                conditions.append(f"{k} = %s")
                params.append(int(v == True))
            else:
                conditions.append(f"{k} = %s")
                params.append(v)
        else:
            conditions.append(f"{k} IS NULL")

    where_clause = " AND ".join(conditions)
    query = f"SELECT {attributes_str} FROM {table_name} WHERE {where_clause}"

    try:
        try:
            cursor = cnx.cursor(as_dict=True)
            cursor.execute(query, params)
        except pymssql._pymssql.InterfaceError:
            print("Reconnecting...")
            cnx = mssql_connect(mssql_params)
            cursor = cnx.cursor(as_dict=True)
            cursor.execute(query, params)
        a = cursor.fetchall()
        cursor.close()
        return a
    except Exception as e:
        raise TypeError(f"sql_read_where: {e}")


def sql_insert_row_into(table_name, d):
    import pymssql
    global cnx, mssql_params
    keys = ""
    values = ""
    data = []
    for k in d:
        keys += k + ','
        values += "%s,"
        if isinstance(d[k],bool):
            data.append(int(d[k] == True))
        else:
            data.append(d[k])
    keys = keys[:-1]
    values = values[:-1]
    insert = 'INSERT INTO %s (%s) VALUES (%s)'  % (table_name, keys, values)
    data = tuple(data)
    #print(insert)
    #print(data)
    try:
        try:
            cursor = cnx.cursor(as_dict=True)
            cursor.execute(insert, data)
        except pymssql._pymssql.InterfaceError:
            print("reconnecting...")
            cnx = mssql_connect(mssql_params)
            cursor = cnx.cursor(as_dict=True)
            cursor.execute(insert, data)
        cnx.commit()
        id_new = cursor.lastrowid
        cursor.close()
        return id_new
    except Exception as e:
        raise TypeError("sql_insert_row_into:%s" % e)

def sql_update_where(table_name, d_field, d_where):
    import pymssql
    global cnx, mssql_params
    update = 'UPDATE %s SET ' % table_name
    for k,v in d_field.items():
        if v is None:
            update +='%s = NULL, ' % (k)
        elif isinstance(v,bool):
            update +='%s = %s, ' % (k,int(v == True))
        elif isinstance(v,str):
            update +="%s = '%s', " % (k,v)
        else:
            update +='%s = %s, ' % (k,v)
    # Remove last ", "
    update = update[:-2]
    update += ' WHERE ( '
    for k,v in d_where.items():
        if v is not None:
            if isinstance(v,bool):
                update += "%s = '%s' AND " % (k,int(v == True))
            else:
                update += "%s = '%s' AND " % (k,v)
        else:
            update += '%s is NULL AND ' % (k)
    # Remove last "AND "
    update = update[:-4]
    update += ")"
    #print(update)
    try:
        try:
            cursor = cnx.cursor(as_dict=True)
            a = cursor.execute(update)
        except pymssql._pymssql.InterfaceError:
            print("reconnecting...")
            cnx = mssql_connect(mssql_params)
            cursor = cnx.cursor(as_dict=True)
            a = cursor.execute(update)
        cnx.commit()
        cursor.close()
        return a
    except Exception as e:
        raise TypeError("sql_update_where:%s" % e)

def sql_delete_where(table_name, d_where):
    import pymssql
    global cnx, mssql_params
    delete = 'DELETE FROM %s ' % table_name
    delete += ' WHERE ( '
    for k,v in d_where.items():
        if v is not None:
            if isinstance(v,bool):
                delete += "%s = '%s' AND " % (k,int(v == True))
            else:
                delete += "%s = '%s' AND " % (k,v)
        else:
            delete += '%s is NULL AND ' % (k)
    # Remove last "AND "
    delete = delete[:-4]
    delete += ")"
    #print(delete)
    try:
        try:
            cursor = cnx.cursor(as_dict=True)
            a = cursor.execute(delete)
        except pymssql._pymssql.InterfaceError:
            print("reconnecting...")
            cnx = mssql_connect(mssql_params)
            cursor = cnx.cursor(as_dict=True)
            a = cursor.execute(delete)
        cnx.commit()
        cursor.close()
        return a
    except Exception as e:
        raise TypeError("sql_delete_where:%s" % e)

def obtener_puntos_usuario(usuario_id):
    import pymssql
    global cnx, mssql_params
    
    query_retos = """
    SELECT COALESCE(SUM(r.PUNTAJE), 0) AS puntos_retos
    FROM USUARIOS_RETOS ur
    JOIN RETOS r ON ur.ID_RETO = r.ID_RETO
    WHERE ur.ID_USUARIO = %s AND ur.COMPLETADO = 1;
    """
    
    query_eventos = """
    SELECT COALESCE(SUM(e.PUNTAJE), 0) AS puntos_eventos
    FROM USUARIOS_EVENTOS ue
    JOIN EVENTOS e ON ue.EVENTO = e.ID_EVENTO
    WHERE ue.USUARIO = %s AND ue.ASISTIO = 1;
    """
    
    query_beneficios = """
    SELECT COALESCE(SUM(b.PUNTOS), 0) AS puntos_beneficios
    FROM USUARIOS_BENEFICIOS ub
    JOIN BENEFICIOS b ON ub.BENEFICIO = b.ID_BENEFICIO
    WHERE ub.USUARIO = %s AND ub.CANJEADO = 1;
    """
    
    try:
        cursor = cnx.cursor(as_dict=True)
        cursor.execute(query_retos, (usuario_id,))
        puntos_retos = cursor.fetchone()['puntos_retos']

        cursor.execute(query_eventos, (usuario_id,))
        puntos_eventos = cursor.fetchone()['puntos_eventos']

        cursor.execute(query_beneficios, (usuario_id,))
        puntos_beneficios = cursor.fetchone()['puntos_beneficios']

        total_puntos = puntos_retos + puntos_eventos - puntos_beneficios
        cursor.close()
        return total_puntos

    except Exception as e:
        raise TypeError(f"obtener_puntos_usuario: {e}")


