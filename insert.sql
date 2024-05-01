CREATE TABLE usuarios(
	idUsuario INT IDENTITY(1,1) PRIMARY KEY,
	usuario VARCHAR(100),
	senha VARCHAR(30)
);

CREATE SEQUENCE SEQ_idPessoa
    AS INT
    START WITH 7
    INCREMENT BY 8;

CREATE TABLE pessoa (
    idPessoa int primary key not null default NEXT VALUE FOR SEQ_idPessoa,
    nome varchar(255) not null,
    logradouro varchar(255) not null,
    cidade varchar(255) not null,
    estado varchar(2) not null,
    telefone varchar(11) not null,
    email varchar(255) not null unique
);

CREATE TABLE pessoa_juridica (
    idPessoa int foreign key references pessoa(idPessoa) not null primary key,
    cnpj varchar(14) not null
);

CREATE TABLE pessoa_fisica (
    idPessoa int foreign key references pessoa(idPessoa) primary key,
    cpf varchar(11)�not�null�
);


CREATE TABLE produto(
	idProduto INT PRIMARY KEY NOT NULL,
	nome VARCHAR(255),
	quantidade INT,
	precoVenda DECIMAL(10, 2)
);

CREATE TABLE movimento(
	idMovimento INT IDENTITY(1,1) PRIMARY KEY,
	idUsuario INT NOT NULL,
	idPessoa INT NOT NULL,
	idProduto INT NOT NULL,
	quantidade INT,
	tipo VARCHAR(1),
	valorUnitario DECIMAL(10,2),
	FOREIGN KEY (idUsuario) REFERENCES usuarios(idUsuario),
	FOREIGN KEY (idPessoa) REFERENCES pessoa(idPessoa),
	FOREIGN KEY (idProduto) REFERENCES produto(idProduto),
	CONSTRAINT TIPO_MOVIMENTO_INVALIDO CHECK (tipo IN ('E', 'S'))
);


INSERT INTO usuarios (usuario, senha) VALUES ('op1', 'op1');
INSERT INTO usuarios (usuario, senha) VALUES ('op2', 'op2');

SELECT * FROM usuarios;



INSERT INTO produto (idProduto, nome, quantidade, precoVenda) VALUES (1, 'Banana', 100, 5.00);
INSERT INTO produto (idProduto, nome, quantidade, precoVenda) VALUES (3, 'Laranja', 500, 2.00);
INSERT INTO produto (idProduto, nome, quantidade, precoVenda) VALUES (4, 'Manga', 100, 4.00);

SELECT * FROM produto;


DECLARE @idFisica INT;
SET @idFisica = NEXT VALUE FOR SEQ_idPessoa;

INSERT INTO pessoa (idPessoa, nome, logradouro, cidade, estado, telefone, email)
VALUES (@idFisica, 'Joao', 'Rua 12, casa 3, Quitanda', 'Riacho do Sul', 'PA', '1111-1111', 'joao@riacho.com');

INSERT INTO pessoa_fisica (idPessoa, cpf) VALUES (@idFisica, '11111111111');

SELECT * FROM pessoa AS p INNER JOIN pessoa_fisica pf ON p.idPessoa = pf.idPessoa;


DECLARE @idJuridica INT;
SET @idJuridica = NEXT VALUE FOR SEQ_idPessoa;

INSERT INTO pessoa (idPessoa, nome, logradouro, cidade, estado, telefone, email)
VALUES (@idJuridica, 'JJC', 'Rua 11. Centro', 'Riacho do Norte', 'PA', '1212-1212', 'jjc@riacho.com');

INSERT INTO pessoa_juridica (idPessoa, cnpj) VALUES (@idJuridica, '22222222222222');

SELECT * FROM pessoa a INNER JOIN pessoa_juridica pj ON a.idPessoa = pj.idPessoa;


INSERT INTO movimento (idUsuario, idPessoa, idProduto, quantidade, tipo, valorUnitario) VALUES 
	(1, @idFisica, 1, 20, 'S', 4.00),
	(1, @idFisica, 3, 15, 'S', 2.00),
	(2, @idFisica, 3, 10, 'S', 3.00),
	(1, @idJuridica, 3, 15, 'E', 5.00),
	(1, @idJuridica, 4, 20, 'E', 4.00);

SELECT * FROM movimento;

SELECT * FROM pessoa a INNER JOIN pessoa_fisica pf ON a.idPessoa = pf.idPessoa;

SELECT * FROM pessoa a INNER JOIN pessoa_juridica pj ON a.idPessoa = pj.idPessoa;


SELECT a.idMovimento,
	a.tipo,
	b.nome AS Produto,
	c.nome as Fornecedor,
	a.quantidade AS Quantidade,
	a.valorUnitario AS Preco_Unitario,
	a.quantidade * a.valorUnitario AS Valor_Total
FROM movimento a
INNER JOIN pessoa b ON a.idPessoa = b.idPessoa
INNER JOIN produto c ON a.idProduto = c.idProduto
WHERE a.tipo = 'E';


SELECT a.idMovimento,
	a.tipo,
	b.nome AS Produto,
	c.nome AS Comprador,
	a.quantidade AS Quantidade,
	a.valorUnitario AS Preco_Unitario,
	a.quantidade * a.valorUnitario AS Valor_Total
FROM movimento a
INNER JOIN produto b ON a.idProduto = b.idProduto
INNER JOIN pessoa c ON a.idPessoa = c.idPessoa
WHERE a.tipo = 'S';


SELECT b.idProduto, b.nome AS produto,
	SUM(a.quantidade * a.valorUnitario) AS total
FROM movimento a
INNER JOIN produto b ON a.idProduto = b.idProduto
WHERE a.tipo = 'E'
GROUP BY b.nome, b.idProduto;


SELECT b.idProduto, b.nome AS produto,
	SUM(a.quantidade * a.valorUnitario) AS total
FROM movimento a
INNER JOIN produto b ON a.idProduto = b.idProduto
WHERE a.tipo = 'S'
GROUP BY b.nome, b.idProduto;


SELECT a.* FROM usuarios a
LEFT JOIN movimento b ON b.idUsuario = a.idUsuario AND b.tipo = 'E'
WHERE b.idMovimento IS NULL;


SELECT b.idUsuario, b.usuario AS operador,
	SUM(a.quantidade * a.valorUnitario) AS total
FROM movimento a
INNER JOIN usuarios b ON a.idUsuario = b.idUsuario
WHERE a.tipo = 'E'
GROUP BY b.usuario, b.idUsuario;


SELECT b.idUsuario, b.usuario AS operador,
	SUM(a.quantidade * a.valorUnitario) AS total
FROM movimento a
INNER JOIN usuarios b ON a.idUsuario = b.idUsuario
WHERE a.tipo = 'S'
GROUP BY b.usuario, b.idUsuario;


SELECT b.idProduto, 
       b.nome AS produto,
       SUM(a.quantidade * a.valorUnitario) / SUM(a.quantidade) AS valorMedio
FROM movimento a
INNER JOIN produto b ON a.idProduto = b.idProduto
WHERE a.tipo = 'S'
GROUP BY b.idProduto, b.nome;