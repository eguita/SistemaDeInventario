-- Creacion de la Base de Datos--
CREATE DATABASE dbsistema
go
--Usamos la Base de Datos--
use dbsistema
go
--Tabla Categoria--
CREATE TABLE CATEGORIA(
ID_CATEGORIA INT PRIMARY KEY IDENTITY,
NOMBRE VARCHAR(50) NOT NULL UNIQUE,
DESCRIPCION VARCHAR(250) NULL,
ESTADO BIT DEFAULT (1)
)
--TABLA SUB CATEGORIA--
CREATE TABLE SUB_CATEGORIA(
ID_SUB_CATEGORIA INT PRIMARY KEY IDENTITY,
NOMBRE VARCHAR(50) NOT NULL UNIQUE,
DESCRIPCION VARCHAR(250) NULL,
ESTADO BIT DEFAULT (1)
)
--TABLA MARCA--
CREATE TABLE MARCA(
ID_MARCA INT PRIMARY KEY IDENTITY,
NOMBRE VARCHAR(50) NOT NULL UNIQUE,
DESCRIPCION VARCHAR(250) NULL,
ESTADO BIT DEFAULT (1)
)

--TABLA MODELO--
CREATE TABLE MODELO(
ID_MODELO INT PRIMARY KEY IDENTITY,
NOMBRE VARCHAR(50) NOT NULL UNIQUE,
DESCRIPCION VARCHAR(250) NULL,
ESTADO BIT DEFAULT (1)
)

--TABLA COLORES--
CREATE TABLE COLORES(
ID_COLORES INT PRIMARY KEY IDENTITY,
NOMBRE VARCHAR(50) NOT NULL UNIQUE,
DESCRIPCION VARCHAR(250) NULL,
ESTADO BIT DEFAULT (1)
)

-- TABLA ARTICULOS--
CREATE TABLE ARTICULOS (
ID_ARTICULO INT PRIMARY KEY IDENTITY,
ID_CATEGORIA INT NOT NULL,
ID_SUB_CATEGORIA INT NOT NULL,
ID_MARCA INT NOT NULL,
ID_MODELO INT NOT NULL,
ID_COLORES INT NOT NULL,
FOREIGN KEY (ID_CATEGORIA) REFERENCES CATEGORIA(ID_CATEGORIA) ,
FOREIGN KEY (ID_SUB_CATEGORIA) REFERENCES SUB_CATEGORIA(ID_SUB_CATEGORIA),
FOREIGN KEY (ID_MARCA) REFERENCES MARCA(ID_MARCA) ,
FOREIGN KEY (ID_MODELO) REFERENCES MODELO(ID_MODELO) ,
FOREIGN KEY (ID_COLORES) REFERENCES COLORES(ID_COLORES) ,
DESCRIPCION VARCHAR(250) NOT NULL UNIQUE,
ESTADO BIT DEFAULT(1),
OBSERVACIONES VARCHAR(250) NULL,
IMAGEN VARCHAR(20) NULL
);

SELECT * FROM ARTICULOS

-- CONDICIONES DEL EQUIPO --
CREATE TABLE CONDICION_EQUIPO(
ID_CONDICION_EQUIPO INT PRIMARY KEY IDENTITY,
CONDICION VARCHAR(50) NOT NULL UNIQUE,
DESCRIPCION VARCHAR(250) NULL,
ESTADO BIT DEFAULT (1)
)

-- DEPARTAMENTOS --
CREATE TABLE DEPARTAMENTO(
ID_DEPARTAMENTO INT PRIMARY KEY IDENTITY,
NOMBRE VARCHAR(100) NOT NULL UNIQUE,
DESCRIPCION VARCHAR(250) NULL,
ESTADO BIT DEFAULT (1)
)


-- ROL --
CREATE TABLE ROL(
ID_ROL INT PRIMARY KEY IDENTITY,
NOMBRE VARCHAR(100) NOT NULL UNIQUE,
DESCRIPCION VARCHAR(250) NULL,
ESTADO BIT DEFAULT (1)
)


