USE library_db;

-- 10 Libros Semilla
INSERT INTO libros (isbn, titulo, autor, editorial, anio_publicacion, stock_total, stock_disponible) VALUES
('978-0131103627', 'El lenguaje de programación C', 'Brian W. Kernighan', 'Prentice Hall', 1988, 5, 5),
('978-0201616224', 'Design Patterns', 'Erich Gamma', 'Addison-Wesley', 1994, 3, 3),
('978-0132350884', 'Clean Code', 'Robert C. Martin', 'Prentice Hall', 2008, 10, 10),
('978-0134685991', 'Effective Java', 'Joshua Bloch', 'Addison-Wesley', 2017, 7, 7),
('978-1449331818', 'Learning Python', 'Mark Lutz', 'O''Reilly Media', 2013, 8, 8),
('978-0201144710', 'An Introduction to Database Systems', 'C.J. Date', 'Addison-Wesley', 2003, 4, 4),
('978-1492056300', 'Designing Data-Intensive Applications', 'Martin Kleppmann', 'O''Reilly Media', 2017, 6, 6),
('978-0134092669', 'Computer Networking', 'James Kurose', 'Pearson', 2016, 5, 5),
('978-0262033848', 'Introduction to Algorithms', 'Thomas H. Cormen', 'MIT Press', 2009, 3, 3),
('978-1491950357', 'Building Microservices', 'Sam Newman', 'O''Reilly Media', 2021, 5, 5);

-- 10 Socios Semilla
INSERT INTO socios (dni, nombre, apellidos, email, telefono, fecha_registro) VALUES
('11111111A', 'Carlos', 'Gómez', 'carlos.gomez@email.com', '555-0001', '2025-01-15'),
('22222222B', 'Ana', 'Pérez', 'ana.perez@email.com', '555-0002', '2025-02-10'),
('33333333C', 'Luis', 'Martínez', 'luis.martinez@email.com', '555-0003', '2025-03-05'),
('44444444D', 'María', 'López', 'maria.lopez@email.com', '555-0004', '2025-04-20'),
('55555555E', 'Jorge', 'Hernández', 'jorge.hernandez@email.com', '555-0005', '2025-05-11'),
('66666666F', 'Laura', 'Díaz', 'laura.diaz@email.com', '555-0006', '2025-06-30'),
('77777777G', 'Pedro', 'Sánchez', 'pedro.sanchez@email.com', '555-0007', '2025-07-22'),
('88888888H', 'Sofía', 'Ramírez', 'sofia.ramirez@email.com', '555-0008', '2025-08-14'),
('99999999I', 'Miguel', 'Torres', 'miguel.torres@email.com', '555-0009', '2025-09-01'),
('00000000J', 'Lucía', 'Flores', 'lucia.flores@email.com', '555-0010', '2025-10-18');

INSERT INTO prestamos (id_libro, id_socio, fecha_prestamo, fecha_devolucion_esperada, estado) VALUES
(1, 1, '2026-05-01', '2026-05-15', 'ACTIVO'),
(2, 2, '2026-05-02', '2026-05-16', 'ACTIVO'),
(3, 3, '2026-05-03', '2026-05-17', 'ACTIVO');

-- Simular libros devueltos
INSERT INTO prestamos (id_libro, id_socio, fecha_prestamo, fecha_devolucion_esperada, estado) VALUES
(4, 4, '2026-04-01', '2026-04-15', 'ACTIVO');
UPDATE prestamos SET estado = 'DEVUELTO', fecha_devolucion_real = '2026-04-14' WHERE id_libro = 4 AND id_socio = 4;

INSERT INTO prestamos (id_libro, id_socio, fecha_prestamo, fecha_devolucion_esperada, estado) VALUES
(5, 5, '2026-04-05', '2026-04-20', 'ACTIVO');
UPDATE prestamos SET estado = 'DEVUELTO', fecha_devolucion_real = '2026-04-19' WHERE id_libro = 5 AND id_socio = 5;

-- Más activos
INSERT INTO prestamos (id_libro, id_socio, fecha_prestamo, fecha_devolucion_esperada, estado) VALUES
(6, 6, '2026-05-04', '2026-05-18', 'ACTIVO'),
(7, 7, '2026-05-04', '2026-05-18', 'ACTIVO'),
(8, 8, '2026-05-05', '2026-05-19', 'ACTIVO'),
(9, 9, '2026-05-05', '2026-05-19', 'ACTIVO'),
(10, 10, '2026-05-05', '2026-05-19', 'ACTIVO');
