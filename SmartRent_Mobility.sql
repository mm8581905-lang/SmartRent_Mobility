USE master;
GO
IF DB_ID(N'SmartRentMobility') IS NULL
BEGIN
    EXEC(N'CREATE DATABASE SmartRentMobility');
END;
GO
USE SmartRentMobility;
GO

IF OBJECT_ID('dbo.Calificaciones', 'U') IS NOT NULL DROP TABLE dbo.Calificaciones;
IF OBJECT_ID('dbo.Peritajes', 'U') IS NOT NULL DROP TABLE dbo.Peritajes;
IF OBJECT_ID('dbo.Contratos', 'U') IS NOT NULL DROP TABLE dbo.Contratos;
IF OBJECT_ID('dbo.ReservaSeguros', 'U') IS NOT NULL DROP TABLE dbo.ReservaSeguros;
IF OBJECT_ID('dbo.Reservas', 'U') IS NOT NULL DROP TABLE dbo.Reservas;
IF OBJECT_ID('dbo.Seguros', 'U') IS NOT NULL DROP TABLE dbo.Seguros;
IF OBJECT_ID('dbo.Vehiculos', 'U') IS NOT NULL DROP TABLE dbo.Vehiculos;
IF OBJECT_ID('dbo.Usuarios', 'U') IS NOT NULL DROP TABLE dbo.Usuarios;
GO

CREATE TABLE dbo.Usuarios (
    usuario_id INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    documento VARCHAR(20) NOT NULL UNIQUE,
    correo VARCHAR(100) NOT NULL UNIQUE,
    telefono VARCHAR(20) NOT NULL,
    rol VARCHAR(20) NOT NULL,
    estado VARCHAR(15) NOT NULL DEFAULT 'Activo',
    fecha_registro DATE NOT NULL DEFAULT (CONVERT(date, GETDATE()))
);

CREATE TABLE dbo.Vehiculos (
    vehiculo_id INT IDENTITY(1,1) PRIMARY KEY,
    proveedor_id INT NOT NULL,
    marca VARCHAR(40) NOT NULL,
    modelo VARCHAR(40) NOT NULL,
    categoria VARCHAR(30) NOT NULL DEFAULT 'Intermedio',
    transmision VARCHAR(15) NOT NULL DEFAULT 'Automatica',
    anio INT NOT NULL,
    placa VARCHAR(10) NOT NULL UNIQUE,
    tarifa_diaria DECIMAL(10,2) NOT NULL,
    estado VARCHAR(15) NOT NULL DEFAULT 'Disponible',
    kilometraje INT NOT NULL DEFAULT 0,
    FOREIGN KEY (proveedor_id) REFERENCES dbo.Usuarios(usuario_id)
);

CREATE TABLE dbo.Seguros (
    seguro_id INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(60) NOT NULL UNIQUE,
    descripcion VARCHAR(150) NOT NULL,
    costo_diario DECIMAL(10,2) NOT NULL,
    deducible DECIMAL(10,2) NOT NULL DEFAULT 0,
    activo BIT NOT NULL DEFAULT 1
);

CREATE TABLE dbo.Reservas (
    reserva_id INT IDENTITY(1,1) PRIMARY KEY,
    arrendatario_id INT NOT NULL,
    vehiculo_id INT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'Confirmada',
    total_base DECIMAL(12,2) NOT NULL,
    fecha_creacion DATE NOT NULL DEFAULT (CONVERT(date, GETDATE())),
    FOREIGN KEY (arrendatario_id) REFERENCES dbo.Usuarios(usuario_id),
    FOREIGN KEY (vehiculo_id) REFERENCES dbo.Vehiculos(vehiculo_id)
);

CREATE TABLE dbo.ReservaSeguros (
    reserva_seguro_id INT IDENTITY(1,1) PRIMARY KEY,
    reserva_id INT NOT NULL,
    seguro_id INT NOT NULL,
    costo_total DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (reserva_id) REFERENCES dbo.Reservas(reserva_id),
    FOREIGN KEY (seguro_id) REFERENCES dbo.Seguros(seguro_id),
    UNIQUE (reserva_id, seguro_id)
);

