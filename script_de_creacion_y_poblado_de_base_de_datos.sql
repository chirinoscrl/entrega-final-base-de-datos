-- ###################################################################
-- ########## SCRIPS DE CREACIÓN DE BASE DE DATOS Y TABLAS ###########
-- ###################################################################

CREATE DATABASE IF NOT EXISTS finanzas_personales_db;

CREATE TABLE `divisa` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(50) NOT NULL,
  `fecha_registro` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
);

CREATE TABLE `categoria_meta` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(50) NOT NULL,
  `descripcion` VARCHAR(50) NULL,
  `fecha_registro` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
);

CREATE TABLE `entidad_bancaria` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(150) NOT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `franquicia` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(80) NOT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `tipo_cuenta` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(50) NOT NULL,
  `descripcion` VARCHAR(50) NULL,
  `fecha_registro` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
);

CREATE TABLE `categoria_transaccion` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(50) NOT NULL,
  `descripcion` VARCHAR(50) NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `usuario` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  `correo_electronico` VARCHAR(50) NOT NULL,
  `contrasena` VARCHAR(20) NOT NULL,
  `estado` BOOLEAN NOT NULL DEFAULT 0,
  `fecha_registro` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `id_divisa` INT NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`id_divisa`) REFERENCES `divisa` (`id`)
);

CREATE TABLE `meta` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(50) NOT NULL,
  `descripcion` VARCHAR(120) NULL,
  `valor` INT NOT NULL,
  `fecha_final` DATETIME NOT NULL,
  `fecha_registro` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `id_usuario` INT NOT NULL,
  `id_categoria_meta` INT NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id`),
  FOREIGN KEY (`id_categoria_meta`) REFERENCES `categoria_meta` (`id`)
);

CREATE TABLE `abono_meta` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `valor` INT NOT NULL,
  `fecha_registro` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `id_meta` INT NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`id_meta`) REFERENCES `meta` (`id`)
);

CREATE TABLE `tipo_interes` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `prestamo` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `monto` INT NOT NULL DEFAULT 0,
  `plazo` INT NOT NULL DEFAULT 0,
  `tasa_interes` FLOAT NOT NULL DEFAULT 0,
  `fecha_pago` DATETIME NOT NULL,
  `fecha_inicio` DATETIME NOT NULL,
  `fecha_registro` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `id_usuario` INT NOT NULL,
  `id_entidad_bancaria` INT NOT NULL,
  `id_tipo_interes` INT NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id`),
  FOREIGN KEY (`id_entidad_bancaria`) REFERENCES `entidad_bancaria` (`id`),
  FOREIGN KEY (`id_tipo_interes`) REFERENCES `tipo_interes` (`id`)
);

CREATE TABLE `abono_prestamo` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `valor` INT NOT NULL,
  `fecha_registro` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `id_prestamo` INT NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`id_prestamo`) REFERENCES `prestamo` (`id`)
);

CREATE TABLE `tarjeta_credito` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(50) NOT NULL,
  `descripcion` VARCHAR(50) NULL,
  `fecha_corte` DATETIME NOT NULL,
  `fecha_limite_pago` DATETIME NOT NULL,
  `limite_maximo_credito` INT NOT NULL,
  `fecha_registro` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `id_usuario` INT NOT NULL,
  `id_franquicia` INT NOT NULL,
  `id_entidad_bancaria` INT NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id`),
  FOREIGN KEY (`id_franquicia`) REFERENCES `franquicia` (`id`),
  FOREIGN KEY (`id_entidad_bancaria`) REFERENCES `entidad_bancaria` (`id`)
);

CREATE TABLE `cuenta` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `descripcion` VARCHAR(50) NOT NULL,
  `saldo_disponible` INT NOT NULL,
  `fecha_registro` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `id_tipo_cuenta` INT NOT NULL,
  `id_entidad_bancaria` INT NOT NULL,
  `id_usuario` INT NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`id_tipo_cuenta`) REFERENCES `tipo_cuenta` (`id`),
  FOREIGN KEY (`id_entidad_bancaria`) REFERENCES `entidad_bancaria` (`id`),
  FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id`)
);

CREATE TABLE `tipo_transaccion` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(50) NOT NULL,
  `descripcion` VARCHAR(50) NULL,
  `id_categoria_transaccion` INT NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`id_categoria_transaccion`) REFERENCES `categoria_transaccion` (`id`)
);

CREATE TABLE `transaccion` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `valor` INT NOT NULL,
  `fecha_transaccion` DATETIME NOT NULL,
  `id_usuario` INT NOT NULL,
  `id_cuenta` INT NOT NULL,
  `id_categoria_transaccion` INT NOT NULL,
  `id_tipo_transaccion` INT NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`id_cuenta`) REFERENCES `cuenta` (`id`),
  FOREIGN KEY (`id_categoria_transaccion`) REFERENCES `categoria_transaccion` (`id`),
  FOREIGN KEY (`id_tipo_transaccion`) REFERENCES `tipo_transaccion` (`id`)
);


