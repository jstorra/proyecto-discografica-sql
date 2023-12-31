USE discografica;

INSERT INTO estudios (nombre, ubicacion, fechaFundacion) VALUES
('Estudio Sonic', 'Los Angeles, CA', '2000-05-15'),
('SoundLab Studios', 'Nashville, TN', '1998-11-23'),
('Harmony Studios', 'London, UK', '2005-08-10'),
('Pulse Recording', 'New York, NY', '2003-04-30'),
('Golden Ear Studios', 'Berlin, Germany', '1995-07-18'),
('Echo Sound Works', 'Tokyo, Japan', '2008-02-14'),
('Melody Studios', 'Sydney, Australia', '1990-09-05'),
('Metro Sound Productions', 'Toronto, Canada', '1997-12-12'),
('Euphony Studios', 'Paris, France', '2001-06-28'),
('Rhythm Room Studios', 'Austin, TX', '1993-03-08'),
('Mystic Sound Studios', 'Stockholm, Sweden', '2007-10-03'),
('Fusion Studios', 'São Paulo, Brazil', '1992-01-20'),
('Celestial Soundscapes', 'Cape Town, South Africa', '2004-09-17'),
('Pacific Sound Studios', 'Vancouver, Canada', '1999-06-25'),
('Epicenter Productions', 'Moscow, Russia', '2006-12-07'),
('Astral Audio Studios', 'Buenos Aires, Argentina', '1996-04-14'),
('Zenith Studios', 'Seoul, South Korea', '2010-03-22'),
('Virtuoso Studios', 'Vienna, Austria', '1994-08-31'),
('Harmonic Heights', 'Mumbai, India', '2009-01-12'),
('Crescendo Studios', 'Mexico City, Mexico', '1991-07-02');

INSERT INTO personas (sexo, tipo, nombre, apellido1, apellido2, nombreArtistico, telefonoPrincipal, paisOrigen, fechaNacimiento, anyoInicioCarrera, estudio_id) VALUES
('H', 'artista', 'Juan', 'Perez', 'Gomez', 'Juanito', '+1 555-987-6543', 'España', '1990-01-15', 2010, 1),
('M', 'compositor', 'Ana', 'Lopez', 'Garcia', NULL, '+44 20 7946 2154', 'Argentina', '1985-05-20', 2005, 2),
('H', 'ingeniero', 'Carlos', 'Gonzalez', 'Fernandez', NULL, '+33 1 45 67 89 21', 'México', '1982-11-10', 2002, 3),
('M', 'artista', 'Elena', 'Martinez', 'Ruiz', 'Elenita', '+49 30 87654321', 'Colombia', '1995-03-08', 2015, 3),
('H', 'compositor', 'Javier', 'Sanchez', 'Lopez', NULL, '+81 3-5678-9012', 'Perú', '1978-07-25', 1998, 4),
('M', 'ingeniero', 'Laura', 'Diaz', 'Gutierrez', NULL, '+39 02 3456 7890', 'Chile', '1980-09-18', 2000, 5),
('H', 'artista', 'Miguel', 'Rodriguez', 'Fernandez', 'Miguelito', '+34 91 234 56 78', 'Uruguay', '1987-12-03', 2007, 6),
('M', 'compositor', 'Isabel', 'Lopez', 'Perez', NULL, '+86 10 5678 1234', 'Brasil', '1992-06-30', 2012, 7),
('H', 'ingeniero', 'Roberto', 'Gomez', 'Hernandez', NULL, '+61 2 3456 7890', 'Ecuador', '1984-04-12', 2004, 7),
('M', 'artista', 'Sofia', 'Garcia', 'Martinez', 'Sof', '+7 495 987-654-32', 'Venezuela', '1998-02-22', 2018, 8),
('H', 'artista', 'Luis', 'Fernandez', NULL, 'Lucho', '+52 55 7890 1234', 'Argentina', '1993-08-10', 2013, 9),
('M', 'compositor', 'Carmen', 'Gutierrez', 'Lopez', NULL, '+1 416-555-5678', 'México', '1989-04-05', 2009, 10),
('H', 'ingeniero', 'Raúl', 'Hernandez', 'Diaz', NULL, '+33 1 23 45 67 98', 'Canada', '1981-12-18', 2001, 10),
('M', 'artista', 'Pedro', 'Martinez', 'Fernandez', 'Pedrito', '+49 40 12345678', 'Colombia', '1997-07-12', 2017, 11),
('H', 'compositor', 'Ana', 'Hernandez', 'Perez', NULL, '+81 90-1234-5678', 'España', '1983-04-25', 2003, 12),
('M', 'ingeniero', 'Diego', 'Gomez', 'Rodriguez', NULL, '+39 06 1234 5678', 'Chile', '1986-11-30', 2006, 13),
('H', 'artista', 'Marina', 'Sanchez', 'Lopez', 'Marinita', '+34 93 123 45 67', 'Perú', '1990-02-15', 2010, 14),
('M', 'compositor', 'Alejandro', 'Perez', 'Gutierrez', NULL, '+86 21 1234 5678', 'Brasil', '1980-08-08', 2000,14),
('H', 'ingeniero', 'Julio', 'Gutierrez', 'Fernandez', NULL, '+61 3 2345 6789', 'Venezuela', '1989-06-03', 2009, 15),
('M', 'artista', 'Camila', 'Martinez', 'Ruiz', 'Cami', '+7 812 123-45-67', 'Ecuador', '1995-03-22', 2015, 19);