CREATE TABLE dbo.Contratos (
    contrato_id INT IDENTITY(1,1) PRIMARY KEY,
    reserva_id INT NOT NULL UNIQUE,
    codigo VARCHAR(25) NOT NULL UNIQUE,
    fecha_firma DATE NOT NULL,
    penalizacion DECIMAL(10,2) NOT NULL DEFAULT 0,
    estado VARCHAR(20) NOT NULL DEFAULT 'Firmado',
    total_final DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (reserva_id) REFERENCES dbo.Reservas(reserva_id)
);

CREATE TABLE dbo.Peritajes (
    peritaje_id INT IDENTITY(1,1) PRIMARY KEY,
    reserva_id INT NOT NULL,
    tipo VARCHAR(10) NOT NULL,
    kilometraje INT NOT NULL,
    combustible INT NOT NULL,
    cantidad_fotos INT NOT NULL DEFAULT 8,
    observaciones VARCHAR(180) NOT NULL,
    fecha_registro DATE NOT NULL,
    FOREIGN KEY (reserva_id) REFERENCES dbo.Reservas(reserva_id)
);

CREATE TABLE dbo.Calificaciones (
    calificacion_id INT IDENTITY(1,1) PRIMARY KEY,
    reserva_id INT NOT NULL UNIQUE,
    calificador_id INT NOT NULL,
    calificado_id INT NOT NULL,
    puntuacion INT NOT NULL,
    comentario VARCHAR(180) NOT NULL,
    fecha_calificacion DATE NOT NULL,
    FOREIGN KEY (reserva_id) REFERENCES dbo.Reservas(reserva_id),
    FOREIGN KEY (calificador_id) REFERENCES dbo.Usuarios(usuario_id),
    FOREIGN KEY (calificado_id) REFERENCES dbo.Usuarios(usuario_id)
);
GO

ALTER TABLE dbo.Vehiculos
ADD geocerca_activa BIT NOT NULL DEFAULT 0;
GO

INSERT INTO dbo.Usuarios (nombre, apellido, documento, correo, telefono, rol, fecha_registro) VALUES
    (N'Carlos', N'Gómez', 'CC100001', 'usuario1@smartrent.com', '3001000001', N'Proveedor', '2026-01-01'),
    (N'Andrea', N'Rodríguez', 'CC100002', 'usuario2@smartrent.com', '3001000002', N'Proveedor', '2026-01-04'),
    (N'Jorge', N'Martínez', 'CC100003', 'usuario3@smartrent.com', '3001000003', N'Proveedor', '2026-01-07'),
    (N'Laura', N'López', 'CC100004', 'usuario4@smartrent.com', '3001000004', N'Proveedor', '2026-01-10'),
    (N'Felipe', N'Hernández', 'CC100005', 'usuario5@smartrent.com', '3001000005', N'Proveedor', '2026-01-13'),
    (N'Valentina', N'Pérez', 'CC100006', 'usuario6@smartrent.com', '3001000006', N'Arrendatario', '2026-01-16'),
    (N'Santiago', N'Ramírez', 'CC100007', 'usuario7@smartrent.com', '3001000007', N'Arrendatario', '2026-01-19'),
    (N'Camila', N'Torres', 'CC100008', 'usuario8@smartrent.com', '3001000008', N'Arrendatario', '2026-01-22'),
    (N'Andrés', N'Díaz', 'CC100009', 'usuario9@smartrent.com', '3001000009', N'Arrendatario', '2026-01-25'),
    (N'Natalia', N'Vargas', 'CC100010', 'usuario10@smartrent.com', '3001000010', N'Arrendatario', '2026-01-28'),
    (N'Daniel', N'Castro', 'CC100011', 'usuario11@smartrent.com', '3001000011', N'Arrendatario', '2026-01-31'),
    (N'Mariana', N'Moreno', 'CC100012', 'usuario12@smartrent.com', '3001000012', N'Arrendatario', '2026-02-03'),
    (N'Sebastián', N'Rojas', 'CC100013', 'usuario13@smartrent.com', '3001000013', N'Arrendatario', '2026-02-06'),
    (N'Paula', N'Jiménez', 'CC100014', 'usuario14@smartrent.com', '3001000014', N'Arrendatario', '2026-02-09'),
    (N'Mateo', N'Muñoz', 'CC100015', 'usuario15@smartrent.com', '3001000015', N'Arrendatario', '2026-02-12'),
    (N'Isabella', N'Álvarez', 'CC100016', 'usuario16@smartrent.com', '3001000016', N'Arrendatario', '2026-02-15'),
    (N'David', N'Romero', 'CC100017', 'usuario17@smartrent.com', '3001000017', N'Arrendatario', '2026-02-18'),
    (N'Gabriela', N'Suárez', 'CC100018', 'usuario18@smartrent.com', '3001000018', N'Arrendatario', '2026-02-21'),
    (N'Juan', N'Restrepo', 'CC100019', 'usuario19@smartrent.com', '3001000019', N'Arrendatario', '2026-02-24'),
    (N'Lucía', N'Cárdenas', 'CC100020', 'usuario20@smartrent.com', '3001000020', N'Arrendatario', '2026-02-27');

