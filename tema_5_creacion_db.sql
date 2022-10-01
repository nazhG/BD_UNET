CREATE TABLE cliente (
    id_cliente             NUMBER NOT NULL,
    nombre                 VARCHAR2(32 CHAR) NOT NULL,
    tipo_cedula            VARCHAR2(1 CHAR),
    cedula                 NUMBER NOT NULL,
    fecha_nacimiento       DATE NOT NULL,
    dirrecion              VARCHAR2(64 CHAR) NOT NULL,
    correo                 VARCHAR2(32 CHAR),
    telefono               VARCHAR2(16 CHAR),
    municipio_id_municipio NUMBER NOT NULL,
    lugar_nacimiento       NUMBER
) TABLESPACE tbs1;

ALTER TABLE cliente
    ADD CONSTRAINT cliente_cedula_tipos CHECK ( tipo_cedula IN ( 'V', 'E' ) );

ALTER TABLE cliente
    ADD CONSTRAINT cliente_ck_nombre CHECK ( nombre = upper(nombre) );

ALTER TABLE cliente ADD CONSTRAINT cliente_pk PRIMARY KEY ( id_cliente );

ALTER TABLE cliente ADD CONSTRAINT cliente__un UNIQUE ( cedula,
                                                        tipo_cedula );

CREATE TABLE estado (
    id_estado    NUMBER NOT NULL,
    nombre       VARCHAR2(16 CHAR) NOT NULL,
    pais_id_pais NUMBER NOT NULL
) TABLESPACE tbs1;

ALTER TABLE estado ADD CONSTRAINT estado_pk PRIMARY KEY ( id_estado );

CREATE TABLE municipio (
    id_municipio     NUMBER NOT NULL,
    nombre           VARCHAR2(16 CHAR) NOT NULL,
    estado_id_estado NUMBER NOT NULL
) TABLESPACE tbs1;

ALTER TABLE municipio ADD CONSTRAINT municipio_pk PRIMARY KEY ( id_municipio );

CREATE TABLE pais (
    id_pais NUMBER NOT NULL,
    nombre  VARCHAR2(16 CHAR)
) TABLESPACE tbs1;

ALTER TABLE pais ADD CONSTRAINT pais_pk PRIMARY KEY ( id_pais );

CREATE TABLE satisfaccion (
    id_satisfaccion   NUMBER NOT NULL,
    desc_satisfaccion VARCHAR2(32 CHAR) NOT NULL
) TABLESPACE tbs1;

ALTER TABLE satisfaccion
    ADD CONSTRAINT satisfaccion_ck_1 CHECK ( id_satisfaccion BETWEEN 1 AND 10 );

ALTER TABLE satisfaccion ADD CONSTRAINT satisfaccion_pk PRIMARY KEY ( id_satisfaccion );

CREATE TABLE sevicio (
    id_servicio                    NUMBER NOT NULL,
    descripcion                    VARCHAR2(64 CHAR),
    fecha_asignacion               DATE NOT NULL,
    fecha_estimada                 DATE,
    fecha_real                     DATE,
    costo                          FLOAT NOT NULL,
    solicitud_id_solicitud         NUMBER NOT NULL,
    tecnico_id_tecnico             NUMBER NOT NULL,
    tipo_servicio_id_tipo_servicio NUMBER NOT NULL
) TABLESPACE tbs1;

ALTER TABLE sevicio
    ADD CONSTRAINT sevicio_ck_1 CHECK ( fecha_asignacion >= fecha_estimada
                                        AND fecha_estimada >= fecha_real );

ALTER TABLE sevicio ADD CONSTRAINT sevicio_pk PRIMARY KEY ( id_servicio );

CREATE TABLE solicitud (
    id_solicitud                 NUMBER NOT NULL,
    fecha_reporte                DATE NOT NULL,
    cliente_id_cliente           NUMBER NOT NULL,
    supervisor_id_supevisor      NUMBER NOT NULL,
    satisfaccion_id_satisfaccion NUMBER,
    estado_solicitud             VARCHAR2(1 CHAR) NOT NULL,
    tipo_solicitud_id            NUMBER NOT NULL
) TABLESPACE tbs1;

ALTER TABLE solicitud
    ADD CONSTRAINT solicitud_ck_1 CHECK ( id_solicitud BETWEEN 10000 AND 99999 );

ALTER TABLE solicitud
    ADD CONSTRAINT solicitud_ck_2 CHECK ( estado_solicitud IN ( 'A', 'E' ) );