-- EMPLEADO --
CREATE TABLE EMPLEADO(
ID_EMPLEADO INT PRIMARY KEY IDENTITY,
ID_DEPARTAMENTO INT NOT NULL,
ID_ROL INT NOT NULL,
FOREIGN KEY(ID_DEPARTAMENTO) REFERENCES DEPARTAMENTO(ID_DEPARTAMENTO),
NOMBRES VARCHAR(100) NOT NULL,
APELLIDOS VARCHAR(150) NOT NULL,
TIPO_DOCUMENTO VARCHAR(20) NULL,
NUMERO_DOCUMENTO VARCHAR(20) NULL,
CELULAR VARCHAR(20) NULL,
EMAIL VARCHAR(80) NULL,
CIUDAD_RESIDENCIA VARCHAR(50) NULL,
FOREIGN KEY(ID_ROL) REFERENCES ROL(ID_ROL),
OBSERVACIONES VARCHAR(250) NOT NULL
)

-- TABLA INVENTARIO --
CREATE TABLE INVENTARIO(
ID_EMPLEADO INT NOT NULL,
ID_ARTICULO INT NOT NULL,
ID_CONDICION_EQUIPO INT NOT NULL,
FOREIGN KEY(ID_EMPLEADO) REFERENCES EMPLEADO(ID_EMPLEADO),
FOREIGN KEY (ID_ARTICULO) REFERENCES ARTICULOS(ID_ARTICULO),
NUMERO_SERIAL VARCHAR(80) NULL,
NUMERO_INSTITUCIONAL VARCHAR(80) NULL,
FOREIGN KEY (ID_CONDICION_EQUIPO) REFERENCES CONDICION_EQUIPO(ID_CONDICION_EQUIPO),
FECHA VARCHAR(10) NULL,
INICIO_OPERATIVIDAD VARCHAR(10) NULL,
ULTIMA_REVISION VARCHAR(10) NULL,
OBSERVACIONES VARCHAR(200) NULL,
)

--TABLA USUARIO--
CREATE TABLE USUARIO(
ID_USUARIO INT PRIMARY KEY IDENTITY,
ID_ROL INT NOT NULL,
FOREIGN KEY(ID_ROL) REFERENCES ROL(ID_ROL),
NOMBRES VARCHAR (100) NOT NULL,
TIPO_DOCUMENTO VARCHAR(20) NULL,
NUM_DOCUMENTO VARCHAR(20) NULL,
CIUDAD VARCHAR(70) NULL,
CELULAR VARCHAR(20) NULL,
EMAIL VARCHAR(100) NULL,
CLAVE VARBINARY(MAX) NOT NULL,
ESTADO BIT DEFAULT(1),

)

-- TABLA PROVEEDOR--
CREATE TABLE PROVEEDOR(
ID_PROVEEDOR INT PRIMARY KEY IDENTITY,
NOMBRES VARCHAR(100) NOT NULL,
APELLIDOS VARCHAR(150) NOT NULL,
TIPO_DOCUMENTO VARCHAR(20) NULL,
NUMERO_DOCUMENTO VARCHAR(20) NULL,
CELULAR VARCHAR(20) NULL,
EMAIL VARCHAR(80) NULL,
CIUDAD_RESIDENCIA VARCHAR(50) NULL,
OBSERVACIONES VARCHAR(250) NOT NULL
)

CREATE TABLE INGRESO(
ID_INGRESO INT PRIMARY KEY IDENTITY,
ID_PROVEEDOR INT NOT NULL,
ID_USUARIO INT NOT NULL,
TIPO_COMPROBANTE VARCHAR(20) NOT NULL,
SERIE_COMPROBANTE VARCHAR(20)  NULL,
NUM_COMPROBANTE VARCHAR(20) NOT NULL,
FECHA DATETIME NOT NULL,
IMPUESTO DECIMAL (4,2) NOT NULL,
TOTAL DECIMAL(11,2) NOT NULL,
ESTADO VARCHAR(20) NOT NULL,
FOREIGN KEY (ID_PROVEEDOR) REFERENCES PROVEEDOR(ID_PROVEEDOR),
FOREIGN KEY (ID_USUARIO) REFERENCES USUARIO(ID_USUARIO),
);

