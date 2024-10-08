USE icaritasborregos;
GO CREATE PROCEDURE sp_AddUsuarioEvento @UsuarioID numeric(18, 0),
    @EventoID numeric(18, 0) AS BEGIN
INSERT INTO USUARIOS_EVENTOS (USUARIO, EVENTO)
VALUES (@UsuarioID, @EventoID)
END
GO USE iborregos;
GO CREATE PROCEDURE sp_DeleteUsuarioEvento @UsuarioID numeric(18, 0),
    @EventoID numeric(18, 0) AS BEGIN
DELETE FROM USUARIOS_EVENTOS
WHERE USUARIO = @UsuarioID
    AND EVENTO = @EventoID
END
GO USE iborregos;
GO CREATE PROCEDURE sp_SelectEvento @EventoID numeric(18, 0) AS BEGIN
SELECT *
FROM EVENTOS
WHERE ID_EVENTO = @EventoID;
END
GO -- Adding extended properties
    EXEC sp_addextendedproperty @name = N'Column_Description',
    @value = 'Empleado / Voluntario',
    @level0type = N'Schema',
    @level0name = 'dbo',
    @level1type = N'Table',
    @level1name = 'USUARIOS',
    @level2type = N'Column',
    @level2name = 'ID_TIPO_USUARIO';
GO CREATE PROCEDURE GetPendingUserChallenges @ID_USUARIO NUMERIC(18, 0) AS BEGIN
SELECT R.ID_RETO,
    R.NOMBRE,
    R.DESCRIPCION,
    R.PUNTAJE
FROM RETOS R
    JOIN USUARIOS_RETOS UR ON R.ID_RETO = UR.ID_RETO
WHERE UR.ID_USUARIO = @ID_USUARIO
    AND UR.COMPLETADO = 0;
-- 0 represents 'false' for the bit field
END;
SELECT *
FROM USUARIOS_EVENTOS;
USE icaritasborregos;
GO 

CREATE PROCEDURE GetRetoStats @ID_USUARIO NUMERIC(18, 0) AS BEGIN -- Count total number of RETOS
DECLARE @TotalRetos INT;
DECLARE @CompletedRetos INT;

-- Count total RETOS
SELECT @TotalRetos = COUNT(*)
FROM RETOS;

-- Count completed RETOS by the user
SELECT @CompletedRetos = COUNT(*)
FROM USUARIOS_RETOS
WHERE ID_USUARIO = @ID_USUARIO
    AND COMPLETADO = 1;

-- Return the results
SELECT @TotalRetos AS TotalRetos,
    @CompletedRetos AS CompletedRetos;
END;
GO 

CREATE PROCEDURE GetRecentDatosFisicosByUsuario @ID_USUARIO NUMERIC(18, 0) AS BEGIN
SELECT TOP 5 *
FROM DATOS_FISICOS
WHERE ID_USUARIO = @ID_USUARIO
ORDER BY FECHA_ACTUALIZACION DESC;
END;
GO

CREATE PROCEDURE AddUsuarioBeneficio
    @beneficio_id NUMERIC(18,0),
    @usuario_id NUMERIC(18,0)
AS
BEGIN
    -- Insert the new record into the USUARIOS_BENEFICIOS table
    INSERT INTO [USUARIOS_BENEFICIOS] ([USUARIO], [BENEFICIO], [CANJEADO])
    VALUES (@usuario_id, @beneficio_id, 0);  -- Set CANJEADO to 0 (default not redeemed)

    -- Optionally, you can add error handling or checks before the insert if needed
END;
GO
