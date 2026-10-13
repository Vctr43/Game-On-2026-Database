-- Espinosa Sosa Víctor Gabriel, Curso de base de datos;

-- Elimina todo, es de apoyo;
-- DROP TABLE IF EXISTS Equipo CASCADE;
-- DROP TABLE IF EXISTS Jugador CASCADE;
-- DROP TABLE IF EXISTS Campo CASCADE;
-- DROP TABLE IF EXISTS Ambulancia CASCADE;
-- DROP TABLE IF EXISTS Paramedico CASCADE;
-- DROP TABLE IF EXISTS Ambulancia_Paramedico CASCADE;
-- DROP TABLE IF EXISTS Partido CASCADE;
-- DROP TABLE IF EXISTS Equipo_Partido CASCADE;
-- DROP TABLE IF EXISTS Arbitro CASCADE;
-- DROP TABLE IF EXISTS Partido_Arbitro CASCADE;
-- DROP TABLE IF EXISTS Sancion CASCADE;
-- DROP TABLE IF EXISTS Arbitro_Sancion CASCADE;

-- GENERACION DE TABLAS;
CREATE TABLE IF NOT EXISTS Equipo (
	clave_equipo VARCHAR(15), 
	nombre VARCHAR(20), 
	presidente_club VARCHAR(50), 
	color_cam_vis VARCHAR(20), 
	color_cam_loc VARCHAR(20), 
	num_jugadores_h INT, 
	num_jugadores_m INT,
	CONSTRAINT clave_equipo_pk PRIMARY KEY (clave_equipo),
	CONSTRAINT num_jugadores_h_chk CHECK (num_jugadores_h <= 7),
	CONSTRAINT num_jugadores_m_chk CHECK (num_jugadores_m <= 7)
);

CREATE TABLE IF NOT EXISTS Jugador (
	num_cuenta VARCHAR(15), 
	curp VARCHAR(18) NOT NULL, 
	num_seguro_social VARCHAR(11) NOT NULL, 
	nombre_pila VARCHAR(20), 
	apellido_pat VARCHAR(20), 
	apellido_mat VARCHAR(20), 
	sexo CHAR(1) GENERATED ALWAYS AS (substr(curp, 11, 1)) STORED, 
	edad INT, 
	peso NUMERIC(5,2), 
	estatura INT,
	clave_equipo VARCHAR(15),
	CONSTRAINT num_cuenta_pk PRIMARY KEY (num_cuenta),
	CONSTRAINT clave_equipo_fk FOREIGN KEY (clave_equipo) REFERENCES Equipo(clave_equipo),
	CONSTRAINT peso_chk CHECK (peso >= 50 AND peso <= 200),
	CONSTRAINT estatura_chk CHECK (estatura >= 50 AND estatura <= 240),
	CONSTRAINT curp_u UNIQUE (curp),
	CONSTRAINT num_seguro_social_u UNIQUE (num_seguro_social)
); 

CREATE TABLE IF NOT EXISTS Campo (
	id_campo VARCHAR(15), 
	cupo_max INT, 
	nombre VARCHAR(20), 
	ubicacion VARCHAR(50),
	CONSTRAINT id_campo_pk PRIMARY KEY (id_campo)
);

CREATE TABLE IF NOT EXISTS Ambulancia (
	id_ambulancia VARCHAR(15), 
	placa VARCHAR(10) NOT NULL,
	CONSTRAINT id_ambulancia_pk PRIMARY KEY (id_ambulancia),
	CONSTRAINT placa_u UNIQUE (placa)
);

CREATE TABLE IF NOT EXISTS Paramedico (
	num_paramedico VARCHAR(15), 
	nombre_pila VARCHAR(20), 
	apellido_pat VARCHAR(20), 
	apellido_mat VARCHAR(20), 
	cedula VARCHAR(15) NOT NULL,
	CONSTRAINT num_paramedico_pk PRIMARY KEY (num_paramedico),
	CONSTRAINT cedula_u UNIQUE (cedula)
);

CREATE TABLE IF NOT EXISTS Ambulancia_Paramedico (
	id_ambulancia VARCHAR(15), 
	rol_par CHAR(2), 
	num_paramedico VARCHAR(15),
	CONSTRAINT ambulancia_paramedico_pk PRIMARY KEY (id_ambulancia, rol_par),
	CONSTRAINT id_ambulancia_fk FOREIGN KEY (id_ambulancia) REFERENCES Ambulancia(id_ambulancia),
	CONSTRAINT num_paramedico_fk FOREIGN KEY (num_paramedico) REFERENCES Paramedico(num_paramedico),
	CONSTRAINT rol_par_chk CHECK (rol_par IN('P1', 'P2', 'P3'))
);

