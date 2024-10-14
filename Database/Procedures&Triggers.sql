USE icaritasborregos;
GO 
CREATE PROCEDURE sp_AddUsuarioEvento @UsuarioID numeric(18, 0),
    @EventoID numeric(18, 0) AS BEGIN
INSERT INTO USUARIOS_EVENTOS (USUARIO, EVENTO)
VALUES (@UsuarioID, @EventoID)
END;
GO 
CREATE PROCEDURE sp_DeleteUsuarioEvento @UsuarioID numeric(18, 0),
    @EventoID numeric(18, 0) AS BEGIN
DELETE FROM USUARIOS_EVENTOS
WHERE USUARIO = @UsuarioID
    AND EVENTO = @EventoID
END;
GO 
CREATE PROCEDURE sp_SelectEvento @EventoID numeric(18, 0) AS BEGIN
SELECT *
FROM EVENTOS
WHERE ID_EVENTO = @EventoID;
END;
GO
CREATE PROCEDURE GetPendingUserChallenges @ID_USUARIO NUMERIC(18, 0) AS BEGIN
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
GO 
CREATE PROCEDURE GetRetoStats @ID_USUARIO NUMERIC(18, 0) AS BEGIN -- Count total number of RETOS
DECLARE @TotalRetos INT;
DECLARE @CompletedRetos INT;
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
CREATE PROCEDURE AddUsuarioBeneficio @beneficio_id NUMERIC(18, 0),
    @usuario_id NUMERIC(18, 0) AS BEGIN -- Insert the new record into the USUARIOS_BENEFICIOS table
INSERT INTO [USUARIOS_BENEFICIOS] ([USUARIO], [BENEFICIO], [CANJEADO])
VALUES (@usuario_id, @beneficio_id, 0);
-- Set CANJEADO to 0 (default not redeemed)
-- Optionally, you can add error handling or checks before the insert if needed
END;
GO -- Obtener puntos
    CREATE PROCEDURE GetUserTotalPoints @usuario_id NUMERIC(18, 0) AS BEGIN -- CTE for total points from completed challenges (retos)
    WITH TotalRetoPoints AS (
        SELECT SUM(R.PUNTAJE) AS RetoPoints
        FROM USUARIOS_RETOS UR
            JOIN RETOS R ON UR.ID_RETO = R.ID_RETO
        WHERE UR.ID_USUARIO = @usuario_id
            AND UR.COMPLETADO = 1
    ),
    -- CTE for total points from attended events
    TotalEventPoints AS (
        SELECT SUM(E.PUNTAJE) AS EventPoints
        FROM USUARIOS_EVENTOS UE
            JOIN EVENTOS E ON UE.EVENTO = E.ID_EVENTO
        WHERE UE.USUARIO = @usuario_id
            AND UE.ASISTIO = 1
    ),
    -- CTE for total points from redeemed benefits (premios)
    TotalPremiosPoints AS (
        SELECT SUM(B.PUNTOS) AS PremiosPoints
        FROM USUARIOS_BENEFICIOS UB
            JOIN BENEFICIOS B ON UB.BENEFICIO = B.ID_BENEFICIO
        WHERE UB.USUARIO = @usuario_id
    ) -- Final SELECT to return the calculated total points
SELECT COALESCE(RetoPoints, 0) + COALESCE(EventPoints, 0) - COALESCE(PremiosPoints, 0) AS TotalPoints
FROM TotalRetoPoints,
    TotalEventPoints,
    TotalPremiosPoints;
END;
GO 
EXEC GetUserTotalPoints @usuario_id = 1;
EXEC sp_helptext 'GetUserTotalPoints';
SELECT *
FROM USUARIOS;