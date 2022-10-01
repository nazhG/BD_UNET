/*CREATE OR REPLACE FUNCTION iva_cal (precio NUMBER, iva NUMBER)
RETURN number IS 
   total number; 
BEGIN 
   RETURN ((NVL(precio, 0) *  NVL(iva, 1)) /100); 
END;
/*/

/*EXECUTE dbms_session.reset_package;
SET SERVEROUTPUT ON SIZE UNLIMITED
EXECUTE sys.dbms_output.enable(NULL);
CLEAR SCREEN
EXEC ut.run('[redacted]',ut_coverage_html_reporter())*/

DECLARE
CURSOR get_cli_with_fact IS SELECT
    cli.nombre AS cli_nombre,
    pue.nombre AS pue_nombre,
    cli.codcli AS  codcli
FROM
    clientes cli
JOIN
    pueblos pue ON pue.codpue = cli.codpue
WHERE cli.codcli IN (select distinct fac.codcli FROM facturas fac WHERE fac.fecha BETWEEN '01/01/98' AND '31/12/98' AND fac.codcli is not null)
ORDER BY cli.codcli ASC;
    
CURSOR get_fac_by_client IS SELECT
    fac.codfac,
    fac.fecha,
    fac.iva,
    fac.codcli
FROM
    facturas fac
WHERE fac.fecha BETWEEN '01/01/98' AND '31/12/98';
    
CURSOR get_fac_line IS SELECT
    fl.codart,
    fl.precio,
    fl.cant,
    fl.codfac
FROM
    lineas_fac fl;

iva NUMBER;
cant_lineas NUMBER;
cant_art NUMBER;
media_art NUMBER;
monto_total NUMBER;
monto_promedio NUMBER;
monto_total_iva NUMBER;

BEGIN

FOR clien IN get_cli_with_fact LOOP
sys.Dbms_output.put_line(clien.cli_nombre||' pueblo: '||clien.pue_nombre||' codigo: '||clien.codcli);
    FOR fact IN get_fac_by_client LOOP
    IF clien.codcli = fact.codcli THEN
        sys.Dbms_output.put_line(' factura #: '||fact.codfac||'   IVA: '||fact.iva||'% '||' '||fact.fecha);
        sys.Dbms_output.put_line('      ------------------          ');

        iva := 0;
        cant_lineas := 0;
        cant_art := 0;
        media_art := 0;
        monto_total := 0;
        monto_promedio := 0;
        monto_total_iva := 0;
        
        FOR linea_fac IN get_fac_line LOOP
        IF fact.codfac = linea_fac.codfac THEN
            iva := iva_cal(linea_fac.precio,fact.iva);
            
            cant_lineas := cant_lineas + 1;
            cant_art := cant_art + linea_fac.cant;
            monto_total := monto_total + (linea_fac.precio * linea_fac.cant);
            monto_total_iva := monto_total_iva + iva;
            sys.Dbms_output.put_line('*'||linea_fac.codart||chr(9)||chr(9)||linea_fac.precio||'$x'||linea_fac.cant||chr(9)||iva);
        END IF;
        END LOOP;
        sys.Dbms_output.put_line('      ------------------          ');

        media_art := cant_art / cant_lineas;
        monto_promedio := monto_total / cant_lineas;
        
        sys.Dbms_output.put_line('iva: '||iva);
        sys.Dbms_output.put_line('cant lineas: '||cant_lineas);
        sys.Dbms_output.put_line('cant art: '||cant_art);
        sys.Dbms_output.put_line('media art: '||media_art);
        sys.Dbms_output.put_line('monto total: '||monto_total);
        sys.Dbms_output.put_line('monto promedio: '||monto_promedio);
        sys.Dbms_output.put_line('monto total iva: '||monto_total_iva);
        
        
    END IF;

    END LOOP;
END LOOP;
END;
/