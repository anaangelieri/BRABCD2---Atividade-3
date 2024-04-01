drop schema teste_produto;
create schema teste_produto;
use teste_produto;

create table PRODUTO(
	codigo int(2),
    descricao varchar(20)
);

insert into PRODUTO 
values	(1, 'maça'),
		(2, 'cenoura'),
        (3, 'bola'),
        (4, 'smartphone'),
        (5, 'notebook'),
        (6, 'garrafa de água'),
        (7, 'relógio');
        
DELIMITER //

CREATE PROCEDURE ExibirProdutoOferta()
BEGIN
    DECLARE dia_semana VARCHAR(20);
    DECLARE produto_oferta VARCHAR(100);
    DECLARE codigo_produto int;

    -- Configurar a exibição do dia da semana em português
    SET lc_time_names = 'pt_PT';

    -- Obter o nome do dia da semana
    SET dia_semana = DAYNAME(SYSDATE());

    -- Selecionar o produto correspondente ao dia da semana
    SELECT CASE dia_semana
        WHEN 'Domingo' THEN 1
        WHEN 'Segunda' THEN 2
        WHEN 'Terça' THEN 3
        WHEN 'Quarta' THEN 4
        WHEN 'Quinta' THEN 5
        WHEN 'Sexta' THEN 6
        WHEN 'Sábado' THEN 7
    END INTO codigo_produto;
    
    SELECT DESCRICAO INTO produto_oferta
    FROM PRODUTO
    WHERE CODIGO = codigo_produto;

    -- Construir a mensagem e retornar
    SELECT CONCAT('Hoje é ', dia_semana, ' e o produto em oferta é ', produto_oferta, '.') as mensagem;
END //
DELIMITER ;

CALL ExibirProdutoOferta();