-- #####################################################
-- ########## SCRIPS PARA POBLAR DE TABLAS #############
-- #####################################################

INSERT INTO divisa(id, nombre)
VALUES (1, 'Dólar'),
       (2, 'Peso Mexicano'),
       (3, 'Euro');

INSERT INTO usuario (id, nombre, correo_electronico, contrasena, estado, fecha_registro, id_divisa)
VALUES (1, 'Juan Pérez', 'juan@mail.com', '123456', 1, '2020-05-14', 1),
       (2, 'María López', 'maria@mail.com', 'qwerty', 1, '2020-05-14', 2),
       (3, 'Luis Torres', 'luis@mail.com', '987654', 1, '2020-05-14', 3),
       (4, 'Lucía García', 'lucia@mail.com', 'lucia123', 1, '2020-05-14', 1),
       (5, 'Pedro Ruiz', 'pedro@mail.com', 'tucutucu1', 1, '2020-05-14', 2),
       (6, 'Mónica Zapata', 'monica@mail.com', 'b624ndsi7', 1, '2020-05-14', 3),
       (7, 'Pablo Reyes', 'pablo@mail.com', 'cl4v3p4bl0', 1, '2020-05-14', 1),
       (8, 'Ana Cortéz', 'ana@mail.com', 'anit4555', 1, '2020-05-14', 2),
       (9, 'Carlos Pineda', 'carlos@mail.com', 'p1n3d4', 1, '2020-05-14', 3),
       (10, 'Patricia Mora', 'patricia@mail.com', 'm0r4p4t1', 0, '2020-05-14', 1);

INSERT INTO categoria_meta(id, nombre, descripcion, fecha_registro)
VALUES (1, 'Viajes y transporte', 'Categoria de metas relacionadas a viajes', '2020-01-01'),
       (2, 'Educación', 'Categoria de metas educativas o cursos', '2020-01-01');

INSERT INTO meta (id, nombre, descripcion, valor, fecha_final, id_usuario, id_categoria_meta, fecha_registro)
VALUES (1, 'Viaje a Brasil', 'Juntar para viaje fin de año', 5000, '2023-11-30', 1, 1, '2023-05-14'),
       (2, 'Comprar auto', 'Ahorrar para compra de auto', 15000, '2023-12-01', 1, 1, '2023-02-09'),
       (3, 'Curso de Inglés', 'Juntar para curso de ingles intenstivo', 1000, '2023-08-15', 2, 2, '2022-10-30'),
       (4, 'Pasaje a España', 'Ahorrar para viaje a España en 2023', 2000, '2023-06-30', 1, 1, '2023-01-04'),
       (5, 'Pasajes a Chile', 'Ir de vacaciones a la nieve ', 600, '2023-07-20', 1, 1, '2023-07-11');

INSERT INTO `abono_meta` (`valor`, `id_meta`)
VALUES (200, 1),
       (250, 1),
       (300, 1),
       (500, 2),
       (600, 2),
       (900, 2),
       (100, 3),
       (160, 3),
       (70, 5),
       (80, 5),
       (90, 5);

INSERT INTO entidad_bancaria(id, nombre)
VALUES (1, 'Mi Banco SA'),
       (2, 'Banco Galicia'),
       (3, 'Macro');

INSERT INTO tipo_cuenta(id, nombre, descripcion)
VALUES (1, 'Cuenta Ahorros', 'Cuenta para ahorrar dinero'),
       (2, 'Cuenta Corriente', 'Cuenta para manejo diario de dinero'),
       (3, 'Cuenta Conjunta', 'Cuenta compartida entre varias personas'),
       (4, 'Cuenta de Estudiante', 'Cuenta especial para estudiantes');

INSERT INTO `cuenta` (id, `descripcion`, `saldo_disponible`, `id_tipo_cuenta`, `id_entidad_bancaria`, `id_usuario`)
VALUES (1, 'Caja de Ahorros para la universidad', 15000000, 1, 1, 1),
       (2, 'Cuenta principal para gastos diarios', 8000000, 2, 1, 2),
       (3, 'Cuenta remunerada para fondos de emergencia', 12000000, 3, 2, 1),
       (4, 'Depósito a largo plazo para comprar una casa', 35000000, 4, 2, 2);

INSERT INTO franquicia(id, nombre)
VALUES (1, 'Visa'),
       (2, 'Mastercard'),
       (3, 'American Express');

-- Faltan campos fechaCorte y fechaLimitePago (estos campos son tipo Int y aceptan valores entre 1 a 31)------------------------------------------------------
INSERT INTO tarjeta_credito (id, nombre, descripcion, fecha_corte, fecha_limite_pago, limite_maximo_credito, id_usuario,
                             id_franquicia, id_entidad_bancaria)
