USE library_db;

DELIMITER //

CREATE PROCEDURE registrar_prestamo(
    IN p_id_libro INT,
    IN p_id_socio INT,
    IN p_dias_prestamo INT
)
BEGIN
    DECLARE v_stock_disponible INT;
    DECLARE v_estado_socio INT;
    
    -- Manejo de errores
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    -- Validar que el libro exista y tenga stock
    SELECT stock_disponible INTO v_stock_disponible 
    FROM libros WHERE id_libro = p_id_libro FOR UPDATE;
    
    IF v_stock_disponible IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El libro no existe.';
    ELSEIF v_stock_disponible <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: No hay stock disponible para este libro.';
    END IF;
    
    -- Validar que el socio exista
    SELECT COUNT(*) INTO v_estado_socio FROM socios WHERE id_socio = p_id_socio;
    IF v_estado_socio = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El socio no existe.';
    END IF;
    
    -- Insertar el préstamo
    INSERT INTO prestamos (id_libro, id_socio, fecha_prestamo, fecha_devolucion_esperada, estado)
    VALUES (p_id_libro, p_id_socio, CURDATE(), DATE_ADD(CURDATE(), INTERVAL p_dias_prestamo DAY), 'ACTIVO');
    
    -- El trigger se encargará de actualizar el stock
    
    COMMIT;
END //

CREATE PROCEDURE devolver_libro(
    IN p_id_prestamo INT
)
BEGIN
    DECLARE v_estado VARCHAR(20);
    
    -- Manejo de errores
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    -- Bloquear el registro para evitar concurrencia
    SELECT estado INTO v_estado FROM prestamos WHERE id_prestamo = p_id_prestamo FOR UPDATE;
    
    IF v_estado IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El préstamo no existe.';
    ELSEIF v_estado = 'DEVUELTO' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El libro ya ha sido devuelto anteriormente.';
    END IF;
    
    -- Actualizar el préstamo
    UPDATE prestamos 
    SET fecha_devolucion_real = CURDATE(),
        estado = 'DEVUELTO'
    WHERE id_prestamo = p_id_prestamo;
    
    -- El trigger se encargará de actualizar el stock de regreso
    
    COMMIT;
END //

CREATE PROCEDURE buscar_libros_disponibles(
    IN p_termino_busqueda VARCHAR(100)
)
BEGIN
    SELECT 
        id_libro,
        isbn,
        titulo,
        autor,
        editorial,
        stock_total,
        stock_disponible
    FROM libros
    WHERE (titulo LIKE CONCAT('%', p_termino_busqueda, '%') 
           OR autor LIKE CONCAT('%', p_termino_busqueda, '%'))
      AND stock_disponible > 0
    ORDER BY titulo;
END //

DELIMITER ;