INSERT INTO generos (nombre) VALUES
('Rock'),
('Pop'),
('Jazz'),
('Electrónica'),
('Hip Hop'),
('Clásica'),
('Reggae'),
('Salsa'),
('Blues'),
('Country'),
('Rap'),
('Folk'),
('Metal'),
('R&B'),
('Indie'),
('Funk'),
('Soul'),
('Disco'),
('Punk'),
('Reguetón');

INSERT INTO genero_artista_compositor (persona_id, genero_id) VALUES
(1, 13),
(1, 11),
(2, 17),
(4, 20),
(5, 5),
(7, 1),
(8, 3),
(10, 8),
(10, 7),
(11, 14),
(12, 9),
(12, 19),
(14, 2),
(15, 1),
(15, 13),
(17, 18),
(18, 15),
(18, 16),
(20, 18),
(20, 20);

INSERT INTO especializaciones (nombre) VALUES
('Producción Musical'),
('Ingeniería de Sonido'),
('Composición Musical'),
('Diseño de Sonido'),
('Gestión de Eventos Musicales'),
('Marketing Musical'),
('Distribución Digital de Música'),
('Gestión de Derechos de Autor'),
('Promoción Artística'),
('Desarrollo de Carrera Musical'),
('Producción de Conciertos'),
('Arreglos Musicales'),
('Ingeniería Acústica'),
('Edición Musical'),
('Música para Medios Audiovisuales'),
('Diseño de Portadas de Álbumes'),
('Masterización de Audio'),
('Producción de Música Electrónica'),
('Tecnología Musical'),
('Estrategias de Branding en la Industria Musical');

INSERT INTO especializacion_persona (especializacion_id, persona_id) VALUES
(1, 13),
(1, 11),
(2, 6),
(3, 3),
(4, 5),
(4, 9),
(5, 4),
(6, 10),
(6, 9),
(7, 4),
(8, 7),
(9, 19),
(10, 20),
(11, 15),
(14, 13),
(18, 12),
(18, 11),
(19, 19),
(20, 4),
(20, 8);

INSERT INTO telefonosPersona (telefono, persona_id) VALUES
('+1 555-876-5432', 1),
('+44 20 7946 2109', 1),
('+33 1 45 67 89 11', 3),
('+49 30 76543210', 4),
('+81 3-6789-0123', 5),
('+39 02 3456 7891', 6),
('+34 91 234 56 79', 6),
('+86 10 5678 1235', 8),
('+61 2 3456 7891', 8),
('+7 495 876-543-21', 9),
('+52 55 7890 1235', 10),
('+1 416-555-6789', 11),
('+33 1 23 45 67 99', 13),
('+49 40 12345678', 14),
('+81 90-1234-5678', 15),
('+39 06 1234 5679', 15),
('+34 93 123 45 68', 17),
('+86 21 1234 5679', 18),
('+61 3 2345 6789', 20),
('+7 812 123-45-68', 20);

INSERT INTO albumes (titulo, fechaLanzamiento, artista_id) VALUES
('Amanecer Musical', '2022-03-10', 4),
('Sinfonía Nocturna', '2021-08-25', 1),
('Ritmo del Corazón', '2020-11-15', 1),
('Melodías del Alma', '2019-05-02', 4),
('Viaje Sonoro', '2018-09-12', 10),
('Huellas Musicales', '2017-04-20', 10),
('Reflejos Acústicos', '2016-07-08', 7),
('Notas en el Viento', '2015-12-30', 14),
('Aurora Musical', '2014-02-14', 17),
('Ecos del Pasado', '2013-06-18', 14),
('Armonías Celestiales', '2012-10-05', 11),
('Cantos del Universo', '2011-03-22', 10),
('Misterios Musicales', '2010-09-08', 7),
('Sonatas del Silencio', '2009-12-01', 4),
('Rapsodia Estelar', '2008-04-05', 1),
('Sueños Sonoros', '2007-08-19', 14),
('Vibraciones Místicas', '2006-01-14', 4),
('Expresiones Audaces', '2005-05-28', 14),
('Canciones del Corazón', '2004-09-03', 11),
('Ecos del Tiempo', '2003-12-20', 4);