INSERT INTO dbo.Vehiculos (proveedor_id, marca, modelo, categoria, transmision, anio, placa, tarifa_diaria, estado, kilometraje) VALUES
    (1, N'Toyota', N'Corolla', N'Intermedio', N'Automatica', 2021, 'SMR001', 140000.00, N'Disponible', 19250),
    (2, N'Mazda', N'3', N'Intermedio', N'Automatica', 2022, 'SMR002', 155000.00, N'Disponible', 20500),
    (3, N'Chevrolet', N'Onix', N'Intermedio', N'Automatica', 2023, 'SMR003', 170000.00, N'Disponible', 21750),
    (4, N'Kia', N'Cerato', N'Intermedio', N'Automatica', 2024, 'SMR004', 185000.00, N'Disponible', 23000),
    (5, N'Hyundai', N'Elantra', N'Intermedio', N'Automatica', 2025, 'SMR005', 200000.00, N'Alquilado', 24250),
    (1, N'Nissan', N'Sentra', N'Intermedio', N'Automatica', 2026, 'SMR006', 140000.00, N'Disponible', 25500),
    (2, N'Renault', N'Logan', N'Intermedio', N'Automatica', 2021, 'SMR007', 155000.00, N'Disponible', 26750),
    (3, N'Volkswagen', N'Jetta', N'Intermedio', N'Automatica', 2022, 'SMR008', 170000.00, N'Disponible', 28000),
    (4, N'Honda', N'Civic', N'Intermedio', N'Automatica', 2023, 'SMR009', 185000.00, N'Disponible', 29250),
    (5, N'Toyota', N'Yaris', N'Intermedio', N'Automatica', 2024, 'SMR010', 200000.00, N'Alquilado', 30500),
    (1, N'Mazda', N'3 Touring', N'Intermedio', N'Automatica', 2025, 'SMR011', 140000.00, N'Disponible', 31750),
    (2, N'Kia', N'Forte', N'Intermedio', N'Automatica', 2026, 'SMR012', 155000.00, N'Disponible', 33000),
    (3, N'Hyundai', N'Accent', N'Intermedio', N'Automatica', 2021, 'SMR013', 170000.00, N'Disponible', 34250),
    (4, N'Nissan', N'Versa', N'Intermedio', N'Automatica', 2022, 'SMR014', 185000.00, N'Disponible', 35500),
    (5, N'Chevrolet', N'Cruze', N'Intermedio', N'Automatica', 2023, 'SMR015', 200000.00, N'Alquilado', 36750),
    (1, N'Volkswagen', N'Virtus', N'Intermedio', N'Automatica', 2024, 'SMR016', 140000.00, N'Disponible', 38000),
    (2, N'Honda', N'City', N'Intermedio', N'Automatica', 2025, 'SMR017', 155000.00, N'Disponible', 39250),
    (3, N'Renault', N'Fluence', N'Intermedio', N'Automatica', 2026, 'SMR018', 170000.00, N'Disponible', 40500),
    (4, N'Toyota', N'Corolla Cross', N'Intermedio', N'Automatica', 2021, 'SMR019', 185000.00, N'Disponible', 41750),
    (5, N'Mazda', N'CX-30', N'Intermedio', N'Automatica', 2022, 'SMR020', 200000.00, N'Alquilado', 43000);