ALTER TABLE solicitud ADD CONSTRAINT solicitud_pk PRIMARY KEY ( id_solicitud );

CREATE TABLE supervisor (
    id_supevisor NUMBER NOT NULL,
    nombre       VARCHAR2(32 CHAR) NOT NULL,
    telefono     VARCHAR2(16 CHAR)
) TABLESPACE tbs1;

ALTER TABLE supervisor ADD CONSTRAINT supervisor_pk PRIMARY KEY ( id_supevisor );

CREATE TABLE tecnico (
    id_tecnico NUMBER NOT NULL,
    nombre     VARCHAR2(32 CHAR) NOT NULL,
    telefono   VARCHAR2(16 CHAR)
) TABLESPACE tbs1;

ALTER TABLE tecnico ADD CONSTRAINT tecnico_pk PRIMARY KEY ( id_tecnico );

CREATE TABLE tipo_servicio (
    id_tipo_servicio NUMBER NOT NULL,
    nombre           VARCHAR2(32 CHAR) NOT NULL,
    "desc"           VARCHAR2(64 CHAR)
) TABLESPACE tbs1;

ALTER TABLE tipo_servicio ADD CONSTRAINT tipo_servicio_pk PRIMARY KEY ( id_tipo_servicio );

CREATE TABLE tipo_solicitud (
    id_tipo_solicitud NUMBER NOT NULL,
    nombre            VARCHAR2(32 CHAR) NOT NULL,
    costo             FLOAT NOT NULL
) TABLESPACE tbs1;

ALTER TABLE tipo_solicitud ADD CONSTRAINT tipo_solicitud_pk PRIMARY KEY ( id_tipo_solicitud );

ALTER TABLE cliente
    ADD CONSTRAINT cliente_municipio_fk FOREIGN KEY ( municipio_id_municipio )
        REFERENCES municipio ( id_municipio );

ALTER TABLE estado
    ADD CONSTRAINT estado_pais_fk FOREIGN KEY ( pais_id_pais )
        REFERENCES pais ( id_pais );

ALTER TABLE cliente
    ADD CONSTRAINT lugar_nacimiento FOREIGN KEY ( lugar_nacimiento )
        REFERENCES municipio ( id_municipio );

ALTER TABLE municipio
    ADD CONSTRAINT municipio_estado_fk FOREIGN KEY ( estado_id_estado )
        REFERENCES estado ( id_estado );

ALTER TABLE sevicio
    ADD CONSTRAINT sevicio_solicitud_fk FOREIGN KEY ( solicitud_id_solicitud )
        REFERENCES solicitud ( id_solicitud );

ALTER TABLE sevicio
    ADD CONSTRAINT sevicio_tecnico_fk FOREIGN KEY ( tecnico_id_tecnico )
        REFERENCES tecnico ( id_tecnico );

ALTER TABLE sevicio
    ADD CONSTRAINT sevicio_tipo_servicio_fk FOREIGN KEY ( tipo_servicio_id_tipo_servicio )
        REFERENCES tipo_servicio ( id_tipo_servicio );

ALTER TABLE solicitud
    ADD CONSTRAINT solicitud_cliente_fk FOREIGN KEY ( cliente_id_cliente )
        REFERENCES cliente ( id_cliente );

ALTER TABLE solicitud
    ADD CONSTRAINT solicitud_satisfaccion_fk FOREIGN KEY ( satisfaccion_id_satisfaccion )
        REFERENCES satisfaccion ( id_satisfaccion );

ALTER TABLE solicitud
    ADD CONSTRAINT solicitud_supervisor_fk FOREIGN KEY ( supervisor_id_supevisor )
        REFERENCES supervisor ( id_supevisor );

ALTER TABLE solicitud
    ADD CONSTRAINT solicitud_tipo_solicitud_fk FOREIGN KEY ( tipo_solicitud_id )
        REFERENCES tipo_solicitud ( id_tipo_solicitud );

CREATE SEQUENCE satisfaccion_id_satisfaccion 
START WITH 1 
    NOCACHE 
    ORDER ;

CREATE OR REPLACE TRIGGER satisfaccion_id_satisfaccion 
BEFORE INSERT ON satisfaccion 
FOR EACH ROW 
WHEN (NEW.id_satisfaccion IS NULL) 
BEGIN
:new.id_satisfaccion := satisfaccion_id_satisfaccion.nextval;

end;
/