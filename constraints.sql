ALTER TABLE InformacionInstitucion
ADD CONSTRAINT CHK_InformacionInstitucionRuc CHECK (ruc NOT LIKE '%[^0-9]%');

ALTER TABLE InformacionInstitucion
ADD CONSTRAINT UC_InformacionInstituticion UNIQUE (nombre);

ALTER TABLE InformacionInstitucion
ADD CONSTRAINT CHK_InformacionInstitucionBannerUrl CHECK (bannerUrl LIKE 'http://%' OR bannerUrl LIKE 'https://%');

----

ALTER TABLE Persona
ADD CONSTRAINT CHK_PersonaDni CHECK (dni NOT LIKE '%[^0-9]%');

ALTER TABLE Persona
ADD CONSTRAINT UC_Persona UNIQUE (email);

ALTER TABLE Persona
ADD CONSTRAINT CHK_PersonaSexo CHECK (sexo IN ('M', 'F'));

ALTER TABLE Persona
ADD CONSTRAINT CHK_PersonaEmailFormat CHECK (email LIKE '%_@__%.__%');

----

ALTER TABLE Alumno
ADD CONSTRAINT CHK_AlumnoDni CHECK (dni NOT LIKE '%[^0-9]%');

----