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

