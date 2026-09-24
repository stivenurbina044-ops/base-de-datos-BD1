CREATE TABLE cuentas(
	id_cuenta int PRIMARY KEY,
	titular varchar(100),
	saldo decimal(10,2)
);

CREATE TABLE historial_transferencias (
id_transferencia INT AUTO_INCREMENT PRIMARY KEY,
cuenta_origen INT,
cuenta_destino INT,
monto DECIMAL(10,2),
fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO cuentas (id_cuenta, titular, saldo) 
VALUES 
(1, 'Ana López', 5000.00),
(2, 'Carlos Pérez', 3000.00);

CREATE PROCEDURE TransferirFondos(
    IN p_origen INT,
    IN p_destino INT,
    IN p_monto DECIMAL(10,2),
    OUT p_codigo_respuesta INT
)
BEGIN
	
    DECLARE v_saldo DECIMAL(10,2);

    SELECT saldo INTO v_saldo FROM cuentas WHERE id_cuenta = p_origen;

    IF v_saldo >= p_monto THEN
        START TRANSACTION;

        UPDATE cuentas SET saldo = saldo - p_monto WHERE id_cuenta = p_origen;
        UPDATE cuentas SET saldo = saldo + p_monto WHERE id_cuenta = p_destino;

        INSERT INTO historial_transferencias (cuenta_origen, cuenta_destino, monto)
        VALUES (p_origen, p_destino, p_monto);

        COMMIT;
        SET p_codigo_respuesta = 1; 
    ELSE
        SET p_codigo_respuesta = 0; 
    END IF;
END;



CALL TransferirFondos(1, 2, 500.00, @resultado);

SELECT @resultado AS Mesagge;

SELECT * FROM cuentas;
SELECT * FROM historial_transferencias;