CREATE TABLE IF NOT EXISTS Partido (
	num_partido VARCHAR(15), 
	fecha DATE, 
	hora TIME, 
	marcador_local INT, 
	marcador_visitante INT, 
	id_campo VARCHAR(15), 
	id_ambulancia VARCHAR(15),
	CONSTRAINT num_partido_pk PRIMARY KEY (num_partido),
	CONSTRAINT id_campo_fk FOREIGN KEY (id_campo) REFERENCES Campo(id_campo),
	CONSTRAINT id_ambulancia_fk FOREIGN KEY (id_ambulancia) REFERENCES Ambulancia(id_ambulancia)
);

CREATE TABLE IF NOT EXISTS Equipo_Partido (
	num_partido VARCHAR(15), 
	local_visitante CHAR(1), 
	clave_equipo VARCHAR(15),
	CONSTRAINT equipo_partido_pk PRIMARY KEY (num_partido, local_visitante),
	CONSTRAINT num_partido_fk FOREIGN KEY (num_partido) REFERENCES Partido(num_partido),
	CONSTRAINT clave_equipo_fk FOREIGN KEY (clave_equipo) REFERENCES Equipo(clave_equipo),
	CONSTRAINT local_visitante_chk CHECK (local_visitante IN('L', 'V'))
);

CREATE TABLE IF NOT EXISTS Arbitro (
	num_arbitro VARCHAR(15),
	nombre_pila VARCHAR(20),
	apellido_pat VARCHAR(20),
	apellido_mat VARCHAR(20),
	codigo_arbitro VARCHAR(15) NOT NULL,
	CONSTRAINT num_arbitro_pk PRIMARY KEY (num_arbitro),
	CONSTRAINT codigo_arbitro_u UNIQUE (codigo_arbitro)
);

CREATE TABLE IF NOT EXISTS Partido_Arbitro (
	num_partido VARCHAR(15), 
	rol_arb CHAR(2), 
	num_arbitro VARCHAR(15), 
	CONSTRAINT Partido_Arbitro_pk PRIMARY KEY (num_partido, rol_arb),
	CONSTRAINT num_partido_fk FOREIGN KEY (num_partido) REFERENCES Partido(num_partido),
	CONSTRAINT num_arbitro_fk FOREIGN KEY (num_arbitro) REFERENCES Arbitro(num_arbitro),
	CONSTRAINT rol_arb_chk CHECK (rol_arb IN('TI', 'A1', 'A2'))
);

CREATE TABLE IF NOT EXISTS Sancion (
	id_sancion VARCHAR(15), 
	descripcion VARCHAR(50),
	CONSTRAINT id_sancion_pk PRIMARY KEY (id_sancion)
);

CREATE TABLE IF NOT EXISTS Arbitro_Sancion (
	num_arbitro VARCHAR(15),
	id_sancion VARCHAR(15),
	CONSTRAINT Arbitro_Sancion_pk PRIMARY KEY (num_arbitro, id_sancion),
	CONSTRAINT num_arbitro_fk FOREIGN KEY (num_arbitro) REFERENCES Arbitro(num_arbitro),
	CONSTRAINT id_sancion_fk FOREIGN KEY (id_sancion) REFERENCES Sancion(id_sancion)
);

-- INSERCION DE REGISTROS EN LAS TABLAS. Los valores de Equipos, Jugadores, Campos, Paramedicos fueron generados por ChatGPT;
INSERT INTO Equipo (clave_equipo, nombre, presidente_club, color_cam_vis, color_cam_loc, num_jugadores_h, num_jugadores_m)
VALUES
('EQ001', 'Titanes', 'Carlos Mendoza', 'Azul', 'Blanco', 0, 0),
('EQ002', 'Halcones', 'Ana Ramírez', 'Rojo', 'Negro', 0, 0),
('EQ003', 'Leones', 'Jorge Herrera', 'Verde', 'Blanco', 0, 0),
('EQ004', 'Panteras', 'María López', 'Morado', 'Gris', 0, 0),
('EQ005', 'Tormenta', 'Luis Castillo', 'Amarillo', 'Naranja', 0, 0);