INSERT INTO dbo.Seguros (nombre, descripcion, costo_diario, deducible) VALUES
    (N'Seguro Básico', N'Responsabilidad civil básica', 12000.00, 1500000.00),
    (N'Protección Parcial', N'Cobertura parcial de daños', 18000.00, 1200000.00),
    (N'Protección Ampliada', N'Cobertura ampliada', 25000.00, 900000.00),
    (N'Protección contra Robo', N'Cobertura contra robo según contrato', 22000.00, 1000000.00),
    (N'Asistencia Vial', N'Asistencia en carretera', 8000.00, 0.00),
    (N'Protección de Vidrios', N'Cobertura de vidrios', 7000.00, 250000.00),
    (N'Protección de Llantas', N'Cobertura de llantas', 6000.00, 200000.00),
    (N'Terceros Plus', N'Responsabilidad civil ampliada', 15000.00, 1000000.00),
    (N'Plan Tranquilidad', N'Protección complementaria', 28000.00, 800000.00),
    (N'Protección Urbana', N'Cobertura adicional urbana', 11000.00, 900000.00),
    (N'Protección Viajero', N'Asistencia durante el viaje', 9000.00, 0.00),
    (N'Daños Menores', N'Cobertura de daños menores', 13000.00, 500000.00),
    (N'Protección Familiar', N'Asistencia para viajes familiares', 16000.00, 700000.00),
    (N'Plan Carretera', N'Asistencia ampliada en carretera', 12000.00, 0.00),
    (N'Protección Premium', N'Coberturas ampliadas', 35000.00, 600000.00),
    (N'Cobertura Accidente', N'Cobertura complementaria de accidente', 20000.00, 1000000.00),
    (N'Asistencia Mecánica', N'Asistencia por fallas cubiertas', 10000.00, 0.00),
    (N'Protección Ocupantes', N'Protección para ocupantes', 14000.00, 750000.00),
    (N'Plan Flexible', N'Cobertura adicional flexible', 17000.00, 850000.00),
    (N'Cobertura Integral', N'Paquete integral sujeto al contrato', 40000.00, 500000.00);

