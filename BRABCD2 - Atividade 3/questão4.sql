drop schema teste_aluno;

create schema teste_aluno;
use teste_aluno;

create table ALUNO(
	RA int(9),
    disciplina varchar(30),
    media double(3,1),
    carga_hora int(2),
    faltas int(2),
    resultado varchar(10)
);

insert into ALUNO values (1, 'Disc 1', 7.5, 80, 20, '');

DELIMITER //
create procedure PreencherResultado()
BEGIN
	declare p_media decimal(3,1);
    declare p_faltas int;
    declare p_carga_horaria int;
    
    select media, faltas, carga_hora into p_media, p_faltas, p_carga_horaria from aluno where RA = 1;
    
    if p_media >= 7.0 and p_faltas <= p_carga_horaria * 0.25 then 
		update aluno set resultado = 'Aprovado' where RA = 1;
    elseif p_media < 7.0 and p_faltas <= p_carga_horaria * 0.25 then 
		update aluno set resultado = 'Exame' where RA = 1;
    else 
		update aluno set resultado = 'Reprovado' where RA = 1;
    end if;
END //
DELIMITER ;

set sql_safe_updates = 0;

call PreencherResultado();

select * from ALUNO;