-- ¿Cuánto dinero tengo en todas mis cuentas en este momento?
SELECT u.nombre, SUM(c.saldo_disponible) AS total_saldo_cuentas
FROM cuenta c
INNER JOIN usuario u ON c.id_usuario = u.id
WHERE u.id = 1;


-- ¿Cuánto gasté en la categoría Comida el mes pasado?
SELECT u.nombre, SUM(t.valor) AS total_gasto_comida
FROM transaccion t
INNER JOIN categoria_transaccion ct ON t.id_categoria_transaccion = ct.id
INNER JOIN usuario u ON t.id_usuario = u.id
WHERE ct.nombre = 'Comida y restaurantes'
  AND t.id_usuario = 1
  AND YEAR(t.fecha_transaccion) = YEAR(DATE_SUB(NOW(), INTERVAL 1 MONTH))
  AND MONTH(t.fecha_transaccion) = MONTH(DATE_SUB(NOW(), INTERVAL 1 MONTH));


-- ¿Cuánto debo en préstamos en total?
SELECT u.nombre,
       p.monto AS monto_prestamo,
       (SELECT SUM(monto) FROM prestamo WHERE id_usuario = p.id_usuario) - (SELECT COALESCE(SUM(valor), 0) FROM abono_prestamo ap JOIN prestamo pr ON ap.id_prestamo = pr.id WHERE pr.id_usuario = p.id_usuario) AS deuda_total
FROM prestamo p
JOIN usuario u ON u.id = p.id_usuario
WHERE p.id_usuario = 1;


-- ¿Cuánto dinero he ahorrado en la cuenta de ahorro en los últimos 6 meses?
SELECT c.id,
       c.descripcion,
       SUM(t.valor) AS ahorrado_ultimos_6_meses
FROM transaccion t
         JOIN cuenta c ON t.id_cuenta = c.id
         JOIN tipo_cuenta tc ON c.id_tipo_cuenta = tc.id
         JOIN categoria_transaccion ct ON t.id_categoria_transaccion = ct.id
WHERE t.id_usuario = 1
  AND c.id_tipo_cuenta = 1 -- 1 es el ID para 'Cuenta Ahorros' en la tabla `tipo_cuenta`
  AND ct.id_tipo_transaccion = 1 -- 1 es el ID para 'Ingresos' en la tabla `tipo_transaccion`
GROUP BY c.id, c.descripcion;


-- ¿Cuál es la suma de mis ingresos en la categoría Salario este mes?
SELECT u.nombre AS Nombre_Usuario,
       u.correo_electronico AS Correo_Usuario,
       SUM(t.valor) AS Total_Salario_Mes
FROM transaccion t
         JOIN categoria_transaccion ct ON t.id_categoria_transaccion = ct.id
         JOIN usuario u ON t.id_usuario = u.id
WHERE t.id_usuario = 1
  AND ct.id = 3
  AND MONTH(t.fecha_transaccion) = MONTH(NOW())
  AND YEAR(t.fecha_transaccion) = YEAR(NOW());


-- ¿Cuánto dinero he transferido a mi cuenta de ahorro en el último trimestre?


-- ¿Cuánto he abonado a la meta Vacaciones hasta el momento?


-- ¿Cuál es el balance mensual de ingresos versus gastos hasta la fecha?


-- ¿Cuál es el saldo total de mis cuentas corrientes en este momento?


-- ¿Cuál es el gasto acumulado en la categoría "Transporte" en el último semestre?


-- ¿Cuál es el valor promedio de los ingresos mensuales en el último año?