INSERT INTO dbo.Reservas (arrendatario_id, vehiculo_id, fecha_inicio, fecha_fin, estado, total_base, fecha_creacion) VALUES
    (6, 1, '2026-01-05', '2026-01-08', N'Confirmada', 420000.00, '2025-12-29'),
    (7, 2, '2026-01-10', '2026-01-14', N'Finalizada', 620000.00, '2026-01-03'),
    (8, 3, '2026-01-15', '2026-01-20', N'Confirmada', 850000.00, '2026-01-08'),
    (9, 4, '2026-01-20', '2026-01-22', N'Finalizada', 370000.00, '2026-01-13'),
    (10, 5, '2026-01-25', '2026-01-28', N'Confirmada', 600000.00, '2026-01-18'),
    (11, 6, '2026-01-30', '2026-02-03', N'Finalizada', 560000.00, '2026-01-23'),
    (12, 7, '2026-02-04', '2026-02-09', N'Confirmada', 775000.00, '2026-01-28'),
    (13, 8, '2026-02-09', '2026-02-11', N'Finalizada', 340000.00, '2026-02-02'),
    (14, 9, '2026-02-14', '2026-02-17', N'Confirmada', 555000.00, '2026-02-07'),
    (15, 10, '2026-02-19', '2026-02-23', N'Finalizada', 800000.00, '2026-02-12'),
    (16, 11, '2026-02-24', '2026-03-01', N'Confirmada', 700000.00, '2026-02-17'),
    (17, 12, '2026-03-01', '2026-03-03', N'Finalizada', 310000.00, '2026-02-22'),
    (18, 13, '2026-03-06', '2026-03-09', N'Confirmada', 510000.00, '2026-02-27'),
    (19, 14, '2026-03-11', '2026-03-15', N'Finalizada', 740000.00, '2026-03-04'),
    (20, 15, '2026-03-16', '2026-03-21', N'Confirmada', 1000000.00, '2026-03-09'),
    (6, 16, '2026-03-21', '2026-03-23', N'Finalizada', 280000.00, '2026-03-14'),
    (7, 17, '2026-03-26', '2026-03-29', N'Confirmada', 465000.00, '2026-03-19'),
    (8, 18, '2026-03-31', '2026-04-04', N'Finalizada', 680000.00, '2026-03-24'),
    (9, 19, '2026-04-05', '2026-04-10', N'Confirmada', 925000.00, '2026-03-29'),
    (10, 20, '2026-04-10', '2026-04-12', N'Finalizada', 400000.00, '2026-04-03');

INSERT INTO dbo.ReservaSeguros (reserva_id, seguro_id, costo_total) VALUES
    (1, 1, 36000.00),
    (2, 2, 72000.00),
    (3, 3, 125000.00),
    (4, 4, 44000.00),
    (5, 5, 24000.00),
    (6, 6, 28000.00),
    (7, 7, 30000.00),
    (8, 8, 30000.00),
    (9, 9, 84000.00),
    (10, 10, 44000.00),
    (11, 11, 45000.00),
    (12, 12, 26000.00),
    (13, 13, 48000.00),
    (14, 14, 48000.00),
    (15, 15, 175000.00),
    (16, 16, 40000.00),
    (17, 17, 30000.00),
    (18, 18, 56000.00),
    (19, 19, 85000.00),
    (20, 20, 80000.00);

INSERT INTO dbo.Contratos (reserva_id, codigo, fecha_firma, penalizacion, estado, total_final) VALUES
    (1, 'SMR-2026-001', '2026-01-03', 0.00, N'Firmado', 456000.00),
    (2, 'SMR-2026-002', '2026-01-08', 0.00, N'Cerrado', 692000.00),
    (3, 'SMR-2026-003', '2026-01-13', 0.00, N'Firmado', 975000.00),
    (4, 'SMR-2026-004', '2026-01-18', 0.00, N'Cerrado', 414000.00),
    (5, 'SMR-2026-005', '2026-01-23', 0.00, N'Firmado', 624000.00),
    (6, 'SMR-2026-006', '2026-01-28', 25000.00, N'Cerrado', 613000.00),
    (7, 'SMR-2026-007', '2026-02-02', 0.00, N'Firmado', 805000.00),
    (8, 'SMR-2026-008', '2026-02-07', 0.00, N'Cerrado', 370000.00),
    (9, 'SMR-2026-009', '2026-02-12', 0.00, N'Firmado', 639000.00),
    (10, 'SMR-2026-010', '2026-02-17', 0.00, N'Cerrado', 844000.00),
    (11, 'SMR-2026-011', '2026-02-22', 0.00, N'Firmado', 745000.00),
    (12, 'SMR-2026-012', '2026-02-27', 25000.00, N'Cerrado', 361000.00),
    (13, 'SMR-2026-013', '2026-03-04', 0.00, N'Firmado', 558000.00),
    (14, 'SMR-2026-014', '2026-03-09', 0.00, N'Cerrado', 788000.00),
    (15, 'SMR-2026-015', '2026-03-14', 0.00, N'Firmado', 1175000.00),
    (16, 'SMR-2026-016', '2026-03-19', 0.00, N'Cerrado', 320000.00),
    (17, 'SMR-2026-017', '2026-03-24', 0.00, N'Firmado', 495000.00),
    (18, 'SMR-2026-018', '2026-03-29', 25000.00, N'Cerrado', 761000.00),
    (19, 'SMR-2026-019', '2026-04-03', 0.00, N'Firmado', 1010000.00),
    (20, 'SMR-2026-020', '2026-04-08', 0.00, N'Cerrado', 480000.00);