INSERT INTO Jugador VALUES
('202600001','PELJ080512HQRRMN01','10000000001','Juan','Perez','Lopez',DEFAULT,18,82.50,178,'EQ001'),
('202600002','GALC071023HDFRMN02','10000000002','Carlos','Garcia','Lopez',DEFAULT,19,91.20,182,'EQ001'),
('202600003','HELM060315HCHRMS03','10000000003','Miguel','Hernandez','Lopez',DEFAULT,20,88.70,180,'EQ001'),
('202600004','ROLD050729HYNRMS04','10000000004','Diego','Rodriguez','Lopez',DEFAULT,21,93.80,184,'EQ001'),
('202600005','SAGJ040916HSLRMS05','10000000005','Jorge','Sanchez','Garcia',DEFAULT,22,86.90,177,'EQ001'),
('202600006','TOPA031124HQRRMS06','10000000006','Andres','Torres','Perez',DEFAULT,23,95.40,186,'EQ001'),
('202600007','MOLD020405HNERMS07','10000000007','Luis','Morales','Diaz',DEFAULT,24,89.60,181,'EQ001'),
('202600008','LOMA090225MQRRMN08','10000000008','Ana','Lopez','Martinez',DEFAULT,17,61.40,165,'EQ001'),
('202600009','GASM081014MDFRMN09','10000000009','Maria','Garcia','Sanchez',DEFAULT,18,64.20,168,'EQ001'),
('202600010','PESF070603MCHRMS10','10000000010','Sofia','Perez','Flores',DEFAULT,19,60.50,164,'EQ001'),
('202600011','RUFV061126MYNRMS11','10000000011','Valeria','Ruiz','Flores',DEFAULT,20,62.70,166,'EQ001'),
('202600012','MOFC050710MSLRMS12','10000000012','Fernanda','Morales','Castro',DEFAULT,21,63.90,167,'EQ001'),
('202600013','CACC040919MQRRMS13','10000000013','Camila','Castillo','Cruz',DEFAULT,22,59.30,163,'EQ001'),
('202600014','TOPR031105MNERMS14','10000000014','Paula','Torres','Ramirez',DEFAULT,23,65.80,169,'EQ001');
UPDATE Equipo SET num_jugadores_h = 7, num_jugadores_m = 7 WHERE clave_equipo = 'EQ001';


INSERT INTO Jugador VALUES
('202600015','GOPR080428HDFRMN15','10000000015','Ricardo','Gomez','Perez',DEFAULT,18,90.30,183,'EQ002'),
('202600016','VECA071216HCHRMS16','10000000016','Alejandro','Vega','Castro',DEFAULT,19,92.10,185,'EQ002'),
('202600017','LEDE060330HYNRMS17','10000000017','Eduardo','Leon','Diaz',DEFAULT,20,87.50,179,'EQ002'),
('202600018','SIPF050617HSLRMS18','10000000018','Fernando','Silva','Perez',DEFAULT,21,94.80,187,'EQ002'),
('202600019','RODH040801HQRRMS19','10000000019','Hector','Romero','Diaz',DEFAULT,22,85.60,176,'EQ002'),
('202600020','NAGP031109HNERMS20','10000000020','Pedro','Navarro','Garcia',DEFAULT,23,91.40,182,'EQ002'),
('202600021','ORDJ020221HDFRMS21','10000000021','Jorge','Ortiz','Diaz',DEFAULT,24,89.90,180,'EQ002'),
('202600022','MEGA090312MCHRMN22','10000000022','Gabriela','Mendoza','Aguilar',DEFAULT,17,58.20,162,'EQ002'),
('202600023','HELU081024MYNRMN23','10000000023','Lucia','Herrera','Luna',DEFAULT,18,61.70,166,'EQ002'),
('202600024','VADA070705MSLRMS24','10000000024','Daniela','Vargas','Diaz',DEFAULT,19,63.50,168,'EQ002'),
('202600025','ROAN061117MQRRMS25','10000000025','Andrea','Rojas','Navarro',DEFAULT,20,64.10,167,'EQ002'),
('202600026','CAEL050614MNERMS26','10000000026','Elena','Campos','Lopez',DEFAULT,21,60.40,164,'EQ002'),
('202600027','SAAM040803MDFRMS27','10000000027','Mariana','Salas','Martinez',DEFAULT,22,62.90,165,'EQ002'),
('202600028','LUPA030928MCHRMS28','10000000028','Paula','Luna','Perez',DEFAULT,23,59.80,163,'EQ002');
UPDATE Equipo SET num_jugadores_h = 7, num_jugadores_m = 7 WHERE clave_equipo = 'EQ002';

