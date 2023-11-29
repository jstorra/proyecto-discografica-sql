# Sistema de Gestión para una Discográfica

## Secciones

-   [**Requisitos de Uso**](#requisitos-de-uso)
-   [**Enunciado**](#enunciado)
-   [**Requisitos Funcionales del Sistema**](#requisitos-funcionales)
-   [**Restricciones del Sistema**](#restricciones)
-   [**Consultas**](#consultas)
-   [**Modelos (IMG)**](#modelos)
-   [**Uso del Proyecto**](#uso-del-proyecto)

## Requisitos de Uso

Tener instalado un gestor de base de datos, preferiblemente **MySQL**, es fundamental para realizar consultas de forma eficiente.

## Enunciado

Una reconocida discográfica ha decidido modernizar su sistema de gestión para optimizar el manejo de la información sobre artistas, compositores, álbumes, canciones, estudios de grabación, ingenieros de sonido, fechas de lanzamiento, ventas y giras. La discográfica desea un sistema que le permita organizar eficientemente sus operaciones diarias, incluyendo el seguimiento de la producción musical, la gestión de eventos de lanzamiento, el control de ventas y el manejo de giras de artistas.

Las personas registradas en el sistema, ya sea de tipo **artista**, **compositor** o **ingeniero**, pueden tener muchas especializaciones, por lo que se deberá llevar un registro de estas. Además, un **artista** o **compositor** pueden abordar distintos tipos de géneros musicales y la discográfica desea almacenar esa información. Se deja en claro que un **artista** puede ser a la vez un compositor de sus propias canciones como tambien puede ser el compositor de la cancion de otro artista.

Se desea manejar el sistema de forma en la que pueden existir varias canciones de un único artista con su correspondiente compositor; estas canciones pertenecen específicamente a un álbum, ya que no se pretende, por el momento, realizar álbumes de mejores canciones con canciones de diferentes álbumes. Los álbumes tienen su correspondiente ingreso generado de venta, el cual es dividido por día de venta. Es decir, se genera un registro diario de los ingresos obtenidos por ese día.

Debemos tener en cuenta que pueden existir álbumes remasterizados o de ediciones especiales, por lo que debemos llevar un registro de los álbumes que fueron relanzados y su respectivo tipo de relanzamiento. Además, cada álbum puede tener distintos tipos de formatos para su lanzamiento.

Para finalizar, la discográfica requiere llevar el registro de las giras de un artista, especificando su fecha de inicio, fecha de fin en caso de ya estar estipulada y los países en los que se llevará a cabo la misma.

## Requisitos Funcionales

1. **Registro de Artistas:**

    - Almacenar información detallada sobre los artistas, incluyendo nombre, apellidos, nombre artístico, país de origen, año de inicio en la industria, etc.

2. **Registro de Compositores:**

    - Almacenar información detallada sobre los compositores, incluyendo nombre, apellidos, país de origen, año de inicio en la industria, etc.

3. **Catálogo de Álbumes y Canciones:**

    - Mantener un catálogo completo de álbumes, con detalles como título, fecha de lanzamiento y formato.
    - Registrar información detallada sobre cada canción, incluyendo título, duración, compositor y letra.

4. **Estudios de Grabación e Ingenieros de Sonido:**

    - Gestionar la información de los estudios de grabación, incluyendo nombre, ubicación y año de fundación.
    - Registrar los ingenieros de sonido asociados a cada estudio, con detalles sobre su nombre, apellidos, año de inicio en la carrera, etc.

5. **Fechas de Lanzamiento y Ventas:**

    - Seguir las fechas de lanzamiento y relanzamiento de álbumes.
    - Mantener un registro sobre los relanzamientos de álbumes como la fecha y el tipo de relanzamiento.
    - Registrar información sobre las ventas, incluyendo la cantidad vendida y los ingresos generados.

6. **Gestión de Giras:**
    - Mantener un registro de las giras de los artistas, incluyendo el nombre de la gira, la fecha de inicio y fin, así como los países visitados.

## Restricciones

### Personas

-   Un artista puede abordar diferentes géneros musicales.
-   Un compositor puede abordar diferentes géneros musicales.
-   Una persona puede tener uno o más teléfonos de contacto.
-   Una persona puede tener una o muchas especializaciones.

### Estudios de grabación

-   Cada estudio de grabación puede tener varios artistas, pero cada artista está asociado a un solo estudio de grabación.
-   Cada estudio de grabación puede tener varios compositores, pero cada compositor está asociado a un solo estudio de grabación.
-   Cada estudio de grabación puede tener varios ingenieros de sonido, pero cada ingeniero de sonido está asociado a un solo estudio de grabación.

### Álbumes y Canciones

-   Cada álbum debe estar asociado a un único artista.
-   Cada álbum puede ser relanzado en varias ocasiones.
-   Cada álbum puede tener más de un formato.
-   Cada canción debe pertenecer a un álbum.
-   Cada canción debe estar compuesta por un único compositor.

### Lanzamientos

-   Las fechas de lanzamiento y relanzamiento están vinculadas a álbumes específicos.
-   Los relanzamientos deben especificar el tipo de relanzamiento.

### Giras y Ventas

-   Cada gira está vinculada a un artista específico.
-   Cada gira puede visitar muchos países.
-   Las ventas están asociadas a álbumes especificos.

Este sistema de gestión permitirá a la discográfica mantener un control efectivo sobre sus operaciones, facilitando la toma de decisiones y mejorando la eficiencia en la producción musical y la promoción de sus artistas.

# Consultas

- ## estudios

   ### CRUD

   - **Insertar**

      ```SQL
      INSERT INTO estudios (nombre, ubicacion, fechaFundacion)
      VALUES ('Estudio Sonic', 'Los Angeles, CA', '2000-05-15');
      ```

   - **Seleccionar**
   
      ```SQL
      SELECT * FROM estudios WHERE id = 1;
      ```

   - **Actualizar**

      ```SQL
      UPDATE estudios SET nombre = 'Estudio Sonic' WHERE id = 1;
      ```

   - **Eliminar**

      ```SQL
      DELETE FROM estudios WHERE id = 1;
      ```

   ### 1. Mostrar la información de todos los estudios junto con la cantidad de personas (artistas, compositores e ingenieros) asociadas a cada uno.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS estudios_CantPersonasEstudio //
   CREATE PROCEDURE estudios_CantPersonasEstudio()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM estudios
      );

      IF @consulta > 0 THEN
         SELECT e.id, e.nombre, e.ubicacion, e.fechaFundacion, (
            SELECT COUNT(*) FROM personas p WHERE p.estudio_id = e.id
         ) AS total_personas
         FROM estudios e;
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL estudios_CantPersonasEstudio();
   ```

   ### 2. Listar los estudios que tienen al menos un artista.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS estudios_ListarEstudiosUnArtista //
   CREATE PROCEDURE estudios_ListarEstudiosUnArtista()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM estudios WHERE id IN (
            SELECT DISTINCT estudio_id FROM personas WHERE tipo = 'artista'
         )
      );

      IF @consulta > 0 THEN
         SELECT id, nombre, ubicacion, fechaFundacion FROM estudios WHERE id IN (
            SELECT DISTINCT estudio_id FROM personas WHERE tipo = 'artista'
         );
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL estudios_ListarEstudiosUnArtista();
   ```

   ### 3. Mostrar estudios que fueron fundados antes que cualquier estudio en Canada.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS estudios_ListarEstudiosAntesCanada //
   CREATE PROCEDURE estudios_ListarEstudiosAntesCanada()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM estudios WHERE fechaFundacion < (
            SELECT MIN(fechaFundacion) FROM estudios WHERE ubicacion LIKE '%Canada%'
         )
      );

      IF @consulta > 0 THEN
         SELECT id, nombre, ubicacion, fechaFundacion FROM estudios WHERE fechaFundacion < (
            SELECT MIN(fechaFundacion) FROM estudios WHERE ubicacion LIKE '%Canada%'
         );
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL estudios_ListarEstudiosAntesCanada();
   ```

   ### 4. Listar estudios junto con la edad promedio de las personas asociadas a cada uno.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS estudios_PromedioEdadPersonas //
   CREATE PROCEDURE estudios_PromedioEdadPersonas()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM estudios
      );

      IF @consulta > 0 THEN
         SELECT e.id, e.nombre, e.ubicacion, e.fechaFundacion,
            ROUND(AVG(YEAR(CURDATE()) - YEAR(p.fechaNacimiento)), 2) AS edad_promedio
         FROM estudios e
         LEFT JOIN personas p ON e.id = p.estudio_id
         GROUP BY e.id;
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL estudios_PromedioEdadPersonas();
   ```

   ### 5. Mostrar estudios que tienen más de 3 personas asociadas.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS estudios_EstudiosMayor3Personas //
   CREATE PROCEDURE estudios_EstudiosMayor3Personas()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM estudios WHERE id IN (
            SELECT estudio_id FROM personas
            GROUP BY estudio_id
            HAVING COUNT(*) > 3
         )
      );

      IF @consulta > 0 THEN
         SELECT id, nombre, ubicacion, fechaFundacion FROM estudios WHERE id IN (
            SELECT estudio_id FROM personas
            GROUP BY estudio_id
            HAVING COUNT(*) > 3
         );
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL estudios_EstudiosMayor3Personas();
   ```

   ### 6. Listar estudios junto con la cantidad de personas de cada tipo (artista, compositor, ingeniero) asociadas a cada uno.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS estudios_CantTipoPersonasEstudios //
   CREATE PROCEDURE estudios_CantTipoPersonasEstudios()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM estudios
      );

      IF @consulta > 0 THEN
         SELECT e.id, e.nombre, e.ubicacion, e.fechaFundacion, (
            SELECT COUNT(*) FROM personas p WHERE p.estudio_id = e.id AND p.tipo = 'artista'
         ) AS artistas, (
            SELECT COUNT(*) FROM personas p WHERE p.estudio_id = e.id AND p.tipo = 'compositor'
         ) AS compositores, (
            SELECT COUNT(*) FROM personas p WHERE p.estudio_id = e.id AND p.tipo = 'ingeniero'
         ) AS ingenieros
         FROM estudios e;
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL estudios_CantTipoPersonasEstudios();
   ```

   ### 7. Mostrar estudios fundados en los últimos 10 años junto con la cantidad de personas asociadas a cada uno.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS estudios_CantPersonasEstudiosUltimos10Anyos //
   CREATE PROCEDURE estudios_CantPersonasEstudiosUltimos10Anyos()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM estudios
         WHERE YEAR(fechaFundacion) >= YEAR(CURDATE()) - 10
      );

      IF @consulta > 0 THEN
         SELECT e.id, e.nombre, e.ubicacion, e.fechaFundacion, (
            SELECT COUNT(*) FROM personas p WHERE p.estudio_id = e.id
         ) AS total_personas
         FROM estudios e
         WHERE YEAR(e.fechaFundacion) >= YEAR(CURDATE()) - 10;
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL estudios_CantPersonasEstudiosUltimos10Anyos();
   ```

- ## personas

   ### CRUD

   - **Insertar**

      ```SQL
      INSERT INTO personas (
         sexo, tipo, nombre, apellido1, apellido2, nombreArtistico, telefonoPrincipal, paisOrigen,
         fechaNacimiento, anyoInicioCarrera, estudio_id
      ) VALUES (
         'H', 'artista', 'Juan', 'Perez', 'Gomez', 'Juanito', '+1 555-987-6543', 'España',
         '1990-01-15', 2010, 1
      );
      ```

   - **Seleccionar**
   
      ```SQL
      SELECT * FROM personas WHERE id = 1;
      ```

   - **Actualizar**

      ```SQL
      UPDATE personas SET apellido2 = 'Gomez' WHERE id = 1;
      ```

   - **Eliminar**

      ```SQL
      DELETE FROM personas WHERE id = 1;
      ```

   ### 1. Personas que son artistas y su estudio de grabación fue fundado después de su fecha de nacimiento.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS personas_ArtitasEstudiosFundacionDespuesNacimiento //
   CREATE PROCEDURE personas_ArtitasEstudiosFundacionDespuesNacimiento()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM personas WHERE tipo = 'artista' AND estudio_id IN (
            SELECT id FROM estudios WHERE fechaFundacion > fechaNacimiento
         )
      );

      IF @consulta > 0 THEN
         SELECT * FROM personas WHERE tipo = 'artista' AND estudio_id IN (
            SELECT id FROM estudios WHERE fechaFundacion > fechaNacimiento
         );
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL personas_ArtitasEstudiosFundacionDespuesNacimiento();
   ```

   ### 2. Ingenieros que trabajan en estudios fundados en ciudades Europa.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS personas_IngenierosEstudiosEuropa //
   CREATE PROCEDURE personas_IngenierosEstudiosEuropa()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM personas WHERE tipo = 'ingeniero' AND estudio_id IN (
            SELECT id FROM estudios WHERE ubicacion IN (
               SELECT ubicacion FROM estudios WHERE ubicacion RLIKE 'London|Berlin|Paris|Vienna'
            )
         )
      );

      IF @consulta > 0 THEN
         SELECT * FROM personas WHERE tipo = 'ingeniero' AND estudio_id IN (
            SELECT id FROM estudios WHERE ubicacion IN (
               SELECT ubicacion FROM estudios WHERE ubicacion RLIKE 'London|Berlin|Paris|Vienna'
            )
         );
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL personas_IngenierosEstudiosEuropa();
   ```

   ### 3. Artistas que son mayores de 25 años y comenzaron su carrera antes o en la misma fecha del primer estudio fundado.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS personas_Artistas25AnyosYCarreraAntesPrimerEstudio //
   CREATE PROCEDURE personas_Artistas25AnyosYCarreraAntesPrimerEstudio()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM personas WHERE tipo = 'artista' AND YEAR(fechaNacimiento) < 1998
         AND anyoInicioCarrera <= (
            SELECT MIN(YEAR(fechaFundacion)) FROM estudios
         )
      );

      IF @consulta > 0 THEN
         SELECT * FROM personas WHERE tipo = 'artista' AND YEAR(fechaNacimiento) < 1998
         AND anyoInicioCarrera <= (
            SELECT MIN(YEAR(fechaFundacion)) FROM estudios
         );
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL personas_Artistas25AnyosYCarreraAntesPrimerEstudio();
   ```

   ### 4. Artistas que no tienen un segundo apellido registrado y que trabajan en estudios de California.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS personas_ArtistasNoApellido2EstudiosCA //
   CREATE PROCEDURE personas_ArtistasNoApellido2EstudiosCA()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM personas WHERE tipo = 'artista' AND apellido2 IS NULL
         AND estudio_id IN (
            SELECT id FROM estudios WHERE ubicacion LIKE '%CA%'
         )
      );

      IF @consulta > 0 THEN
         SELECT * FROM personas WHERE tipo = 'artista' AND apellido2 IS NULL
         AND estudio_id IN (
            SELECT id FROM estudios WHERE ubicacion LIKE '%CA%'
         );
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL personas_ArtistasNoApellido2EstudiosCA();
   ```

   ### 5. Compositores que trabajan en estudios que tienen al menos un artista.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS personas_CompositoresEstudiosAlmenosUnArtista //
   CREATE PROCEDURE personas_CompositoresEstudiosAlmenosUnArtista()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM personas WHERE tipo = 'compositor' AND estudio_id IN (
            SELECT DISTINCT estudio_id FROM personas WHERE tipo = 'artista'
         )
      );

      IF @consulta > 0 THEN
         SELECT * FROM personas WHERE tipo = 'compositor' AND estudio_id IN (
            SELECT DISTINCT estudio_id FROM personas WHERE tipo = 'artista'
         );
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL personas_CompositoresEstudiosAlmenosUnArtista();
   ```

   ### 6. Compositores que trabajan en más de un estudio.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS personas_CompositoresTrabajanMasEstudios //
   CREATE PROCEDURE personas_CompositoresTrabajanMasEstudios()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM personas WHERE tipo = 'compositor' AND id IN (
            SELECT id FROM (
               SELECT id, COUNT(DISTINCT estudio_id) AS num_estudios FROM personas
               GROUP BY id
               HAVING num_estudios > 1
            ) AS subconsulta
         )
      );

      IF @consulta > 0 THEN
         SELECT * FROM personas WHERE tipo = 'compositor' AND id IN (
            SELECT id FROM (
               SELECT id, COUNT(DISTINCT estudio_id) AS num_estudios FROM personas
               GROUP BY id
               HAVING num_estudios > 1
            ) AS subconsulta
         );
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL personas_CompositoresTrabajanMasEstudios();
   ```

- ## generos

   ### CRUD

   - **Insertar**

      ```SQL
      INSERT INTO generos (nombre) VALUES ('Rock');
      ```

   - **Seleccionar**
   
      ```SQL
      SELECT * FROM generos WHERE id = 1;
      ```

   - **Actualizar**

      ```SQL
      UPDATE generos SET nombre = 'Rock' WHERE id = 1;
      ```

   - **Eliminar**

      ```SQL
      DELETE FROM generos WHERE id = 1;
      ```

   ### 1. Compositores que están asociados al género "Hip Hop" y han trabajado en estudios fundados después del año 2000.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS generos_CompositoresHipHopEstudiosMas2000 //
   CREATE PROCEDURE generos_CompositoresHipHopEstudiosMas2000()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM personas WHERE tipo = 'compositor' AND estudio_id IN (
            SELECT id FROM estudios WHERE YEAR(fechaFundacion) > 2000) AND id IN (
               SELECT persona_id FROM genero_artista_compositor WHERE genero_id = (
                  SELECT id FROM generos WHERE nombre = 'Hip Hop'
               )
            )
      );

      IF @consulta > 0 THEN
         SELECT * FROM personas WHERE tipo = 'compositor' AND estudio_id IN (
            SELECT id FROM estudios WHERE YEAR(fechaFundacion) > 2000) AND id IN (
               SELECT persona_id FROM genero_artista_compositor WHERE genero_id = (
                  SELECT id FROM generos WHERE nombre = 'Hip Hop'
               )
            );
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL generos_CompositoresHipHopEstudiosMas2000();
   ```

   ### 2. Artistas que tienen un nombre artístico y están asociados al género "Pop".

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS generos_ArtistasGeneroPop //
   CREATE PROCEDURE generos_ArtistasGeneroPop()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM personas WHERE tipo = 'artista' AND nombreArtistico IS NOT NULL
         AND id IN (
            SELECT persona_id FROM genero_artista_compositor WHERE genero_id = (
               SELECT id FROM generos WHERE nombre = 'Pop'
            )
         )
      );

      IF @consulta > 0 THEN
         SELECT * FROM personas WHERE tipo = 'artista' AND nombreArtistico IS NOT NULL
         AND id IN (
            SELECT persona_id FROM genero_artista_compositor WHERE genero_id = (
               SELECT id FROM generos WHERE nombre = 'Pop'
            )
         );
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL generos_ArtistasGeneroPop();
   ```

   ### 3. Compositores que han trabajado en más de un género.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS generos_CompositoresMasGeneros //
   CREATE PROCEDURE generos_CompositoresMasGeneros()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM personas WHERE tipo = 'compositor' AND id IN (
            SELECT persona_id FROM (
               SELECT persona_id, COUNT(DISTINCT genero_id) AS num_generos
               FROM genero_artista_compositor
               GROUP BY persona_id
               HAVING num_generos > 1
            ) AS subconsulta
         )
      );

      IF @consulta > 0 THEN
         SELECT * FROM personas WHERE tipo = 'compositor' AND id IN (
            SELECT persona_id FROM (
               SELECT persona_id, COUNT(DISTINCT genero_id) AS num_generos
               FROM genero_artista_compositor
               GROUP BY persona_id
               HAVING num_generos > 1
            ) AS subconsulta
         );
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL generos_CompositoresMasGeneros();
   ```

   ### 4. Compositores que han trabajado en géneros diferentes al "Clásica".

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS generos_CompositoresNoGeneroClasico //
   CREATE PROCEDURE generos_CompositoresNoGeneroClasico()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM personas WHERE id IN (
            SELECT persona_id FROM genero_artista_compositor WHERE genero_id != (
               SELECT id FROM generos WHERE nombre = 'Clásica'
            )
         )
      );

      IF @consulta > 0 THEN
         SELECT * FROM personas WHERE id IN (
            SELECT persona_id FROM genero_artista_compositor WHERE genero_id != (
               SELECT id FROM generos WHERE nombre = 'Clásica'
            )
         );
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL generos_CompositoresNoGeneroClasico();
   ```

   ### 5. Artistas que han trabajado en estudios fundados en su país de origen y están asociados al género "Pop".

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS generos_ArtistasEstudiosOrigenGeneroPop //
   CREATE PROCEDURE generos_ArtistasEstudiosOrigenGeneroPop()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM personas WHERE tipo = "artista" AND estudio_id IN (
            SELECT id FROM estudios
            WHERE ubicacion LIKE CONCAT('%', paisOrigen, '%')
         ) AND id IN (
            SELECT persona_id FROM genero_artista_compositor WHERE genero_id = (
               SELECT id FROM generos WHERE nombre = 'Pop'
            )
         )
      );

      IF @consulta > 0 THEN
         SELECT * FROM personas WHERE tipo = "artista" AND estudio_id IN (
            SELECT id FROM estudios
            WHERE ubicacion LIKE CONCAT('%', paisOrigen, '%')
         ) AND id IN (
            SELECT persona_id FROM genero_artista_compositor WHERE genero_id = (
               SELECT id FROM generos WHERE nombre = 'Pop'
            )
         );
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL generos_ArtistasEstudiosOrigenGeneroPop();
   ```

