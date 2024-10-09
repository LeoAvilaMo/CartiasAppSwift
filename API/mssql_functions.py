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

def read_user_data(table_name, username):
    import pymssql
    global cnx, mssql_params
    read = "SELECT * FROM {} WHERE username = '{}'".format(table_name, username)
    #print(read)
    try:
        try:
            cursor = cnx.cursor(as_dict=True)
            cursor.execute(read)
        except pymssql._pymssql.InterfaceError:
            print("reconnecting...")
            cnx = mssql_connect(mssql_params)
            cursor = cnx.cursor(as_dict=True)
            cursor.execute(read)
        a = cursor.fetchall()
        cursor.close()
        return a
    except Exception as e:
        raise TypeError("read_user_data: %s" % e)

def sql_read_all(table_name):
    import pymssql
    global cnx, mssql_params
    read = 'SELECT * FROM %s' % table_name
    try:
        try:
            cursor = cnx.cursor(as_dict=True)
            cursor.execute(read)
        except pymssql._pymssql.InterfaceError:
            print("reconnecting...")
            cnx = mssql_connect(mssql_params)
            cursor = cnx.cursor(as_dict=True)
            cursor.execute(read)
        a = cursor.fetchall()
        cursor.close()
        return a
    except Exception as e:
        raise TypeError("sql_read_where:%s" % e)

def sql_read_where(table_name, d_where):
    import pymssql
    global cnx, mssql_params
    read = 'SELECT * FROM %s WHERE ' % table_name
    read += '('
    for k,v in d_where.items():
        if v is not None:
            if isinstance(v,bool):
                read += "%s = '%s' AND " % (k,int(v == True))
            else:
                read += "%s = '%s' AND " % (k,v)
        else:
            read += '%s is NULL AND ' % (k)
    # Remove last "AND "
    read = read[:-4]
    read += ')'
    try:
        try:
            cursor = cnx.cursor(as_dict=True)
            cursor.execute(read)
        except pymssql._pymssql.InterfaceError:
            print("reconnecting...")
            cnx = mssql_connect(mssql_params)
            cursor = cnx.cursor(as_dict=True)
            cursor.execute(read)
        a = cursor.fetchall()
        cursor.close()
        return a
    except Exception as e:
        raise TypeError("sql_read_where:%s" % e)

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

def sql_read_where_attribute(table_name, d_where, attributes=None):
    import pymssql
    global cnx, mssql_params

    # Use '*' if no attributes are provided
    if attributes is None:
        attributes_str = "*"
    else:
        # Join the attributes into a string for the SQL query
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

def obtener_puntos_usuario(usuario_id):
    import pymssql
    global cnx, mssql_params
    
    # Consulta para obtener la suma de puntos de retos
    query_retos = """
    SELECT COALESCE(SUM(r.PUNTAJE), 0) AS puntos_retos
    FROM USUARIOS_RETOS ur
    JOIN RETOS r ON ur.ID_RETO = r.ID_RETO
    WHERE ur.ID_USUARIO = %s AND ur.COMPLETADO = 1;
    """
    
    # Consulta para obtener la suma de puntos de eventos
    query_eventos = """
    SELECT COALESCE(SUM(e.PUNTAJE), 0) AS puntos_eventos
    FROM USUARIOS_EVENTOS ue
    JOIN EVENTOS e ON ue.EVENTO = e.ID_EVENTO
    WHERE ue.USUARIO = %s AND ue.ASISTIO = 1;
    """
    
    # Consulta para obtener la suma de puntos gastados en beneficios
    query_beneficios = """
    SELECT COALESCE(SUM(b.PUNTOS), 0) AS puntos_beneficios
    FROM USUARIOS_BENEFICIOS ub
    JOIN BENEFICIOS b ON ub.BENEFICIO = b.ID_BENEFICIO
    WHERE ub.USUARIO = %s AND ub.CANJEADO = 1;
    """
    
    try:
        # Sumar puntos de retos
        cursor = cnx.cursor(as_dict=True)
        cursor.execute(query_retos, (usuario_id,))
        puntos_retos = cursor.fetchone()['puntos_retos']

        # Sumar puntos de eventos
        cursor.execute(query_eventos, (usuario_id,))
        puntos_eventos = cursor.fetchone()['puntos_eventos']

        # Sumar puntos gastados en beneficios
        cursor.execute(query_beneficios, (usuario_id,))
        puntos_beneficios = cursor.fetchone()['puntos_beneficios']

        # Calcular puntos totales
        total_puntos = puntos_retos + puntos_eventos - puntos_beneficios
        cursor.close()
        return total_puntos

    except Exception as e:
        raise TypeError(f"obtener_puntos_usuario: {e}")


if __name__ == '__main__':
    import json
    mssql_params = {}
    mssql_params['DB_HOST'] = '100.80.80.7'
    mssql_params['DB_NAME'] = 'alumno01'
    mssql_params['DB_USER'] = 'SA'
    mssql_params['DB_PASSWORD'] = 'Shakira123.'
    cnx = mssql_connect(mssql_params)

    # Do your thing
    try:
        rx = sql_read_all('users')
        print(json.dumps(rx, indent=4))
        input("press Enter to continue...")
        rx = read_user_data('users', 'hugo')
        print(rx)
        input("press Enter to continue...")
        print("Querying for user 'paco'...")
        d_where = {'username': 'paco'}
        rx = sql_read_where('users', d_where)
        print(rx)
        input("press Enter to continue...")
        print("Inserting user 'otro'...")
        rx = sql_insert_row_into('users',{'username': 'otro', 'password': 'otro123'})
        print("Inserted record", rx)
        rx = sql_read_all('users')
        print(json.dumps(rx, indent=4))
        input("press Enter to continue...")
        print("Modifying password for user 'otro'...")
        d_field = {'password': 'otro456'}
        d_where = {'username': 'otro'}
        sql_update_where('users', d_field, d_where)
        print("Record updated")
        rx = sql_read_all('users')
        print(json.dumps(rx, indent=4))
        input("press Enter to continue...")
        print("Deleting user 'otro'...")
        d_where = {'username': 'otro'}
        sql_delete_where('users', d_where)
        print("Record deleted")
        rx = sql_read_all('users')
        print(json.dumps(rx, indent=4))
    except Exception as e:
        print(e)
    cnx.close()