INSERT INTO Jugador VALUES
('202600029','FUEM080414HGRRMN29','10000000029','Emilio','Fuentes','Martinez',DEFAULT,18,88.40,181,'EQ003'),
('202600030','MERA071208HDFRMN30','10000000030','Raul','Mendez','Ramirez',DEFAULT,19,91.60,184,'EQ003'),
('202600031','PAIV060527HCHRMS31','10000000031','Ivan','Paredes','Vega',DEFAULT,20,86.80,179,'EQ003'),
('202600032','REMA050815HSLRMS32','10000000032','Manuel','Reyes','Martinez',DEFAULT,21,94.20,186,'EQ003'),
('202600033','SOAR040122HQRRMS33','10000000033','Arturo','Soto','Ramirez',DEFAULT,22,90.10,182,'EQ003'),
('202600034','MESS031110HNERMS34','10000000034','Sergio','Mendez','Suarez',DEFAULT,23,92.30,185,'EQ003'),
('202600035','PEOS020316HDFRMS35','10000000035','Oscar','Perez','Ortega',DEFAULT,24,87.50,180,'EQ003'),
('202600036','VECA090518MGRRMN36','10000000036','Carolina','Vega','Castro',DEFAULT,17,61.30,165,'EQ003'),
('202600037','CAIS081029MDFRMN37','10000000037','Isabel','Castro','Sanchez',DEFAULT,18,63.50,168,'EQ003'),
('202600038','SIMO070722MCHRMS38','10000000038','Monica','Silva','Ortega',DEFAULT,19,60.80,164,'EQ003'),
('202600039','LEAD061114MSLRMS39','10000000039','Adriana','Leon','Diaz',DEFAULT,20,64.20,167,'EQ003'),
('202600040','RISA050621MQRRMS40','10000000040','Sandra','Rios','Aguilar',DEFAULT,21,59.90,163,'EQ003'),
('202600041','HEPA040926MNERMS41','10000000041','Paola','Herrera','Perez',DEFAULT,22,62.40,166,'EQ003'),
('202600042','DIVE030207MDFRMS42','10000000042','Veronica','Diaz','Vega',DEFAULT,23,65.10,169,'EQ003');
UPDATE Equipo SET num_jugadores_h = 7, num_jugadores_m = 7 WHERE clave_equipo = 'EQ003';

INSERT INTO Jugador VALUES
('202600043','AGRO080623HGRRMN43','10000000043','Roberto','Aguilar','Ortega',DEFAULT,18,89.30,182,'EQ004'),
('202600044','FLAN071102HDFRMN44','10000000044','Angel','Flores','Navarro',DEFAULT,19,92.70,185,'EQ004'),
('202600045','MEJE060419HCHRMS45','10000000045','Jesus','Medina','Jimenez',DEFAULT,20,86.40,178,'EQ004'),
('202600046','CATO050827HSLRMS46','10000000046','Tomas','Castillo','Ortega',DEFAULT,21,95.20,187,'EQ004'),
('202600047','GUVI040314HQRRMS47','10000000047','Victor','Guerrero','Vidal',DEFAULT,22,90.50,183,'EQ004'),
('202600048','JIMA031218HNERMS48','10000000048','Marco','Jimenez','Aguilar',DEFAULT,23,91.80,184,'EQ004'),
('202600049','CARU020508HDFRMS49','10000000049','Ruben','Cabrera','Urias',DEFAULT,24,88.60,181,'EQ004'),
('202600050','ROCL090105MGRRMN50','10000000050','Claudia','Romero','Lopez',DEFAULT,17,60.70,164,'EQ004'),
('202600051','NATE081122MDFRMN51','10000000051','Teresa','Navarro','Espinoza',DEFAULT,18,63.10,167,'EQ004'),
('202600052','ORLA070613MCHRMS52','10000000052','Laura','Ortega','Lopez',DEFAULT,19,61.20,165,'EQ004'),
('202600053','SUBE061009MSLRMS53','10000000053','Beatriz','Suarez','Espinosa',DEFAULT,20,64.60,168,'EQ004'),
('202600054','MODI050224MQRRMS54','10000000054','Diana','Molina','Diaz',DEFAULT,21,59.80,163,'EQ004'),
('202600055','MESI040930MNERMS55','10000000055','Silvia','Mendoza','Ibarra',DEFAULT,22,62.30,166,'EQ004'),
('202600056','PERO030811MDFRMS56','10000000056','Rosa','Perez','Ortega',DEFAULT,23,65.40,169,'EQ004');
UPDATE Equipo SET num_jugadores_h = 7, num_jugadores_m = 7 WHERE clave_equipo = 'EQ004';