- ## genero_artista_compositor

   ### CRUD

   - **Insertar**

      ```SQL
      INSERT INTO genero_artista_compositor (persona_id, genero_id) VALUES (1, 13);
      ```

   - **Seleccionar**
   
      ```SQL
      SELECT * FROM genero_artista_compositor WHERE persona_id = 1;
      ```

   - **Actualizar**

      ```SQL
      UPDATE genero_artista_compositor SET genero_id = 13 WHERE persona_id = 1 AND genero_id = 13;
      ```

   - **Eliminar**

      ```SQL
      DELETE FROM genero_artista_compositor WHERE persona_id = 1 AND genero_id = 13;
      ```

   ### 1. Personas que están asociadas al menos a dos géneros diferentes.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS genero_artista_compositor_PersonasGeneros //
   CREATE PROCEDURE genero_artista_compositor_PersonasGeneros()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM (
            SELECT
               p.nombre,
               TRIM(CONCAT(p.apellido1, ' ', IFNULL(p.apellido2, ''))) AS apellidos,
               p.tipo
            FROM genero_artista_compositor gc, personas p WHERE gc.persona_id = p.id
            GROUP BY gc.persona_id
            HAVING COUNT(*) >= 2
         ) AS subconsulta
      );

      IF @consulta > 0 THEN
         SELECT
            p.nombre,
            TRIM(CONCAT(p.apellido1, ' ', IFNULL(p.apellido2, ''))) AS apellidos,
            p.tipo
         FROM genero_artista_compositor gc, personas p WHERE gc.persona_id = p.id
         GROUP BY gc.persona_id
         HAVING COUNT(*) >= 2;
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL genero_artista_compositor_PersonasGeneros();
   ```

   ### 2. Géneros asociados a artistas que han comenzado su carrera antes del año 2000.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS genero_artista_compositor_GenerosArtistasInicioAntes2000 //
   CREATE PROCEDURE genero_artista_compositor_GenerosArtistasInicioAntes2000()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM genero_artista_compositor gc
         INNER JOIN personas p ON gc.persona_id = p.id
         WHERE p.tipo = 'artista' AND p.anyoInicioCarrera < 2000
      );

      IF @consulta > 0 THEN
         SELECT DISTINCT gc.genero_id FROM genero_artista_compositor gc
         INNER JOIN personas p ON gc.persona_id = p.id
         WHERE p.tipo = 'artista' AND p.anyoInicioCarrera < 2000;
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL genero_artista_compositor_GenerosArtistasInicioAntes2000();
   ```

   ### 3. Personas que están asociadas al género 'Rock' y trabajan en estudios de Brazil.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS genero_artista_compositor_PersonasRockEstudiosBrazil //
   CREATE PROCEDURE genero_artista_compositor_PersonasRockEstudiosBrazil()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM genero_artista_compositor gc, personas p WHERE gc.genero_id = (
            SELECT id FROM generos WHERE nombre = 'Rock'
         ) AND p.estudio_id IN (
            SELECT id FROM estudios WHERE ubicacion LIKE '%Brazil%'
         ) AND gc.persona_id = p.id
      );

      IF @consulta > 0 THEN
         SELECT DISTINCT
            p.nombre,
            TRIM(CONCAT(p.apellido1, ' ', IFNULL(p.apellido2, ''))) AS apellidos,
            p.tipo
         FROM genero_artista_compositor gc, personas p WHERE gc.genero_id = (
            SELECT id FROM generos WHERE nombre = 'Rock'
         ) AND p.estudio_id IN (
            SELECT id FROM estudios WHERE ubicacion LIKE '%Brazil%'
         ) AND gc.persona_id = p.id;
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL genero_artista_compositor_PersonasRockEstudiosBrazil();
   ```

   ### 4. Géneros asociados a compositores que han trabajado en estudios fundados antes de 2000.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS genero_artista_compositor_GenerosCompositoresEstudiosAntes2000 //
   CREATE PROCEDURE genero_artista_compositor_GenerosCompositoresEstudiosAntes2000()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM (
            SELECT gc.genero_id, g.nombre FROM genero_artista_compositor gc, generos g, personas p
            WHERE p.tipo = 'compositor' AND gc.genero_id = g.id AND gc.persona_id = p.id
            AND p.estudio_id IN (
               SELECT id FROM estudios WHERE YEAR(fechaFundacion) < 2000
            ) GROUP BY gc.genero_id
         ) AS subconsulta
      );

      IF @consulta > 0 THEN
         SELECT gc.genero_id, g.nombre FROM genero_artista_compositor gc, generos g, personas p
         WHERE p.tipo = 'compositor' AND gc.genero_id = g.id AND gc.persona_id = p.id
         AND p.estudio_id IN (
            SELECT id FROM estudios WHERE YEAR(fechaFundacion) < 2000
         ) GROUP BY gc.genero_id;
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL genero_artista_compositor_GenerosCompositoresEstudiosAntes2000();
   ```

   ### 5. Personas que están asociadas al menos a un género que no sea 'Rock' ni 'Pop'.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS genero_artista_compositor_PersonasNoGenerosRockPop //
   CREATE PROCEDURE genero_artista_compositor_PersonasNoGenerosRockPop()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM genero_artista_compositor gc, personas p WHERE gc.genero_id NOT IN (
            SELECT id FROM generos WHERE nombre IN ('Rock', 'Pop')
         ) AND gc.persona_id = p.id
      );

      IF @consulta > 0 THEN
         SELECT DISTINCT
            p.nombre,
            TRIM(CONCAT(p.apellido1, ' ', IFNULL(p.apellido2, ''))) AS apellidos,
            p.tipo
         FROM genero_artista_compositor gc, personas p WHERE gc.genero_id NOT IN (
            SELECT id FROM generos WHERE nombre IN ('Rock', 'Pop')
         ) AND gc.persona_id = p.id;
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL genero_artista_compositor_PersonasNoGenerosRockPop();
   ```

   ### 6. Géneros asociados a artistas que trabajan en estudios ubicados en paises de Europa.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS genero_artista_compositor_GenerosArtistasEstudiosEuropa //
   CREATE PROCEDURE genero_artista_compositor_GenerosArtistasEstudiosEuropa()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM genero_artista_compositor gc, generos g, personas p
         WHERE p.tipo = 'artista' AND p.estudio_id IN (
            SELECT id FROM estudios WHERE ubicacion RLIKE 'UK|Germany|France|Austria'
         ) AND gc.genero_id = g.id AND gc.persona_id = p.id
      );

      IF @consulta > 0 THEN
         SELECT DISTINCT gc.genero_id, g.nombre FROM genero_artista_compositor gc, generos g, personas p
         WHERE p.tipo = 'artista' AND p.estudio_id IN (
            SELECT id FROM estudios WHERE ubicacion RLIKE 'UK|Germany|France|Austria'
         ) AND gc.genero_id = g.id AND gc.persona_id = p.id;
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL genero_artista_compositor_GenerosArtistasEstudiosEuropa();
   ```

