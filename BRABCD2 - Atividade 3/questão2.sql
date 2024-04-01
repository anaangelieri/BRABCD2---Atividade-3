DROP DATABASE banco_escolar;
CREATE DATABASE IF NOT EXISTS banco_escolar;

USE banco_escolar;



CREATE TABLE ALUNO (
  Name VARCHAR(255) NOT NULL,
  Numero_aluno INT NOT NULL,
  Tipo_aluno VARCHAR(50) NOT NULL,
  Curso VARCHAR(50) NOT NULL,
  PRIMARY KEY (Numero_aluno)
);

CREATE TABLE DISCIPLINA (
  Nome_disciplina VARCHAR(255) NOT NULL,
  Numero_disciplina VARCHAR(50) NOT NULL,
  Creditos INT NOT NULL,
  Departamento VARCHAR(50) NOT NULL,
  PRIMARY KEY (Numero_disciplina)
);

CREATE TABLE TURMA (
  Identificacao_turma VARCHAR(50) NOT NULL,
  Numero_disciplina VARCHAR(50) NOT NULL,
  Semestre VARCHAR(50) NOT NULL,
  Ano INT NOT NULL,
  Professor VARCHAR(255) NOT NULL,
  PRIMARY KEY (Identificacao_turma)
);

CREATE TABLE HISTORICO_ESCOLAR (
  Numero_aluno INT NOT NULL,
  Identificacao_turma VARCHAR(50) NOT NULL,
  Nota char(1),
  FOREIGN KEY (Numero_aluno) REFERENCES ALUNO(Numero_aluno),
  FOREIGN KEY (Identificacao_turma) REFERENCES TURMA(Identificacao_turma)
);

CREATE TABLE PRE_REQUISITO (
  Numero_disciplina VARCHAR(50) NOT NULL,
  Numero_pre_requisito VARCHAR(50) NOT NULL,
  FOREIGN KEY (Numero_disciplina) REFERENCES DISCIPLINA(Numero_disciplina),
  FOREIGN KEY (Numero_pre_requisito) REFERENCES DISCIPLINA(Numero_disciplina) 
);

INSERT INTO ALUNO (Name, Numero_aluno, Tipo_aluno, Curso)
VALUES ('Silva', 17, 'B', 'CC'),
       ('Baga', 8, 'A', 'CC');

INSERT INTO DISCIPLINA (Nome_disciplina, Numero_disciplina, Creditos, Departamento)
VALUES ('Introd. à ciência da computação', 'CC1310', 4, 'CC'),
       ('Estruturas de dados', 'CC3320', 4, 'CC'),
       ('Matemática discreta', 'MAT2410', 3, 'MAT'),
       ('Banco de dados', 'CC3380', 3, '00');

INSERT INTO TURMA (Identificacao_turma, Numero_disciplina, Semestre, Ano, Professor)
VALUES ('85', 'MAT2410', 'Segundo', 07, 'Kleber'),
       ('92', 'CC1310', '102', 112, 'CC3020'),
       ('102', 'CC3380', 'Segundo', 07, 'Anderson'),
       ('112', 'MAT2410', 'Segundo', 08, 'Chang'),
       ('119', 'CC1310', 'Segundo', 08, 'Anderson'),
       ('135', 'CC3380', 'Segundo', 08, 'Santos');

INSERT INTO HISTORICO_ESCOLAR (Numero_aluno, Identificacao_turma, Nota)
VALUES (17, '112', 'B'),
       (17, '119', 'C'),
       (8, '85', 'A'),
       (8, '92', 'A'),
       (8, '102', 'B'),
       (8, '135', 'A');

INSERT INTO PRE_REQUISITO (Numero_disciplina, Numero_pre_requisito)
VALUES ('CC3380', 'CC3320'),
       ('CC3380', 'MAT2410'),
       ('CC3320', 'CC1310');

#1. Crie uma consulta de Natural Join entre as tabelas DISCIPLINA e TURMA.
select * from DISCIPLINA natural join TURMA;

#2. Crie uma consulta que mostre os pré-requisitos de todas as DISCIPLINAS. 
#Se uma disciplina não contiver pré-requisito, ela deve ser listada mesmo assim.
select * from PRE_REQUISITO;

