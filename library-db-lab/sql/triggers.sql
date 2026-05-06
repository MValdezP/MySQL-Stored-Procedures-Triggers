USE library_db;

DELIMITER //

-- Trigger 1: Auditoría de nuevos préstamos (AFTER INSERT)
CREATE TRIGGER trg_audit_prestamos_insert
AFTER INSERT ON prestamos
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_prestamos (
        id_prestamo, 
        accion, 
        usuario_db, 
        detalles
    ) VALUES (
        NEW.id_prestamo,
        'NUEVO_PRESTAMO',
        CURRENT_USER(),
        CONCAT('Préstamo registrado. Socio: ', NEW.id_socio, ', Libro: ', NEW.id_libro, ', Fecha devolución esperada: ', NEW.fecha_devolucion_esperada)
    );
END //

-- Trigger 2: Actualización de stock al crear préstamo (AFTER INSERT)
CREATE TRIGGER trg_update_stock_prestamo_insert
AFTER INSERT ON prestamos
FOR EACH ROW
BEGIN
    UPDATE libros 
    SET stock_disponible = stock_disponible - 1
    WHERE id_libro = NEW.id_libro;
END //

-- Trigger 3: Actualización de stock y auditoría al devolver préstamo (AFTER UPDATE)
CREATE TRIGGER trg_update_stock_prestamo_update
AFTER UPDATE ON prestamos
FOR EACH ROW
BEGIN
    -- Si el estado cambia a DEVUELTO, aumentamos el stock disponible
    IF OLD.estado != 'DEVUELTO' AND NEW.estado = 'DEVUELTO' THEN
        UPDATE libros 
        SET stock_disponible = stock_disponible + 1
        WHERE id_libro = NEW.id_libro;
        
        -- Registrar en auditoría la devolución
        INSERT INTO auditoria_prestamos (
            id_prestamo, 
            accion, 
            usuario_db, 
            detalles
        ) VALUES (
            NEW.id_prestamo,
            'DEVOLUCION_LIBRO',
            CURRENT_USER(),
            CONCAT('Libro devuelto. Socio: ', NEW.id_socio, ', Libro: ', NEW.id_libro, ', Fecha devolución real: ', NEW.fecha_devolucion_real)
        );
    END IF;
END //

DELIMITER ;