- ## especializaciones

   ### CRUD

   - **Insertar**

      ```SQL
      INSERT INTO especializaciones (nombre) VALUES ('Producción Musical');
      ```

   - **Seleccionar**
   
      ```SQL
      SELECT * FROM especializaciones WHERE id = 1;
      ```

   - **Actualizar**

      ```SQL
      UPDATE especializaciones SET nombre = 'Producción Musical' WHERE id = 1;
      ```

   - **Eliminar**

      ```SQL
      DELETE FROM especializaciones WHERE id = 1;
      ```

   ### 1. Artistas que tienen la especialización "Producción Musical".

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS especializaciones_ArtistasProduccionMusical //
   CREATE PROCEDURE especializaciones_ArtistasProduccionMusical()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM personas WHERE tipo = 'artista' AND id IN (
            SELECT DISTINCT persona_id FROM especializacion_persona WHERE especializacion_id = (
               SELECT id FROM especializaciones WHERE nombre = 'Producción Musical'
            )
         )
      );

      IF @consulta > 0 THEN
         SELECT * FROM personas WHERE tipo = 'artista' AND id IN (
            SELECT DISTINCT persona_id FROM especializacion_persona WHERE especializacion_id = (
               SELECT id FROM especializaciones WHERE nombre = 'Producción Musical'
            )
         );
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL especializaciones_ArtistasProduccionMusical();
   ```

   ### 2. Compositores que tienen al menos dos especializaciones distintas.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS especializaciones_Compositores2Especializaciones //
   CREATE PROCEDURE especializaciones_Compositores2Especializaciones()
   BEGIN
      SET @consulta = (
        SELECT COUNT(*) FROM personas p WHERE p.tipo = 'compositor' AND (
            SELECT COUNT(*) FROM especializacion_persona ep WHERE ep.persona_id = p.id
         ) >= 2
      );

      IF @consulta > 0 THEN
         SELECT p.nombre, TRIM(CONCAT(p.apellido1,' ', IFNULL(p.apellido2, ''))) AS apellidos
         FROM personas p WHERE p.tipo = 'compositor' AND (
            SELECT COUNT(*) FROM especializacion_persona ep WHERE ep.persona_id = p.id
         ) >= 2;
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL especializaciones_Compositores2Especializaciones();
   ```

   ### 3. Ingenieros que tienen la especialización "Ingeniería de Sonido" y trabajan en estudios de Argentina.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS especializaciones_IngenierosSonidoEstudiosArgentina //
   CREATE PROCEDURE especializaciones_IngenierosSonidoEstudiosArgentina()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*)
         FROM personas p, especializacion_persona ep, especializaciones e, estudios es
         WHERE p.tipo = "compositor" AND p.id = ep.persona_id AND ep.especializacion_id = e.id
         AND e.nombre = 'Ingeniería de Sonido' AND p.estudio_id = es.id
         AND es.ubicacion LIKE '%Argentina%'
      );

      IF @consulta > 0 THEN
         SELECT * FROM personas p, especializacion_persona ep, especializaciones e, estudios es
         WHERE p.tipo = 'compositor' AND p.id = ep.persona_id AND ep.especializacion_id = e.id
         AND e.nombre = 'Ingeniería de Sonido' AND p.estudio_id = es.id
         AND es.ubicacion LIKE '%Argentina%';
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL especializaciones_IngenierosSonidoEstudiosArgentina();
   ```

   ### 4. Artistas que tienen al menos tres especializaciones diferentes.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS especializaciones_Artistas3Especializaciones //
   CREATE PROCEDURE especializaciones_Artistas3Especializaciones()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM personas p WHERE p.tipo = 'artista' AND (
            SELECT COUNT(*) FROM especializacion_persona ep WHERE ep.persona_id = p.id
         ) >= 3
      );

      IF @consulta > 0 THEN
         SELECT p.nombre, TRIM(CONCAT(p.apellido1,' ', IFNULL(p.apellido2, ''))) AS apellidos
         FROM personas p WHERE p.tipo = 'artista' AND (
            SELECT COUNT(*) FROM especializacion_persona ep WHERE ep.persona_id = p.id
         ) >= 3;
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL especializaciones_Artistas3Especializaciones();
   ```

   ### 5. Compositores que tienen la especialización "Composición Musical" y han trabajado en estudios fundados antes de 2000.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS especializaciones_CompositoresComposicionEstudiosAntes2000 //
   CREATE PROCEDURE especializaciones_CompositoresComposicionEstudiosAntes2000()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM personas WHERE tipo = 'compositor' AND id IN (
            SELECT ep.persona_id FROM especializacion_persona ep
            INNER JOIN personas p ON ep.persona_id = p.id
            INNER JOIN estudios e ON p.estudio_id = e.id
            WHERE ep.especializacion_id = (
               SELECT id FROM especializaciones WHERE nombre = 'Composición Musical'
            ) AND YEAR(e.fechaFundacion) < 2000
         )
      );

      IF @consulta > 0 THEN
         SELECT p.nombre, TRIM(CONCAT(p.apellido1,' ', IFNULL(p.apellido2, ''))) AS apellidos
         FROM personas p WHERE tipo = 'compositor' AND id IN (
            SELECT ep.persona_id FROM especializacion_persona ep
            INNER JOIN personas p ON ep.persona_id = p.id
            INNER JOIN estudios e ON p.estudio_id = e.id
            WHERE ep.especializacion_id = (
               SELECT id FROM especializaciones WHERE nombre = 'Composición Musical'
            ) AND YEAR(e.fechaFundacion) < 2000
         );
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL especializaciones_CompositoresComposicionEstudiosAntes2000();
   ```

   ### 6. Artistas que tienen la especialización "Gestión de Derechos de Autor" y su nombre artístico comienza con 'M'.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS especializaciones_ArtistasGestoresNombreArtisticoM //
   CREATE PROCEDURE especializaciones_ArtistasGestoresNombreArtisticoM()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM personas p WHERE p.tipo = 'artista' AND p.id IN (
            SELECT ep.persona_id FROM especializacion_persona ep WHERE ep.especializacion_id = (
               SELECT id FROM especializaciones WHERE nombre = 'Gestión de Derechos de Autor'
            ) AND p.nombreArtistico LIKE 'M%' AND ep.persona_id = p.id
         )
      );

      IF @consulta > 0 THEN
         SELECT p.nombre, TRIM(CONCAT(p.apellido1,' ', IFNULL(p.apellido2, ''))) AS apellidos
         FROM personas p WHERE p.tipo = 'artista' AND p.id IN (
            SELECT ep.persona_id FROM especializacion_persona ep WHERE ep.especializacion_id = (
               SELECT id FROM especializaciones WHERE nombre = 'Gestión de Derechos de Autor'
            ) AND p.nombreArtistico LIKE 'M%' AND ep.persona_id = p.id
         );
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL especializaciones_ArtistasGestoresNombreArtisticoM();
   ```

