/*
DROP TABLE Edital;
DROP TABLE IdiomasAceitos;
DROP TABLE EixosApresentacao;
DROP TABLE SubEixosApresentacao;
DROP TABLE AreasApresentacao;
DROP TABLE SubAreasApresentacao;
DROP TABLE Regras;
DROP TABLE CronogramaEdital;
DROP TABLE PeriodoInscricoesEdital;
DROP TABLE PeriodoSubmissoesEdital;
DROP TABLE Trabalho;
*/

CREATE TABLE IF NOT EXISTS Edital (
    idEdital INTEGER GENERATED ALWAYS AS IDENTITY,
    sigla VARCHAR(8) NOT NULL,
    url VARCHAR(64) NOT NULL,
    dataUltimaEdicao DATE,
    dataPublicacaoOriginal DATE,

    PRIMARY KEY(idEdital),
    FOREIGN KEY(sigla) REFERENCES Evento(sigla),
    UNIQUE(sigla, url)
);

CREATE TABLE IF NOT EXISTS IdiomasAceitos (
    idioma VARCHAR(20) NOT NULL,
    idEdital INTEGER NOT NULL, 

    PRIMARY KEY(idioma, idEdital),
    FOREIGN KEY(idEdital) REFERENCES Edital(idEdital)
);

CREATE TABLE IF NOT EXISTS EixosApresentacao (
    idEixo INTEGER GENERATED ALWAYS AS IDENTITY,
    idEdital INTEGER NOT NULL,
    nomeEixo VARCHAR(20) NOT NULL,
    
    PRIMARY KEY(idEixo),
    FOREIGN KEY(idEdital) REFERENCES Edital(idEdital),
    UNIQUE(idEdital, nomeEixo)
);

CREATE TABLE IF NOT EXISTS SubEixosApresentacao (
    idEixo INTEGER NOT NULL,
    nomeSubEixo VARCHAR(20) NOT NULL,
    
    PRIMARY KEY(nomeSubEixo, idEixo),
    FOREIGN KEY(idEixo) REFERENCES EixosApresentacao(idEixo)
);

CREATE TABLE IF NOT EXISTS AreasApresentacao (
    idArea INTEGER GENERATED ALWAYS AS IDENTITY,
    idEdital INTEGER NOT NULL,
    nomeArea VARCHAR(20) NOT NULL,
    
    PRIMARY KEY(idArea),
    FOREIGN KEY(idEdital) REFERENCES Edital(idEdital),
    UNIQUE(idEdital, nomeArea)
);

CREATE TABLE IF NOT EXISTS SubAreasApresentacao (
    idArea INTEGER NOT NULL,
    nomeSubArea VARCHAR(20) NOT NULL,
    
    PRIMARY KEY(nomeSubArea, idArea),
    FOREIGN KEY(idArea) REFERENCES AreasApresentacao(idArea)
);

CREATE TABLE IF NOT EXISTS Regras (
    idEdital INTEGER NOT NULL PRIMARY KEY,
    descricao VARCHAR(200),
    modelo VARCHAR(64), /* o que seria aqui? o link do modelo? ou precisa especificar que é um arquivo pdf (por exemplo)? */

  --essa parte eu preciso estudar ainda
  --parece que tem um tipo que armazena arquivos pdf
    
    FOREIGN KEY(idEdital) REFERENCES Edital(idEdital)
);

CREATE TABLE IF NOT EXISTS CronogramaEdital (
    idCronogramaEdital INTEGER GENERATED ALWAYS AS IDENTITY,
    idEdital INTEGER NOT NULL,
    dataPublicacaoOriginal DATE, --aqui não seria not null tbm?
    dataRealizacao DATE,
    dataDivulgacaoListaAprovados DATE,
    
    PRIMARY KEY(idCronogramaEdital),
    FOREIGN KEY(idEdital) REFERENCES Edital(idEdital),
    UNIQUE(idEdital, dataPublicacaoOriginal)
);

CREATE TABLE IF NOT EXISTS PeriodoInscricoesEdital (
    idCronogramaEdital INTEGER NOT NULL,
    inicioPeriodoI DATE NOT NULL,
    fimPeriodoI DATE NOT NULL,
    
    PRIMARY KEY(inicioPeriodoI, fimPeriodoI, idCronogramaEdital),
    FOREIGN KEY(idCronogramaEdital) REFERENCES CronogramaEdital(idCronogramaEdital)
);

CREATE TABLE IF NOT EXISTS PeriodoSubmissoesEdital (
    idCronogramaEdital INTEGER NOT NULL,
    inicioPeriodoS DATE NOT NULL,
    fimPeriodoS DATE NOT NULL,
    
    PRIMARY KEY(inicioPeriodoS, fimPeriodoS, idCronogramaEdital),
    FOREIGN KEY(idCronogramaEdital) REFERENCES CronogramaEdital(idCronogramaEdital)
);

CREATE TABLE IF NOT EXISTS Trabalho (
    idTrabalho INTEGER GENERATED ALWAYS AS IDENTITY,
    titulo VARCHAR(64) NOT NULL,
    palavraChave1 VARCHAR(16) NOT NULL,
    palavraChave2 VARCHAR(16) NOT NULL,
    palavraChave3 VARCHAR(16) NOT NULL,
    idiomaPrincipal VARCHAR(20) NOT NULL,
    status VARCHAR(16),
    idioma2 VARCHAR(20),
    idioma3 VARCHAR(20),
    descricao VARCHAR(200),
    palavraChave4 VARCHAR(16),
    palavraChave5 VARCHAR(16),
    tipoTrabalho VARCHAR(32) NOT NULL,
    
    PRIMARY KEY(idTrabalho),
    CHECK (tipoTrabalho IN ('Oficina', 'Minicurso','Artigo')),
    UNIQUE(titulo, palavraChave1, palavraChave2, palavraChave3, idiomaPrincipal)
);

CREATE TABLE IF NOT EXISTS Artigo (
  idTrabalho INTEGER NOT NULL,
  tipoArtigo VARCHAR(32) NOT NULL,
    
  PRIMARY KEY(idTrabalho),
  FOREIGN KEY(idTrabalho) REFERENCES Trabalho(idTrabalho),
  CHECK (tipoArtigo IN ('Resumo', 'ResumoEstendido', 'ArtigoCompleto'))
);

CREATE TABLE IF NOT EXISTS VersaoSintese (
  idTrabalho INTEGER NOT NULL,
  idioma VARCHAR(20) NOT NULL,
  texto TEXT NOT NULL,
  ehPrimario BOOLEAN NOT NULL, --fiquei com uma dúvida aqui, deixando assim, não seria possível eu colocar 2 sinteses como primarias?

  PRIMARY KEY(idTrabalho),
  FOREIGN KEY(idTrabalho) REFERENCES Artigo(idTrabalho)
);