CREATE TABLE DETALLE_INGRESO(
	ID_DETALLE_INGRESO INT PRIMARY KEY IDENTITY,
	ID_INGRESO INT NOT NULL,
	ID_ARTICULO INT NOT NULL,
	CANTIDAD INT NOT NULL,
	PRECIO DECIMAL(11,2) NOT NULL,
	FOREIGN KEY (ID_INGRESO) REFERENCES INGRESO(ID_INGRESO) ON DELETE CASCADE,
	FOREIGN KEY (ID_ARTICULO) REFERENCES ARTICULOS(ID_ARTICULO),
)

-------------------------------------------------------------------------------------------------------------------
												-- PROCEDIMIENTOS ALMACENADOS --
-- CATEGORIA Listar --
CREATE PROC categoria_listar
as
select ID_CATEGORIA AS ID, NOMBRE , DESCRIPCION, ESTADO FROM CATEGORIA
ORDER BY ID_CATEGORIA DESC
go

-- CATEGORIA BUSCAR --
CREATE PROC categoria_buscar
@VALOR VARCHAR(50)
as
select ID_CATEGORIA AS ID, NOMBRE , DESCRIPCION, ESTADO FROM CATEGORIA 
WHERE NOMBRE LIKE '%' + @VALOR +'%' OR  DESCRIPCION LIKE '%' + @VALOR+'%'
ORDER BY NOMBRE DESC
go

-- CATEGORIA INSERTAR --
CREATE PROC categoria_insertar
@NOMBRE VARCHAR(50),
@DESCRIPCION VARCHAR(250)
AS
INSERT INTO CATEGORIA (NOMBRE,DESCRIPCION) VALUES (@NOMBRE,@DESCRIPCION)
GO

-- CATEGORIA ACTUALIZAR --
CREATE PROC categoria_actualizar
@ID_CATEGORIA INT,
@NOMBRE VARCHAR(50),
@DESCRIPCION VARCHAR(250)
AS
UPDATE CATEGORIA SET NOMBRE=@NOMBRE, DESCRIPCION=@DESCRIPCION 
WHERE ID_CATEGORIA=@ID_CATEGORIA
GO
-- CATEGORIA ELIMINAR --
CREATE PROC categoria_eliminar
@ID_CATEGORIA INT
AS
DELETE FROM CATEGORIA WHERE ID_CATEGORIA=@ID_CATEGORIA
GO
---- CATEGORIA DESACTIVAR --
CREATE PROC categoria_desactivar
@ID_CATEGORIA INT
AS
UPDATE CATEGORIA SET ESTADO=0 WHERE ID_CATEGORIA = @ID_CATEGORIA

---- CATEGORIA ACTIVAR --
CREATE PROC categoria_activar
@ID_CATEGORIA INT
AS
UPDATE CATEGORIA SET ESTADO=1 WHERE ID_CATEGORIA = @ID_CATEGORIA


-------------------------------------------------------------------------------------------------------------------
												-- PROCEDIMIENTOS ALMACENADOS --
-- SUBCATEGORIA Listar --
CREATE PROC SUBCATEGORIA_LISTAR
as
select ID_SUB_CATEGORIA AS ID, NOMBRE , DESCRIPCION, ESTADO FROM SUB_CATEGORIA
ORDER BY ID_SUB_CATEGORIA DESC
go

-- SUBCATEGORIA BUSCAR --
CREATE PROC SUBCATEGORIA_BUSCAR
@VALOR VARCHAR(50)
as
select ID_SUB_CATEGORIA AS ID, NOMBRE , DESCRIPCION, ESTADO FROM SUB_CATEGORIA 
WHERE NOMBRE LIKE '%' + @VALOR +'%' OR  DESCRIPCION LIKE '%' + @VALOR+'%'
ORDER BY NOMBRE DESC
go

-- SUBCATEGORIA INSERTAR --
CREATE PROC SUBCATEGORIA_INSERTAR
@NOMBRE VARCHAR(50),
@DESCRIPCION VARCHAR(250)
AS
INSERT INTO SUBSUB_CATEGORIA (NOMBRE,DESCRIPCION) VALUES (@NOMBRE,@DESCRIPCION)
GO