- ## especializacion_persona

   ### CRUD

   - **Insertar**

      ```SQL
      INSERT INTO especializacion_persona (especializacion_id, persona_id) VALUES (1, 13);
      ```

   - **Seleccionar**
   
      ```SQL
      SELECT * FROM especializacion_persona WHERE especializacion_id = 1;
      ```

   - **Actualizar**

      ```SQL
      UPDATE especializacion_persona SET especializacion_id = 1
      WHERE especializacion_id = 1 AND persona_id = 13;
      ```

   - **Eliminar**

      ```SQL
      DELETE FROM especializacion_persona WHERE especializacion_id = 1 AND persona_id = 11;
      ```

   ### 1. Subconsulta para obtener nombres de personas con especialización en 'Producción Musical'.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS especializacion_persona_PersonasProduccionMusical //
   CREATE PROCEDURE especializacion_persona_PersonasProduccionMusical()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM personas WHERE id IN (
            SELECT persona_id FROM especializacion_persona WHERE especializacion_id = (
               SELECT id FROM especializaciones WHERE nombre = 'Producción Musical'
            )
         )
      );

      IF @consulta > 0 THEN
         SELECT nombre, TRIM(CONCAT(apellido1,' ',IFNULL(apellido2, ''))) AS apellidos
         FROM personas WHERE id IN (
            SELECT persona_id FROM especializacion_persona WHERE especializacion_id = (
               SELECT id FROM especializaciones WHERE nombre = 'Producción Musical'
            )
         );
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL especializacion_persona_PersonasProduccionMusical();
   ```

   ### 2. Obtener especializaciones de la persona con Nombre Artístico 'Sof'.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS especializacion_persona_EspecializacionesArtistaSof //
   CREATE PROCEDURE especializacion_persona_EspecializacionesArtistaSof()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM especializaciones WHERE id IN (
            SELECT especializacion_id FROM especializacion_persona WHERE persona_id = (
               SELECT id FROM personas WHERE nombreArtistico = 'Sof'
            )
         )
      );

      IF @consulta > 0 THEN
         SELECT nombre FROM especializaciones WHERE id IN (
            SELECT especializacion_id FROM especializacion_persona WHERE persona_id = (
               SELECT id FROM personas WHERE nombreArtistico = 'Sof'
            )
         );
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL especializacion_persona_EspecializacionesArtistaSof();
   ```

   ### 3. Personas con especialización en 'Diseño de Sonido' y que sean Ingenieros.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS especializacion_persona_IngenierosDiseñoDeSonido //
   CREATE PROCEDURE especializacion_persona_IngenierosDiseñoDeSonido()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM personas WHERE id IN (
            SELECT persona_id FROM especializacion_persona WHERE especializacion_id = (
               SELECT id FROM especializaciones WHERE nombre = 'Diseño de Sonido'
            )
         ) AND tipo = 'ingeniero'
      );

      IF @consulta > 0 THEN
         SELECT nombre, TRIM(CONCAT(apellido1,' ',IFNULL(apellido2, ''))) AS apellidos
         FROM personas WHERE id IN (
            SELECT persona_id FROM especializacion_persona WHERE especializacion_id = (
               SELECT id FROM especializaciones WHERE nombre = 'Diseño de Sonido'
            )
         ) AND tipo = 'ingeniero';
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL especializacion_persona_IngenierosDiseñoDeSonido();
   ```

   ### 4. Personas que comparten especialización con la persona de nombre artístico 'Miguelito'.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS especializacion_persona_PersonasEspecializacionMiguelito //
   CREATE PROCEDURE especializacion_persona_PersonasEspecializacionMiguelito()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM personas WHERE id IN (
            SELECT persona_id FROM especializacion_persona WHERE especializacion_id IN (
               SELECT especializacion_id FROM especializacion_persona WHERE persona_id = (
                  SELECT id FROM personas WHERE nombreArtistico = 'Miguelito'
               )
            )
         ) AND nombreArtistico != 'Miguelito'
      );

      IF @consulta > 0 THEN
         SELECT nombre, TRIM(CONCAT(apellido1,' ',IFNULL(apellido2, ''))) AS apellidos
         FROM personas WHERE id IN (
            SELECT persona_id FROM especializacion_persona WHERE especializacion_id IN (
               SELECT especializacion_id FROM especializacion_persona WHERE persona_id = (
                  SELECT id FROM personas WHERE nombreArtistico = 'Miguelito'
               )
            )
         ) AND nombreArtistico != 'Miguelito';
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL especializacion_persona_PersonasEspecializacionMiguelito();
   ```

   ### 5. Obtener estudios con personas especializadas en 'Ingeniería de Sonido'.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS especializacion_persona_EstudiosPersonasIngenieriaSonido //
   CREATE PROCEDURE especializacion_persona_EstudiosPersonasIngenieriaSonido()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM estudios WHERE id IN (
            SELECT estudio_id FROM personas WHERE tipo = 'ingeniero' AND id IN (
               SELECT persona_id FROM especializacion_persona WHERE especializacion_id = (
                  SELECT id FROM especializaciones WHERE nombre = 'Ingeniería de Sonido'
               )
            )
         )
      );

      IF @consulta > 0 THEN
         SELECT nombre FROM estudios WHERE id IN (
            SELECT estudio_id FROM personas WHERE tipo = 'ingeniero' AND id IN (
               SELECT persona_id FROM especializacion_persona WHERE especializacion_id = (
                  SELECT id FROM especializaciones WHERE nombre = 'Ingeniería de Sonido'
               )
            )
         );
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL especializacion_persona_EstudiosPersonasIngenieriaSonido();
   ```

   ### 6. Subconsulta para obtener personas con mas de una especialización.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS especializacion_persona_PersonasMasEspecializaciones //
   CREATE PROCEDURE especializacion_persona_PersonasMasEspecializaciones()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM personas p WHERE (
            SELECT COUNT(*) FROM especializacion_persona ep WHERE ep.persona_id = p.id
         ) > 1
      );

      IF @consulta > 0 THEN
         SELECT p.nombre, TRIM(CONCAT(p.apellido1,' ',IFNULL(p.apellido2,''))) AS apellidos
         FROM personas p WHERE (
            SELECT COUNT(*) FROM especializacion_persona ep WHERE ep.persona_id = p.id
         ) > 1;
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL especializacion_persona_PersonasMasEspecializaciones();
   ```

   ### 7. Personas con especialización en 'Composición Musical' que no sean de Argentina.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS especializacion_persona_PersonasComposicionNoArgentina //
   CREATE PROCEDURE especializacion_persona_PersonasComposicionNoArgentina()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM personas WHERE id IN (
            SELECT persona_id FROM especializacion_persona WHERE especializacion_id = (
               SELECT id FROM especializaciones WHERE nombre = 'Composición Musical'
            )
         ) AND paisOrigen != 'Argentina'
      );

      IF @consulta > 0 THEN
         SELECT nombre, TRIM(CONCAT(apellido1,' ',IFNULL(apellido2,''))) AS apellidos
         FROM personas WHERE id IN (
            SELECT persona_id FROM especializacion_persona WHERE especializacion_id = (
               SELECT id FROM especializaciones WHERE nombre = 'Composición Musical'
            )
         ) AND paisOrigen != 'Argentina';
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL especializacion_persona_PersonasComposicionNoArgentina();
   ```

- ## telefonosPersona

   ### CRUD

   - **Insertar**

      ```SQL
      INSERT INTO telefonosPersona (telefono, persona_id) VALUES ('+1 555-876-5432', 1);
      ```

   - **Seleccionar**
   
      ```SQL
      SELECT * FROM telefonosPersona WHERE persona_id = 1;
      ```

   - **Actualizar**

      ```SQL
      UPDATE telefonosPersona SET telefono = '+1 555-876-5432' WHERE persona_id = 1;
      ```

   - **Eliminar**

      ```SQL
      DELETE FROM telefonosPersona WHERE persona_id = 1;
      ```

   ### 1. Obtener personas que comparten el mismo teléfono.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS telefonosPersona_PersonasMismoTelefono //
   CREATE PROCEDURE telefonosPersona_PersonasMismoTelefono()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM personas p
         JOIN telefonosPersona tp1 ON p.id = tp1.persona_id
         JOIN telefonosPersona tp2 ON tp1.telefono = tp2.telefono
         WHERE tp1.persona_id != tp2.persona_id
      );

      IF @consulta > 0 THEN
         SELECT DISTINCT p.* FROM personas p
         JOIN telefonosPersona tp1 ON p.id = tp1.persona_id
         JOIN telefonosPersona tp2 ON tp1.telefono = tp2.telefono
         WHERE tp1.persona_id != tp2.persona_id;
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL telefonosPersona_PersonasMismoTelefono();
   ```

   ### 2. Obtener personas cuyo teléfono empieza con '+1' y son artistas.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS telefonosPersona_ArtistasTelefono1 //
   CREATE PROCEDURE telefonosPersona_ArtistasTelefono1()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM personas WHERE id IN (
            SELECT persona_id FROM telefonosPersona WHERE telefono LIKE '+1%'
         ) AND tipo = 'artista'
      );

      IF @consulta > 0 THEN
         SELECT nombre, TRIM(CONCAT(apellido1,' ',IFNULL(apellido2, ''))) AS apellidos
         FROM personas WHERE id IN (
            SELECT persona_id FROM telefonosPersona WHERE telefono LIKE '+1%'
         ) AND tipo = 'artista';
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL telefonosPersona_ArtistasTelefono1();
   ```

   ### 3. Listar teléfonos secundarios y personas con nombre artístico.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS telefonosPersona_TelefonosSecundariosArtistico //
   CREATE PROCEDURE telefonosPersona_TelefonosSecundariosArtistico()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM (
            SELECT p.nombre FROM personas p, telefonosPersona tp
            WHERE p.nombreArtistico IS NOT NULL AND p.id = tp.persona_id
            GROUP BY p.id
         ) AS subconsulta
      );

      IF @consulta > 0 THEN
         SELECT
            p.nombre,
            TRIM(CONCAT(p.apellido1,' ',IFNULL(p.apellido2,''))) AS apellidos,
            GROUP_CONCAT(DISTINCT '( ',tp.telefono,' )' SEPARATOR ' - ') AS telefonos_secundarios
         FROM personas p, telefonosPersona tp WHERE p.nombreArtistico IS NOT NULL
         AND p.id = tp.persona_id
         GROUP BY p.id;
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL telefonosPersona_TelefonosSecundariosArtistico();
   ```

   ### 4. Obtener personas con más de un teléfono, mostrar el principal y cuales son los otros telefonos.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS telefonosPersona_PersonasSegundoTelefono //
   CREATE PROCEDURE telefonosPersona_PersonasSegundoTelefono()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM personas p , telefonosPersona tp WHERE p.id = tp.persona_id
      );

      IF @consulta > 0 THEN
         SELECT
	         p.nombre,
            TRIM(CONCAT(p.apellido1,' ',IFNULL(apellido2,''))) AS apellidos,
            p.telefonoPrincipal,
            GROUP_CONCAT('( ',tp.telefono,' )' SEPARATOR ' - ') AS otros_telefonos
         FROM personas p , telefonosPersona tp WHERE p.id = tp.persona_id
         GROUP BY p.id;
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL telefonosPersona_PersonasSegundoTelefono();
   ```

   ### 5. Contar teléfonos secundarios por país de origen.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS telefonosPersona_CantTelefonosPaisOrigen //
   CREATE PROCEDURE telefonosPersona_CantTelefonosPaisOrigen()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM (
            SELECT paisOrigen, COUNT(telefono) AS cantidadTelefonos FROM telefonosPersona
            JOIN personas ON telefonosPersona.persona_id = personas.id
            GROUP BY paisOrigen
         ) AS subconsulta
      );

      IF @consulta > 0 THEN
         SELECT paisOrigen, COUNT(telefono) AS cantidadTelefonos FROM telefonosPersona
         JOIN personas ON telefonosPersona.persona_id = personas.id
         GROUP BY paisOrigen;
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL telefonosPersona_CantTelefonosPaisOrigen();
   ```