INSERT INTO dbo.Peritajes (reserva_id, tipo, kilometraje, combustible, cantidad_fotos, observaciones, fecha_registro) VALUES
    (1, 'Check-in', 19250, 100, 8, 'Estado del vehiculo registrado al entregar.', '2026-01-05'),
    (1, 'Check-out', 19610, 75, 8, 'Estado del vehiculo registrado al devolver.', '2026-01-08'),
    (2, 'Check-in', 20500, 100, 8, 'Estado del vehiculo registrado al entregar.', '2026-01-10'),
    (2, 'Check-out', 20980, 75, 8, 'Estado del vehiculo registrado al devolver.', '2026-01-14'),
    (3, 'Check-in', 21750, 100, 8, 'Estado del vehiculo registrado al entregar.', '2026-01-15'),
    (3, 'Check-out', 22350, 75, 8, 'Estado del vehiculo registrado al devolver.', '2026-01-20'),
    (4, 'Check-in', 23000, 100, 8, 'Estado del vehiculo registrado al entregar.', '2026-01-20'),
    (4, 'Check-out', 23240, 75, 8, 'Estado del vehiculo registrado al devolver.', '2026-01-22'),
    (5, 'Check-in', 24250, 100, 8, 'Estado del vehiculo registrado al entregar.', '2026-01-25'),
    (5, 'Check-out', 24610, 75, 8, 'Estado del vehiculo registrado al devolver.', '2026-01-28'),
    (6, 'Check-in', 25500, 100, 8, 'Estado del vehiculo registrado al entregar.', '2026-01-30'),
    (6, 'Check-out', 25980, 75, 8, 'Estado del vehiculo registrado al devolver.', '2026-02-03'),
    (7, 'Check-in', 26750, 100, 8, 'Estado del vehiculo registrado al entregar.', '2026-02-04'),
    (7, 'Check-out', 27350, 75, 8, 'Estado del vehiculo registrado al devolver.', '2026-02-09'),
    (8, 'Check-in', 28000, 100, 8, 'Estado del vehiculo registrado al entregar.', '2026-02-09'),
    (8, 'Check-out', 28240, 75, 8, 'Estado del vehiculo registrado al devolver.', '2026-02-11'),
    (9, 'Check-in', 29250, 100, 8, 'Estado del vehiculo registrado al entregar.', '2026-02-14'),
    (9, 'Check-out', 29610, 75, 8, 'Estado del vehiculo registrado al devolver.', '2026-02-17'),
    (10, 'Check-in', 30500, 100, 8, 'Estado del vehiculo registrado al entregar.', '2026-02-19'),
    (10, 'Check-out', 30980, 75, 8, 'Estado del vehiculo registrado al devolver.', '2026-02-23'),
    (11, 'Check-in', 31750, 100, 8, 'Estado del vehiculo registrado al entregar.', '2026-02-24'),
    (11, 'Check-out', 32350, 75, 8, 'Estado del vehiculo registrado al devolver.', '2026-03-01'),
    (12, 'Check-in', 33000, 100, 8, 'Estado del vehiculo registrado al entregar.', '2026-03-01'),
    (12, 'Check-out', 33240, 75, 8, 'Estado del vehiculo registrado al devolver.', '2026-03-03'),
    (13, 'Check-in', 34250, 100, 8, 'Estado del vehiculo registrado al entregar.', '2026-03-06'),
    (13, 'Check-out', 34610, 75, 8, 'Estado del vehiculo registrado al devolver.', '2026-03-09'),
    (14, 'Check-in', 35500, 100, 8, 'Estado del vehiculo registrado al entregar.', '2026-03-11'),
    (14, 'Check-out', 35980, 75, 8, 'Estado del vehiculo registrado al devolver.', '2026-03-15'),
    (15, 'Check-in', 36750, 100, 8, 'Estado del vehiculo registrado al entregar.', '2026-03-16'),
    (15, 'Check-out', 37350, 75, 8, 'Estado del vehiculo registrado al devolver.', '2026-03-21'),
    (16, 'Check-in', 38000, 100, 8, 'Estado del vehiculo registrado al entregar.', '2026-03-21'),
    (16, 'Check-out', 38240, 75, 8, 'Estado del vehiculo registrado al devolver.', '2026-03-23'),
    (17, 'Check-in', 39250, 100, 8, 'Estado del vehiculo registrado al entregar.', '2026-03-26'),
    (17, 'Check-out', 39610, 75, 8, 'Estado del vehiculo registrado al devolver.', '2026-03-29'),
    (18, 'Check-in', 40500, 100, 8, 'Estado del vehiculo registrado al entregar.', '2026-03-31'),
    (18, 'Check-out', 40980, 75, 8, 'Estado del vehiculo registrado al devolver.', '2026-04-04'),
    (19, 'Check-in', 41750, 100, 8, 'Estado del vehiculo registrado al entregar.', '2026-04-05'),
    (19, 'Check-out', 42350, 75, 8, 'Estado del vehiculo registrado al devolver.', '2026-04-10'),
    (20, 'Check-in', 43000, 100, 8, 'Estado del vehiculo registrado al entregar.', '2026-04-10'),
    (20, 'Check-out', 43240, 75, 8, 'Estado del vehiculo registrado al devolver.', '2026-04-12');