-- SUBCATEGORIA ACTUALIZAR --
CREATE PROC SUBCATEGORIA_ACTUALIZAR
@ID_SUB_CATEGORIA INT,
@NOMBRE VARCHAR(50),
@DESCRIPCION VARCHAR(250)
AS
UPDATE SUB_CATEGORIA SET NOMBRE=@NOMBRE, DESCRIPCION=@DESCRIPCION 
WHERE ID_SUB_CATEGORIA=@ID_SUB_CATEGORIA
GO
-- SUBCATEGORIA ELIMINAR --
CREATE PROC SUBCATEGORIA_ELIMINAR
@ID_SUB_CATEGORIA INT
AS
DELETE FROM SUB_CATEGORIA WHERE ID_SUB_CATEGORIA=@ID_SUB_CATEGORIA
GO
---- SUBCATEGORIA DESACTIVAR --
CREATE PROC SUBCATEGORIA_DESACTIVAR
@ID_SUB_CATEGORIA INT
AS
UPDATE SUB_CATEGORIA SET ESTADO=0 WHERE ID_SUB_CATEGORIA = @ID_SUB_CATEGORIA

---- SUBCATEGORIA ACTIVAR --
CREATE PROC SUBCATEGORIA_ACTIVAR
@ID_SUB_CATEGORIA INT
AS
UPDATE SUB_CATEGORIA SET ESTADO=1 WHERE ID_SUB_CATEGORIA = @ID_SUB_CATEGORIA


-------------------------------------------------------------------------------------------------------------------
												-- PROCEDIMIENTOS ALMACENADOS MARCA--
-- MARCA Listar --
CREATE PROC MARCA_LISTAR
as
select ID_MARCA AS ID, NOMBRE , DESCRIPCION, ESTADO FROM MARCA
ORDER BY ID_MARCA DESC
go

-- MARCA BUSCAR --
CREATE PROC MARCA_BUSCAR
@VALOR VARCHAR(50)
as
select ID_MARCA AS ID, NOMBRE , DESCRIPCION, ESTADO FROM MARCA 
WHERE NOMBRE LIKE '%' + @VALOR +'%' OR  DESCRIPCION LIKE '%' + @VALOR+'%'
ORDER BY NOMBRE DESC
go

-- MARCA INSERTAR --
CREATE PROC MARCA_INSERTAR
@NOMBRE VARCHAR(50),
@DESCRIPCION VARCHAR(250)
AS
INSERT INTO MARCA (NOMBRE,DESCRIPCION) VALUES (@NOMBRE,@DESCRIPCION)
GO

-- MARCA ACTUALIZAR --
CREATE PROC MARCA_ACTUALIZAR
@ID_MARCA INT,
@NOMBRE VARCHAR(50),
@DESCRIPCION VARCHAR(250)
AS
UPDATE MARCA SET NOMBRE=@NOMBRE, DESCRIPCION=@DESCRIPCION 
WHERE ID_MARCA=@ID_MARCA
GO
-- MARCA ELIMINAR --
CREATE PROC MARCA_ELIMINAR
@ID_MARCA INT
AS
DELETE FROM MARCA WHERE ID_MARCA=@ID_MARCA
GO
---- MARCA DESACTIVAR --
CREATE PROC MARCA_DESACTIVAR
@ID_MARCA INT
AS
UPDATE MARCA SET ESTADO=0 WHERE ID_MARCA = @ID_MARCA

---- MARCA ACTIVAR --
CREATE PROC MARCA_ACTIVAR
@ID_MARCA INT
AS
UPDATE MARCA SET ESTADO=1 WHERE ID_MARCA = @ID_MARCA

-------------------------------------------------------------------------------------------------------------------
												-- PROCEDIMIENTOS ALMACENADOS MODELO--
-- MODELO Listar --
CREATE PROC MODELO_LISTAR
as
select ID_MODELO AS ID, NOMBRE , DESCRIPCION, ESTADO FROM MODELO
ORDER BY ID_MODELO DESC
go