- ## albumes

   ### CRUD

   - **Insertar**

      ```SQL
      INSERT INTO albumes (titulo, fechaLanzamiento, artista_id)
      VALUES ('Amanecer Musical', '2022-03-10', 4);
      ```

   - **Seleccionar**
   
      ```SQL
      SELECT * FROM albumes WHERE id = 1;
      ```

   - **Actualizar**

      ```SQL
      UPDATE albumes SET titulo = 'Amanecer Musical' WHERE id = 1;
      ```

   - **Eliminar**

      ```SQL
      DELETE FROM albumes WHERE id = 1;
      ```

   ### 1. Artistas de los albumes lanzados en 2022.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS albumes_ArtistasAlbumes2022 //
   CREATE PROCEDURE albumes_ArtistasAlbumes2022()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM albumes WHERE YEAR(fechaLanzamiento) = 2022
      );

      IF @consulta > 0 THEN
         SELECT titulo, (
            SELECT CONCAT(nombre, ' ', apellido1) FROM personas WHERE id = artista_id
         ) AS artista
         FROM albumes WHERE YEAR(fechaLanzamiento) = 2022;
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL albumes_ArtistasAlbumes2022();
   ```

   ### 2. Compositores de albumes con una antiguedad de más de 10 años.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS albumes_CompositoresAlbumes10añosAntiguo //
   CREATE PROCEDURE albumes_CompositoresAlbumes10añosAntiguo()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM albumes WHERE YEAR(CURDATE()) - YEAR(fechaLanzamiento) > 10
      );

      IF @consulta > 0 THEN
         SELECT titulo, (
            SELECT CONCAT(nombre, ' ', apellido1) FROM personas WHERE id = artista_id
         ) AS compositor, CONCAT(YEAR(CURDATE()) - YEAR(fechaLanzamiento),' años') AS antiguedad
         FROM albumes WHERE YEAR(CURDATE()) - YEAR(fechaLanzamiento) > 10;
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL albumes_CompositoresAlbumes10añosAntiguo();
   ```

   ### 3. Albumes lanzados en febrero y su estudio de grabación.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS albumes_AlbumesFebreroYEstudio //
   CREATE PROCEDURE albumes_AlbumesFebreroYEstudio()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM albumes a WHERE MONTH(fechaLanzamiento) = 2
      );

      IF @consulta > 0 THEN
         SELECT a.titulo, (
	         SELECT e.nombre FROM estudios e, personas p
            WHERE a.artista_id = p.id AND p.estudio_id = e.id
         ) AS estudio
         FROM albumes a WHERE MONTH(fechaLanzamiento) = 2;
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL albumes_AlbumesFebreroYEstudio();
   ```

   ### 4. Albumes con nombre artístico del artista y ubicación del estudio.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS albumes_AlbumesArtistaUbicacionEstudio //
   CREATE PROCEDURE albumes_AlbumesArtistaUbicacionEstudio()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM albumes a, personas p, estudios e
         WHERE a.artista_id = p.id AND p.estudio_id = e.id
      );

      IF @consulta > 0 THEN
         SELECT titulo, (
            SELECT nombreArtistico FROM personas WHERE id = artista_id
         ) AS nombreArtistico, (
            SELECT ubicacion FROM estudios WHERE id = p.estudio_id
         ) AS ubicacionEstudio
         FROM albumes a, personas p, estudios e WHERE a.artista_id = p.id AND p.estudio_id = e.id;
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL albumes_AlbumesArtistaUbicacionEstudio();
   ```

   ### 5. Albumes y países de origen de artistas femeninas.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS albumes_AlbumesPaisesOrigenArtistasM //
   CREATE PROCEDURE albumes_AlbumesPaisesOrigenArtistasM()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM albumes WHERE (
            SELECT sexo FROM personas WHERE id = artista_id
         ) = 'M'
      );

      IF @consulta > 0 THEN
         SELECT titulo, (
            SELECT paisOrigen FROM personas WHERE id = artista_id
         ) AS pais
         FROM albumes WHERE (
            SELECT sexo FROM personas WHERE id = artista_id
         ) = 'M';
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL albumes_AlbumesPaisesOrigenArtistasM();
   ```

- ## formatos

   ### CRUD

   - **Insertar**

      ```SQL
      INSERT INTO formatos (nombre) VALUES ('CD estándar');
      ```

   - **Seleccionar**
   
      ```SQL
      SELECT * FROM formatos WHERE id = 1;
      ```

   - **Actualizar**

      ```SQL
      UPDATE formatos SET nombre = 'CD estándar' WHERE id = 1;
      ```

   - **Eliminar**

      ```SQL
      DELETE FROM formatos WHERE id = 1;
      ```

   ### 1. Obten la cantidad de álbumes asociados a cada formato.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS formatos_CantAlbumesFormato //
   CREATE PROCEDURE formatos_CantAlbumesFormato()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM formatos
      );

      IF @consulta > 0 THEN
         SELECT f.nombre, (
            SELECT COUNT(*) FROM formato_album fa WHERE f.id = fa.formato_id
         )  AS cantidad_albumes
         FROM formatos f;
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL formatos_CantAlbumesFormato();
   ```

   ### 2. Obtén los formatos que no están asociados a ningún álbum.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS formatos_FormatosNoAlbum //
   CREATE PROCEDURE formatos_FormatosNoAlbum()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM formatos WHERE id NOT IN (
            SELECT DISTINCT formato_id FROM formato_album
         )
      );

      IF @consulta > 0 THEN
         SELECT * FROM formatos WHERE id NOT IN (
            SELECT DISTINCT formato_id FROM formato_album
         );
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL formatos_FormatosNoAlbum();
   ```

   ### 3. Obtén el formato más utilizado.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS formatos_FormatoMasUtilizado //
   CREATE PROCEDURE formatos_FormatoMasUtilizado()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM formatos WHERE (
            SELECT COUNT(*) FROM formato_album WHERE formatos.id = formato_album.formato_id
         ) = (
            SELECT COUNT(*) FROM formatos f, formato_album fa WHERE f.id = fa.formato_id
            GROUP BY f.id
            ORDER BY COUNT(*) DESC
            LIMIT 1
         )
      );

      IF @consulta > 0 THEN
         SELECT *, (
            SELECT COUNT(*) FROM formato_album WHERE formatos.id = formato_album.formato_id
         ) AS cantidad_usos
         FROM formatos WHERE (
            SELECT COUNT(*) FROM formato_album WHERE formatos.id = formato_album.formato_id
         ) = (
            SELECT COUNT(*) FROM formatos f, formato_album fa WHERE f.id = fa.formato_id
            GROUP BY f.id
            ORDER BY COUNT(*) DESC
            LIMIT 1
         );
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL formatos_FormatoMasUtilizado();
   ```

   ### 4. Obtén los formatos que fueron utilizados en álbumes lanzados antes del 2010.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS formatos_FormatosUsadosAlbumesAntes2010 //
   CREATE PROCEDURE formatos_FormatosUsadosAlbumesAntes2010()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM formatos f, formato_album fa, albumes a
         WHERE f.id = fa.formato_id AND fa.album_id = a.id AND YEAR(a.fechaLanzamiento) < 2010
      );

      IF @consulta > 0 THEN
         SELECT f.* FROM formatos f, formato_album fa, albumes a
         WHERE f.id = fa.formato_id AND fa.album_id = a.id AND YEAR(a.fechaLanzamiento) < 2010;
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL formatos_FormatosUsadosAlbumesAntes2010();
   ```

   ### 5. Obtén los formatos utilizados en álbumes cuyo título no contiene la palabra "Música".

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS formatos_FormatosAlbumesNoPalabraMusica //
   CREATE PROCEDURE formatos_FormatosAlbumesNoPalabraMusica()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM formatos f, formato_album fa, albumes a
         WHERE f.id = fa.formato_id AND fa.album_id = a.id AND a.titulo NOT LIKE '%Música%'
      );

      IF @consulta > 0 THEN
         SELECT DISTINCT f.* FROM formatos f, formato_album fa, albumes a
         WHERE f.id = fa.formato_id AND fa.album_id = a.id AND a.titulo NOT LIKE '%Música%';
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL formatos_FormatosAlbumesNoPalabraMusica();
   ```

   ### 6. Obtén los formatos utilizados en álbumes del artista con id igual a 14 y lanzados en el año 2019.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS formatos_FormatosAlbumesArtista14Año2019 //
   CREATE PROCEDURE formatos_FormatosAlbumesArtista14Año2019()
   BEGIN
      SET @consulta = (
         SELECT DISTINCT COUNT(*) FROM formatos f, formato_album fa, albumes a
         WHERE f.id = fa.formato_id AND fa.album_id = a.id AND a.artista_id = 14
         AND YEAR(a.fechaLanzamiento) = 2019
      );

      IF @consulta > 0 THEN
         SELECT DISTINCT f.* FROM formatos f, formato_album fa, albumes a
         WHERE f.id = fa.formato_id AND fa.album_id = a.id AND a.artista_id = 14
         AND YEAR(a.fechaLanzamiento) = 2019;
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL formatos_FormatosAlbumesArtista14Año2019();
   ```

- ## formato_album

   ### CRUD

   - **Insertar**

      ```SQL
      INSERT INTO formato_album (album_id, formato_id) VALUES (1, 1);
      ```

   - **Seleccionar**

      ```SQL
      SELECT * FROM formato_album WHERE album_id = 1;
      ```

   - **Actualizar**

      ```SQL
      UPDATE formato_album SET formato_id = 4 WHERE album_id = 1 AND formato_id = 4;
      ```

   - **Eliminar**

      ```SQL
      DELETE FROM formato_album WHERE album_id = 1 AND formato_id = 4;
      ```

   ### 1. Obtener los títulos de los álbumes que tienen al menos un formato en vinilo.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS formato_album_AlbumesFormatoVinilo //
   CREATE PROCEDURE formato_album_AlbumesFormatoVinilo()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM formato_album WHERE formato_id IN (
            SELECT id FROM formatos WHERE nombre LIKE 'Vinilo%'
         )
      );

      IF @consulta > 0 THEN
         SELECT DISTINCT album_id, (
            SELECT titulo FROM albumes WHERE id = album_id
         ) AS titulo FROM formato_album WHERE formato_id IN (
            SELECT id FROM formatos WHERE nombre LIKE 'Vinilo%'
         );
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL formato_album_AlbumesFormatoVinilo();
   ```

   ### 2. Encontrar los formatos utilizados para un álbum específico (por ejemplo, 'Amanecer Musical')

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS formato_album_FormatosAlbumEspecifico //
   CREATE PROCEDURE formato_album_FormatosAlbumEspecifico()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM formatos WHERE id IN (
            SELECT formato_id FROM formato_album WHERE album_id = (
               SELECT id FROM albumes WHERE titulo = 'Amanecer Musical'
            )
         )
      );

      IF @consulta > 0 THEN
         SELECT * FROM formatos WHERE id IN (
            SELECT formato_id FROM formato_album WHERE album_id = (
               SELECT id FROM albumes WHERE titulo = 'Amanecer Musical'
            )
         );
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL formato_album_FormatosAlbumEspecifico();
   ```

   ### 3. Obtener los títulos de los álbumes que tienen al menos un formato en CD pero ninguno en Vinilo.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS formato_album_AlbumesFormatoCDNoVinilo //
   CREATE PROCEDURE formato_album_AlbumesFormatoCDNoVinilo()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM formato_album WHERE formato_id IN (
            SELECT id FROM formatos WHERE nombre LIKE 'CD%'
         ) AND album_id NOT IN (
            SELECT DISTINCT album_id FROM formato_album WHERE formato_id IN (
               SELECT id FROM formatos WHERE nombre LIKE 'Vinilo%'
            )
         )
      );

      IF @consulta > 0 THEN
         SELECT DISTINCT album_id, (
            SELECT titulo FROM albumes WHERE id = album_id
         ) AS titulo FROM formato_album WHERE formato_id IN (
            SELECT id FROM formatos WHERE nombre LIKE 'CD%'
         ) AND album_id NOT IN (
            SELECT DISTINCT album_id FROM formato_album WHERE formato_id IN (
               SELECT id FROM formatos WHERE nombre LIKE 'Vinilo%'
            )
         );
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL formato_album_AlbumesFormatoCDNoVinilo();
   ```

   ### 4. Obtener los títulos de los álbumes que tienen al menos un formato en vinilo y fueron lanzados antes del 2010.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS formato_album_AlbumesFormatoVinilo2010 //
   CREATE PROCEDURE formato_album_AlbumesFormatoVinilo2010()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM formato_album WHERE formato_id IN (
            SELECT id FROM formatos WHERE nombre LIKE 'Vinilo%'
         ) AND album_id IN (
            SELECT id FROM albumes WHERE fechaLanzamiento < '2010-01-01'
         )
      );

      IF @consulta > 0 THEN
         SELECT DISTINCT album_id, (
            SELECT titulo FROM albumes WHERE id = album_id
         ) AS titulo FROM formato_album WHERE formato_id IN (
            SELECT id FROM formatos WHERE nombre LIKE 'Vinilo%'
         ) AND album_id IN (
            SELECT id FROM albumes WHERE fechaLanzamiento < '2010-01-01'
         );
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL formato_album_AlbumesFormatoVinilo2010();
   ```

   ### 5. Encontrar los formatos utilizados para los álbumes del artista con id 4.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS formato_album_FormatosAlbumesArtista4 //
   CREATE PROCEDURE formato_album_FormatosAlbumesArtista4()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM formatos WHERE id IN (
            SELECT formato_id FROM formato_album WHERE album_id IN (
               SELECT id FROM albumes WHERE artista_id = 4
            )
         )
      );

      IF @consulta > 0 THEN
         SELECT * FROM formatos WHERE id IN (
            SELECT formato_id FROM formato_album WHERE album_id IN (
               SELECT id FROM albumes WHERE artista_id = 4
            )
         );
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL formato_album_FormatosAlbumesArtista4();
   ```

