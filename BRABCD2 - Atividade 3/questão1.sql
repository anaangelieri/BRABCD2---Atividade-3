# Escreva uma Function para somar dois números inteiros.
create schema functions;
use functions;

DELIMITER //

create function soma(a INT, b INT) 
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE result INT;
  SET result = a + b;
  RETURN result;
END //

DELIMITER ;


select soma(12,27);

# Escreva uma Function que receba um número inteiro e retorne o número ao quadrado.

DELIMITER //
CREATE FUNCTION quadrado (a int)
RETURNS int
DETERMINISTIC
BEGIN
	DECLARE result double;
    SET result = a * a;
    RETURN result;
END//
DELIMITER ;

select quadrado(32);