INSERT INTO Jugador VALUES
('202600057','NUAL080330HGRRMN57','10000000057','Alberto','Nuñez','Lopez',DEFAULT,18,90.80,184,'EQ005'),
('202600058','VICE071027HDFRMN58','10000000058','Cesar','Vidal','Castro',DEFAULT,19,93.10,186,'EQ005'),
('202600059','SAPA060912HCHRMS59','10000000059','Pablo','Santos','Perez',DEFAULT,20,87.90,180,'EQ005'),
('202600060','MOFR050226HSLRMS60','10000000060','Francisco','Mora','Flores',DEFAULT,21,94.70,187,'EQ005'),
('202600061','ARGU040731HQRRMS61','10000000061','Guillermo','Arias','Ruiz',DEFAULT,22,89.20,182,'EQ005'),
('202600062','COJA031204HNERMS62','10000000062','Javier','Contreras','Jimenez',DEFAULT,23,91.50,184,'EQ005'),
('202600063','ESMA020618HDFRMS63','10000000063','Martin','Escobar','Martinez',DEFAULT,24,88.30,181,'EQ005'),
('202600064','VEAL090413MGRRMN64','10000000064','Alejandra','Vega','Lopez',DEFAULT,17,61.60,165,'EQ005'),
('202600065','FUMA081118MDFRMN65','10000000065','Mariana','Fuentes','Martinez',DEFAULT,18,63.80,168,'EQ005'),
('202600066','MEKA070624MCHRMS66','10000000066','Karla','Medina','Aguilar',DEFAULT,19,60.90,164,'EQ005'),
('202600067','POLO061030MSLRMS67','10000000067','Lorena','Ponce','Lopez',DEFAULT,20,64.40,167,'EQ005'),
('202600068','AGCR050221MQRRMS68','10000000068','Cristina','Aguilar','Ramirez',DEFAULT,21,59.70,163,'EQ005'),
('202600069','RIJU040906MNERMS69','10000000069','Julia','Rivas','Juarez',DEFAULT,22,62.50,166,'EQ005'),
('202600070','TORE030517MDFRMS70','10000000070','Renata','Torres','Espinoza',DEFAULT,23,65.20,169,'EQ005');
UPDATE Equipo SET num_jugadores_h = 7, num_jugadores_m = 7 WHERE clave_equipo = 'EQ005';

INSERT INTO Campo (id_campo, cupo_max, nombre, ubicacion)
VALUES
('CAM001', 500, 'Campo Jaguar', 'Unidad Deportiva Norte'),
('CAM002', 300, 'Campo Centenario', 'Complejo Deportivo Central'),
('CAM003', 450, 'Campo Guerrero', 'Parque Deportivo Oriente'),
('CAM004', 250, 'Campo Titan', 'Unidad Deportiva Sur'),
('CAM005', 600, 'Campo Azteca', 'Estadio Municipal');

INSERT INTO Ambulancia VALUES
('AMB01', 'ABC001'),
('AMB02', 'ABC002'),
('AMB03', 'ABC003'),
('AMB04', 'ABC004'),
('AMB05', 'ABC005'),
('AMB06', 'ABC006'),
('AMB07', 'ABC007'),
('AMB08', 'ABC008'),
('AMB09', 'ABC009'),
('AMB10', 'ABC010');

INSERT INTO Paramedico VALUES
('PM001', 'Carlos', 'Gomez', 'Lopez', '10001'),
('PM002', 'Ana', 'Martinez', 'Perez', '10002'),
('PM003', 'Luis', 'Hernandez', 'Garcia', '10003'),
('PM004', 'Maria', 'Rodriguez', 'Sanchez', '10004'),
('PM005', 'Jorge', 'Ramirez', 'Torres', '10005'),
('PM006', 'Sofia', 'Flores', 'Cruz', '10006'),
('PM007', 'Miguel', 'Morales', 'Diaz', '10007'),
('PM008', 'Laura', 'Vargas', 'Ruiz', '10008'),
('PM009', 'Daniel', 'Castillo', 'Mendoza', '10009'),
('PM010', 'Fernanda', 'Ortiz', 'Herrera', '10010'),
('PM011', 'Ricardo', 'Navarro', 'Silva', '10011'),
('PM012', 'Paola', 'Rojas', 'Medina', '10012'),
('PM013', 'Andres', 'Santos', 'Vega', '10013'),
('PM014', 'Valeria', 'Cruz', 'Aguilar', '10014'),
('PM015', 'Eduardo', 'Jimenez', 'Romero', '10015'),
('PM016', 'Gabriela', 'Mendoza', 'Castro', '10016'),
('PM017', 'Fernando', 'Torres', 'Lopez', '10017'),
('PM018', 'Daniela', 'Garcia', 'Morales', '10018'),
('PM019', 'Alejandro', 'Perez', 'Flores', '10019'),
('PM020', 'Mariana', 'Sanchez', 'Vargas', '10020'),
('PM021', 'Jose', 'Hernandez', 'Ruiz', '10021'),
('PM022', 'Claudia', 'Ramirez', 'Diaz', '10022'),
('PM023', 'Roberto', 'Lopez', 'Mendez', '10023'),
('PM024', 'Andrea', 'Castro', 'Navarro', '10024'),
('PM025', 'Pablo', 'Aguilar', 'Ortega', '10025'),
('PM026', 'Carolina', 'Vega', 'Santos', '10026'),
('PM027', 'Hector', 'Medina', 'Rojas', '10027'),
('PM028', 'Lucia', 'Herrera', 'Jimenez', '10028'),
('PM029', 'Sergio', 'Romero', 'Cabrera', '10029'),
('PM030', 'Natalia', 'Cabrera', 'Molina', '10030');