INSERT INTO formatos (nombre) VALUES
('CD estándar'),
('Vinilo LP'),
('Casete'),
('CD Deluxe'),
('Vinilo 7 pulgadas'),
('Edición Limitada CD'),
('Vinilo Picture Disc'),
('Casete de Colección'),
('CD Doble'),
('Vinilo 12 pulgadas'),
('Edición Especial Vinilo'),
('Casete de Edición Limitada'),
('CD Acústico'),
('Vinilo Colorido'),
('Casete Retro'),
('CD en Vivo'),
('Vinilo 10 pulgadas'),
('Casete Clásico'),
('CD Recopilatorio'),
('Vinilo EP');

INSERT INTO formato_album (album_id, formato_id) VALUES
(1, 1),
(1, 4),
(2, 5),
(2, 1),
(3, 9),
(3, 10),
(4, 14),
(4, 15),
(5, 3),
(5, 10),
(6, 18),
(6, 19),
(7, 1),
(7, 4),
(8, 8),
(8, 13),
(9, 17),
(9, 18),
(10, 19),
(10, 20);

INSERT INTO canciones (titulo, duracion, letra, album_id, compositor_id) VALUES
('Bohemian Rhapsody', '06:07:00', 'Is this the real life. Is this just fantasy. Caught in a landside. No escape from reality.', 1, 4),
('Like a Rolling Stone', '06:13:00', "Once upon a time. You dressed so fine. You threw the bums a dime. In your prime, didn't you?", 2, 1),
('Imagine', '03:03:00', "Imagine there's no heaven. It's easy if you try. No hell below us. Above us only sky.", 4, 4),
('A Day in the Life', '05:35:00', 'I read the news today, oh boy. About a lucky man who made the grade. And though the news was rather sad.', 4, 7),
('Purple Haze', '02:50:00', "Purple haze all in my brain. Lately things just don't seem the same. Actin' funny, but I don't know why.", 7, 5),
("What's Going On", '03:52:00', "Mother, mother. There's too many of you crying. Brother, brother, brother. There's far too many of you dying.", 8, 18),
('Hotel California', '06:30:00', 'On a dark desert highway, cool wind in my hair. Warm smell of colitas, rising through the air. Up ahead in the distance.', 10, 7),
("Blowin' in the Wind", '02:48:00', 'How many roads must a man walk down. Before you call him a man? How many seas must a white dove sail.', 3, 8),
('Billie Jean', '04:54:00', "She was more like a beauty queen from a movie scene. I said don't mind, but what do you mean. I am the one.", 5, 10),
('Smells Like Teen Spirit', '05:01:00', "Load up on guns, bring your friends. It's fun to lose and to pretend. She's overboard and self-assured.", 14, 4),
('Stairway to Heaven', '08:02:00', "There's a lady who's sure all that glitters is gold. And she's buying a stairway to heaven. When she gets there.", 15, 11),
('Let It Be', '03:50:00', 'When I find myself in times of trouble. Mother Mary comes to me. Speaking words of wisdom. Let it be.', 19, 12),
('Hey Jude', '07:11:00', "Hey Jude, don't make it bad. Take a sad song and make it better. Remember to let her into your heart.", 20, 4),
("What'd I Say", '06:30:00', "Hey mama, don't you treat me wrong. Come and love your daddy all night long. All right now. Hey hey, all right.", 14, 4),
("The Times They Are A-Changin'", '03:15:00', "Come gather 'round people. Wherever you roam. And admit that the waters. Around you have grown.", 15, 15),
('Boogie Woogie Bugle Boy', '02:26:00', 'He was a famous trumpet man from out Chicago way. He had a boogie style that no one else could play.', 16, 17),
('Johnny B. Goode', '02:41:00', 'Deep down in Louisiana close to New Orleans. Way back up in the woods among the evergreens.', 17, 4),
('My Generation', '03:15:00', 'People try to put us down. Just because we get around. Things they do look awful cold. I hope I die before I get old.', 12, 18),
('Born to Run', '04:30:00', 'In the day we sweat it out on the streets of a runaway American dream. At night we ride through mansions of glory in suicide machines.', 5, 5),
('Superstition', '04:28:00', "Very superstitious, writings on the wall. Very superstitious, ladders bout' to fall. Thirteen-month-old baby.", 9, 20);

INSERT INTO tiposRelanzamiento (nombre) VALUES
('Edición Especial'),
('Remasterizado'),
('Versión Deluxe'),
('Aniversario'),
('Vinilo de Colección'),
('Acústico'),
('En Vivo'),
('Edición Limitada'),
('Digital Remasterizado'),
('Versión Extendida'),
('Clásico'),
('Reimaginado'),
('Recopilatorio'),
('Sesiones Inéditas'),
('Versión Original'),
('Vinilo Transparente'),
('Edición de Lujo'),
('Concierto Especial'),
('Versión Alternativa'),
('Edición de Coleccionista');

