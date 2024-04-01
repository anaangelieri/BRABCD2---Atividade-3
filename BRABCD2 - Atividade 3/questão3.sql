drop schema DER;
create schema DER;

use DER;

create table PAIS(
	cd_pais int primary key,
    nm_pais varchar(200)
);

create table EQUIPE(
	cd_eq int primary key,
    nm_eq varchar(200),
    cd_pais int,
    foreign key(cd_pais) references PAIS(cd_pais)
);

create table CIRCUITO(
	cd_cir int primary key, 
    nm_cir varchar(200),
    cd_pais int,
    foreign key (cd_pais) references PAIS(cd_pais)
);

create table PROVA (
    cd_pro int primary key,
    tp_pro varchar(200),
    dt_pro date,
    cd_cir int,
    foreign key (cd_cir) references CIRCUITO(cd_cir)
);

create table PILOTO (
    cd_pil int primary key,
    nm_pil varchar(200),
    cd_eq int,
    cd_pais int,
    foreign key (cd_eq) references EQUIPE(cd_eq),
    foreign key (cd_pais) references PAIS(cd_pais)
);

create table PILOTO_PROVA (
    cd_pil int,
    cd_pro int,
    posicao int,
    primary key (cd_pil, cd_pro),
    foreign key (cd_pil) references PILOTO(cd_pil),
    foreign key (cd_pro) references PROVA(cd_pro)
);

-- Inserindo dados na tabela PAIS
INSERT INTO PAIS (cd_pais, nm_pais) VALUES
(1, 'Brasil'),
(2, 'Alemanha'),
(3, 'França'), 
(4, 'Argentina'),
(5, 'Uruguai');

-- Inserindo dados na tabela EQUIPE
INSERT INTO EQUIPE (cd_eq, nm_eq, cd_pais) VALUES
(1, 'Mercedes', 1),
(2, 'Red Bull Racing', 2),
(3, 'Ferrari', 3);

-- Inserindo dados na tabela CIRCUITO
INSERT INTO CIRCUITO (cd_cir, nm_cir, cd_pais) VALUES
(1, 'Interlagos', 1),
(2, 'Nürburgring', 2),
(3, 'Circuit de Spa-Francorchamps', 3);

-- Inserindo dados na tabela PROVA
INSERT INTO PROVA (cd_pro, tp_pro, dt_pro, cd_cir) VALUES
(1, 'Treino Livre', '2024-03-01', 1),
(2, 'Classificação', '2024-03-02', 2),
(3, 'Corrida', '2024-03-03', 3);

-- Inserindo dados na tabela PILOTO
INSERT INTO PILOTO (cd_pil, nm_pil, cd_eq, cd_pais) VALUES
(1, 'Lewis Hamilton', 1, 1),
(2, 'Max Verstappen', 2, 2),
(3, 'Charles Leclerc', 3, 3),
(4, 'Valtteri Bottas', 1, 1),
(5, 'Sergio Perez', 2, 2),
(6, 'Sebastian Vettel', 1, 1);

-- Inserindo dados na tabela PILOTO_PROVA
INSERT INTO PILOTO_PROVA (cd_pil, cd_pro, posicao) VALUES
(1, 1, 2),
(2, 2, 1), 
(3, 3, 3), 
(4, 1, 4), 
(5, 2, 5),
(6, 3, 6), 
(5, 3, 1);

#1. Listar o nome de cada equipe seguida do nome do país que ela representa, 
#mas listar também os demais países que não tem representação.
select E.nm_eq, P.nm_pais from EQUIPE E right join PAIS P on E.cd_pais = P.cd_pais;

#2. Listar o nome de cada equipe seguida do nome do país que ela representa.
select E.nm_eq, P.nm_pais from EQUIPE E inner join PAIS P on E.cd_pais = P.cd_pais;

#3.Listar o nome dos pilotos que obtiveram 1º lugar em alguma prova (posiçao=1). 
#Não é necessário repetir o nome do piloto caso ele tenha obtido o 1º lugar em mais de uma prova.
select P.nm_pil, PP.posicao from PILOTO P inner join PILOTO_PROVA PP on P.cd_pil = PP.cd_pil where PP.posicao = 1;

#4. Listar o nome dos pilotos e a posição de cada um obtida no GP do Brasil.
select P.nm_pil, PP.posicao, PA.nm_pais from PILOTO P 
inner join PILOTO_PROVA PP on P.cd_pil = PP.cd_pil 
inner join PAIS PA on P.cd_pais = PA.cd_pais where PA.nm_pais = 'Brasil';

#5. Listar o nome da equipe, seguida do número de pilotos da equipe.
select E.nm_eq, count(P.cd_pil) as num_pilotos from EQUIPE E left join PILOTO P on E.cd_eq = P.cd_eq group by E.nm_eq;

#6. Listar o nome da equipe, seguida do número de pilotos da equipe, 
#somente quando o número de pilotos por equipe for maior do que 2.
select E.nm_eq, count(P.cd_pil) as num_pilotos from EQUIPE E left join PILOTO P on E.cd_eq = P.cd_eq group by E.nm_eq having count(P.cd_pil) > 2;