- ## canciones

   ### CRUD

   - **Insertar**

      ```SQL
      INSERT INTO canciones (titulo, duracion, letra, album_id, compositor_id)
      VALUES ('Bohemian Rhapsody', '06:07:00',
         'Is this the real life. Is this just fantasy. Caught in a landside. No escape from reality.',
         1, 4
      );
      ```

   - **Seleccionar**

      ```SQL
      SELECT * FROM canciones WHERE id = 1;
      ```

   - **Actualizar**

      ```SQL
      UPDATE canciones SET titulo = 'Bohemian Rhapsody' WHERE id = 1;
      ```

   - **Eliminar**

      ```SQL
      DELETE FROM canciones WHERE id = 1;
      ```

   ### 1. Canciones y sus compositores que son artistas.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS canciones_CancionesCompositoresSonArtistas //
   CREATE PROCEDURE canciones_CancionesCompositoresSonArtistas()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM canciones WHERE compositor_id IN (
            SELECT id FROM personas WHERE tipo = 'artista'
         )
      );

      IF @consulta > 0 THEN
         SELECT titulo AS cancion, (
            SELECT CONCAT(nombre, ' ', apellido1) FROM personas WHERE id = canciones.compositor_id
         ) AS compositor FROM canciones WHERE compositor_id IN (
            SELECT id FROM personas WHERE tipo = 'artista'
         );
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL canciones_CancionesCompositoresSonArtistas();
   ```

   ### 2. Canciones y la edad del compositor en el Año del Lanzamiento del album.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS canciones_CancionesEdadCompositorLanzamientoAlbum //
   CREATE PROCEDURE canciones_CancionesEdadCompositorLanzamientoAlbum()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM canciones c, personas p, albumes a
         WHERE p.id = c.compositor_id AND c.album_id = a.id
      );

      IF @consulta > 0 THEN
         SELECT
            c.titulo AS cancion,
            p.nombre,
            CONCAT(
               (SELECT YEAR(a.fechaLanzamiento) - YEAR(p.fechaNacimiento)),' años'
            ) AS edad_compositor_en_album
         FROM canciones c, personas p, albumes a
         WHERE p.id = c.compositor_id AND c.album_id = a.id;
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL canciones_CancionesEdadCompositorLanzamientoAlbum();
   ```

   ### 3. Canciones y la diferencia de años entre el Compositor y el Artista.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS canciones_CancionesYDifEdadesCompoArtista //
   CREATE PROCEDURE canciones_CancionesYDifEdadesCompoArtista()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM canciones c, albumes a WHERE c.album_id = a.id
      );

      IF @consulta > 0 THEN
         SELECT c.titulo AS cancion, (
            SELECT fechaNacimiento FROM personas WHERE id = c.compositor_id
         ) AS fecha_nacimiento_compositor, (
            SELECT fechaNacimiento FROM personas WHERE id = a.artista_id
         ) AS fecha_nacimiento_artista, ABS((
            SELECT YEAR(fechaNacimiento) FROM personas WHERE id = c.compositor_id
         ) - (
            SELECT YEAR(fechaNacimiento) FROM personas WHERE id = a.artista_id
         )) AS anios_diferencia
         FROM canciones c, albumes a WHERE c.album_id = a.id
         ORDER BY anios_diferencia DESC;
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL canciones_CancionesYDifEdadesCompoArtista();
   ```

   ### 4. Obtener las canciones de un artista donde la fecha de lanzamiento del album fue hace mas de 5 años.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS canciones_CancionesArtistaAlbumHace5Años //
   CREATE PROCEDURE canciones_CancionesArtistaAlbumHace5Años()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM canciones c, albumes a, personas p
         WHERE c.album_id = a.id AND a.artista_id = p.id
         AND YEAR(CURDATE()) - YEAR(a.fechaLanzamiento) > 5
      );

      IF @consulta > 0 THEN
         SELECT c.titulo AS cancion, (
            SELECT TRIM(CONCAT(nombre,' ',apellido1,' ',IFNULL(apellido2,''))) FROM personas
            WHERE id = c.compositor_id
         ) AS compositor_cancion,
         TRIM(CONCAT(p.nombre,' ',p.apellido1,' ',IFNULL(p.apellido2,''))) AS nombre_artista,
         p.nombreArtistico AS nombre_artistico FROM canciones c, albumes a, personas p
         WHERE c.album_id = a.id AND a.artista_id = p.id
         AND YEAR(CURDATE()) - YEAR(a.fechaLanzamiento) > 5;
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL canciones_CancionesArtistaAlbumHace5Años();
   ```

   ### 5. Canciones donde su compositor ha compuestó mas canciones.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS canciones_CancionesCompositoresCompuestoMasCanciones //
   CREATE PROCEDURE canciones_CancionesCompositoresCompuestoMasCanciones()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM canciones WHERE compositor_id IN (
            SELECT id FROM personas WHERE (
               SELECT COUNT(*) FROM canciones WHERE personas.id = compositor_id
            ) > 1
         )
      );

      IF @consulta > 0 THEN
         SELECT titulo AS cancion FROM canciones WHERE compositor_id IN (
            SELECT id FROM personas WHERE (
               SELECT COUNT(*) FROM canciones WHERE personas.id = compositor_id
            ) > 1
         );
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL canciones_CancionesCompositoresCompuestoMasCanciones();
   ```

- ## tiposRelanzamiento

   ### CRUD

   - **Insertar**

      ```SQL
      INSERT INTO tiposRelanzamiento (nombre) VALUES ('Edición Especial');
      ```

   - **Seleccionar**

      ```SQL
      SELECT * FROM tiposRelanzamiento WHERE id = 1;
      ```

   - **Actualizar**

      ```SQL
      UPDATE tiposRelanzamiento SET nombre = 'Edición Especial' WHERE id = 1;
      ```

   - **Eliminar**

      ```SQL
      DELETE FROM tiposRelanzamiento WHERE id = 1;
      ```

   ### 1. Obtener la cantidad de albumes por Tipo de Relanzamiento y ordernarlos de mayor a menor cantidad.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS tiposRelanzamiento_CantAlbumesPorTipoRelanzamiento //
   CREATE PROCEDURE tiposRelanzamiento_CantAlbumesPorTipoRelanzamiento()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM tiposRelanzamiento tr
      );

      IF @consulta > 0 THEN
         SELECT tr.nombre AS tipo_relanzamiento, (
            SELECT COUNT(*) FROM relanzamientos WHERE tipoRelanzamiento_id = tr.id
         ) AS cantidad_albumes
         FROM tiposRelanzamiento tr
         ORDER BY cantidad_albumes DESC;
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL tiposRelanzamiento_CantAlbumesPorTipoRelanzamiento();
   ```

   ### 2. Subconsulta para obtener el ultimo album relanzado por tipo y ordenarlo alfabeticamente.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS tiposRelanzamiento_UltimoAlbumPorTipoRelanzamiento //
   CREATE PROCEDURE tiposRelanzamiento_UltimoAlbumPorTipoRelanzamiento()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM tiposRelanzamiento tr, relanzamientos r, albumes a
         WHERE tr.id = r.tipoRelanzamiento_id AND r.album_id = a.id
      );

      IF @consulta > 0 THEN
         SELECT a.titulo AS album, tr.nombre AS tipo_relanzamiento, (
            SELECT MAX(fechaRelanzamiento) FROM relanzamientos WHERE tipoRelanzamiento_id = tr.id
         ) AS ultima_fecha_relanzamiento
         FROM tiposRelanzamiento tr, relanzamientos r, albumes a
         WHERE tr.id = r.tipoRelanzamiento_id AND r.album_id = a.id
         GROUP BY ultima_fecha_relanzamiento, a.titulo, tr.nombre
         ORDER BY album;
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL tiposRelanzamiento_UltimoAlbumPorTipoRelanzamiento();
   ```

   ### 3. Subconsulta para obtener el Tipo de Relanzamiento con más albumes.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS tiposRelanzamiento_TipoRelanzamientoConMasAlbumes //
   CREATE PROCEDURE tiposRelanzamiento_TipoRelanzamientoConMasAlbumes()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM tiposRelanzamiento tr
      );

      IF @consulta > 0 THEN
         SELECT nombre AS tipo_relanzamiento FROM tiposRelanzamiento tr
         ORDER BY (
            SELECT COUNT(*) FROM relanzamientos WHERE tipoRelanzamiento_id = tr.id
         ) DESC
         LIMIT 1;
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL tiposRelanzamiento_TipoRelanzamientoConMasAlbumes();
   ```

   ### 4. Obtener el Tipo de Relanzamiento con la mayor brecha de tiempo entre relanzamientos.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS tiposRelanzamiento_TipoRelanzamientoMayorBrecha //
   CREATE PROCEDURE tiposRelanzamiento_TipoRelanzamientoMayorBrecha()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM tiposRelanzamiento tr WHERE id = (
            SELECT tipoRelanzamiento_id FROM relanzamientos
            GROUP BY tipoRelanzamiento_id
            ORDER BY MAX(fechaRelanzamiento) - MIN(fechaRelanzamiento) DESC
            LIMIT 1
         )
      );

      IF @consulta > 0 THEN
         SELECT nombre AS tipo_relanzamiento FROM tiposRelanzamiento tr WHERE id = (
            SELECT tipoRelanzamiento_id FROM relanzamientos
            GROUP BY tipoRelanzamiento_id
            ORDER BY MAX(fechaRelanzamiento) - MIN(fechaRelanzamiento) DESC
            LIMIT 1
         );
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL tiposRelanzamiento_TipoRelanzamientoMayorBrecha();
   ```

   ### 5. Obtener el Tipo de Relanzamiento con más de 10 años de historia.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS tiposRelanzamiento_TipoRelanzamiento10años //
   CREATE PROCEDURE tiposRelanzamiento_TipoRelanzamiento10años()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM tiposRelanzamiento tr WHERE id IN (
            SELECT tipoRelanzamiento_id FROM relanzamientos
            GROUP BY tipoRelanzamiento_id
            HAVING MAX(fechaRelanzamiento) - MIN(fechaRelanzamiento) > 3650
         )
      );

      IF @consulta > 0 THEN
         SELECT nombre AS tipo_relanzamiento FROM tiposRelanzamiento tr WHERE id IN (
            SELECT tipoRelanzamiento_id FROM relanzamientos
            GROUP BY tipoRelanzamiento_id
            HAVING MAX(fechaRelanzamiento) - MIN(fechaRelanzamiento) > 3650
         );
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL tiposRelanzamiento_TipoRelanzamiento10años();
   ```

