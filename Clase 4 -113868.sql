use libreria_113868
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
select v.cod_vendedor, sum (d.cantidad*d.pre_unitario) 'total'
from facturas f 
join detalle_facturas d on d.nro_factura = f.nro_factura
join vendedores v on v.cod_vendedor = f.cod_vendedor

group by v.cod_vendedor

---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------

--2. Por cada factura emitida mostrar la cantidad total de artículos vendidos (suma de las cantidades vendidas), la cantidad ítems que tiene cada
--factura en el detalle (cantidad de registros de detalles) y el Importe total de la facturación de este año


SELECT SUM(cantidad) ' CANTIDAD DE ART', COUNT (F.nro_factura) 'CANT ITEMS',  sum(df.cantidad*df.pre_unitario)  ' IMPORTE TOTAL'
from facturas f
join detalle_facturas df on df.nro_factura = f.nro_factura
WHERE YEAR (FECHA) = YEAR (GETDATE()) 


---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
--3. Se quiere saber en este negocio, cuánto se factura:
--a. Diariamente

select  DAY(MAX(FECHA)), SUM (df.cantidad*df.pre_unitario) ' TOTAL'
from facturas f
join detalle_facturas df on df.nro_factura = f.nro_factura
WHERE DAY(FECHA) = GETDATE()
group by f.fecha
--------------------------------
SELECT FECHA
FROM facturas
WHERE FECHA BETWEEN '01/08/2022' AND '26/08/2022'
---------------------------------------------------


--b. Mensualmente
SELECT MONTH(MAX(FECHA)), sum(df.cantidad*df.pre_unitario) ' TOTAL'
from facturas F
join detalle_facturas df on df.nro_factura = f.nro_factura
WHERE MONTH (F.FECHA) = MONTH (GETDATE())
--group by MONTH(FECHA)

--c. Anualmente

SELECT YEAR(MAX(FECHA))'FECHA' ,sum(df.cantidad*df.pre_unitario) ' TOTAL'
from facturas F
join detalle_facturas df on df.nro_factura = f.nro_factura
WHERE YEAR(F.FECHA) = YEAR (GETDATE())

--GROUP BY YEAR(fecha)
ORDER BY 1

----------------------------------------------------------------------------------------
--CUAL FUE EL MONTO VENDIDO POR CADA VENDEDOR A CADA CLIENTE EL AÑO PASADO
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------


SELECT V.nom_vendedor 'NOMBRE VENDEDOR', sum(d.cantidad*d.pre_unitario) ' TOTAL', C.nom_cliente+ '  ' + C.ape_cliente
from facturas f 
join detalle_facturas d on d.nro_factura = f.nro_factura
join vendedores v on v.cod_vendedor = f.cod_vendedor
JOIN clientes C ON C.cod_cliente = F.cod_cliente

WHERE DATEDIFF ( YEAR, F.FECHA, GETDATE())= 1 -- YEAR(FECHA) = YEAR (GETDATE())-1
GROUP BY V.nom_vendedor,C.nom_cliente, C.ape_cliente

------------------- EJEMPLO HAVING ---------------------------
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------

SELECT F.nro_factura, sum(cantidad*pre_unitario) ' TOTAL'
FROM FACTURAS F
JOIN detalle_facturas DF ON F.nro_factura = DF.nro_factura
GROUP BY F.nro_factura

HAVING sum(cantidad*pre_unitario) BETWEEN 25 AND 890
ORDER BY 2
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
-------------------- 
-- QUE VENDEDORES VENDIERON MENOS DE $20.000 EN TOTAL, ESTE AÑO  Y CUAL ES EL MONTO

SELECT V.nom_vendedor 'NOMBRE VENDEDOR', sum(d.cantidad*d.pre_unitario) ' TOTAL'
from facturas f 
join detalle_facturas d on d.nro_factura = f.nro_factura
join vendedores v on v.cod_vendedor = f.cod_vendedor
WHERE YEAR (FECHA) = YEAR (GETDATE()) 

GROUP BY V.nom_vendedor
HAVING sum(d.cantidad*d.pre_unitario) > 20000 -- MENOR NO HAY 

-- ESTE ANO Y EL ANTERIOR 

SELECT V.nom_vendedor 'NOMBRE VENDEDOR', sum(d.cantidad*d.pre_unitario) ' TOTAL'
from facturas f 
join detalle_facturas d on d.nro_factura = f.nro_factura
join vendedores v on v.cod_vendedor = f.cod_vendedor
WHERE YEAR (FECHA) = YEAR (GETDATE()) 

GROUP BY V.nom_vendedor
HAVING sum(d.cantidad*d.pre_unitario) < 135000 -- MENOR NO HAY 
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
--4. Emitir un listado de la cantidad de facturas confeccionadas diariamente,
--correspondiente a los meses que no sean enero, julio ni diciembre.
--Ordene por la cantidad de facturas en forma descendente y fecha.
SELECT FECHA ' FEHCA FACTURA', COUNT( F.nro_factura) 'CANTIDAD FAC'
from facturas f 
join detalle_facturas d on d.nro_factura = f.nro_factura
WHERE MONTH(F.FECHA) NOT IN (1,7,12)
GROUP BY fecha,F.nro_factura
ORDER BY F.nro_factura DESC

-- 2021 
SELECT FECHA ' FEHCA FACTURA', COUNT( F.nro_factura) 'CANTIDAD FAC'
from facturas f 
join detalle_facturas d on d.nro_factura = f.nro_factura
WHERE MONTH(F.FECHA) NOT IN (1,7,12) and year(f.fecha)=2021
GROUP BY fecha,F.nro_factura
ORDER BY F.nro_factura DESC




