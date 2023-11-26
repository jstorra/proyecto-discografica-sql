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
         SELECT COUNT(*)
         FROM estudios
         WHERE id IN (
            SELECT DISTINCT estudio_id
            FROM personas
            WHERE tipo = 'artista'
         )
      );

      IF @consulta > 0 THEN
         SELECT id, nombre, ubicacion, fechaFundacion
         FROM estudios
         WHERE id IN (
            SELECT DISTINCT estudio_id
            FROM personas
            WHERE tipo = 'artista'
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
         SELECT COUNT(*)
         FROM estudios
         WHERE fechaFundacion < (
            SELECT MIN(fechaFundacion)
            FROM estudios
            WHERE ubicacion LIKE '%Canada%'
         )
      );

      IF @consulta > 0 THEN
         SELECT id, nombre, ubicacion, fechaFundacion
         FROM estudios
         WHERE fechaFundacion < (
            SELECT MIN(fechaFundacion)
            FROM estudios
            WHERE ubicacion LIKE '%Canada%'
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
         SELECT COUNT(*)
         FROM estudios
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
         SELECT COUNT(*)
         FROM estudios
         WHERE id IN (
            SELECT estudio_id
            FROM personas
            GROUP BY estudio_id
            HAVING COUNT(*) > 3
         )
      );

      IF @consulta > 0 THEN
         SELECT id, nombre, ubicacion, fechaFundacion
         FROM estudios
         WHERE id IN (
            SELECT estudio_id
            FROM personas
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
         SELECT COUNT(*)
         FROM estudios
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
         SELECT COUNT(*)
         FROM estudios
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
         sexo,
         tipo,
         nombre,
         apellido1,
         apellido2,
         nombreArtistico,
         telefonoPrincipal,
         paisOrigen, fechaNacimiento,
         anyoInicioCarrera,
         estudio_id
      ) VALUES (
         'H',
         'artista',
         'Juan',
         'Perez',
         'Gomez',
         'Juanito',
         '+1 555-987-6543',
         'España',
         '1990-01-15',
         2010, 1
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

- ## canciones

   ### CRUD

   - **Insertar**

      ```SQL
      INSERT INTO canciones (titulo, duracion, letra, album_id, compositor_id)
      VALUES (
         'Bohemian Rhapsody',
         '06:07:00',
         'Is this the real life. Is this just fantasy. Caught in a landside. No escape from reality.',
         1,
         4
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