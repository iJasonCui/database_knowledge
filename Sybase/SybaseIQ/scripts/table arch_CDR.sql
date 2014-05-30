CREATE TABLE "arch_CDR"."DNISLIST" (
	"DNIS" char(12) NOT NULL 
) IN "IQ_SYSTEM_MAIN";
CREATE TABLE "arch_CDR"."LavaCDR" (
	"startDate" "datetime" NOT NULL ,
	"duration" integer NOT NULL ,
	"connString" char(50) NOT NULL ,
	"ani" char(30) NOT NULL ,
	"dnis" char(30) NOT NULL ,
	"callType" char(3) NOT NULL ,
	"fileDate" "datetime" NOT NULL ,
	"vruServer" char(50) NOT NULL 
) IN "IQ_SYSTEM_MAIN";
CREATE TABLE "arch_CDR"."LavaCDRLoadSum" (
	"fileDate" "datetime" NOT NULL  UNIQUE,
	"rowCount" integer NULL ,
	"dateCreated" "datetime" NOT NULL ,
) IN "IQ_SYSTEM_MAIN";
CREATE TABLE "arch_CDR"."Level3Cdr_LL" (
	"startDate" "datetime" NOT NULL ,
	"ani" char(10) NOT NULL ,
	"dnis" char(10) NOT NULL ,
	"charge" double NOT NULL ,
	"duration" integer NOT NULL ,
	"billnum" char(10) NOT NULL ,
	"fromCity" char(10) NOT NULL ,
	"fromState" char(2) NOT NULL ,
	"toCity" char(10) NOT NULL ,
	"toState" char(2) NOT NULL ,
	"settlement" char(1) NOT NULL ,
	"fileDate" "datetime" NOT NULL ,
	"sourceDir" char(4) NOT NULL 
) IN "IQ_SYSTEM_MAIN";
CREATE TABLE "arch_CDR"."Level3Cdr_LL_0252" (
	"startDate" "datetime" NOT NULL ,
	"ani" char(10) NOT NULL ,
	"dnis" char(10) NOT NULL ,
	"charge" double NOT NULL ,
	"duration" integer NOT NULL ,
	"billnum" char(10) NOT NULL ,
	"fromCity" char(10) NOT NULL ,
	"fromState" char(2) NOT NULL ,
	"toCity" char(10) NOT NULL ,
	"toState" char(2) NOT NULL ,
	"settlement" char(1) NOT NULL ,
	"fileDate" "datetime" NOT NULL ,
	"sourceDir" char(4) NOT NULL 
) IN "IQ_SYSTEM_MAIN";
CREATE TABLE "arch_CDR"."Level3Cdr_ML" (
	"startDate" "datetime" NOT NULL ,
	"ani" char(10) NOT NULL ,
	"dnis" char(10) NOT NULL ,
	"charge" double NOT NULL ,
	"duration" integer NOT NULL ,
	"billnum" char(10) NOT NULL ,
	"fromCity" char(10) NOT NULL ,
	"fromState" char(2) NOT NULL ,
	"toCity" char(10) NOT NULL ,
	"toState" char(2) NOT NULL ,
	"settlement" char(1) NOT NULL ,
	"fileDate" "datetime" NOT NULL ,
	"sourceDir" char(4) NOT NULL 
) IN "IQ_SYSTEM_MAIN";
CREATE TABLE "arch_CDR"."Level3Cdr_NE" (
	"startDate" "datetime" NOT NULL ,
	"ani" char(10) NOT NULL ,
	"dnis" char(10) NOT NULL ,
	"charge" double NOT NULL ,
	"duration" integer NOT NULL ,
	"billnum" char(10) NOT NULL ,
	"fromCity" char(10) NOT NULL ,
	"fromState" char(2) NOT NULL ,
	"toCity" char(10) NOT NULL ,
	"toState" char(2) NOT NULL ,
	"settlement" char(1) NOT NULL ,
	"fileDate" "datetime" NOT NULL ,
	"sourceDir" char(4) NOT NULL 
) IN "IQ_SYSTEM_MAIN";
CREATE TABLE "arch_CDR"."Level3CdrLoadSum" (
	"fileDate" "datetime" NOT NULL ,
	"product" char(2) NOT NULL ,
	"sourceDir" char(4) NOT NULL ,
	"rowCount" integer NULL ,
	"dateCreated" "datetime" NOT NULL 
) IN "IQ_SYSTEM_MAIN";