#3. Crie uma consulta que mostre as DISCIPLINAs com notas no HISTORICO_ESCOLAR e seus ALUNOs 
#(Todas as DISCIPLINAS devem ser listadas).
SELECT D.Nome_disciplina, H.Nota, A.Name
FROM DISCIPLINA D 
left join TURMA t on D.Numero_disciplina = T.Numero_disciplina
left join HISTORICO_ESCOLAR H on T.Identificacao_turma = H.Identificacao_turma
left join ALUNO A on H.Numero_aluno = A.Numero_aluno;

#4. Crie uma consulta que retorne o nome, numero_disciplina e creditos de todas as disciplinas em que o aluno 'Silva'
# está matriculado. Utilize algum JOIN para isso.
SELECT d.Nome_disciplina, d.Numero_disciplina, d.Creditos
FROM DISCIPLINA d
JOIN TURMA t ON d.Numero_disciplina = t.Numero_disciplina
JOIN HISTORICO_ESCOLAR he ON t.Identificacao_turma = he.Identificacao_turma
JOIN ALUNO a ON he.Numero_aluno = a.Numero_aluno
WHERE a.Name = 'Silva';

#5. Crie uma consulta que mostre as DISCIPLINAs com notas no HISTORICO_ESCOLAR e seus ALUNOs 
#(Todas as DISCIPLINAS devem ser listadas).
SELECT D.Nome_disciplina, H.Nota, A.Name
FROM DISCIPLINA D 
left join TURMA t on D.Numero_disciplina = T.Numero_disciplina
left join HISTORICO_ESCOLAR H on T.Identificacao_turma = H.Identificacao_turma
left join ALUNO A on H.Numero_aluno = A.Numero_aluno;

#5. Escreva uma Stored Procedure para ler o nome de um aluno e imprimir sua média de notas, 
#considerando que A=4, B=3, C=2 e D=1 ponto. 

DELIMITER //
create procedure Stored_pro(in aluno_nome varchar(255))
BEGIN
	declare total_notas decimal(3,1);
    declare num_notas int;
    declare media decimal(3,2);
    
    select sum(
		case when H.Nota = 'A' then 4
        when H.Nota = 'B' then 3
        when H.Nota = 'C' then 2
        when H.Nota = 'D' then 1
        else 0
        end),
        count(*)
	into total_notas, num_notas from HISTORICO_ESCOLAR H 
    join ALUNO A on H.Numero_aluno = A.Numero_aluno
    where A.name = aluno_nome;
    
    if num_notas > 0 then
		set media = total_notas / num_notas;
        select concat('A média de notas do aluno ', aluno_nome, ' é: ', media);
	else
		select concat('O aluno não possui notas registradas');
	end if;
END //
DELIMITER ;

call Stored_pro('Baga');

#6. Crie uma Function que retorne a nota média de um aluno dado o seu nome.
DELIMITER //

CREATE FUNCTION CalcularMedia(aluno_nome VARCHAR(255))
RETURNS FLOAT
DETERMINISTIC
BEGIN
    DECLARE soma_notas FLOAT;
    DECLARE num_notas INT;
    DECLARE media FLOAT;

    select sum(
		case when H.Nota = 'A' then 4
        when H.Nota = 'B' then 3
        when H.Nota = 'C' then 2
        when H.Nota = 'D' then 1
        else 0
        end),
           COUNT(*)
    INTO soma_notas, num_notas
    FROM HISTORICO_ESCOLAR H
    JOIN ALUNO a ON H.Numero_aluno = A.Numero_aluno
    WHERE a.Name = aluno_nome;

    IF num_notas > 0 THEN
        SET media = soma_notas / num_notas;
        RETURN media;
    ELSE
        RETURN NULL;
    END IF;
END //

DELIMITER ;
SELECT CalcularMedia('Baga');

#7. Utilizando a Function criada na atividade anterior, 
#crie uma consulta que liste as disciplinas em que o aluno de Nome `BRAGA` possua pontuação acima da média de suas notas.
SELECT d.Nome_disciplina, h.Nota
FROM HISTORICO_ESCOLAR H
JOIN ALUNO A ON H.Numero_aluno = A.Numero_aluno
JOIN TURMA T ON H.Identificacao_turma = T.Identificacao_turma
JOIN DISCIPLINA D ON T.Numero_disciplina = D.Numero_disciplina
WHERE A.Name = 'Baga' AND H.Nota > (SELECT CalcularMedia('Baga'));



