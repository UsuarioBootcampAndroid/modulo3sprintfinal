CREATE USER telovendouser IDENTIFIED BY '123456';
GRANT ALL PRIVILEGES ON * . * TO 'telovendouser';
CREATE SCHEMA `telovendoschema` ;
CREATE TABLE telovendoschema.Vendedor(
	idVendedor INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(200) NOT NULL,
    apellidos VARCHAR(200) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    seccion INTEGER NOT NULL,
    salario INTEGER NOT NULL
);
CREATE TABLE telovendoschema.Vendedor_Cliente(
	idVendedor INT UNSIGNED NOT NULL,
	idCliente INT UNSIGNED NOT NULL
);
CREATE TABLE telovendoschema.Cliente (
    idCliente INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(200) NOT NULL,
    apellidos VARCHAR(200) NOT NULL,
    telefono VARCHAR(200) NOT NULL,
    direccion VARCHAR(200) NOT NULL,
    comuna VARCHAR(200) NOT NULL,
    correo VARCHAR(200) NOT NULL,
    fecha_registro DATETIME NOT NULL,
    total_pagado INTEGER NOT NULL
);
ALTER TABLE telovendoschema.Vendedor_Cliente ADD CONSTRAINT fk_vendedor_cliente FOREIGN KEY (idVendedor) REFERENCES telovendoschema.Vendedor (idVendedor);
ALTER TABLE telovendoschema.Vendedor_Cliente ADD CONSTRAINT fk_cliente_vendedor FOREIGN KEY (idCliente) REFERENCES telovendoschema.Cliente (idCliente);
CREATE TABLE telovendoschema.Pedido(
	idPedido INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    boleta VARCHAR(100),
    fecha_compra TIMESTAMP(6),
    monto_compra INTEGER
);
CREATE TABLE telovendoschema.Pedido_Producto(
	idPedido INT UNSIGNED NOT NULL,
	idProducto INT UNSIGNED NOT NULL
);
CREATE TABLE telovendoschema.Producto(
	idProducto INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    sku  INTEGER NOT NULL, 
    nombre VARCHAR(200) NOT NULL,
    categoria INTEGER NOT NULL, 
    proveedor VARCHAR(100) NOT NULL,
    stock INTEGER NOT NULL, 
    precio INTEGER NOT NULL,
    color VARCHAR(50) NOT NULL
);
ALTER TABLE telovendoschema.Pedido_Producto ADD CONSTRAINT fk_pedido_producto FOREIGN KEY (idPedido) REFERENCES telovendoschema.Pedido (idPedido);
ALTER TABLE telovendoschema.Pedido_Producto ADD CONSTRAINT fk_producto_pedido FOREIGN KEY (idProducto) REFERENCES telovendoschema.Producto (idProducto);
CREATE TABLE telovendoschema.Producto_Proveedor(
	idProducto INT UNSIGNED NOT NULL,
	idProveedor INT UNSIGNED NOT NULL	
);
CREATE TABLE telovendoschema.Proveedor(
	idProveedor INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    representante_legal VARCHAR(200) NOT NULL,
    corporativo VARCHAR(200) NOT NULL,
    telefono_uno VARCHAR(15) NOT NULL,
    telefono_dos VARCHAR(15) NOT NULL,
    recepcionista VARCHAR(200) NOT NULL,
    categoria_productos INT NOT NULL,
    correo VARCHAR(200) NOT NULL
);
ALTER TABLE telovendoschema.Producto_Proveedor ADD CONSTRAINT fk_producto_proveedor FOREIGN KEY (idProducto) REFERENCES telovendoschema.Producto (idProducto);
ALTER TABLE telovendoschema.Producto_Proveedor ADD CONSTRAINT fk_proveedor_producto FOREIGN KEY (idProveedor) REFERENCES telovendoschema.Proveedor (idProveedor);
ALTER TABLE telovendoschema.Pedido ADD CONSTRAINT fk_pedido_vendedor FOREIGN KEY (idPedido) REFERENCES telovendoschema.Vendedor (idVendedor);
/*Los alcances siguientes podrían tener sentido en la holgura que permita el mismo ejercicio solicitado, pero es más sensato otro tipo de control*/
ALTER TABLE telovendoschema.Cliente ADD UNIQUE (direccion);/*¿Qué pasaría en el modelo si, en dicha dirección se registra otro cliente?*/
/*ALTER TABLE telovendoschema.Proveedor ADD UNIQUE (categoria_productos);*//*¿Qué pasaría en el modelo si, otro proveedor tiene la misma categoría?*/
/*Otra opción de mejora en este punto del análisis es considerar una tabla nueva que aparte la categoría en si misma, ya que en producto y en proveedor, está actualmente 
definido la categoría*/
/*Se considera que, la asignación de UNIQUE a dirección si es válida, ya que en el sistema, si otra persona quisiera comprar en TELOVENDO, bastaría que usara los datos 
del cliente registrado, ahora bien, si hay otro adulto en el lugar y quiere registrarse en el sistema con la misma dirección, actualmente podría sobreescribirse con INSERT 
IGNORE pero en proveedor, definir UNIQUE a categoria_productos, es un bloqueante para otro proveedor que quiera entregar productos de la misma categoría, solo podría darse 
el escenario que un proveedor entrega productos de una única categoría que no entrega cualquier otro proveedor distinto de él, pero en la oración "... sabemos que la 
mayoría de los proveedores son de productos electrónicos... " no podría entenderse tan fácilmente, el hecho de que simplemente, la categoría "electrónico" exista solo una 
vez en la tabla proveedor, siendo así, en el caso de los proveedores, podría considerarse un método más acabado en tanto de la restricción dada en la sentencia (fragmento) 
"... la categoría de sus productos (solo nos pueden indicar una categoría)... ", aquí se lee mejor que puede en la tabla existir una categoría ingresada más de una vez, 
pero, un proveedor por regla de negocio, no puede registrarse con más de una categoría (quizás en un modelo mejorado bajo otros requrimientos, exista una tabla categoría)
*/
/*Un alcance para solucionar esto, podría darse al construir un procedimiento almacenado que reciba la categoría del producto y el proveedor en cuestión (idProveedor), luego 
que cada vez y antes de, un INSERT INTO en la misma tabla proveedor, verifique si, existe tal proveedor, y si existe, sobre escriba la categoría, o visto de otra manera, 
bastaría con que se disponga la restricción con UNIQUE en el proveedor en si mismo, ya que si, un proveedor solo puede tener una categoría, basta con decir que un proveedor, 
solo puede insertarse una vez, obligando que solo tenga una categoría de producto, pero no obligando que algún otro proveedor, tenga la misma categoría que él, ya que dicha 
columna es no nula en su diseño base. Por esto, la restricción UNIQUE si se asigna al correo, es estratégicamente correcto, implicando en ese diseño, a la categoría del 
producto y descartando la necesidad de rendimiento y exigencia mayores, al llamar al procedimiento almacenado cada vez se quiera una inserción en la tabla proveedor*/
ALTER TABLE telovendoschema.Proveedor ADD UNIQUE (correo);
SELECT * FROM telovendoschema.cliente;
INSERT INTO telovendoschema.cliente VALUES (1, 'Nombre 001', 'Apellidos 001', '+569876544321', 'Dirección 001', 'Comuna 001', 'correo@correo.com', NOW(), 100000);
/*INSERT INTO telovendoschema.cliente VALUES (2, 'Nombre 002', 'Apellidos 002', '+569876544321', 'Dirección 001', 'Comuna 002', 'correo@correo.com', NOW(), 150000);*/
INSERT INTO telovendoschema.cliente VALUES (2, 'Nombre 002', 'Apellidos 002', '+569876544321', 'Dirección 002', 'Comuna 002', 'correo@correo.com', NOW(), 150000);
INSERT INTO telovendoschema.cliente VALUES (3, 'Nombre 003', 'Apellidos 003', '+569876544321', 'Dirección 003', 'Comuna 003', 'correo@correo.com', NOW(), 95000);
INSERT INTO telovendoschema.cliente VALUES (4, 'Nombre 004', 'Apellidos 004', '+569876544321', 'Dirección 004', 'Comuna 004', 'correo@correo.com', NOW(), 85000);
INSERT INTO telovendoschema.cliente VALUES (5, 'Nombre 005', 'Apellidos 005', '+569876544321', 'Dirección 005', 'Comuna 005', 'correo@correo.com', NOW(), 175000);
SELECT * FROM telovendoschema.proveedor;INSERT INTO telovendoschema.proveedor VALUES (1, 'Representante 001', 'Coporativo 001', '+56987654321', '+569123456789', 'Recepcionista 001', 1, 'correo@correo.com');
/*INSERT INTO telovendoschema.proveedor VALUES (2, 'Representante 002', 'Coporativo 002', '+56987654321', '+569123456789', 'Recepcionista 002', 1, 'correo@correo.com');*/
INSERT INTO telovendoschema.proveedor VALUES (2, 'Representante 002', 'Coporativo 002', '+56987654321', '+569123456789', 'Recepcionista 002', 1, 'correo2@correo.com');
INSERT INTO telovendoschema.proveedor VALUES (3, 'Representante 003', 'Coporativo 003', '+56987654321', '+569123456789', 'Recepcionista 003', 1, 'correo3@correo.com');
INSERT INTO telovendoschema.proveedor VALUES (4, 'Representante 004', 'Coporativo 004', '+56987654321', '+569123456789', 'Recepcionista 004', 2, 'correo4@correo.com');
INSERT INTO telovendoschema.proveedor VALUES (5, 'Representante 005', 'Coporativo 005', '+56987654321', '+569123456789', 'Recepcionista 005', 3, 'correo5@correo.com');
SELECT * FROM telovendoschema.producto;
INSERT INTO telovendoschema.producto VALUES (1, 123456, 'Producto 001', 1, 'Representante 001', 1000, 10000, 'color 001');
INSERT INTO telovendoschema.producto VALUES (2, 123456, 'Producto 002', 1, 'Representante 002', 850, 15000, 'color 002');
INSERT INTO telovendoschema.producto VALUES (3, 123456, 'Producto 003', 1, 'Representante 003', 1500, 13550, 'color 003');
INSERT INTO telovendoschema.producto VALUES (4, 123456, 'Producto 004', 2, 'Representante 004', 1350, 9500, 'color 004');
INSERT INTO telovendoschema.producto VALUES (5, 123456, 'Producto 005', 1, 'Representante 003', 650, 14000, 'color 005');
INSERT INTO telovendoschema.producto VALUES (6, 123456, 'Producto 006', 2, 'Representante 004', 2200, 8750, 'color 006');
INSERT INTO telovendoschema.producto VALUES (7, 123456, 'Producto 007', 3, 'Representante 001', 1100, 12250, 'color 007');
INSERT INTO telovendoschema.producto VALUES (8, 123456, 'Producto 008', 2, 'Representante 004', 900, 9950, 'color 008');
INSERT INTO telovendoschema.producto VALUES (9, 123456, 'Producto 009', 3, 'Representante 001', 3500, 6750, 'color 009');
INSERT INTO telovendoschema.producto VALUES (10, 123456, 'Producto 010', 1, 'Representante 003', 2750, 18850, 'color 001');
/*Lista los productos con la categoría y las veces de esa categoría*/
SELECT 
	DISTINCT(prod.nombre) AS Producto, prod.categoria AS Categoria, COUNT(prod.categoria) AS Veces