- ## relanzamientos

   ### CRUD

   - **Insertar**

      ```SQL
      INSERT INTO relanzamientos (fechaRelanzamiento, album_id, tipoRelanzamiento_id)
      VALUES ('2022-03-20', 1, 1);
      ```

   - **Seleccionar**

      ```SQL
      SELECT * FROM relanzamientos WHERE album_id = 1;
      ```

   - **Actualizar**

      ```SQL
      UPDATE relanzamientos SET tipoRelanzamiento_id = 1
      WHERE album_id = 1 AND fechaRelanzamiento = '2022-03-20';
      ```

   - **Eliminar**

      ```SQL
      DELETE FROM relanzamientos WHERE fechaRelanzamiento = '2022-03-20' AND album_id = 1;
      ```

   ### 1. Mostrar los artistas que han lanzado álbumes remasterizados.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS relanzamientos_ArtistasAlbumesRemasterizados //
   CREATE PROCEDURE relanzamientos_ArtistasAlbumesRemasterizados()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM personas p
         JOIN albumes a ON p.id = a.artista_id
         WHERE EXISTS (
            SELECT * FROM relanzamientos r WHERE r.album_id = a.id AND r.tipoRelanzamiento_id = (
               SELECT id FROM tiposRelanzamiento WHERE nombre = 'Remasterizado'
            )
         )
      );

      IF @consulta > 0 THEN
         SELECT * FROM personas p
         JOIN albumes a ON p.id = a.artista_id
         WHERE EXISTS (
            SELECT * FROM relanzamientos r WHERE r.album_id = a.id AND r.tipoRelanzamiento_id = (
               SELECT id FROM tiposRelanzamiento WHERE nombre = 'Remasterizado'
            )
         );
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL relanzamientos_ArtistasAlbumesRemasterizados();
   ```

   ### 2. Encontrar los tipos de relanzamiento utilizados para un álbum específico (por ejemplo, 'Amanecer Musical').

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS relanzamientos_TiposRelanzamientosAlbumEspecifico //
   CREATE PROCEDURE relanzamientos_TiposRelanzamientosAlbumEspecifico()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM tiposRelanzamiento t
         JOIN relanzamientos r ON t.id = r.tipoRelanzamiento_id
         WHERE r.album_id = (
            SELECT id FROM albumes WHERE titulo = 'Amanecer Musical'
         )
      );

      IF @consulta > 0 THEN
         SELECT t.nombre AS tipo_relanzamiento FROM tiposRelanzamiento t
         JOIN relanzamientos r ON t.id = r.tipoRelanzamiento_id
         WHERE r.album_id = (
            SELECT id FROM albumes WHERE titulo = 'Amanecer Musical'
         );
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL relanzamientos_TiposRelanzamientosAlbumEspecifico();
   ```

   ### 3. Contar cuántos álbumes ha lanzado cada artista, incluyendo relanzamientos.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS relanzamientos_CantAlbumesArtistaConRelanzados //
   CREATE PROCEDURE relanzamientos_CantAlbumesArtistaConRelanzados()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM personas p
         LEFT JOIN albumes a ON p.id = a.artista_id
         LEFT JOIN relanzamientos r ON a.id = r.album_id
      );

      IF @consulta > 0 THEN
         SELECT
            p.nombre,
            TRIM(CONCAT(p.apellido1,' ',IFNULL(p.apellido2,''))) AS apellidos,
            p.nombreArtistico,
            COUNT(a.id) + COUNT(r.album_id) AS total_albumes
         FROM personas p
         LEFT JOIN albumes a ON p.id = a.artista_id
         LEFT JOIN relanzamientos r ON a.id = r.album_id
         GROUP BY p.id;
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL relanzamientos_CantAlbumesArtistaConRelanzados();
   ```

   ### 4. Mostrar los álbumes que han sido relanzados en aniversarios (tipo de relanzamiento) en el año 2022.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS relanzamientos_AlbumesRelanzadosUniversario2022 //
   CREATE PROCEDURE relanzamientos_AlbumesRelanzadosUniversario2022()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM albumes WHERE id IN (
            SELECT album_id FROM relanzamientos WHERE tipoRelanzamiento_id = (
               SELECT id FROM tiposRelanzamiento WHERE nombre = 'Aniversario' 
            ) AND YEAR(fechaRelanzamiento) = 2022
         )
      );

      IF @consulta > 0 THEN
         SELECT titulo AS titulo_album FROM albumes WHERE id IN (
            SELECT album_id FROM relanzamientos WHERE tipoRelanzamiento_id = (
               SELECT id FROM tiposRelanzamiento WHERE nombre = 'Aniversario' 
            ) AND YEAR(fechaRelanzamiento) = 2022
         );
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL relanzamientos_AlbumesRelanzadosUniversario2022();
   ```

   ### 5. Encontrar los artistas que han lanzado álbumes tanto en formato físico (vinilo, CD) como en formato digital.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS relanzamientos_ArtistasAlbumesFisicoDigital //
   CREATE PROCEDURE relanzamientos_ArtistasAlbumesFisicoDigital()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM personas p
         JOIN albumes a ON p.id = a.artista_id
         WHERE EXISTS (
            SELECT * FROM relanzamientos r WHERE r.album_id = a.id AND r.tipoRelanzamiento_id IN (
               SELECT id FROM tiposRelanzamiento WHERE nombre IN (
                  'Vinilo de Colección', 'CD', 'Edición Especial', 'Digital Remasterizado'
               )
            )
         )
      );

      IF @consulta > 0 THEN
         SELECT * FROM personas p
         JOIN albumes a ON p.id = a.artista_id
         WHERE EXISTS (
            SELECT * FROM relanzamientos r WHERE r.album_id = a.id AND r.tipoRelanzamiento_id IN (
               SELECT id FROM tiposRelanzamiento WHERE nombre IN (
                  'Vinilo de Colección', 'CD', 'Edición Especial', 'Digital Remasterizado'
               )
            )
         );
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL relanzamientos_ArtistasAlbumesFisicoDigital();
   ```

- ## ventas

   ### CRUD

   - **Insertar**

      ```SQL
      INSERT INTO ventas (album_id, fechaVenta, cantidadVendida, ingresos)
      VALUES (1, '2022-03-20', 500, 750000.00);
      ```

   - **Seleccionar**

      ```SQL
      SELECT * FROM ventas WHERE album_id = 1;
      ```

   - **Actualizar**

      ```SQL
      UPDATE ventas SET cantidadVendida = 500
      WHERE album_id = 1 AND fechaVenta = '2022-03-20';
      ```

   - **Eliminar**

      ```SQL
      DELETE FROM ventas WHERE album_id = 1 AND fechaVenta = '2022-03-20';
      ```

   ### 1. Álbumes vendidos por artistas que tienen un nombre artístico y los detalles de las ventas.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS ventas_AlbumesArtistasConNombreArtistico //
   CREATE PROCEDURE ventas_AlbumesArtistasConNombreArtistico()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM (
            SELECT * FROM ventas WHERE album_id IN (
               SELECT id FROM albumes WHERE artista_id IN (
                  SELECT id FROM personas WHERE nombreArtistico IS NOT NULL AND tipo = 'artista'
               )
            ) ORDER BY album_id
         ) AS subconsulta
         JOIN albumes a ON subconsulta.album_id = a.id
      );

      IF @consulta > 0 THEN
         SELECT a.titulo AS titulo_album, fechaVenta, cantidadVendida, ingresos FROM (
            SELECT * FROM ventas WHERE album_id IN (
               SELECT id FROM albumes WHERE artista_id IN (
                  SELECT id FROM personas WHERE nombreArtistico IS NOT NULL AND tipo = 'artista'
               )
            ) ORDER BY album_id
         ) AS subconsulta
         JOIN albumes a ON subconsulta.album_id = a.id;
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL ventas_AlbumesArtistasConNombreArtistico();
   ```

   ### 2. Top 3 de estudios con más ingresos por ventas.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS ventas_Top3EstudiosMayoresIngresos //
   CREATE PROCEDURE ventas_Top3EstudiosMayoresIngresos()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM ventas v
         INNER JOIN albumes a ON v.album_id = a.id
         INNER JOIN personas p ON a.artista_id = p.id
         INNER JOIN estudios e ON p.estudio_id = e.id
      );

      IF @consulta > 0 THEN
         SELECT e.nombre AS estudio, SUM(v.ingresos) AS totalIngresos FROM ventas v
         INNER JOIN albumes a ON v.album_id = a.id
         INNER JOIN personas p ON a.artista_id = p.id
         INNER JOIN estudios e ON p.estudio_id = e.id
         GROUP BY estudio
         ORDER BY totalIngresos DESC
         LIMIT 3;
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL ventas_Top3EstudiosMayoresIngresos();
   ```

   ### 3. Artista que ha tenido más ventas en un año específico y su ubicación de estudio

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS ventas_ArtistasMayoresVentasPorAñoYSuEstudio //
   CREATE PROCEDURE ventas_ArtistasMayoresVentasPorAñoYSuEstudio()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM ventas v, albumes a WHERE v.album_id = a.id
      );

      IF @consulta > 0 THEN
         SELECT 
            YEAR(v.fechaVenta) AS año, 
            (SELECT nombre FROM personas WHERE id = a.artista_id) AS artista, 
            (SELECT ubicacion FROM estudios WHERE id = (
               SELECT estudio_id FROM personas WHERE id = a.artista_id
            )) AS ubicacion, MAX(v.cantidadVendida) AS maxCantidadVendida
         FROM ventas v, albumes a
         WHERE v.album_id = a.id
         GROUP BY año, artista, ubicacion;
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL ventas_ArtistasMayoresVentasPorAñoYSuEstudio();
   ```

   ### 4. Artistas que SI han vendido álbumes con sus nombres y el título de los álbumes.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS ventas_ArtistasYSusAlbumesVendidos //
   CREATE PROCEDURE ventas_ArtistasYSusAlbumesVendidos()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM ventas
      );

      IF @consulta > 0 THEN
         SELECT *,
            (SELECT CONCAT(nombre, ' ', apellido1) FROM personas WHERE id = (
               SELECT artista_id FROM albumes WHERE id = ventas.album_id
            )) AS nombre_artista,
            (SELECT titulo FROM albumes WHERE id = ventas.album_id) AS titulo_album
         FROM ventas;
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL ventas_ArtistasYSusAlbumesVendidos();
   ```

   ### 5. Álbum más vendido (por cantidad) y álbum más vendido (por ingresos) con información del álbum y artista.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS ventas_AlbumMasVendidoPorCantidadYPorIngresos //
   CREATE PROCEDURE ventas_AlbumMasVendidoPorCantidadYPorIngresos()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM (
            (SELECT album_id, fechaVenta, cantidadVendida, ingresos, (
               SELECT titulo FROM albumes WHERE id = ventas.album_id
            ) AS titulo_album, (
               SELECT CONCAT(nombre, ' ', apellido1) FROM personas WHERE id = (
                  SELECT artista_id FROM albumes WHERE id = ventas.album_id
               )
            ) AS nombre_artista FROM ventas
            ORDER BY cantidadVendida DESC
            LIMIT 1)
            UNION ALL
            (SELECT album_id, fechaVenta, cantidadVendida, SUM(ingresos) as maxIngresos, (
               SELECT titulo FROM albumes WHERE id = ventas.album_id
            ) AS titulo_album, (
               SELECT CONCAT(nombre, ' ', apellido1) FROM personas WHERE id = (
                  SELECT artista_id FROM albumes WHERE id = ventas.album_id
               )
            ) AS nombre_artista FROM ventas
            GROUP BY album_id
            ORDER BY maxIngresos DESC
            LIMIT 1)
         ) AS tabla
      );

      IF @consulta > 0 THEN
         (SELECT album_id, fechaVenta, cantidadVendida, ingresos, (
            SELECT titulo FROM albumes WHERE id = ventas.album_id
         ) AS titulo_album, (
            SELECT CONCAT(nombre, ' ', apellido1) FROM personas WHERE id = (
               SELECT artista_id FROM albumes WHERE id = ventas.album_id
            )
         ) AS nombre_artista FROM ventas
         ORDER BY cantidadVendida DESC
         LIMIT 1)
         UNION ALL
         (SELECT album_id, fechaVenta, cantidadVendida, SUM(ingresos) as maxIngresos, (
            SELECT titulo FROM albumes WHERE id = ventas.album_id
            ) AS titulo_album, (
               SELECT CONCAT(nombre, ' ', apellido1) FROM personas WHERE id = (
                  SELECT artista_id FROM albumes WHERE id = ventas.album_id
            )
         ) AS nombre_artista FROM ventas
         GROUP BY album_id
         ORDER BY maxIngresos DESC
         LIMIT 1);
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL ventas_AlbumMasVendidoPorCantidadYPorIngresos();
   ```

   ### 6. Artistas que han vendido más de 500 copias en una venta y el total de álbumes vendidos.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS ventas_ArtistasMas500CopiasYAlbumesVendidos //
   CREATE PROCEDURE ventas_ArtistasMas500CopiasYAlbumesVendidos()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM albumes WHERE id IN (
            SELECT album_id FROM ventas WHERE cantidadVendida > 500
         )
      );

      IF @consulta > 0 THEN
         SELECT artista_id, (
            SELECT CONCAT(nombre, ' ', apellido1) FROM personas WHERE id = artista_id
         ) AS nombre_artista, COUNT(*) AS total_albumes_vendidos FROM albumes WHERE id IN (
            SELECT album_id FROM ventas WHERE cantidadVendida > 500
         ) GROUP BY artista_id;
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL ventas_ArtistasMas500CopiasYAlbumesVendidos();
   ```

   ### 7. Artistas que han vendido álbumes en su país de origen y el título de los álbumes.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS ventas_ArtistasVentasAlbumesPaisOrigen //
   CREATE PROCEDURE ventas_ArtistasVentasAlbumesPaisOrigen()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM personas
         JOIN albumes ON personas.id = albumes.artista_id
         JOIN ventas ON albumes.id = ventas.album_id
         WHERE personas.paisOrigen = (
            SELECT paisOrigen FROM personas WHERE id = albumes.artista_id
         ) ORDER BY artista_id
      );

      IF @consulta > 0 THEN
         SELECT DISTINCT artista_id, (
            SELECT CONCAT(nombre, ' ', apellido1) FROM personas WHERE id = artista_id
         ) AS nombre_artista, (
            SELECT GROUP_CONCAT(titulo) FROM albumes WHERE artista_id = personas.id
         ) AS titulos_albumes FROM personas
         JOIN albumes ON personas.id = albumes.artista_id
         JOIN ventas ON albumes.id = ventas.album_id
         WHERE personas.paisOrigen = (
            SELECT paisOrigen FROM personas WHERE id = albumes.artista_id
         ) ORDER BY artista_id;
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL ventas_ArtistasVentasAlbumesPaisOrigen();
   ```

