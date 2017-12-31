/* CREATE and USE DATABASE top500rank */
DROP DATABASE IF EXISTS top500rank;
CREATE DATABASE IF NOT EXISTS top500rank CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
#CREATE DATABASE IF NOT EXISTS top500rank CHARACTER SET utf8 COLLATE utf8_general_ci;
USE top500rank;
#SELECT database();
#SHOW TABLES;

# CREATE TABLE with YEARS and MONTHS of TOP500 RANKS (published twice a year since 1993, total: 50 ranks with 500 positions each)
CREATE TABLE IF NOT EXISTS rankmonths(
id_rank SMALLINT NOT NULL AUTO_INCREMENT,
year_rank SMALLINT,
month_rank TINYINT,
PRIMARY KEY (id_rank)
);

# CREATE TABLE with COUNTRY CODES (3-letter ISO code of the country e.g. USA, CHN, JPN, PLN etc.)
CREATE TABLE IF NOT EXISTS countries(
id_cc VARCHAR(3) NOT NULL,
country VARCHAR(30) NOT NULL,
region VARCHAR(40),
continent VARCHAR(15),
PRIMARY KEY (id_cc)
);

# CREATE TABLE with TYPES of SUPERCOMPUTER ARCHITECTURES (Cluster, MPP etc.)
CREATE TABLE IF NOT EXISTS architectures(
id_arch SMALLINT NOT NULL AUTO_INCREMENT,
architecture VARCHAR(20),
PRIMARY KEY (id_arch)
);

# CREATE TABLE with main application segments of supercomputers
CREATE TABLE IF NOT EXISTS segments(
id_segm SMALLINT NOT NULL AUTO_INCREMENT,
segment VARCHAR(20),
PRIMARY KEY (id_segm)
);

# CREATE TABLE with interconnect technologies used in supercomputers
CREATE TABLE IF NOT EXISTS interconnects(
id_interconn SMALLINT NOT NULL AUTO_INCREMENT,
interconnect VARCHAR(60),
interconnect_family VARCHAR(30),
PRIMARY KEY (id_interconn)
);

# CREATE TABLE with Operating Systems used in supercomputers
CREATE TABLE IF NOT EXISTS opsystems(
id_opsys SMALLINT NOT NULL AUTO_INCREMENT,
operating_system VARCHAR(70),
PRIMARY KEY (id_opsys)
);

# CREATE TABLE with information about processors used in supercomputers
CREATE TABLE IF NOT EXISTS processors(
id_proc SMALLINT NOT NULL AUTO_INCREMENT,
processor VARCHAR(60),
processor_technology VARCHAR(30),
processor_speed FLOAT,
PRIMARY KEY (id_proc)
);

# CREATE TABLE manufacturer system families used in supercomputers
CREATE TABLE IF NOT EXISTS systemfams(
id_sysfam SMALLINT NOT NULL AUTO_INCREMENT,
system_family VARCHAR(50),
PRIMARY KEY (id_sysfam)
);

# CREATE TABLE about manufacturers of supercomputers
CREATE TABLE IF NOT EXISTS manufacturers(
id_manufact SMALLINT NOT NULL AUTO_INCREMENT,
manufacturer VARCHAR(100),
PRIMARY KEY (id_manufact)
);

# CREATE TABLE with sites (companies, organizations, places etc.) with installed supercompuers
CREATE TABLE IF NOT EXISTS sites(
id_site SMALLINT NOT NULL AUTO_INCREMENT,
site VARCHAR(150),
id_cc VARCHAR(3) NOT NULL,
PRIMARY KEY (id_site),
FOREIGN KEY (id_cc) REFERENCES countries (id_cc)
ON DELETE CASCADE ON UPDATE CASCADE
);