-- MODELO BUSCAR --
CREATE PROC MODELO_BUSCAR
@VALOR VARCHAR(50)
as
select ID_MODELO AS ID, NOMBRE , DESCRIPCION, ESTADO FROM MODELO 
WHERE NOMBRE LIKE '%' + @VALOR +'%' OR  DESCRIPCION LIKE '%' + @VALOR+'%'
ORDER BY NOMBRE DESC
go

-- MODELO INSERTAR --
CREATE PROC MODELO_INSERTAR
@NOMBRE VARCHAR(50),
@DESCRIPCION VARCHAR(250)
AS
INSERT INTO MOMODELO(NOMBRE,DESCRIPCION) VALUES (@NOMBRE,@DESCRIPCION)
GO

-- MODELO ACTUALIZAR --
CREATE PROC MODELO_ACTUALIZAR
@ID_MODELO INT,
@NOMBRE VARCHAR(50),
@DESCRIPCION VARCHAR(250)
AS
UPDATE MODELO SET NOMBRE=@NOMBRE, DESCRIPCION=@DESCRIPCION 
WHERE ID_MODELO=@ID_MODELO
GO
-- MODELO ELIMINAR --
CREATE PROC MODELO_ELIMINAR
@ID_MODELO INT
AS
DELETE FROM MODELO WHERE ID_MODELO=@ID_MODELO
GO
---- MODELO DESACTIVAR --
CREATE PROC MODELO_DESACTIVAR
@ID_MODELO INT
AS
UPDATE MODELO SET ESTADO=0 WHERE ID_MODELO = @ID_MODELO

---- MODELO ACTIVAR --
CREATE PROC MODELO_ACTIVAR
@ID_MODELO INT
AS
UPDATE MODELO SET ESTADO=1 WHERE ID_MODELO = @ID_MODELO


-------------------------------------------------------------------------------------------------------------------
												-- PROCEDIMIENTOS ALMACENADOS COLORES--
-- COLORES Listar --
CREATE PROC COLORES_LISTAR
as
select ID_COLORES AS ID, NOMBRE , DESCRIPCION, ESTADO FROM COLORES
ORDER BY ID_COLORES DESC
go

-- COLORES BUSCAR --
CREATE PROC COLORES_BUSCAR
@VALOR VARCHAR(50)
as
select ID_COLORES AS ID, NOMBRE , DESCRIPCION, ESTADO FROM COLORES 
WHERE NOMBRE LIKE '%' + @VALOR +'%' OR  DESCRIPCION LIKE '%' + @VALOR+'%'
ORDER BY NOMBRE DESC
go

-- COLORES INSERTAR --
CREATE PROC COLORES_INSERTAR
@NOMBRE VARCHAR(50),
@DESCRIPCION VARCHAR(250)
AS
INSERT INTO COLORES(NOMBRE,DESCRIPCION) VALUES (@NOMBRE,@DESCRIPCION)
GO

-- COLORES ACTUALIZAR --
CREATE PROC COLORES_ACTUALIZAR
@ID_COLORES INT,
@NOMBRE VARCHAR(50),
@DESCRIPCION VARCHAR(250)
AS
UPDATE COLORES SET NOMBRE=@NOMBRE, DESCRIPCION=@DESCRIPCION 
WHERE ID_COLORES=@ID_COLORES
GO
-- COLORES ELIMINAR --
CREATE PROC COLORES_ELIMINAR
@ID_COLORES INT
AS
DELETE FROM COLORES WHERE ID_COLORES=@ID_COLORES
GO
---- COLORES DESACTIVAR --
CREATE PROC COLORES_DESACTIVAR
@ID_COLORES INT
AS
UPDATE COLORES SET ESTADO=0 WHERE ID_COLORES = @ID_COLORES

---- COLORES ACTIVAR --
CREATE PROC COLORES_ACTIVAR
@ID_COLORES INT
AS
UPDATE COLORES SET ESTADO=1 WHERE ID_COLORES = @ID_COLORES
-------------------------------------------------------------------------------------------------------------------

