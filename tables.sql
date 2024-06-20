CREATE TABLE Institucion (
    ruc            CHAR(11) PRIMARY KEY,
    descripcion    VARCHAR(1000) NOT NULL,
    fundador       VARCHAR(100)  NOT NULL,
    fundacionFecha DATE          NOT NULL,
    bannerUrl      VARCHAR(255)  NOT NULL,
    nombre         VARCHAR(150)  UNIQUE NOT NULL
);

CREATE TABLE Persona (
    dni             CHAR(8) PRIMARY KEY,
    nombres         VARCHAR(100) NOT NULL,
    primerApellido  VARCHAR(50)  NOT NULL,
    segundoApellido VARCHAR(50)  NOT NULL,
    nacimientoFecha DATE         NOT NULL,
    sexo            CHAR(1)      NOT NULL,
    email           VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE Colaborador (
    dni                   CHAR(8) PRIMARY KEY REFERENCES Persona (dni),
    sueldoHora            INT      NOT NULL,
    cci                   CHAR(20)    NOT NULL,
    numeroCelular         VARCHAR(15) NOT NULL,
    horasSemanalesTrabajo INT         NOT NULL,
    estaActivo BOOLEAN NOT NULL
);

CREATE TABLE Sede (
    id                 SERIAL PRIMARY KEY,
    coordenadaLongitud DOUBLE PRECISION                     NOT NULL,
    coordenadaLatitud  DOUBLE PRECISION                     NOT NULL,
    direccion          VARCHAR(255)                         NOT NULL,
    construccionFecha  DATE                                 NOT NULL,
    institucionRuc     CHAR(11) REFERENCES Institucion (ruc) NOT NULL
);

CREATE TABLE Director (
    dni CHAR(8) PRIMARY KEY REFERENCES Colaborador (dni),
    sedeId INT REFERENCES Sede (id) NOT NULL
);

CREATE TABLE Consejero (
    dni    CHAR(8) PRIMARY KEY REFERENCES Colaborador (dni),
    sedeId INT REFERENCES Sede (id) NOT NULL
);

CREATE TABLE Secretario (
    dni    CHAR(8) PRIMARY KEY REFERENCES Colaborador (dni),
    sedeId INT REFERENCES Sede (id) NOT NULL
);

CREATE TABLE Profesor (
    dni CHAR(8) PRIMARY KEY REFERENCES Colaborador (dni)
);

CREATE TABLE Grado (
    id     SERIAL PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE Curso (
    id     SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE Salon (
    aforo         INT NOT NULL,
    nombreSeccion VARCHAR(50) UNIQUE             NOT NULL,
    gradoId       INT REFERENCES Grado (id)      NOT NULL,
    sedeId        INT REFERENCES Sede (id)       NOT NULL,
    PRIMARY KEY (nombreSeccion, sedeId)
);

CREATE TABLE Tutor (
     dni    CHAR(8) PRIMARY KEY REFERENCES Colaborador (dni),
     salonNombreSeccion VARCHAR(50) REFERENCES Salon (nombreSeccion) NOT NULL,
     sedeId INT REFERENCES Sede (id) NOT NULL
);

CREATE TABLE Apoderado (
    dni           CHAR(8) PRIMARY KEY REFERENCES Persona (dni),
    numeroCelular VARCHAR(15) NOT NULL
);

CREATE TABLE Alumno (
    dni           CHAR(8) PRIMARY KEY REFERENCES Persona (dni),
    nombreSeccion VARCHAR(50) REFERENCES Salon (nombreSeccion) NOT NULL,
    sedeId        INT REFERENCES Sede (id)                     NOT NULL,
    apoderadoDni  CHAR(8) REFERENCES Apoderado (dni)           NOT NULL
);

CREATE TABLE ProfesorSede (
    profesorDni CHAR(8) REFERENCES Profesor (dni),
    sedeId      INT REFERENCES Sede (id) NOT NULL,
    PRIMARY KEY (profesorDni, sedeId)
);

CREATE TABLE ProfesorCursoGrado (
    cursoId          INT REFERENCES Curso (id),
    gradoId          INT REFERENCES Grado (id),
    profesorDni      CHAR(8) REFERENCES Profesor (dni),
    periodoAcademico DATE NOT NULL,
    PRIMARY KEY (cursoId, gradoId, profesorDni)
);

CREATE TABLE Matricula (
    year          INT,
    alumnoDni     CHAR(8) REFERENCES Alumno (dni),
    sedeId        INT REFERENCES Sede (id),
    gradoId       INT REFERENCES Grado (id)           NOT NULL,
    secretarioDni CHAR(8) REFERENCES Secretario (dni) NOT NULL,
    PRIMARY KEY (year, alumnoDni, sedeId)
);