# CREATE TABLE with specified supercomputer configurations (used processors, architectures, operating systems etc.)
CREATE TABLE IF NOT EXISTS configurations(
id_config SMALLINT NOT NULL AUTO_INCREMENT,
id_proc SMALLINT,
id_opsys SMALLINT,
id_interconn SMALLINT,
id_arch SMALLINT,
id_manufact SMALLINT,
id_sysfam SMALLINT,
computer VARCHAR(150),
processors_cores INTEGER,
PRIMARY KEY (id_config),
FOREIGN KEY (id_proc) REFERENCES processors (id_proc)
ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (id_opsys) REFERENCES opsystems (id_opsys)
ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (id_interconn) REFERENCES interconnects (id_interconn)
ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (id_arch) REFERENCES architectures (id_arch)
ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (id_manufact) REFERENCES manufacturers (id_manufact)
ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (id_sysfam) REFERENCES systemfams (id_sysfam)
ON DELETE CASCADE ON UPDATE CASCADE
);

# CREATE TABLE with joined information about installation (configuration + site + segment + year) of supercomputers
CREATE TABLE IF NOT EXISTS installations(
id_inst MEDIUMINT NOT NULL AUTO_INCREMENT,
id_site SMALLINT NOT NULL,
id_config SMALLINT NOT NULL,
id_segm SMALLINT NOT NULL,
year SMALLINT,
PRIMARY KEY (id_inst),
FOREIGN KEY (id_site) REFERENCES sites (id_site)
ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (id_config) REFERENCES configurations (id_config)
ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (id_segm) REFERENCES segments (id_segm)
ON DELETE CASCADE ON UPDATE CASCADE
);