INSERT INTO Ambulancia_Paramedico VALUES
('AMB01', 'P1', 'PM001'),
('AMB01', 'P2', 'PM002'),
('AMB01', 'P3', 'PM003'),
('AMB02', 'P1', 'PM004'),
('AMB02', 'P2', 'PM005'),
('AMB02', 'P3', 'PM006'),
('AMB03', 'P1', 'PM007'),
('AMB03', 'P2', 'PM008'),
('AMB03', 'P3', 'PM009'),
('AMB04', 'P1', 'PM010'),
('AMB04', 'P2', 'PM011'),
('AMB04', 'P3', 'PM012'),
('AMB05', 'P1', 'PM013'),
('AMB05', 'P2', 'PM014'),
('AMB05', 'P3', 'PM015'),
('AMB06', 'P1', 'PM016'),
('AMB06', 'P2', 'PM017'),
('AMB06', 'P3', 'PM018'),
('AMB07', 'P1', 'PM019'),
('AMB07', 'P2', 'PM020'),
('AMB07', 'P3', 'PM021'),
('AMB08', 'P1', 'PM022'),
('AMB08', 'P2', 'PM023'),
('AMB08', 'P3', 'PM024'),
('AMB09', 'P1', 'PM025'),
('AMB09', 'P2', 'PM026'),
('AMB09', 'P3', 'PM027'),
('AMB10', 'P1', 'PM028'),
('AMB10', 'P2', 'PM029'),
('AMB10', 'P3', 'PM030');

INSERT INTO Partido VALUES
('0001', '2026-06-01', '09:00:00', 14, 30, 'CAM001', 'AMB07'),
('0002', '2026-06-01', '18:00:00', 20, 23, 'CAM004', 'AMB03'),
('0003', '2026-06-02', '09:00:00', 42, 25, 'CAM005', 'AMB06'),
('0004', '2026-06-02', '18:00:00', 16, 13, 'CAM003', 'AMB02'),
('0005', '2026-06-03', '09:00:00', 24, 24, 'CAM004', 'AMB01'),
('0006', '2026-06-03', '18:00:00', 14, 32, 'CAM003', 'AMB04'),
('0007', '2026-06-04', '09:00:00', 32, 23, 'CAM002', 'AMB05'),
('0008', '2026-06-04', '18:00:00', 22, 16, 'CAM005', 'AMB09'),
('0009', '2026-06-05', '09:00:00', 10, 31, 'CAM001', 'AMB08'),
('0010', '2026-06-05', '18:00:00',  7, 20, 'CAM002', 'AMB10');

INSERT INTO Equipo_Partido VALUES
('0001', 'L', 'EQ001'), ('0001', 'V', 'EQ002'),
('0002', 'L', 'EQ004'), ('0002', 'V', 'EQ003'),
('0003', 'L', 'EQ005'), ('0003', 'V', 'EQ001'),
('0004', 'L', 'EQ003'), ('0004', 'V', 'EQ002'),
('0005', 'L', 'EQ004'), ('0005', 'V', 'EQ005'),
('0006', 'L', 'EQ003'), ('0006', 'V', 'EQ001'),
('0007', 'L', 'EQ002'), ('0007', 'V', 'EQ004'),
('0008', 'L', 'EQ005'), ('0008', 'V', 'EQ003'), 
('0009', 'L', 'EQ001'), ('0009', 'V', 'EQ004'),
('0010', 'L', 'EQ002'), ('0010', 'V', 'EQ005');

INSERT INTO Arbitro VALUES 
('ARB001', 'Carlos', 'Mendoza', 'López', 'CODARB001'),
('ARB002', 'Javier', 'Ramírez', 'Torres', 'CODARB002'),
('ARB003', 'Ricardo', 'Sánchez', 'Morales', 'CODARB003'),
('ARB004', 'Fernando', 'Castillo', 'Vega', 'CODARB004'),
('ARB005', 'Luis', 'Hernández', 'Ortega', 'CODARB005'),
('ARB006', 'Miguel', 'Navarro', 'Silva', 'CODARB006');

