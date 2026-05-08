USE library_db;

-- PRUEBAS Y VERIFICACIONES DEL LABORATORIO

-- 1. Verificación Inicial de Stock
-- Comprobamos cómo quedó el stock después del seed_data 
SELECT '--- 1. ESTADO DEL STOCK ---' AS Test;
SELECT id_libro, titulo, stock_total, stock_disponible FROM libros WHERE id_libro IN (1, 4, 10);

-- 2. Prueba del Procedure: registrar_prestamo (y trigger de resta de stock)
-- Registramos un préstamo del libro 3 (Clean Code) para el socio 1 por 14 días
SELECT '--- 2. REGISTRANDO NUEVO PRESTAMO ---' AS Test;
CALL registrar_prestamo(3, 1, 14);

-- Verificamos el stock de Clean Code (debería haber bajado en 1)
SELECT id_libro, titulo, stock_total, stock_disponible FROM libros WHERE id_libro = 3;

-- 3. Prueba de la Auditoría (Trigger 1)
-- Verificamos que se haya registrado la acción en auditoria_prestamos
SELECT '--- 3. REGISTROS DE AUDITORIA ---' AS Test;
SELECT * FROM auditoria_prestamos ORDER BY fecha_accion DESC LIMIT 5;

-- 4. Prueba del Procedure: devolver_libro (y trigger de suma de stock)
-- Buscamos el último préstamo creado
SELECT MAX(id_prestamo) INTO @ultimo_prestamo FROM prestamos;

-- Llamamos al procedure de devolución
SELECT '--- 4. DEVOLVIENDO LIBRO ---' AS Test;
CALL devolver_libro(@ultimo_prestamo);

-- Verificamos el estado del préstamo
SELECT * FROM prestamos WHERE id_prestamo = @ultimo_prestamo;

-- Verificamos nuevamente el stock del libro (debería haber vuelto a subir)
SELECT id_libro, titulo, stock_total, stock_disponible FROM libros WHERE id_libro = 3;

-- Comprobamos si la devolución se auditó
SELECT * FROM auditoria_prestamos ORDER BY fecha_accion DESC LIMIT 2;

-- 5. Prueba del Procedure: buscar_libros_disponibles
SELECT '--- 5. BUSCAR LIBROS POR TERMINO "Data" ---' AS Test;
CALL buscar_libros_disponibles('Data');

-- 6. Prueba de Manejo de Errores (Exceptions / Signal)
SELECT '--- 6. PRUEBA DE ERRORES (Revisar output de MySQL) ---' AS Test;

-- Descomentar para probar: Intentar devolver un libro ya devuelto (Lanzará Error 45000)
-- CALL devolver_libro(@ultimo_prestamo);

-- Descomentar para probar: Intentar prestar un libro sin stock o inexistente (Lanzará Error 45000)
-- CALL registrar_prestamo(999, 1, 14);