INSERT INTO relanzamientos (fechaRelanzamiento, album_id, tipoRelanzamiento_id) VALUES
('2022-03-20', 1, 1),
('2021-10-15', 2, 2),
('2020-05-28', 3, 1),
('2019-09-12', 4, 7),
('2018-12-05', 5, 8),
('2017-06-30', 6, 9),
('2016-09-18', 7, 1),
('2015-11-25', 8, 2),
('2014-03-08', 9, 4),
('2013-07-22', 10, 17),
('2012-11-10', 11, 18),
('2011-04-15', 12, 10),
('2010-10-02', 13, 20),
('2009-12-20', 14, 3),
('2008-06-14', 15, 7),
('2007-09-30', 16, 6),
('2006-12-15', 17, 19),
('2005-03-28', 18, 18),
('2004-08-10', 19, 19),
('2003-11-05', 20, 20);

INSERT INTO ventas (album_id, fechaVenta, cantidadVendida, ingresos) VALUES
(1, '2022-03-20', 500, 750000.00),
(7, '2021-10-15', 300, 450000.00),
(9, '2020-05-28', 700, 1050000.00),
(10, '2019-09-12', 400, 600000.00),
(2, '2018-12-05', 600, 900000.00),
(4, '2017-06-30', 800, 1200000.00),
(19, '2016-09-18', 200, 30000.00),
(20, '2015-11-25', 900, 1350000.00),
(15, '2014-03-08', 100, 150000.00),
(17, '2013-07-22', 450, 675000.00),
(18, '2012-11-10', 550, 825000.00),
(8, '2011-04-15', 350, 525000.00),
(9, '2010-10-02', 250, 375000.00),
(12, '2009-12-20', 150, 225000.00),
(15, '2008-06-14', 950, 1425000.00),
(3, '2007-09-30', 1000, 150000.00),
(6, '2006-12-15', 300, 450000.00),
(17, '2005-03-28', 700, 1050000.00),
(5, '2004-08-10', 400, 600000.00),
(16, '2003-11-05', 600, 900000.00);

INSERT INTO giras (nombre, fechaInicio, fechaFin, artista_id) VALUES
('Gira Mundial 2022', '2022-04-01', NULL, 1),
('Tour Europeo 2021', '2021-09-15', '2021-12-20', 4),
('Gira América del Norte', '2020-06-01', NULL, 7),
('Gira Sudamericana 2019', '2019-03-10', '2019-05-25', 10),
('Asia Tour 2018', '2018-08-01', NULL, 11),
('Gira Oceanía 2017', '2017-05-15', '2017-08-20', 14),
('Norteamérica Tour 2016', '2016-10-01', NULL, 17),
('Europa del Este 2015', '2015-04-20', '2015-07-10', 20),
('Gira Latinoamericana 2014', '2014-01-15', '2014-04-05', 7),
('Gira África 2013', '2013-08-05', '2013-11-25', 7),
('Tour Asia-Pacífico 2012', '2012-06-10', '2012-09-20', 4),
('Gira América del Sur 2011', '2011-03-01', '2011-06-15', 20),
('Tour Europa Occidental 2010', '2010-09-15', NULL, 11),
('Gira Norteamérica 2009', '2009-05-01', '2009-08-10', 1),
('Asia Tour 2008', '2008-12-20', '2009-02-28', 4),
('Gira Oceanía 2007', '2007-07-05', '2007-10-15', 14),
('Norteamérica Tour 2006', '2006-04-15', NULL, 17),
('Europa del Este 2005', '2005-11-01', NULL, 20),
('Gira Latinoamericana 2004', '2004-08-10', '2004-10-25', 1),
('Tour Mundial 2003', '2003-06-01', NULL, 10);

INSERT INTO paises (nombre) VALUES
('Estados Unidos'),
('Reino Unido'),
('Canadá'),
('Australia'),
('Alemania'),
('Japón'),
('Brasil'),
('Suecia'),
('Francia'),
('México'),
('Italia'),
('España'),
('Argentina'),
('India'),
('China'),
('Rusia'),
('Sudáfrica'),
('Corea del Sur'),
('Austria'),
('Nueva Zelanda');

INSERT INTO pais_gira (gira_id, pais_id) VALUES
(1, 3),
(1, 8),
(1, 9),
(2, 5),
(3, 20),
(5, 8),
(6, 18),
(9, 8),
(9, 20),
(10, 6),
(11, 9),
(12, 14),
(12, 18),
(14, 10),
(15, 19),
(19, 1),
(19, 13),
(20, 3),
(20, 17),
(20, 20);