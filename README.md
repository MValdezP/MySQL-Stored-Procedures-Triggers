Library DB Lab
Laboratorio de Base de Datos relacional para la gestión de una biblioteca, desarrollado como práctica para la materia de Bases de Datos II. Este proyecto implementa un diseño DDL versionado, procedimientos almacenados (Stored Procedures), triggers para auditoría y control de stock automático, todo compatible con MySQL 8.0+.

Modelo de Datos (Diagrama ER)
+-------------------+       +-----------------------+       +-------------------+
|      SOCIOS       |       |       PRESTAMOS       |       |      LIBROS       |
+-------------------+       +-----------------------+       +-------------------+
| PK id_socio       |<------| FK id_socio           |   +-->| PK id_libro       |
| UQ dni            |       | FK id_libro           |---+   | UQ isbn           |
|    nombre         |       |    fecha_prestamo     |       |    titulo         |
|    apellidos      |       |    fecha_dev_esperada |       |    autor          |
| UQ email          |       |    fecha_dev_real     |       |    editorial      |
|    telefono       |       |    estado             |       |    anio_publicacion|
|    fecha_registro |       +-----------------------+       |    stock_total    |
+-------------------+                   |                   |    stock_disponible|
                                        |                   +-------------------+
                                        v
                            +-----------------------+
                            |  AUDITORIA_PRESTAMOS  |
                            +-----------------------+
                            | PK id_auditoria       |
                            |    id_prestamo        |
                            |    accion             |
                            |    fecha_accion       |
                            |    usuario_db         |
                            |    detalles           |
                            +-----------------------+
Estructura del Proyecto
sql/V1__init_schema.sql: Script DDL para creación de la base de datos y tablas con restricciones e integridad referencial en snake_case.
sql/procedures.sql: Procedimientos almacenados transaccionales con manejo de errores (SIGNAL SQLSTATE) para la lógica de negocio.
sql/triggers.sql: Triggers automáticos que gestionan auditorías (AFTER INSERT, AFTER UPDATE) y el control del stock.
sql/seed_data.sql: Datos de prueba realistas (mínimo 10 registros por tabla).
sql/test_queries.sql: Consultas y llamadas a los procedures para demostrar y validar su correcto funcionamiento.
Instrucciones de Ejecución
Para desplegar esta base de datos en tu entorno local (Terminal o Workbench), ejecuta los scripts estrictamente en el siguiente orden:

# 1. Crear el esquema y las tablas base
mysql -u tu_usuario -p < sql/V1__init_schema.sql

# 2. Crear los procedimientos almacenados
mysql -u tu_usuario -p < sql/procedures.sql

# 3. Crear los triggers automatizados
mysql -u tu_usuario -p < sql/triggers.sql

# 4. Poblar con datos de prueba
mysql -u tu_usuario -p < sql/seed_data.sql

# 5. Ejecutar script de validación (Verificar salidas)
mysql -u tu_usuario -p < sql/test_queries.sql
Ejemplos de Uso (Stored Procedures)
1. Registrar un Préstamo
Busca un libro y un socio, verifica que haya stock disponible usando bloqueos transaccionales y asienta el registro.

-- Parámetros: p_id_libro, p_id_socio, p_dias_prestamo
CALL registrar_prestamo(3, 1, 14);
2. Devolver un Libro
Registra la devolución marcando la fecha actual. Los triggers devolverán el stock e insertarán un log en la auditoría de manera automática.

-- Parámetros: p_id_prestamo
CALL devolver_libro(1);
3. Buscar Libros Disponibles
Permite al bibliotecario buscar libros en el inventario por título o autor, mostrando solo los que tienen stock_disponible > 0.

-- Parámetros: p_termino_busqueda
CALL buscar_libros_disponibles('Data');