INSERT INTO Partido_Arbitro VALUES
('0001', 'TI', 'ARB001'), ('0001', 'A1', 'ARB003'), ('0001', 'A2', 'ARB005'), 
('0002', 'TI', 'ARB002'), ('0002', 'A1', 'ARB004'), ('0002', 'A2', 'ARB006'),
('0003', 'TI', 'ARB001'), ('0003', 'A1', 'ARB003'), ('0003', 'A2', 'ARB005'), 
('0004', 'TI', 'ARB002'), ('0004', 'A1', 'ARB004'), ('0004', 'A2', 'ARB006'),
('0005', 'TI', 'ARB001'), ('0005', 'A1', 'ARB003'), ('0005', 'A2', 'ARB005'), 
('0006', 'TI', 'ARB002'), ('0006', 'A1', 'ARB004'), ('0006', 'A2', 'ARB006'),
('0007', 'TI', 'ARB001'), ('0007', 'A1', 'ARB003'), ('0007', 'A2', 'ARB005'), 
('0008', 'TI', 'ARB002'), ('0008', 'A1', 'ARB004'), ('0008', 'A2', 'ARB006'),
('0009', 'TI', 'ARB001'), ('0009', 'A1', 'ARB003'), ('0009', 'A2', 'ARB005'), 
('0010', 'TI', 'ARB002'), ('0010', 'A1', 'ARB004'), ('0010', 'A2', 'ARB006');

INSERT INTO Sancion VALUES
('SAN001', 'Golpe de castigo'),
('SAN002', 'Tiro libre'),
('SAN003', 'Tarjeta amarilla'),
('SAN004', 'Tarjeta roja'),
('SAN005', 'Ensayo de castigo');

INSERT INTO Arbitro_Sancion VALUES
('ARB002', 'SAN001'),
('ARB003', 'SAN002'),
('ARB004', 'SAN001'),
('ARB005', 'SAN004'),
('ARB006', 'SAN003'),
('ARB001', 'SAN005'),
('ARB002', 'SAN005');

-- Vistas que utilizare para apoyarme al realizar las consultas;

-- Vista de los arbitros por partido;
CREATE VIEW Arbitro_Titular_Partido AS 
SELECT 
	pa.num_partido, 
	a.nombre_pila AS nombre_arbitro_titular, 
	a.apellido_pat AS apellido_arbitro_titular
FROM Partido_Arbitro pa
INNER JOIN Arbitro a
ON a.num_arbitro = pa.num_arbitro
WHERE pa.rol_arb = 'TI';

CREATE VIEW Arbitro_Ayudante1_Partido AS 
SELECT 
	pa.num_partido, 
	a.nombre_pila AS nombre_arbitro_ayudante1
FROM Partido_Arbitro pa
INNER JOIN Arbitro a
ON a.num_arbitro = pa.num_arbitro
WHERE pa.rol_arb = 'A1';

CREATE VIEW Arbitro_Ayudante2_Partido AS 
SELECT 
	pa.num_partido, 
	a.nombre_pila AS nombre_arbitro_ayudante2
FROM Partido_Arbitro pa
INNER JOIN Arbitro a
ON a.num_arbitro = pa.num_arbitro
WHERE pa.rol_arb = 'A2';

CREATE VIEW Arbitraje_Partido AS
SELECT 
	ti.num_partido, 
	ti.nombre_arbitro_titular, 
	ti.apellido_arbitro_titular, 
	a1.nombre_arbitro_ayudante1, 
	a2.nombre_arbitro_ayudante2
FROM Arbitro_Titular_Partido AS ti
INNER JOIN Arbitro_Ayudante1_Partido a1
ON a1.num_partido = ti.num_partido
INNER JOIN Arbitro_Ayudante2_Partido a2
ON a2.num_partido = ti.num_partido
ORDER BY num_partido;

-- Vista de las ambulancias con sus paramedicos paramedicos;
CREATE VIEW num_Paramedico_en_Ambulancia AS
SELECT 
	a.id_ambulancia, 
	p1.num_paramedico AS num_paramedico1, 
	p2.num_paramedico AS num_paramedico2, 
	p3.num_paramedico AS num_paramedico3
FROM Ambulancia a
INNER JOIN Ambulancia_Paramedico p1
ON a.id_ambulancia = p1.id_ambulancia AND p1.rol_par = 'P1'
INNER JOIN Ambulancia_Paramedico p2
ON a.id_ambulancia = p2.id_ambulancia AND p2.rol_par = 'P2'
INNER JOIN Ambulancia_Paramedico p3
ON a.id_ambulancia = p3.id_ambulancia AND p3.rol_par = 'P3'
ORDER BY a.id_ambulancia;

CREATE VIEW Paramedico_en_Ambulancia AS
SELECT
	npa.id_ambulancia, 
	p1.nombre_pila AS nombre_paramedico1,
	p2.nombre_pila AS nombre_paramedico2,
	p3.nombre_pila AS nombre_paramedico3
FROM num_Paramedico_en_Ambulancia npa
INNER JOIN Paramedico p1 
ON npa.num_paramedico1 = p1.num_paramedico
INNER JOIN Paramedico p2 
ON npa.num_paramedico2 = p2.num_paramedico
INNER JOIN Paramedico p3 
ON npa.num_paramedico3 = p3.num_paramedico
ORDER BY npa.id_ambulancia;

