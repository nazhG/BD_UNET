/** TEMA 6 - NAZHIR GONZALEZ */

--2.1
/* SELECT CODART, PRECIO*2 FROM ARTICULOS WHERE PRECIO < 5; */

--2.2
/*SELECT 
    facturas.codfac, 
    lineas_fac.codart, 
    lineas_fac.codart 
FROM facturas 
JOIN lineas_fac ON lineas_fac.codfac = facturas.codfac 
WHERE lineas_fac.cant < 2 AND facturas.dto + lineas_fac.dto >= 50;*/

--2.3
/*SELECT 
    descrip, 
    (NVL(stock_min, 0) - stock) AS cand_nesecitada,stock, 
    NVL(stock_min, 0) 
FROM articulos 
WHERE stock < stock_min;*/

--2.4
/*SELECT 
    COUNT(DISTINCT codpue) 
FROM clientes 
WHERE codpostal LIKE '%12';*/

--2.5
/*SELECT
    clientes.codcli
FROM
    clientes
LEFT OUTER JOIN
    facturas ON facturas.codcli = clientes.codcli
WHERE
    codpue IN (
    SELECT
        codpue
    FROM 
        pueblos
    WHERE 
        pueblos.codpro = 12);*/
        
--2.6
--SELECT MAX(stock), MIN(stock), (MAX(stock)-MIN(stock)) AS diff FROM articulos WHERE precio BETWEEN 9 AND 12

--2.7
/*SELECT
    codart,
    descrip,
    CONCAT(
        'STOCK ',
        CASE 
            WHEN (stock > NVL(stock_min, 0)) THEN 'SUFICIENTE'
            WHEN (stock = NVL(stock_min, 0)) THEN 'AJUSTADO'
            WHEN (stock < NVL(stock_min, 0)) THEN 'INSUFICIENTE'
        END
    ) AS stock_status
FROM
    articulos
WHERE 
    precio < 100*/
    
--2.8
/*SELECT
    clientes.nombre,
    facturas.fecha,
    facturas.codfac
FROM
    facturas
JOIN 
    clientes ON clientes.codcli = facturas.codcli
WHERE
    fecha BETWEEN '01/08/99' AND '31/08/99'
ORDER BY clientes.nombre, facturas.codfac DESC;*/

--3.1
/*SELECT
    COUNT(codfac),
    to_char(fecha, 'yy')
FROM
    facturas
GROUP  BY
    to_char(fecha, 'yy')
ORDER BY
    to_char(fecha, 'yy') ASC*/
    
--3.2
/*SELECT
    clientes.codcli,
    COUNT(facturas.codcli) AS avg_cli,
    clientes.nombre
FROM
    facturas
JOIN clientes ON clientes.codcli = facturas.codcli
GROUP BY clientes.codcli, clientes.nombre
HAVING COUNT(facturas.codcli) > (
    SELECT 
        COUNT(facturas.codfac) 
    FROM facturas 
    JOIN clientes ON clientes.codcli = facturas.codfac
    JOIN pueblos ON clientes.codpue = pueblos.codpue
    WHERE pueblos.nombre = 'ARAYA'
)*/

--3.3
/*SELECT
    clientes.codcli,
    clientes.nombre,
    COUNT(facturas.codfac) AS cantidad_facturas,
    SUM(lineas_fac.precio) AS compras_netas
FROM
    clientes
JOIN
    facturas ON facturas.codcli = clientes.codcli 
JOIN 
    lineas_fac ON lineas_fac.codfac = facturas.codfac
GROUP BY clientes.codcli, clientes.nombre*/

--3.4
/*SELECT
    c.codcli,
    c.nombre,
    p.nombre AS nombre_pueblo,
    COUNT(f.codfac) AS cantidad_facturas,
    SUM(l.precio) AS compras_netas,
    MAX(sumatorias.suma) AS factura_mas_alta
FROM
    clientes c
JOIN
    facturas f ON f.codcli = c.codcli 
JOIN 
    lineas_fac l ON l.codfac = f.codfac
JOIN 
    pueblos p ON p.codpue = c.codpue
JOIN
    (
    SELECT
        SUM(lf.precio) AS suma,
        fac.codfac,
        fac.codcli
    FROM
        facturas fac
    JOIN 
        lineas_fac lf ON lf.codfac = fac.codfac
    GROUP BY
        fac.codfac, fac.codcli
    ) sumatorias ON sumatorias.codcli = c.codcli
GROUP BY c.codcli, c.nombre, p.nombre*/

--3.5
/*SELECT
    prov.nombre,
    COUNT(pue.codpue) AS numero_pueblos,
    COUNT(cli.codcli) AS num_clientes
FROM
    provincias prov
JOIN
    pueblos pue ON pue.codpro = prov.codpro
LEFT JOIN
    clientes cli ON cli.codpue = pue.codpue
GROUP BY
    prov.nombre
HAVING 
    COUNT(pue.codpue) > 40 AND COUNT(cli.codcli) > 0;*/

--3.6
    

    
    