INSERT INTO dbo.Calificaciones (reserva_id, calificador_id, calificado_id, puntuacion, comentario, fecha_calificacion) VALUES
    (1, 6, 1, 4, N'El vehículo estaba limpio y en buen estado.', '2026-01-09'),
    (2, 7, 2, 5, N'La reserva fue fácil de realizar.', '2026-01-15'),
    (3, 8, 3, 3, N'Buena atención y entrega puntual.', '2026-01-21'),
    (4, 9, 4, 4, N'El vehículo estaba limpio y en buen estado.', '2026-01-23'),
    (5, 10, 5, 5, N'La reserva fue fácil de realizar.', '2026-01-29'),
    (6, 11, 1, 3, N'Buena atención y entrega puntual.', '2026-02-04'),
    (7, 12, 2, 4, N'El vehículo estaba limpio y en buen estado.', '2026-02-10'),
    (8, 13, 3, 5, N'La reserva fue fácil de realizar.', '2026-02-12'),
    (9, 14, 4, 3, N'Buena atención y entrega puntual.', '2026-02-18'),
    (10, 15, 5, 4, N'El vehículo estaba limpio y en buen estado.', '2026-02-24'),
    (11, 16, 1, 5, N'La reserva fue fácil de realizar.', '2026-03-02'),
    (12, 17, 2, 3, N'Buena atención y entrega puntual.', '2026-03-04'),
    (13, 18, 3, 4, N'El vehículo estaba limpio y en buen estado.', '2026-03-10'),
    (14, 19, 4, 5, N'La reserva fue fácil de realizar.', '2026-03-16'),
    (15, 20, 5, 3, N'Buena atención y entrega puntual.', '2026-03-22'),
    (16, 6, 1, 4, N'El vehículo estaba limpio y en buen estado.', '2026-03-24'),
    (17, 7, 2, 5, N'La reserva fue fácil de realizar.', '2026-03-30'),
    (18, 8, 3, 3, N'Buena atención y entrega puntual.', '2026-04-05'),
    (19, 9, 4, 4, N'El vehículo estaba limpio y en buen estado.', '2026-04-11'),
    (20, 10, 5, 5, N'La reserva fue fácil de realizar.', '2026-04-13');