- ## giras

   ### CRUD

   - **Insertar**

      ```SQL
      INSERT INTO giras (nombre, fechaInicio, fechaFin, artista_id)
      VALUES ('Gira Mundial 2022', '2022-04-01', NULL, 1);
      ```

   - **Seleccionar**

      ```SQL
      SELECT * FROM giras WHERE id = 1;
      ```

   - **Actualizar**

      ```SQL
      UPDATE giras SET nombre = 'Gira Mundial 2022' WHERE id = 1;
      ```

   - **Eliminar**

      ```SQL
      DELETE FROM giras WHERE id = 1;
      ```

   ### 1. Mostrar el nombre de la gira y el nombre del estudio donde trabaja el artista asociado a esa gira.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS giras_GiraYNombreEstudioSegunArtista //
   CREATE PROCEDURE giras_GiraYNombreEstudioSegunArtista()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM giras g, estudios e, personas p
         WHERE g.artista_id = p.id AND p.estudio_id = e.id
      );

      IF @consulta > 0 THEN
         SELECT g.nombre AS nombre_gira, e.nombre AS nombre_estudio
         FROM giras g, estudios e, personas p
         WHERE g.artista_id = p.id AND p.estudio_id = e.id;
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL giras_GiraYNombreEstudioSegunArtista();
   ```

   ### 2. Mostrar el nombre de la gira y el nombre de los estudios ubicados en el mismo país que el país de origen del artista asociado a esa gira.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS giras_GirasEstudiosSegunPaisOrigenArtista //
   CREATE PROCEDURE giras_GirasEstudiosSegunPaisOrigenArtista()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM giras g, estudios e, personas p
         WHERE g.artista_id = p.id AND e.ubicacion LIKE CONCAT('%', p.paisOrigen, '%')
      );

      IF @consulta > 0 THEN
         SELECT g.nombre AS nombre_gira, e.nombre AS nombre_estudio
         FROM giras g, estudios e, personas p
         WHERE g.artista_id = p.id AND e.ubicacion LIKE CONCAT('%', p.paisOrigen, '%');
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL giras_GirasEstudiosSegunPaisOrigenArtista();
   ```

   ### 3. Mostrar el nombre de la gira y el nombre de los estudios fundados en un año impar asociados a esa gira.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS giras_GirasYEstudiosFundadosAñoImpar //
   CREATE PROCEDURE giras_GirasYEstudiosFundadosAñoImpar()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM giras g, estudios e WHERE YEAR(e.fechaFundacion) % 2 <> 0
         AND g.artista_id IN (
            SELECT id FROM personas WHERE estudio_id = e.id
         )
      );

      IF @consulta > 0 THEN
         SELECT g.nombre AS nombre_gira, e.nombre AS nombre_estudio FROM giras g, estudios e
         WHERE YEAR(e.fechaFundacion) % 2 <> 0 AND g.artista_id IN (
            SELECT id FROM personas WHERE estudio_id = e.id
         );
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL giras_GirasYEstudiosFundadosAñoImpar();
   ```

   ### 4. Mostrar el nombre de la gira y el nombre de los artistas que tienen más de 30 años, pero que no han realizado giras en América del Norte.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS giras_GirasYArtistas30AñosNoGirasAmericaNorte //
   CREATE PROCEDURE giras_GirasYArtistas30AñosNoGirasAmericaNorte()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM giras g, personas p WHERE g.artista_id = p.id
         AND YEAR(g.fechaInicio) - YEAR(p.fechaNacimiento) > 30 AND NOT EXISTS (
            SELECT * FROM giras g2
            WHERE g2.artista_id = p.id AND g2.nombre LIKE '%América del Norte%'
         )
      );

      IF @consulta > 0 THEN
         SELECT
            g.nombre AS nombre_gira,
            TRIM(CONCAT(p.nombre,' ',p.apellido1,' ',IFNULL(p.apellido2,''))) AS nombre_artista,
            p.nombreArtistico
         FROM giras g, personas p
         WHERE g.artista_id = p.id AND YEAR(g.fechaInicio) - YEAR(p.fechaNacimiento) > 30
         AND NOT EXISTS (
            SELECT * FROM giras g2
            WHERE g2.artista_id = p.id AND g2.nombre LIKE '%América del Norte%'
         );
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL giras_GirasYArtistas30AñosNoGirasAmericaNorte();
   ```

   ### 5. Mostrar el nombre de la gira y el nombre de los artistas que han realizado giras en un año en el que también se fundó un estudio.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS giras_GirasYArtistasMismoAñoFundacionEstudio //
   CREATE PROCEDURE giras_GirasYArtistasMismoAñoFundacionEstudio()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM giras g, personas p WHERE g.artista_id = p.id AND EXISTS (
            SELECT * FROM estudios e WHERE YEAR(g.fechaInicio) = YEAR(e.fechaFundacion)
         )
      );

      IF @consulta > 0 THEN
         SELECT
            g.nombre AS nombre_gira,
            TRIM(CONCAT(p.nombre,' ',p.apellido1,' ',IFNULL(p.apellido2,''))) AS nombre_artista,
            p.nombreArtistico
         FROM giras g, personas p WHERE g.artista_id = p.id AND EXISTS (
            SELECT * FROM estudios e WHERE YEAR(g.fechaInicio) = YEAR(e.fechaFundacion)
         );
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL giras_GirasYArtistasMismoAñoFundacionEstudio();
   ```

   ### 6. Mostrar el nombre de la gira y el nombre de los estudios fundados en el mismo año que el inicio de la gira, pero en un país diferente al país de origen del artista asociado.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS giras_GirasYEstudiosMismoAñoPaisDiferenteSegunArtista //
   CREATE PROCEDURE giras_GirasYEstudiosMismoAñoPaisDiferenteSegunArtista()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM giras g, estudios e, personas p
         WHERE g.artista_id = p.id AND e.id = p.estudio_id
         AND YEAR(g.fechaInicio) = YEAR(e.fechaFundacion)
         AND e.ubicacion != p.paisOrigen
      );

      IF @consulta > 0 THEN
         SELECT
            p.paisOrigen AS pais_artista,
            e.ubicacion AS ubicacion_estudio,
            g.nombre AS nombre_gira,
            e.nombre AS nombre_estudio
         FROM giras g, estudios e, personas p WHERE g.artista_id = p.id AND e.id = p.estudio_id
         AND YEAR(g.fechaInicio) = YEAR(e.fechaFundacion) AND e.ubicacion != p.paisOrigen;
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL giras_GirasYEstudiosMismoAñoPaisDiferenteSegunArtista();
   ```

   ### 7. Mostrar el nombre de la gira y el nombre de los estudios fundados en un año que coincide con el último dígito del año de inicio de carrera del artista asociado a esa gira.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS giras_GirasYEstudiosUltimoDigitoFundacionInicioCarrera //
   CREATE PROCEDURE giras_GirasYEstudiosUltimoDigitoFundacionInicioCarrera()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM giras g, estudios e, personas p
         WHERE g.artista_id = p.id AND e.id = p.estudio_id
         AND YEAR(e.fechaFundacion) % 10 = p.anyoInicioCarrera % 10
      );

      IF @consulta > 0 THEN
         SELECT g.nombre AS nombre_gira, e.nombre AS nombre_estudio
         FROM giras g, estudios e, personas p
         WHERE g.artista_id = p.id AND e.id = p.estudio_id
         AND YEAR(e.fechaFundacion) % 10 = p.anyoInicioCarrera % 10;
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL giras_GirasYEstudiosUltimoDigitoFundacionInicioCarrera();
   ```

- ## paises

   ### CRUD

   - **Insertar**

      ```SQL
      INSERT INTO paises (nombre) VALUES ('Estados Unidos');
      ```

   - **Seleccionar**

      ```SQL
      SELECT * FROM paises WHERE id = 1;
      ```

   - **Actualizar**

      ```SQL
      UPDATE paises SET nombre = 'Estados Unidos' WHERE id = 1;
      ```

   - **Eliminar**

      ```SQL
      DELETE FROM paises WHERE id = 1;
      ```

   ### 1. Encontrar los países que han sido visitados por al menos dos giras en un mismo año.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS paises_PaisesVisitasDosGirasMismoAño //
   CREATE PROCEDURE paises_PaisesVisitasDosGirasMismoAño()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM paises, pais_gira, giras
         WHERE paises.id = pais_gira.pais_id AND pais_gira.gira_id = giras.id
         GROUP BY paises.id, YEAR(giras.fechaInicio)
         HAVING COUNT(DISTINCT giras.id) >= 2
      );

      IF @consulta > 0 THEN
         SELECT paises.nombre AS nombre_pais FROM paises, pais_gira, giras
         WHERE paises.id = pais_gira.pais_id AND pais_gira.gira_id = giras.id
         GROUP BY paises.id, YEAR(giras.fechaInicio)
         HAVING COUNT(DISTINCT giras.id) >= 2;
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL paises_PaisesVisitasDosGirasMismoAño();
   ```

   ### 2. Artistas que han nacido en países que no han sido visitados por ninguna gira.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS paises_ArtistasPaisOrigenNoVisitadoGira //
   CREATE PROCEDURE paises_ArtistasPaisOrigenNoVisitadoGira()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM personas WHERE tipo = 'artista' AND paisOrigen NOT IN (
            SELECT DISTINCT paises.nombre FROM paises, pais_gira
            WHERE paises.id = pais_gira.pais_id
         )
      );

      IF @consulta > 0 THEN
         SELECT * FROM personas WHERE tipo = 'artista' AND paisOrigen NOT IN (
            SELECT DISTINCT paises.nombre FROM paises, pais_gira
            WHERE paises.id = pais_gira.pais_id
         );
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL paises_ArtistasPaisOrigenNoVisitadoGira();
   ```

   ### 3. Listar los artistas que han nacido en países que han sido visitados por al menos dos giras diferentes.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS paises_ArtistasPaisesVisitados2Giras //
   CREATE PROCEDURE paises_ArtistasPaisesVisitados2Giras()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM personas WHERE tipo = 'artista' AND paisOrigen IN (
            SELECT pais_id FROM pais_gira
            GROUP BY pais_id
            HAVING COUNT(DISTINCT gira_id) >= 2
         )
      );

      IF @consulta > 0 THEN
         SELECT * FROM personas WHERE tipo = 'artista' AND paisOrigen IN (
            SELECT pais_id FROM pais_gira
            GROUP BY pais_id
            HAVING COUNT(DISTINCT gira_id) >= 2
         );
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL paises_ArtistasPaisesVisitados2Giras();
   ```

   ### 4. Listar los países que han sido visitados por giras que incluyen artistas que han nacido en países de América del Sur y compositores que han nacido en países de Europa.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS paises_PaisesVisitadosGirasArtistasAmericaCompEuropa //
   CREATE PROCEDURE paises_PaisesVisitadosGirasArtistasAmericaCompEuropa()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM paises, pais_gira, giras, personas
         WHERE paises.id = pais_gira.pais_id AND pais_gira.gira_id = giras.id
         AND giras.artista_id = personas.id AND (
            (personas.paisOrigen IN (
                  'Argentina', 'Colombia', 'Perú', 'Chile', 'Ecuador', 'Venezuela'
               ) AND personas.tipo = 'artista'
            ) OR (personas.paisOrigen IN (
                  'Reino Unido', 'Alemania', 'Suecia', 'Francia', 'Italia', 'España', 'Austria'
               ) AND personas.tipo = 'compositor'
            )
         ) ORDER BY paises.id
      );

      IF @consulta > 0 THEN
         SELECT paises.* FROM paises, pais_gira, giras, personas
         WHERE paises.id = pais_gira.pais_id AND pais_gira.gira_id = giras.id
         AND giras.artista_id = personas.id AND (
            (personas.paisOrigen IN (
                  'Argentina', 'Colombia', 'Perú', 'Chile', 'Ecuador', 'Venezuela'
               ) AND personas.tipo = 'artista'
            ) OR (personas.paisOrigen IN (
                  'Reino Unido', 'Alemania', 'Suecia', 'Francia', 'Italia', 'España', 'Austria'
               ) AND personas.tipo = 'compositor'
            )
         ) ORDER BY paises.id;
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL paises_PaisesVisitadosGirasArtistasAmericaCompEuropa();
   ```

   ### 5. Encontrar los estudios que han sido utilizados por artistas que han nacido en países que no han sido visitados por ninguna gira.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS paises_EstudiosArtistasPaisOrigenNoVisitadoGira //
   CREATE PROCEDURE paises_EstudiosArtistasPaisOrigenNoVisitadoGira()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM estudios, personas
         WHERE estudios.id = personas.estudio_id AND personas.tipo = 'artista'
         AND personas.paisOrigen NOT IN (
            SELECT DISTINCT paises.nombre FROM paises, pais_gira
            WHERE paises.id = pais_gira.pais_id
         )
      );

      IF @consulta > 0 THEN
         SELECT estudios.* FROM estudios, personas
         WHERE estudios.id = personas.estudio_id AND personas.tipo = 'artista'
         AND personas.paisOrigen NOT IN (
            SELECT DISTINCT paises.nombre FROM paises, pais_gira
            WHERE paises.id = pais_gira.pais_id
         );
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL paises_EstudiosArtistasPaisOrigenNoVisitadoGira();
   ```

   ### 6. Listar los países que han sido visitados por giras que incluyen artistas de estudios fundados antes del año 2000 y compositores de estudios fundados después del año 2000.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS paises_PaisesVisitadosArtsYCompsEstudiosAntes2000 //
   CREATE PROCEDURE paises_PaisesVisitadosArtsYCompsEstudiosAntes2000()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM paises, pais_gira, giras, personas, estudios
         WHERE paises.id = pais_gira.pais_id AND pais_gira.gira_id = giras.id
         AND giras.artista_id = personas.id AND personas.tipo IN ('artista', 'compositor')
         AND personas.estudio_id = estudios.id AND (
            (personas.tipo = 'artista' AND YEAR(estudios.fechaFundacion) < 2000)
            OR
            (personas.tipo = 'compositor' AND YEAR(estudios.fechaFundacion) < 2000)
         )
      );

      IF @consulta > 0 THEN
         SELECT paises.* FROM paises, pais_gira, giras, personas, estudios
         WHERE paises.id = pais_gira.pais_id AND pais_gira.gira_id = giras.id
         AND giras.artista_id = personas.id AND personas.tipo IN ('artista', 'compositor')
         AND personas.estudio_id = estudios.id AND (
            (personas.tipo = 'artista' AND YEAR(estudios.fechaFundacion) < 2000)
            OR
            (personas.tipo = 'compositor' AND YEAR(estudios.fechaFundacion) < 2000)
         );
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL paises_PaisesVisitadosArtsYCompsEstudiosAntes2000();
   ```

   ### 7. Personas que han trabajado en estudios ubicados en países que han sido visitados por al menos tres giras diferentes en un año específico.

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS paises_PersonasEstudiosUbicacionVisitados3GirasAño //
   CREATE PROCEDURE paises_PersonasEstudiosUbicacionVisitados3GirasAño()
   BEGIN
      SET @consulta = (
         SELECT COUNT(*) FROM personas, estudios, pais_gira, giras, paises
         WHERE personas.estudio_id = estudios.id AND personas.id = giras.artista_id
         AND giras.id = pais_gira.gira_id AND pais_gira.pais_id = paises.id
         GROUP BY personas.id, YEAR(giras.fechaInicio)
         HAVING COUNT(DISTINCT pais_gira.gira_id) >= 3
      );

      IF @consulta > 0 THEN
         SELECT personas.* FROM personas, estudios, pais_gira, giras, paises
         WHERE personas.estudio_id = estudios.id AND personas.id = giras.artista_id
         AND giras.id = pais_gira.gira_id AND pais_gira.pais_id = paises.id
         GROUP BY personas.id, YEAR(giras.fechaInicio)
         HAVING COUNT(DISTINCT pais_gira.gira_id) >= 3;
      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL paises_PersonasEstudiosUbicacionVisitados3GirasAño();
   ```

- ## pais_gira

   ### CRUD

   - **Insertar**

      ```SQL
      INSERT INTO pais_gira (gira_id, pais_id) VALUES (1, 3);
      ```

   - **Seleccionar**

      ```SQL
      SELECT * FROM pais_gira WHERE gira_id = 1;
      ```

   - **Actualizar**

      ```SQL
      UPDATE pais_gira SET pais_id = 3 WHERE gira_id = 1 AND pais_id = 3;
      ```

   - **Eliminar**

      ```SQL
      DELETE FROM pais_gira WHERE gira_id = 1 AND pais_id = 3;
      ```

   ### 1. 

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS  //
   CREATE PROCEDURE ()
   BEGIN
      SET @consulta = (
         
      );

      IF @consulta > 0 THEN

      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL ();
   ```

   ### 2. 

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS  //
   CREATE PROCEDURE ()
   BEGIN
      SET @consulta = (
         
      );

      IF @consulta > 0 THEN

      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL ();
   ```

   ### 3. 

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS  //
   CREATE PROCEDURE ()
   BEGIN
      SET @consulta = (
         
      );

      IF @consulta > 0 THEN

      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL ();
   ```

   ### 4. 

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS  //
   CREATE PROCEDURE ()
   BEGIN
      SET @consulta = (
         
      );

      IF @consulta > 0 THEN

      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL ();
   ```

   ### 5. 

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS  //
   CREATE PROCEDURE ()
   BEGIN
      SET @consulta = (
         
      );

      IF @consulta > 0 THEN

      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL ();
   ```

   ### 6. 

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS  //
   CREATE PROCEDURE ()
   BEGIN
      SET @consulta = (
         
      );

      IF @consulta > 0 THEN

      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL ();
   ```

   ### 7. 

   ```SQL
   DELIMITER //
   DROP PROCEDURE IF EXISTS  //
   CREATE PROCEDURE ()
   BEGIN
      SET @consulta = (
         
      );

      IF @consulta > 0 THEN

      ELSE
         SELECT 'No hay resultados para mostrar.' AS MENSAJE;
      END IF;
   END //
   DELIMITER ;
   CALL ();
   ```

## Modelos

<div align="center">
   <h3><b>Modelo Conceptual</b></h3>
   <img src="./img/modelo_conceptual.png">
   <h3><b>Modelo Lógico</b></h3>
   <img src="./img/modelo_logico.png">
   <h3><b>Modelo Físico</b></h3>
   <img src="./img/modelo_fisico.png">
</div>

## Uso del Proyecto

Clona este repositorio en tu maquina local:

```BASH
git clone https://github.com/jstorra/proyecto-discografica-sql.git
```

---

<p align="center">Developed by <a href="https://github.com/jstorra">@jstorra</a></p>