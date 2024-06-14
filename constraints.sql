ALTER TABLE InformacionInstitucion
    ADD CONSTRAINT CHK_InformacionInstitucionRuc
        CHECK (ruc NOT LIKE '%[^0-9]%');

ALTER TABLE InformacionInstitucion
    ADD CONSTRAINT UC_InformacionInstituticion
        UNIQUE (nombre);

ALTER TABLE InformacionInstitucion
    ADD CONSTRAINT CHK_InformacionInstitucionBannerUrl
        CHECK (bannerUrl LIKE 'http://%' OR bannerUrl LIKE 'https://%');

----

ALTER TABLE Persona
    ADD CONSTRAINT CHK_PersonaDni
        CHECK (dni NOT LIKE '%[^0-9]%');

ALTER TABLE Persona
    ADD CONSTRAINT UC_Persona
        UNIQUE (email);

ALTER TABLE Persona
    ADD CONSTRAINT CHK_PersonaSexo
        CHECK (sexo IN ('M', 'F'));

ALTER TABLE Persona
    ADD CONSTRAINT CHK_PersonaEmailFormat
        CHECK (email LIKE '%_@__%.__%');

----

ALTER TABLE Apoderado
    ADD CONSTRAINT CHK_ApoderadoNumeroCelular
        CHECK (numeroCelular LIKE '+%[0-9 ]%' OR numeroCelular NOT LIKE '%[^0-9 ]%');

----

ALTER TABLE Colaborador
    ADD CONSTRAINT CHK_ColaboradorSueldoMensual
        CHECK (sueldoMensual >= 1025);

ALTER TABLE Colaborador
    ADD CONSTRAINT CHK_ColaboradorCCI
        CHECK (cci NOT LIKE '%[^0-9]%');

ALTER TABLE Colaborador
    ADD CONSTRAINT CHK_ColaboradorNumeroCelular
        CHECK (numeroCelular LIKE '+%[0-9 ]%' OR numeroCelular NOT LIKE '%[^0-9 ]%');

ALTER TABLE Colaborador
    ADD CONSTRAINT CHK_ColaboradorHorasSemanalesTrabajo
        CHECK (horasSemanalesTrabajo BETWEEN 1 AND 168);

----

ALTER TABLE Salon
    ADD CONSTRAINT CHK_SalonAforo
        CHECK (aforo > 0);

----

ALTER TABLE Sede
    ADD CONSTRAINT CHK_SedeCoordenadaLongitud
        CHECK (coordenadaLongitud BETWEEN -180 AND 180);

ALTER TABLE Sede
    ADD CONSTRAINT CHK_SedeCoordenadaLatitud
        CHECK (coordenadaLatitud BETWEEN -90 AND 90);

ALTER TABLE Sede
    ADD CONSTRAINT CHK_SedeConstruccionFecha
        CHECK (construccionFecha <= CURRENT_DATE);

----

ALTER TABLE ProfesorCursoGrado
    ADD CONSTRAINT CHK_ProfesorCursoGradoPeriodoAcademico
        CHECK (periodoAcademico <= CURRENT_DATE);

----

ALTER TABLE Matricula
    ADD CONSTRAINT CHK_MatriculaYear_Current
        CHECK (year <= EXTRACT(YEAR FROM CURRENT_DATE));
