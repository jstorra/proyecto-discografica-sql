CREATE TABLE estudios (
  id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(50) NOT NULL,
  ubicacion VARCHAR(50) NOT NULL,
  fechaFundacion DATE NOT NULL
);

CREATE TABLE personas (
  id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  sexo ENUM('H','M') NOT NULL,
  tipo ENUM('artista','compositor','ingeniero') NOT NULL,
  nombre VARCHAR(20) NOT NULL,
  apellido1 VARCHAR(20) NOT NULL,
  apellido2 VARCHAR(20),
  nombreArtistico VARCHAR(20),
  telefonoPrincipal VARCHAR(20) NOT NULL,
  paisOrigen VARCHAR(20) NOT NULL,
  fechaNacimiento DATE NOT NULL,
  anyoInicioCarrera YEAR(4) NOT NULL,
  estudio_id INT NOT NULL
);

CREATE TABLE generos (
  id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(20) NOT NULL
);

CREATE TABLE genero_artista_compositor (
  persona_id INT NOT NULL,
  genero_id INT NOT NULL,
  PRIMARY KEY (persona_id, genero_id)
);

CREATE TABLE especializaciones (
  id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(50) NOT NULL
);

CREATE TABLE especializacion_persona (
  especializacion_id INT NOT NULL,
  persona_id INT NOT NULL,
  PRIMARY KEY (especializacion_id, persona_id)
);

CREATE TABLE telefonosPersona (
  telefono VARCHAR(20) NOT NULL,
  persona_id INT NOT NULL,
  PRIMARY KEY (telefono, persona_id)
);

CREATE TABLE albumes (
  id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  titulo VARCHAR(50) NOT NULL,
  fechaLanzamiento DATE NOT NULL,
  artista_id INT NOT NULL
);

CREATE TABLE formatos (
  id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(20) NOT NULL
);

CREATE TABLE formato_album (
  album_id INT NOT NULL,
  formato_id INT NOT NULL,
  PRIMARY KEY (album_id, formato_id)
);

CREATE TABLE canciones (
  id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  titulo VARCHAR(50) NOT NULL,
  duracion TIME NOT NULL,
  letra TEXT NOT NULL,
  album_id INT NOT NULL,
  compositor_id INT NOT NULL
);

CREATE TABLE relanzamientos (
  fechaRelanzamiento DATE NOT NULL,
  album_id INT NOT NULL,
  tipoRelanzamiento_id INT NOT NULL,
  PRIMARY KEY (album_id, fechaRelanzamiento)
);

CREATE TABLE tiposRelanzamiento (
  id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(20) NOT NULL
);

CREATE TABLE ventas (
  album_id INT NOT NULL,
  fechaVenta DATE NOT NULL,
  cantidadVendida INT NOT NULL,
  ingresos DOUBLE NOT NULL,
  PRIMARY KEY (album_id, fechaVenta)
);

CREATE TABLE giras (
  id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(50) NOT NULL,
  fechaInicio DATE NOT NULL,
  fechaFin DATE,
  artista_id INT NOT NULL
);

CREATE TABLE paises (
  id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(20) NOT NULL
);

CREATE TABLE pais_gira (
  gira_id INT NOT NULL,
  pais_id INT NOT NULL,
  PRIMARY KEY (gira_id, pais_id)
);


-- UIDS
ALTER TABLE personas ADD CONSTRAINT UC_Personas_NombreArtistico UNIQUE (nombreArtistico);
ALTER TABLE personas ADD CONSTRAINT UC_Personas_Telefono UNIQUE (telefonoPrincipal);

ALTER TABLE generos ADD CONSTRAINT UC_Generos_Nombre UNIQUE (nombre);

ALTER TABLE especializaciones ADD CONSTRAINT UC_Especializaciones_Nombre UNIQUE (nombre);

ALTER TABLE albumes ADD CONSTRAINT UC_Albumes_Titulo UNIQUE (titulo);

ALTER TABLE formatos ADD CONSTRAINT UC_Formatos_Nombre UNIQUE (nombre);

ALTER TABLE canciones ADD CONSTRAINT UC_Formatos_Titulo UNIQUE (titulo);
ALTER TABLE canciones ADD CONSTRAINT UC_Formatos_Letra UNIQUE (letra);

ALTER TABLE estudios ADD CONSTRAINT UC_Estudios_Nombre UNIQUE (nombre);

ALTER TABLE tiposRelanzamiento ADD CONSTRAINT UC_TiposRelanzamiento_Nombre UNIQUE (nombre);

ALTER TABLE giras ADD CONSTRAINT UC_Giras_Nombre UNIQUE (nombre);

ALTER TABLE paises ADD CONSTRAINT UC_Paises_Nombre UNIQUE (nombre);


-- FOREIGN KEYS
ALTER TABLE personas ADD CONSTRAINT FK_Personas_Estudio_id FOREIGN KEY (estudio_id) REFERENCES estudios (id);

ALTER TABLE genero_artista_compositor ADD CONSTRAINT FK_Genero_artista_compositor_Persona_id FOREIGN KEY (persona_id) REFERENCES personas (id);
ALTER TABLE genero_artista_compositor ADD CONSTRAINT FK_Genero_artista_compositor_Genero_id FOREIGN KEY (genero_id) REFERENCES generos (id);

ALTER TABLE especializacion_persona ADD CONSTRAINT FK_Especializacion_persona_Especializacion_id FOREIGN KEY (especializacion_id) REFERENCES especializaciones (id);
ALTER TABLE especializacion_persona ADD CONSTRAINT FK_Especializacion_persona_Persona_id FOREIGN KEY (persona_id) REFERENCES personas (id);

ALTER TABLE telefonosPersona ADD CONSTRAINT FK_TelefonosPersona_Persona_id FOREIGN KEY (persona_id) REFERENCES personas (id);

ALTER TABLE albumes ADD CONSTRAINT FK_Albumes_Artista_id FOREIGN KEY (artista_id) REFERENCES personas (id);

ALTER TABLE formato_album ADD CONSTRAINT FK_Formato_album_Album_id FOREIGN KEY (album_id) REFERENCES albumes (id);
ALTER TABLE formato_album ADD CONSTRAINT FK_Formato_album_Formato_id FOREIGN KEY (formato_id) REFERENCES formatos (id);

ALTER TABLE canciones ADD CONSTRAINT FK_Canciones_Album_id FOREIGN KEY (album_id) REFERENCES albumes (id);
ALTER TABLE canciones ADD CONSTRAINT FK_Canciones_Compositor_id FOREIGN KEY (compositor_id) REFERENCES personas (id);

ALTER TABLE relanzamientos ADD CONSTRAINT FK_Relanzamientos_Album_id FOREIGN KEY (album_id) REFERENCES albumes (id);
ALTER TABLE relanzamientos ADD CONSTRAINT FK_Relanzamientos_TipoRelanzamiento_id FOREIGN KEY (tipoRelanzamiento_id) REFERENCES tiposRelanzamiento (id);

ALTER TABLE ventas ADD CONSTRAINT FK_Ventas_Album_id FOREIGN KEY (album_id) REFERENCES albumes (id);

ALTER TABLE giras ADD CONSTRAINT FK_Giras_Artista_id FOREIGN KEY (artista_id) REFERENCES personas (id);

ALTER TABLE pais_gira ADD CONSTRAINT FK_Pais_gira_Gira_id FOREIGN KEY (gira_id) REFERENCES giras (id);
ALTER TABLE pais_gira ADD CONSTRAINT FK_Pais_gira_Pais_id FOREIGN KEY (pais_id) REFERENCES paises (id);