UPDATE dbo.Vehiculos
SET estado = 'Alquilado'
WHERE vehiculo_id = 1;
GO

SELECT marca, COUNT(*) AS cantidad, AVG(tarifa_diaria) AS tarifa_promedio
FROM dbo.Vehiculos
WHERE estado = 'Disponible'
  AND categoria = 'Intermedio'
  AND transmision = 'Automatica'
GROUP BY marca
HAVING COUNT(*) >= 1
ORDER BY marca;

SELECT u.nombre, u.apellido, COUNT(c.contrato_id) AS contratos_cerrados,
       SUM(c.total_final) AS ingresos_totales
FROM dbo.Usuarios AS u
INNER JOIN dbo.Vehiculos AS v ON u.usuario_id = v.proveedor_id
INNER JOIN dbo.Reservas AS r ON v.vehiculo_id = r.vehiculo_id
INNER JOIN dbo.Contratos AS c ON r.reserva_id = c.reserva_id
WHERE u.rol = 'Proveedor' AND c.estado = 'Cerrado'
GROUP BY u.nombre, u.apellido
HAVING SUM(c.total_final) > 0
ORDER BY ingresos_totales DESC;

SELECT u.nombre, u.apellido, COUNT(r.reserva_id) AS cantidad_reservas,
       SUM(r.total_base) AS total_base_reservas
FROM dbo.Usuarios AS u
INNER JOIN dbo.Reservas AS r ON u.usuario_id = r.arrendatario_id
WHERE u.rol = 'Arrendatario'
GROUP BY u.nombre, u.apellido
HAVING COUNT(r.reserva_id) > 1
ORDER BY cantidad_reservas DESC;

SELECT u.nombre, u.apellido, COUNT(ca.calificacion_id) AS cantidad_calificaciones,
       AVG(CAST(ca.puntuacion AS DECIMAL(5,2))) AS promedio_estrellas
FROM dbo.Usuarios AS u
INNER JOIN dbo.Calificaciones AS ca ON u.usuario_id = ca.calificado_id
WHERE u.rol = 'Proveedor'
GROUP BY u.nombre, u.apellido
HAVING COUNT(ca.calificacion_id) >= 1
ORDER BY promedio_estrellas DESC;

SELECT c.codigo, c.fecha_firma, c.total_final, u.nombre AS cliente, v.marca, v.modelo
FROM dbo.Contratos AS c
INNER JOIN dbo.Reservas AS r ON c.reserva_id = r.reserva_id
INNER JOIN dbo.Usuarios AS u ON r.arrendatario_id = u.usuario_id
INNER JOIN dbo.Vehiculos AS v ON r.vehiculo_id = v.vehiculo_id
WHERE c.fecha_firma >= '2026-01-01' AND c.fecha_firma < '2026-07-01'
ORDER BY c.fecha_firma;

SELECT s.nombre, COUNT(rs.reserva_seguro_id) AS veces_usado,
       SUM(rs.costo_total) AS costo_acumulado, AVG(rs.costo_total) AS costo_promedio
FROM dbo.Seguros AS s
INNER JOIN dbo.ReservaSeguros AS rs ON s.seguro_id = rs.seguro_id
GROUP BY s.nombre
HAVING SUM(rs.costo_total) > 0
ORDER BY costo_acumulado DESC;

SELECT r.reserva_id, r.fecha_inicio, r.fecha_fin, r.estado, c.codigo AS contrato
FROM dbo.Reservas AS r
LEFT JOIN dbo.Contratos AS c ON r.reserva_id = c.reserva_id
ORDER BY r.fecha_inicio;
