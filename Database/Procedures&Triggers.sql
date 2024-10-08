USE iborregos;
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
GO

-- Adding extended properties
EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Empleado / Voluntario',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'USUARIOS',
@level2type = N'Column', @level2name = 'ID_TIPO_USUARIO';
GO

CREATE PROCEDURE GetPendingUserChallenges
    @ID_USUARIO NUMERIC(18, 0)
AS
BEGIN
    SELECT R.ID_RETO, R.NOMBRE, R.DESCRIPCION, R.PUNTAJE
    FROM RETOS R
    JOIN USUARIOS_RETOS UR ON R.ID_RETO = UR.ID_RETO
    WHERE UR.ID_USUARIO = @ID_USUARIO
    AND UR.COMPLETADO = 0;  -- 0 represents 'false' for the bit field
END;