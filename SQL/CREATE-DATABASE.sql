-- Database: Data_Base_Resilia

-- DROP DATABASE IF EXISTS "Data_Base_Resilia";

CREATE DATABASE "Data_Base_Resilia"
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'Portuguese_Brazil.1252'
    LC_CTYPE = 'Portuguese_Brazil.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

-- Table: public.tb_alunos

-- DROP TABLE IF EXISTS public.tb_alunos;

CREATE TABLE IF NOT EXISTS public.tb_alunos
(
    id integer NOT NULL,
    nome character varying(150) COLLATE pg_catalog."default" NOT NULL,
    cpf character(11) COLLATE pg_catalog."default" NOT NULL,
    celular character varying(20) COLLATE pg_catalog."default",
    email character varying(100) COLLATE pg_catalog."default",
    endereco character varying(255) COLLATE pg_catalog."default",
    bairro character varying(45) COLLATE pg_catalog."default",
    cidade character varying(45) COLLATE pg_catalog."default",
    uf character varying(2) COLLATE pg_catalog."default",
    cep character varying(10) COLLATE pg_catalog."default",
    status boolean NOT NULL DEFAULT true,
    CONSTRAINT tb_alunos_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.tb_alunos
    OWNER to postgres;

-- Table: public.tb_status

-- DROP TABLE IF EXISTS public.tb_status;

CREATE TABLE IF NOT EXISTS public.tb_status
(
    id_aluno integer NOT NULL,
    status_aluno boolean NOT NULL,
    data_atualizacao timestamp with time zone NOT NULL,
    CONSTRAINT id_aluno FOREIGN KEY (id_aluno)
        REFERENCES public.tb_alunos (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.tb_status
    OWNER to postgres;

-- Table: public.tb_curso

-- DROP TABLE IF EXISTS public.tb_curso;

CREATE TABLE IF NOT EXISTS public.tb_curso
(
    id integer NOT NULL,
    modalidade character varying(50) COLLATE pg_catalog."default",
    duracao_horas character varying(50) COLLATE pg_catalog."default",
    CONSTRAINT tb_curso_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.tb_curso
    OWNER to postgres;

-- Table: public.tb_modulo

-- DROP TABLE IF EXISTS public.tb_modulo;

CREATE TABLE IF NOT EXISTS public.tb_modulo
(
    id integer NOT NULL,
    posicao character varying(2) COLLATE pg_catalog."default",
    CONSTRAINT tb_modulo_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.tb_modulo
    OWNER to postgres;

-- Table: public.tb_facilitadores

-- DROP TABLE IF EXISTS public.tb_facilitadores;

CREATE TABLE IF NOT EXISTS public.tb_facilitadores
(
    id integer NOT NULL,
    nome character varying(150) COLLATE pg_catalog."default" NOT NULL,
    cpf character(11) COLLATE pg_catalog."default" NOT NULL,
    celular character varying(20) COLLATE pg_catalog."default",
    email character varying(100) COLLATE pg_catalog."default",
    endereco character varying(255) COLLATE pg_catalog."default",
    bairro character varying(45) COLLATE pg_catalog."default",
    cidade character varying(45) COLLATE pg_catalog."default",
    uf character varying(2) COLLATE pg_catalog."default",
    cep character varying(10) COLLATE pg_catalog."default",
    CONSTRAINT tb_facilitadores_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.tb_facilitadores
    OWNER to postgres;

-- Table: public.tb_turma

-- DROP TABLE IF EXISTS public.tb_turma;

CREATE TABLE IF NOT EXISTS public.tb_turma
(
    id integer NOT NULL,
    id_curso integer,
    id_modulo integer,
    n_alunos integer,
    data_criacao date DEFAULT CURRENT_DATE,
    CONSTRAINT tb_turma_pkey PRIMARY KEY (id),
    CONSTRAINT tb_turma_id_curso_fkey FOREIGN KEY (id_curso)
        REFERENCES public.tb_curso (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT tb_turma_id_modulo_fkey FOREIGN KEY (id_modulo)
        REFERENCES public.tb_modulo (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.tb_turma
    OWNER to postgres;

-- Table: public.tb_facilitadores_turma

-- DROP TABLE IF EXISTS public.tb_facilitadores_turma;

CREATE TABLE IF NOT EXISTS public.tb_facilitadores_turma
(
    id_facilitador integer,
    id_turma integer,
    funcao character varying(10) COLLATE pg_catalog."default",
    CONSTRAINT tb_facilitadores_turma_id_facilitador_fkey FOREIGN KEY (id_facilitador)
        REFERENCES public.tb_facilitadores (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT tb_facilitadores_turma_id_turma_fkey FOREIGN KEY (id_turma)
        REFERENCES public.tb_turma (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.tb_facilitadores_turma
    OWNER to postgres;

-- Table: public.tb_matricula

-- DROP TABLE IF EXISTS public.tb_matricula;

CREATE TABLE IF NOT EXISTS public.tb_matricula
(
    n_matricula integer NOT NULL,
    id_aluno integer NOT NULL,
    id_turma integer,
    data_matricula date NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT tb_matricula_pkey PRIMARY KEY (n_matricula),
    CONSTRAINT id_aluno FOREIGN KEY (id_aluno)
        REFERENCES public.tb_alunos (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT id_turma FOREIGN KEY (id_turma)
        REFERENCES public.tb_turma (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.tb_matricula
    OWNER to postgres;