-- GENERACION DE CONSULTAS;

-- Consulta de jugadores junto al equipo donde juegan;
SELECT 
	j.nombre_pila AS nombre, 
	j.apellido_pat AS apellido_paterno, 
	j.apellido_mat AS apellido_materno, 
	j.sexo, 
	j.edad,
	j.peso,
	j.estatura,
	e.nombre AS juega_en
FROM jugador j
INNER JOIN Equipo e
ON j.clave_equipo = e.clave_equipo;

-- Consulta todos los partidos de 'Panteras' (EQ004) junto al contrincante, día, 
-- hora, campo donde se jugó, si es de local o visitante y marcador final;
SELECT 
	e1.nombre AS nombre_equipo,
	e2.nombre AS nombre_contrincante,
	p.fecha,
	p.hora,
	c.nombre AS campo,
	ep1.local_visitante AS juega_como,
	p.marcador_local,
	p.marcador_visitante
FROM Equipo_Partido ep1
JOIN Equipo_Partido ep2 
	ON ep1.num_partido = ep2.num_partido AND 
		ep1.clave_equipo <> ep2.clave_equipo
JOIN Equipo e1 ON e1.clave_equipo = ep1.clave_equipo
JOIN Equipo e2 ON e2.clave_equipo = ep2.clave_equipo
JOIN Partido p ON ep1.num_partido = p.num_partido
JOIN Campo c ON p.id_campo = c.id_campo
WHERE ep1.clave_equipo = 'EQ004';

-- Consulta de todos los partidos, dando los datos del nombre del equipo local 
-- y visitante, color de camisa, campo;
SELECT
	ep1.num_partido,
	e1.nombre AS equipo_local,
	e2.nombre AS equipo_visitante,
	e1.color_cam_loc AS color_camisa_local,
	e2.color_cam_vis AS color_camisa_visitante,
	c.nombre AS campo
FROM Equipo_Partido ep1
JOIN Equipo_Partido ep2
	ON ep1.num_partido = ep2.num_partido AND 
		ep1.clave_equipo <> ep2.clave_equipo AND 
		ep2.local_visitante = 'V'
JOIN Equipo e1 ON e1.clave_equipo = ep1.clave_equipo
JOIN Equipo e2 ON e2.clave_equipo = ep2.clave_equipo
JOIN Partido p ON p.num_partido = ep1.num_partido
JOIN Campo c ON c.id_campo = p.id_campo
ORDER BY ep1.num_partido;

-- Consulta de los trabajadores en los partidos, dando los datos del nombre del 
-- equipo local y visitante, árbitros y paramédicos;
SELECT
	ep1.num_partido,
	e1.nombre AS equipo_local,
	e2.nombre AS equipo_visitante,
	ap.nombre_arbitro_titular AS arbitro_titular, 
	ap.nombre_arbitro_ayudante1 AS ayudante1, 
	ap.nombre_arbitro_ayudante2 AS ayudante2,
	pa.*
FROM Equipo_Partido ep1
JOIN Equipo_Partido ep2
	ON ep1.num_partido = ep2.num_partido AND 
		ep1.clave_equipo <> ep2.clave_equipo AND 
		ep2.local_visitante = 'V'
JOIN Equipo e1 ON e1.clave_equipo = ep1.clave_equipo
JOIN Equipo e2 ON e2.clave_equipo = ep2.clave_equipo
JOIN Partido p ON p.num_partido = ep1.num_partido
JOIN Paramedico_en_Ambulancia pa ON pa.id_ambulancia = p.id_ambulancia
JOIN Arbitraje_Partido ap ON ap.num_partido = ep1.num_partido 
ORDER BY ep1.num_partido;

-- Consulta de las sanciones emitidas por cada árbitro;
SELECT 
	a.nombre_pila AS nombre,
	a.apellido_pat,
	a.apellido_mat,
	s.descripcion
FROM Arbitro_Sancion a_s
JOIN Arbitro a ON a.num_arbitro = a_s.num_arbitro
JOIN Sancion s ON s.id_sancion = a_s.id_sancion
ORDER BY a.num_arbitro;

-- Consultas a todas las tablas;

SELECT * FROM Equipo;

SELECT * FROM Jugador;

SELECT * FROM Campo;

SELECT * FROM Ambulancia;

SELECT * FROM Paramedico;

SELECT * FROM Ambulancia_Paramedico;

SELECT * FROM Partido;

SELECT * FROM Equipo_Partido;

SELECT * FROM Arbitro;

SELECT * FROM Partido_Arbitro;

SELECT * FROM Sancion;

SELECT * FROM Arbitro_Sancion;

