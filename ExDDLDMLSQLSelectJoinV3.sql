CREATE DATABASE projetos

USE projetos

CREATE TABLE projects(
id			INT			NOT NULL	IDENTITY(10001, 1),
name		VARCHAR(45)	NOT NULL,
description	VARCHAR(45)	NULL,
dates		DATE		NOT NULL	CHECK(dates > '2014-09-01')
PRIMARY KEY(id)
)

CREATE TABLE users(
id			INT			NOT NULL	IDENTITY(1, 1),
name		VARCHAR(45)	NOT NULL,
username	VARCHAR(45)	NOT NULL	UNIQUE,
password	VARCHAR(45)	NOT NULL	DEFAULT '123mudar',
email		VARCHAR(45)	NOT NULL
PRIMARY KEY(id)
)

CREATE TABLE user_has_projects(
users_id	INT			NOT NULL,
projects_id	INT			NOT NULL,
PRIMARY KEY(users_id, projects_id),
FOREIGN KEY(users_id) REFERENCES users(id),
FOREIGN KEY(projects_id) REFERENCES projects(id)
)

--Removendo 'UNIQUE' constraint de username
ALTER TABLE users
DROP CONSTRAINT UQ__users__F3DBC572C2423FF5;

--Alterando coluna
ALTER TABLE users
ALTER COLUMN username VARCHAR(10) NOT NULL

--Recriando constraint
ALTER TABLE users
ADD UNIQUE (username);

ALTER TABLE users
ALTER COLUMN password VARCHAR(8) NOT NULL

INSERT INTO users(name, username, email) VALUES(
'Maria', 'Rh_maria', 'maria@empresa.com')

INSERT INTO users VALUES(
'Paulo', 'Ti_paulo', '123@456', 'paulo@empresa.com')

INSERT INTO users(name, username, email) VALUES
('Ana', 'Rh_ana', 'ana@empresa.com'),
('Clara', 'Ti_clara', 'clara@empresa.com')

INSERT INTO users VALUES(
'Aparecido', 'Rh_apareci', '55@!cido', 'aparecido@empresa.com')

INSERT INTO projects VALUES
('Re-folha', 'Refatoração das Folhas', '2014-09-05'),
('Manutenção PCs', 'Manutenção PCs', '2014-09-06'),
('Auditoria', NULL, '2014-09-07')

INSERT INTO user_has_projects VALUES
(1, 10001),
(5, 10001),
(3, 10003),
(4, 10002),
(2, 10002)

UPDATE projects
SET dates = '2014-09-12'
WHERE name = 'Manutenção PCs'

UPDATE users
SET username = 'Rh_cido'
WHERE name = 'Aparecido'

UPDATE users
SET username = '888@*,'
WHERE username = 'Rh_maria' AND password='123mudar'

DELETE user_has_projects
WHERE users_id = 2 AND projects_id = 10002

--a) Adicionar User
--(6; Joao; Ti_joao; 123mudar; joao@empresa.com)
INSERT INTO users(name, username, email) VALUES (
'Joao', 'Ti_joao', 'joao@empresa.com')

--b) Adicionar Project
--(10004; Atualização de Sistemas; Modificação de Sistemas Operacionais nos PC's; 12/09/2014)
INSERT INTO projects VALUES(
'Atualização de Sistemas', 'Modificação de Sistemas Operacionais nos PC''s', '2014-09-12')

--c) Consultar:
--Quantos projetos não tem usuários associados a ele. A coluna deve chamar
--qty_projects_no_users
SELECT COUNT(p.id) AS qty_projects_no_users
FROM projects p LEFT OUTER JOIN user_has_projects up 
ON p.id = up.projects_id 
WHERE up.projects_id IS NULL

--Id do projeto, nome do projeto, qty_users_project (quantidade de usuários por
--projeto) em ordem alfabética crescente pelo nome do projeto
SELECT p.id, p.name, COUNT(u.id) AS qty_users_project
FROM users u, projects p, user_has_projects up
WHERE u.id = up.users_id AND p.id = up.projects_id
GROUP BY p.id, p.name
ORDER BY p.name