FROM 
	telovendoschema.producto prd 
INNER JOIN 
	telovendoschema.producto prod 
ON 
	prd.categoria = prod.categoria
WHERE
	prod.nombre IS NOT NULL
GROUP BY
	prod.nombre, prod.categoria
ORDER BY
	Veces
DESC;
/*Lista la categoría que se repite más veces y cuántas veces está en la tabla repetida dicha categoría*/
SELECT 
	prod.categoria AS Categoria, COUNT(prod.categoria) AS Veces
FROM 
	telovendoschema.producto prd 
INNER JOIN 
	telovendoschema.producto prod 
ON 
	prd.categoria = prod.categoria
WHERE
	prod.nombre IS NOT NULL
GROUP BY
	prod.nombre, prod.categoria
ORDER BY
	Veces
DESC
LIMIT 1;
/*Productos con mayor stock*/
SELECT 
	prod.idProducto, 
    prod.sku, 
    prod.nombre, 
    prod.categoria, 
    prod.proveedor, 
    prod.stock, 
    prod.precio, 
    prod.color 
FROM 
	telovendoschema.producto prod 
WHERE 
	stock = (SELECT MAX(prd.stock) FROM telovendoschema.producto prd);
/*Color más común en producto(s)*/
SELECT 
	DISTINCT(prod.color) AS Color, COUNT(prod.color) AS Veces_Color
FROM 
	telovendoschema.producto prd 
INNER JOIN 
	telovendoschema.producto prod 
ON 
	prd.color = prod.color
WHERE
	prod.nombre IS NOT NULL
GROUP BY
	prod.nombre, prod.color
ORDER BY
	Veces_Color
DESC
LIMIT 1;
/*Proveedores con menos stock de productos*/
SELECT 
	prov.representante_legal AS Proveedor, prod.stock AS Stock
FROM 
	telovendoschema.proveedor prov
INNER JOIN 
	telovendoschema.producto prod
ON
	prov.representante_legal = prod.proveedor
ORDER BY
	prod.stock
ASC;
/*Cambiar categoría de producto más popular por "Electrónica y Computación"*/
/*Nota, en el modelo implementado, no se pensó la columna categoría en la tabla producto, como un varchar, con lo que la solicitud de este punto no se puede realizar
,pero queda abierta la posibilidad de en el caso que el sistema implique dar un nombre a la categoría, crear una tabla categoría en donde puedan añadirse ciertos otros 
atributos como nombre, descripción y otras relaciones propias de tal contexto*/