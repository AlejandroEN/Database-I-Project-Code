CREATE TABLE InformacionInstitucion
(
    ruc            CHAR(11) PRIMARY KEY,
    descripcion    VARCHAR(1000),
    fundador       VARCHAR(100),
    fundacionFecha DATE,
    bannerUrl      VARCHAR(255),
    nombre         VARCHAR(150)
);


CREATE TABLE Persona
(
    dni             CHAR(8) PRIMARY KEY,
    nombres         VARCHAR(100),
    primerApellido  VARCHAR(50),
    segundoApellido VARCHAR(50),
    nacimientoFecha DATE,
    sexo            CHAR(1),
    email           VARCHAR(100)
);

CREATE TABLE Alumno
(
    dni           CHAR(8) PRIMARY KEY REFERENCES Persona(dni),
    nombreSeccion VARCHAR(50) REFERENCES Salon (nombreSeccion),
    gradoId       INT REFERENCES Grado (id),
    sedeId        INT REFERENCES Sede (id),
    apoderadoDni  CHAR(8) REFERENCES Apoderado (dni)
);

CREATE TABLE Apoderado
(
    dni           CHAR(8) PRIMARY KEY REFERENCES Persona (dni),
    numeroCelular VARCHAR(15)
);

CREATE TABLE Colaborador
(
    dni                   CHAR(8) PRIMARY KEY REFERENCES Persona (dni),
    sueldoMensual         FLOAT,
    cci                   VARCHAR(20),
    numeroCelular         VARCHAR(15),
    horasSemanalesTrabajo INT
);

CREATE TABLE Consejero
(
    dni    CHAR(8) PRIMARY KEY REFERENCES Colaborador (dni),
    sedeId INT REFERENCES Sede (id)
);

CREATE TABLE Secretario
(
    dni    CHAR(8) PRIMARY KEY REFERENCES Colaborador (dni),
    sedeId INT REFERENCES Sede (id)
);

CREATE TABLE Tutor
(
    dni    CHAR(8) PRIMARY KEY REFERENCES Colaborador (dni),
    sedeId INT REFERENCES Sede (id)
);

CREATE TABLE Profesor
(
    dni CHAR(8) PRIMARY KEY REFERENCES Colaborador (dni)
);

CREATE TABLE Grado
(
    id     INT PRIMARY KEY,
    nombre VARCHAR(50)
);

CREATE TABLE Curso
(
    id     INT PRIMARY KEY,
    nombre VARCHAR(50)
);

CREATE TABLE Salon
(
    aforo         INT,
    nombreSeccion VARCHAR(50),
    gradoId       INT REFERENCES Grado (id),
    sedeId        INT REFERENCES Sede (id),
    tutorDni      CHAR(8) REFERENCES Tutor (dni),
    PRIMARY KEY (nombreSeccion, sedeId)
);


CREATE TABLE Sede
(
    id                 INT PRIMARY KEY,
    coordenadaLongitud DOUBLE PRECISION,
    coordenadaLatitud  DOUBLE PRECISION,
    direccion          VARCHAR(255),
    construccionFecha  DATE,
    directorDni        CHAR(8) REFERENCES Persona (dni)
);

CREATE TABLE ProfesorSede
(
    profesorDni CHAR(8) PRIMARY KEY REFERENCES Profesor (dni),
    sedeId      INT REFERENCES Sede (id)
);

CREATE TABLE ProfesorCursoGrado
(
    cursoId          INT REFERENCES Curso (id),
    gradoId          INT REFERENCES Grado (id),
    profesorDni      CHAR(8) REFERENCES Profesor (dni),
    periodoAcademico DATE,
    PRIMARY KEY (cursoId, gradoId, profesorDni)
);

CREATE TABLE Matricula
(
    year          DATE,
    alumnoDni     CHAR(8) REFERENCES Alumno (dni),
    sedeId        INT REFERENCES Sede (id),
    gradoId       INT REFERENCES Grado (id),
    secretarioDni CHAR(8) REFERENCES Secretario (dni),
    PRIMARY KEY (year, alumnoDni, sedeId)
);
