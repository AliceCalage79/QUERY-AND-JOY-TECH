-- Total de alunos cadastrados --
SELECT COUNT (tb_alunos.id) AS Total_Alunos
FROM tb_alunos;

-- Percentual do total de  alunos por status
SELECT count(tba.id) AS Total_Status,tba.status,
(count(tba.id)::numeric / subquery.total * 100::numeric)::numeric(10) AS percentual_por_estatus
FROM tb_alunos tba,
(SELECT count(tb_alunos.id)::numeric(10) AS total
FROM tb_alunos) subquery
GROUP BY  subquery.total, tba.status;

-- numero de turmas por facilitador --

SELECT C.nome as facilitador, B.funcao, COUNT(A.id_curso) as n_turmas
FROM TB_TURMA A
LEFT JOIN TB_FACILITADORES_TURMA B ON A.id = B.id_turma
LEFT JOIN TB_FACILITADORES C ON B.id_facilitador = C.id
GROUP BY C.nome, B.funcao
HAVING COUNT(A.id_curso) > 1
ORDER BY COUNT(A.id_curso) DESC;

-- View: public.percentual_alunos_status_evasao_turma

-- DROP VIEW public.percentual_alunos_status_evasao_turma;
-- View  de percentual de alunos com evasão por turma --

CREATE OR REPLACE VIEW public.percentual_alunos_status_evasao_turma
 AS
 SELECT tbm.id_turma,
    count(tba.id) AS count,
    tba.status,
    (count(tba.id)::numeric / subquery.total * 100::numeric)::numeric(10,3) AS percentual
   FROM tb_alunos tba
     JOIN tb_matricula tbm ON tba.id = tbm.id_aluno,
    (SELECT count(tb_alunos.id)::numeric(10,3) AS total
           FROM tb_alunos) subquery
 GROUP BY tbm.id_turma, subquery.total, tba.status
 HAVING tba.status = false;

ALTER TABLE public.percentual_alunos_status_evasao_turma
    OWNER TO postgres;

-- criação da trigeer da tabela de log tb_status
CREATE OR REPLACE FUNCTION atualiza_status()
RETURNS trigger AS $$
begin
if old.id =new.id and old.status = new.status then
    return old;
else 
	insert into tb_status (id_aluno, status_aluno, data_atualizacao)
	values (new.id, new.status, now());
end if;
	return null;
	end;
	$$language plpgsql;
	
CREATE TRIGGER tb_status
AFTER INSERT OR UPDATE
ON tb_alunos
FOR EACH ROW
EXECUTE PROCEDURE atualiza_status();

--percentual de alunos com evasão por modulo--

SELECT tbmd.posicao as modulo, COUNT (tba.id) qtd_evasao,tba.status,
CAST ((COUNT(tba.id)/subquery.total )* 100 AS numeric (10,1)) AS percentual
FROM tb_alunos AS tba INNER JOIN tb_matricula AS tbm
ON tba.id = tbm.id_aluno INNER JOIN tb_turma AS tbt 
ON tbm.id_turma = tbt.id INNER JOIN tb_modulo As tbmd
ON tbt.id_modulo = tbmd.id,
(SELECT CAST (COUNT (tb_alunos.id) 
AS numeric (10,1))total FROM tb_alunos) AS subquery                                                                                                                                  
GROUP BY tbmd.posicao,subquery.total,tba.status
HAVING tba.status='f'
ORDER BY percentual desc;

--percentual de alunos por regiao--

SELECT tba.uf,
    count(tba.id) AS count,
    (count(tba.id)::numeric / subquery.total * 100::numeric)::numeric(10,3) AS percentual
   FROM tb_alunos tba
     JOIN tb_matricula tbm ON tba.id = tbm.id_aluno,
    ( SELECT count(tb_alunos.id)::numeric(10,3) AS total
           FROM tb_alunos) subquery
  GROUP BY tba.uf, subquery.total
  order by tba.uf;
 
 
