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