---------------------------------listados de art cuyos precios son menores al promedio------------------------------------------------------------
select descripcion, observaciones 
from articulos
where pre_unitario < (select avg(pre_unitario) from articulos)


-- guia 1 pag 4 eje 2

--Se quiere saber qué vendedores y clientes hay en la empresa; para los casos en que su teléfono y dirección de e-mail sean conocidos. Se deberá visualizar el
--código, nombre y si se trata de un cliente o de un vendedor. Ordene por la columna tercera y segunda.

select cod_cliente 'codigo', nom_cliente + ' , ' + ape_cliente 'nombre', 'clientes' tipo
from clientes
where nro_tel is not null  and [e-mail] is not null
union
select cod_vendedor 'codigo' , nom_vendedor + ' , ' + ape_vendedor 'nombre', 'vendedor' 
from vendedores
where nro_tel is not null  and [e-mail] is not null
order by 3,2

------------------------------------ TEST DE PERTENENCIA  IN  valor que pertenece a un conjunto ---------------------------------------------------

--Listar los datos de los clientes que compraron este año:
SELECT *
FROM clientes
WHERE cod_cliente IN (SELECT cod_cliente                       FROM facturas 					  WHERE YEAR(fecha) = YEAR(GETDATE()))-- listar los datos de los clientes que no compraron el año pasado.select cod_cliente codigo, ape_cliente + ','+ nom_clientefrom clienteswhere cod_cliente not in (select cod_cliente                           from facturas 						  where year(fecha) = year (getdate()) - 1)---------------------------------------- TEST DE EXISTENCIA (MUY SIMILAR A IN)  EXISTS UN VALOR CUMPLE CON UNA CCONDICION ----------------------------------------------------------Listar los datos de los clientes que compraron este añoSELECT cod_cliente Código, ape_cliente +' '+ nom_cliente Nombre
 FROM clientes c
WHERE EXISTS (SELECT cod_cliente -- subconsulta
              FROM facturas f
              WHERE c.cod_cliente = f.cod_cliente
              AND YEAR(fecha) = YEAR(GETDATE())
)-- Listar los datos de los clientes que no compraron el año pasadoSELECT cod_cliente Código, ape_cliente +' '+ nom_cliente Nombre
 FROM clientes c
WHERE NOT EXISTS (SELECT cod_cliente
                  FROM facturas f
                  WHERE c.cod_cliente = f.cod_cliente
                  AND YEAR(fecha) = YEAR(GETDATE()) -1
)---------------------------------------------TEST CUANTIFICADOS -------------------------------------------------  ANY ALGUNOS //  ALL TODOS Comprubea que todas la comparaciones sean verdaderas-- Listar los clientes que alguna vez compraron un producto menor a $ 10.-  // ANYSELECT cod_cliente Código, ape_cliente +' '+ nom_cliente Nombre
 FROM clientes c where 10 > any (select pre_unitario                 from facturas f join detalle_facturas df on df.nro_factura = f.nro_factura 			     where c.cod_cliente = f.cod_cliente)-- Listar los clientes que siempre fueron atendidos por el vendedor 3select cod_cliente codigo, ape_cliente + ' , ' + nom_cliente nombrefrom clientes cwhere 3 = all ( select cod_vendedor                from facturas f				where c.cod_cliente = f.cod_cliente)---------------------------------------------------------------- GUIA 2 EJE 2----------------------------------- CORRECTOSELECT   A.cod_articulo ' CODIGO',  A.pre_unitario, descripcionFROM articulos AWHERE A.pre_unitario BETWEEN 50 AND 100AND A.cod_articulo NOT IN (SELECT cod_articulo                           FROM Detalle_facturas df JOIN FACTURAS F  ON F.nro_factura = DF.nro_factura						   WHERE YEAR (F.FECHA) = YEAR( GETDATE()))-- Emitir un listado de los artículos que no fueron vendidos este año. En ese listado solo incluir aquellos cuyo precio unitario del artículo oscile entre 50 y 100. --SELECT   A.cod_articulo ' CODIGO', observaciones 'OBSERVACIONES', A.pre_unitario--FROM articulos A--WHERE cod_articulo IN( SELECT DF.cod_articulo	--                       FROM detalle_facturas df JOIN FACTURAS F  ON F.nro_factura = DF.nro_factura--					   WHERE YEAR (F.FECHA) != YEAR( GETDATE()) AND A.pre_unitario BETWEEN 50 AND 100)--MALLL ----- SELECT  DISTINCT A.cod_articulo ' CODIGO', observaciones 'OBSERVACIONES', A.pre_unitario, FECHA	--FROM articulos A--JOIN detalle_facturas df on df.cod_articulo = A.cod_articulo --JOIN facturas F ON F.nro_factura = DF.nro_factura--WHERE F.nro_factura NOT IN (SELECT nro_factura FROM FACTURAS WHERE YEAR(FECHA) = YEAR(GETDATE()))--AND A.pre_unitario BETWEEN 50 AND 100 --------------- eje 3-- Genere un reporte con los clientes que vinieron más de 2 veces el año pasado.select cod_cliente codigo, ape_cliente + ' , ' + nom_cliente nombrefrom clientes cwhere c.cod_cliente in ( select cod_cliente from facturas f join detalle_facturas df on F.nro_factura = DF.nro_facturawhere year (fecha) = year (getdate()) -1 group by 