VALUES (1, 'Visa Platinum', 'Para compras importantes e internacionales', '2023-08-22', '2023-09-03', 30000, 1, 1, 1),
       (2, 'MasterCard Gold', 'Para entretenimiento y estilo de vida', '2023-08-24', '2023-09-05', 45000, 2, 2, 2),
       (3, 'Visa Signature', 'Para viajes y alojamiento', '2023-08-26', '2023-09-07', 80000, 3, 1, 1),
       (4, 'MasterCard Black', 'Para compras de lujo', '2023-08-28', '2023-09-09', 100000, 4, 2, 2),
       (5, 'Visa Classic', 'Para compras diarias y esenciales', '2023-08-30', '2023-09-11', 20000, 5, 1, 1),
       (6, 'MasterCard Standard', 'Para gastos generales', '2023-09-02', '2023-09-13', 28000, 6, 2, 2),
       (7, 'Visa Gold', 'Para compras en línea', '2023-09-04', '2023-09-15', 35000, 7, 1, 1),
       (8, 'MasterCard Platinum', 'Para viajes aéreos y recompensas', '2023-09-06', '2023-09-17', 50000, 8, 2, 2),
       (9, 'Visa Business', 'Para gastos de negocio', '2023-09-08', '2023-09-19', 60000, 9, 1, 1),
       (10, 'MasterCard Business', 'Para cuentas de publicidad y gastos comerciales', '2023-09-10', '2023-09-21', 88000,
        10, 2, 2);

INSERT INTO tipo_interes(nombre)
VALUES ('Efectivo Anual'),
       ('Nominal Anual'),
       ('Nominal Mensual');

-- Falta campo 'tipoInteres' (coumpuesto, mensual, anual, etc) y 'fechaPago' (tipo Int y acepta valores entre 1 y 31)------------------------------------------------------
INSERT INTO prestamo(monto, plazo, tasa_interes, fecha_pago, fecha_inicio, id_usuario, id_entidad_bancaria,
                     id_tipo_interes)
VALUES (50000, 36, 6.5, '2026-09-10', '2023-09-10', 1, 1, 1),
       (20000, 12, 5.0, '2024-09-10', '2023-09-10', 2, 2, 1),
       (30000, 24, 3.5, '2025-09-10', '2023-09-10', 3, 1, 2),
       (60000, 60, 4.0, '2028-09-10', '2023-09-10', 4, 2, 1),
       (70000, 48, 6.0, '2027-09-10', '2023-09-10', 5, 1, 1),
       (40000, 30, 7.0, '2026-03-10', '2023-09-10', 6, 2, 2),
       (90000, 72, 5.5, '2029-09-10', '2023-09-10', 7, 1, 1),
       (100000, 84, 8.0, '2031-02-10', '2023-09-10', 8, 2, 3),
       (25000, 18, 4.5, '2025-03-10', '2023-09-10', 9, 1, 3),
       (35000, 24, 6.5, '2025-09-10', '2023-09-10', 10, 2, 1);

INSERT INTO abono_prestamo(valor, id_prestamo, fecha_registro)
VALUES (1389, 1, '2023-10-10'),
       (1389, 1, '2023-11-10'),
       (1389, 1, '2023-12-10'),
       (1389, 1, '2024-01-10'),
       (1389, 1, '2026-09-10'),
       (1667, 2, '2023-10-10'),
       (1667, 2, '2023-11-10'),
       (1667, 2, '2023-12-10'),
       (1667, 2, '2024-01-10'),
       (1667, 2, '2024-09-10'),
       (1250, 3, '2023-10-10'),
       (1250, 3, '2023-11-10'),
       (1250, 3, '2023-12-10'),
       (1250, 3, '2024-01-10');


INSERT INTO categoria_transaccion(id, nombre, descripcion)
VALUES (1, 'Ingresos', 'Ingresos de dinero'),
       (2, 'Gastos fijos', 'Gastos fijos mensuales'),
       (3, 'Gastos variables', 'Otros gastos mensuales variables');

INSERT INTO tipo_transaccion(id, nombre, descripcion, id_categoria_transaccion)
VALUES (1, 'Comida y restaurantes', 'Gastos en comer afuera', 3),
       (2, 'Supermercado', 'Gastos en supermercado', 2),
       (3, 'Sueldo', 'Depositos de sueldo', 1),
       (4, 'Intereses', 'Intereses ganados', 1),
       (5, 'Alquiler', 'Pago de alquiler', 2),
       (6, 'Impuestos', 'Pago de impuestos', 2);

INSERT INTO transaccion(valor, fecha_transaccion, id_usuario, id_cuenta, id_categoria_transaccion, id_tipo_transaccion)
VALUES (2000, '2023-09-10', 1, 1, 1, 1),
       (500, '2023-09-12', 1, 1, 1, 2),
       (800, '2023-09-15', 1, 2, 2, 3),
       (200, '2023-09-17', 1, 2, 2, 4),
       (150, '2023-09-18', 2, 1, 3, 4),
       (300, '2023-09-20', 2, 1, 3, 6);