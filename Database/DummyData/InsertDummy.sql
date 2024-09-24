USE iborregos;
-- Insert dummy data into TIPO_USUARIO
INSERT INTO [TIPO_USUARIO] ([DESCRIPCION])
VALUES
('Empleado'),
('Voluntario');

-- Insert dummy data into USUARIOS
INSERT INTO [USUARIOS] ([NOMBRE], [A_PATERNO], [A_MATERNO], [ID_TIPO_USUARIO], [EMAIL], [CONTRASENA])
VALUES
('Juan', 'Perez', 'Lopez', 1, 'juan.perez@example.com', 'password1'),
('Maria', 'Gonzalez', 'Ramirez', 2, 'maria.gonzalez@example.com', 'password2'),
('Luis', 'Martinez', 'Fernandez', 1, 'luis.martinez@example.com', 'password3');

INSERT INTO [EVENTOS] ([NOMBRE], [DESCRIPCION], [NUM_MAX_ASISTENTES], [PUNTAJE], [FECHA_EVENTO])
VALUES
('Conferencia de Tecnología', 'Evento sobre los últimos avances en tecnología', 200, 50, '2023-10-15'),
('Feria de Emprendimiento', 'Feria para promover startups y negocios locales', 150, 40, '2023-11-01'),
('Taller de Programación', 'Taller intensivo de programación en Python', 100, 30, '2023-11-20');

-- Insert dummy data into DATOS_FISICOS
INSERT INTO [DATOS_FISICOS] ([ID_USUARIO], [PESO], [ALTURA], [IMC], [GLUCOSA], [FECHA_ACTUALIZACION])
VALUES
(1, 70.5, 1.75, 23.1, 90.0, GETDATE()),
(2, 65.0, 1.60, 25.4, 85.0, GETDATE()),
(3, 80.0, 1.80, 24.7, 92.0, GETDATE());

-- Insert dummy data into BENEFICIOS
INSERT INTO [BENEFICIOS] ([NOMBRE], [DESCRIPCION], [PUNTOS])
VALUES
('Descuento en Cafetería', 'Descuento del 10% en productos de la cafetería', 20),
('Acceso VIP', 'Acceso VIP a eventos especiales', 50);

-- Insert dummy data into USUARIOS_BENEFICIOS
INSERT INTO [USUARIOS_BENEFICIOS] ([USUARIO], [BENEFICIO])
VALUES
(1, 1),
(2, 2),
(3, 1);

-- Insert dummy data into RETOS
INSERT INTO [RETOS] ([NOMBRE], [DESCRIPCION], [PUNTAJE])
VALUES
('Reto de Ejercicio', 'Completar 10,000 pasos diarios por una semana', 100),
('Reto de Lectura', 'Leer 5 libros en un mes', 150);

-- Insert dummy data into USUARIOS_RETOS
INSERT INTO [USUARIOS_RETOS] ([ID], [ID_RETO])
VALUES
(1, 1),
(2, 2),
(3, 1);

-- Insert dummy data into HISTORICO
INSERT INTO [HISTORICO] ([ID_USUARIO], [FECHA_MOV], [ID_TIPO], [FECHA])
VALUES
(1, GETDATE(), 1, GETDATE()),
(2, GETDATE(), 2, GETDATE()),
(3, GETDATE(), 1, GETDATE());

-- Insert dummy data into USUARIOS_EVENTOS
INSERT INTO [USUARIOS_EVENTOS] ([USUARIO], [EVENTO])
VALUES
(1, 1),
(2, 2),
(3, 3);
