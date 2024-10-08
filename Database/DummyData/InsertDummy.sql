-- Insert dummy data into TIPO_USUARIO
INSERT INTO [TIPO_USUARIO] ([DESCRIPCION])
VALUES ('Empleado'),
    ('Voluntario');
GO -- Insert dummy data into USUARIOS
INSERT INTO [USUARIOS] (
        [NOMBRE],
        [A_PATERNO],
        [A_MATERNO],
        [ID_TIPO_USUARIO],
        [EMAIL],
        [CONTRASENA]
    )
VALUES (
        'Juan',
        'Perez',
        'Lopez',
        1,
        'juan.perez@example.com',
        '5befcc27e2914043f55ed389cb70be744ccec8508cf58805affd3b45a25e22c2'
    ),
    (
        'Maria',
        'Gonzalez',
        'Ramirez',
        2,
        'maria.gonzalez@example.com',
        'bfc462ff679df02ae974cb06f0d088c47f0e32062e5eb98501e911beba4803d4'
    ),
    (
        'Luis',
        'Martinez',
        'Fernandez',
        1,
        'luis.martinez@example.com',
        'cb7d19fc0969d10cb9cddbc94b5b1293ad5628039e0a015492c91322fe671e9d'
    );
GO -- Insert dummy data into EVENTOS
INSERT INTO [EVENTOS] (
        [NOMBRE],
        [DESCRIPCION],
        [NUM_MAX_ASISTENTES],
        [PUNTAJE],
        [FECHA_EVENTO]
    )
VALUES (
        'Conferencia de Tecnología',
        'Evento sobre los últimos avances en tecnología',
        200,
        50,
        '2023-10-15'
    ),
    (
        'Feria de Emprendimiento',
        'Feria para promover startups y negocios locales',
        150,
        40,
        '2023-11-01'
    ),
    (
        'Taller de Programación',
        'Taller intensivo de programación en Python',
        100,
        30,
        '2023-11-20'
    );
GO -- Insert dummy data into DATOS_FISICOS
INSERT INTO [DATOS_FISICOS] (
        [ID_USUARIO],
        [PESO],
        [ALTURA],
        [IMC],
        [GLUCOSA],
        [FECHA_ACTUALIZACION]
    )
VALUES (1, 70.5, 1.75, 23.1, 90.0, GETDATE()),
    (2, 65.0, 1.60, 25.4, 85.0, GETDATE()),
    (3, 80.0, 1.80, 24.7, 92.0, GETDATE());
GO -- Insert dummy data into BENEFICIOS
INSERT INTO [BENEFICIOS] ([NOMBRE], [DESCRIPCION], [PUNTOS])
VALUES (
        'Descuento en Cafetería',
        'Descuento del 10% en productos de la cafetería',
        20
    ),
    (
        'Acceso VIP',
        'Acceso VIP a eventos especiales',
        50
    );
GO -- Insert dummy data into USUARIOS_BENEFICIOS
INSERT INTO [USUARIOS_BENEFICIOS] ([USUARIO], [BENEFICIO])
VALUES (1, 1),
    (2, 2),
    (3, 1);
GO -- Insert dummy data into RETOS
INSERT INTO [RETOS] ([NOMBRE], [DESCRIPCION], [PUNTAJE])
VALUES (
        'Reto de Ejercicio',
        'Completar 10,000 pasos diarios por una semana',
        100
    ),
    (
        'Reto de Lectura',
        'Leer 5 libros en un mes',
        150
    );
GO -- Insert dummy data into USUARIOS_RETOS
INSERT INTO [USUARIOS_RETOS] ([ID_RETO], [ID_USUARIO], [COMPLETADO])
VALUES (1, 1, 0),
    (2, 2, 1),
    (1, 3, 0);
GO -- Insert dummy data into HISTORICO
INSERT INTO [HISTORICO] ([ID_USUARIO], [FECHA_MOV], [ID_TIPO], [FECHA])
VALUES (1, GETDATE(), 1, GETDATE()),
    (2, GETDATE(), 2, GETDATE()),
    (3, GETDATE(), 1, GETDATE());
GO -- Insert dummy data into USUARIOS_EVENTOS
INSERT INTO [USUARIOS_EVENTOS] ([USUARIO], [EVENTO], [ASISTIO])
VALUES (1, 1, 0),
    (2, 2, 1),
    (3, 3, 0);
GO

SELECT * FROM USUARIOS_EVENTOS;