# CREATE TABLE with ranks of installed supercomputers
# rmax: measured LINPACK performance; rpeak: estimated theoretical maximum; nmax: size of calculated problem for rmax result
CREATE TABLE IF NOT EXISTS ranks(
id_rank SMALLINT NOT NULL,
id_position SMALLINT NOT NULL,
id_inst MEDIUMINT NOT NULL,
rmax DOUBLE,
rpeak DOUBLE,
nmax INTEGER,
CONSTRAINT PK_RANK PRIMARY KEY (id_rank, id_position),
FOREIGN KEY (id_rank) REFERENCES rankmonths (id_rank)
ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (id_inst) REFERENCES installations (id_inst)
ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS rankusers(
id_user SMALLINT NOT NULL AUTO_INCREMENT,
login VARCHAR(20) NOT NULL UNIQUE,
passwd VARCHAR(20) NOT NULL,
hashcode VARCHAR(64),
email VARCHAR(30),
username VARCHAR(30),
userrole VARCHAR(20),
accesslevel SMALLINT,
accountstatus SMALLINT,
PRIMARY KEY (id_user)
);

# CREATE VIEW #1 - VIEW ALL RANKS - SIMPLE
# DISPLAY JOINS - RANKS, RANKMONTHS, INSTALLATIONS, SITES, COUNTRIES, SEGMENTS, CONFIGURATIONS
CREATE VIEW view_allranks_simple AS SELECT t1.id_rank, t2.year_rank, t2.month_rank, t1.id_position, t7.computer, t7.processors_cores, t5.country, t5.id_cc, t1.rmax AS 'rmax [GFlop/s]', t1.rpeak AS 'rpeak [GFlop/s]', round(100*t1.rmax/t1.rpeak,0) AS 'rmax2rpeak [%]' FROM ranks AS t1 JOIN rankmonths AS t2 ON t1.id_rank=t2.id_rank JOIN installations AS t3 ON t1.id_inst=t3.id_inst JOIN sites AS t4 ON t3.id_site=t4.id_site JOIN countries AS t5 ON t4.id_cc=t5.id_cc JOIN segments AS t6 ON t3.id_segm=t6.id_segm JOIN configurations AS t7 ON t3.id_config=t7.id_config ORDER BY t1.id_rank DESC, t1.id_position ASC;

# CREATE VIEW #2 - VIEW ALL RANKS - DETAILED
# DISPLAY JOINS - RANKS, RANKMONTHS, INSTALLATIONS, SITES, COUNTRIES, SEGMENTS, CONFIGURATIONS, MANUFACTURERS, PROCESSORS, OPSYSTEMS, ARCHITECTURES
CREATE VIEW view_allranks_detailed AS SELECT t1.id_rank, t2.year_rank, t2.month_rank, t1.id_position, t4.site, t5.country, t5.id_cc, t8.manufacturer, t9.processor, t9.processor_speed AS 'processor_speed [MHz]', t10.operating_system, t11.architecture, t7.processors_cores, t1.rmax AS 'rmax [GFlop/s]', t1.rpeak AS 'rpeak [GFlop/s]', round(100*t1.rmax/t1.rpeak,0) AS 'rmax2rpeak [%]' FROM ranks AS t1 JOIN rankmonths AS t2 ON t1.id_rank=t2.id_rank JOIN installations AS t3 ON t1.id_inst=t3.id_inst JOIN sites AS t4 ON t3.id_site=t4.id_site JOIN countries AS t5 ON t4.id_cc=t5.id_cc JOIN segments AS t6 ON t3.id_segm=t6.id_segm JOIN configurations AS t7 ON t3.id_config=t7.id_config JOIN manufacturers AS t8 ON t7.id_manufact=t8.id_manufact JOIN processors AS t9 ON t7.id_proc=t9.id_proc JOIN opsystems AS t10 ON t7.id_opsys=t10.id_opsys JOIN architectures AS t11 ON t7.id_arch=t11.id_arch ORDER BY t1.id_rank DESC, t1.id_position ASC;

# CREATE VIEW #3 - VIEW NEWEST RANK
# DISPLAY JOINS - RANKS, RANKMONTHS, INSTALLATIONS, SITES, COUNTRIES, SEGMENTS, CONFIGURATIONS
CREATE VIEW view_newestrank AS SELECT t1.id_rank, t2.year_rank, t2.month_rank, t1.id_position, t7.computer, t7.processors_cores, t5.country, t5.id_cc, t1.rmax AS 'rmax [GFlop/s]', t1.rpeak AS 'rpeak [GFlop/s]', round(100*t1.rmax/t1.rpeak,0) AS 'rmax2rpeak [%]' FROM ranks AS t1 JOIN rankmonths AS t2 ON t1.id_rank=t2.id_rank JOIN installations AS t3 ON t1.id_inst=t3.id_inst JOIN sites AS t4 ON t3.id_site=t4.id_site JOIN countries AS t5 ON t4.id_cc=t5.id_cc JOIN segments AS t6 ON t3.id_segm=t6.id_segm JOIN configurations AS t7 ON t3.id_config=t7.id_config WHERE t1.id_rank = (SELECT max(id_rank) FROM rankmonths) ORDER BY t1.id_rank DESC, t1.id_position ASC;

# CREATE VIEW #4 - VIEW RANKS FOR POLAND
# DISPLAY JOINS - RANKS, RANKMONTHS, INSTALLATIONS, SITES, COUNTRIES, SEGMENTS, CONFIGURATIONS, MANUFACTURERS, PROCESSORS, OPSYSTEMS, ARCHITECTURES
CREATE VIEW view_polranks AS SELECT t1.id_rank, t2.year_rank, t2.month_rank, t1.id_position, t4.site, t8.manufacturer, t9.processor, t9.processor_speed AS 'processor_speed [MHz]', t10.operating_system, t11.architecture, t7.processors_cores, t1.rmax AS 'rmax [GFlop/s]', t1.rpeak AS 'rpeak [GFlop/s]', round(100*t1.rmax/t1.rpeak,0) AS 'rmax2rpeak [%]' FROM ranks AS t1 JOIN rankmonths AS t2 ON t1.id_rank=t2.id_rank JOIN installations AS t3 ON t1.id_inst=t3.id_inst JOIN sites AS t4 ON t3.id_site=t4.id_site JOIN countries AS t5 ON t4.id_cc=t5.id_cc JOIN segments AS t6 ON t3.id_segm=t6.id_segm JOIN configurations AS t7 ON t3.id_config=t7.id_config JOIN manufacturers AS t8 ON t7.id_manufact=t8.id_manufact JOIN processors AS t9 ON t7.id_proc=t9.id_proc JOIN opsystems AS t10 ON t7.id_opsys=t10.id_opsys JOIN architectures AS t11 ON t7.id_arch=t11.id_arch WHERE t5.id_cc = "POL" ORDER BY t1.id_rank DESC, t1.id_position ASC;

USE top500rank;
