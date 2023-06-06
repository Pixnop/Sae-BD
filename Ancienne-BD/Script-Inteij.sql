CREATE TABLE "FIEVETL"."ABSENCES_DATA"
(	"IDETUDIANT" VARCHAR2(100),
     "NOM" VARCHAR2(100),
     "PRENOM" VARCHAR2(100),
     "IDCOURS" VARCHAR2(100),
     "IDMODULE" VARCHAR2(100),
     "NOMMODULE" VARCHAR2(100),
     "IDSEMESTRE" VARCHAR2(100),
     "PROMOTION" VARCHAR2(100),
     "NUMSEMESTRE" VARCHAR2(100),
     "JOURABSENCE" VARCHAR2(100),
     "ESTABS" VARCHAR2(100),
     "ESTJUST" VARCHAR2(100),
     "MATIN" VARCHAR2(100),
     "MOTIFABSENCE" VARCHAR2(100)
) SEGMENT CREATION IMMEDIATE
    PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
    NOCOMPRESS LOGGING
    STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
    PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
    BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
    TABLESPACE "ANNEE1" ;
;

CREATE TABLE "FIEVETL"."ADMISSIONS"
(	"IDADMISSION" NUMBER(15,10),
     "NOTEFRANCAIS" VARCHAR2(50),
     "NOTEANGLAIS" VARCHAR2(50),
     "NOTEPHYSIQUE" VARCHAR2(50),
     "NOTEMATH" VARCHAR2(50),
     "NOMSPECIALITE" VARCHAR2(50),
     "APPELATIONBAC" VARCHAR2(50),
     "IDETUDIANT" VARCHAR2(100) NOT NULL ENABLE,
     PRIMARY KEY ("IDADMISSION")
         USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255
             TABLESPACE "ANNEE1"  ENABLE,
     UNIQUE ("IDETUDIANT")
         USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255
             TABLESPACE "ANNEE1"  ENABLE
) SEGMENT CREATION DEFERRED
    PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
    NOCOMPRESS LOGGING
    TABLESPACE "ANNEE1" ;

CREATE UNIQUE INDEX "FIEVETL"."SYS_C00977264" ON "FIEVETL"."ADMISSIONS" ("IDETUDIANT")
    PCTFREE 10 INITRANS 2 MAXTRANS 255
    TABLESPACE "ANNEE1" ;
CREATE UNIQUE INDEX "FIEVETL"."SYS_C00977263" ON "FIEVETL"."ADMISSIONS" ("IDADMISSION")
    PCTFREE 10 INITRANS 2 MAXTRANS 255
    TABLESPACE "ANNEE1" ;
;

CREATE TABLE "FIEVETL"."ANNEE"
(	"ANNEE" NUMBER(*,0),
     PRIMARY KEY ("ANNEE")
         USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255
             TABLESPACE "ANNEE1"  ENABLE
) SEGMENT CREATION DEFERRED
    PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
    NOCOMPRESS LOGGING
    TABLESPACE "ANNEE1" ;

CREATE UNIQUE INDEX "FIEVETL"."SYS_C00977227" ON "FIEVETL"."ANNEE" ("ANNEE")
    PCTFREE 10 INITRANS 2 MAXTRANS 255
    TABLESPACE "ANNEE1" ;
;

CREATE TABLE "FIEVETL"."ASSOANNEEADMISSION"
(	"IDADMISSION" NUMBER(15,10),
     "ANNEE" NUMBER(*,0),
     PRIMARY KEY ("IDADMISSION", "ANNEE")
         USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255
             TABLESPACE "ANNEE1"  ENABLE
) SEGMENT CREATION DEFERRED
    PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
    NOCOMPRESS LOGGING
    TABLESPACE "ANNEE1" ;

CREATE UNIQUE INDEX "FIEVETL"."SYS_C00977271" ON "FIEVETL"."ASSOANNEEADMISSION" ("IDADMISSION", "ANNEE")
    PCTFREE 10 INITRANS 2 MAXTRANS 255
    TABLESPACE "ANNEE1" ;
;

CREATE TABLE "FIEVETL"."ASSOBACANNEE"
(	"IDADMISSION" NUMBER(15,10),
     "ANNEE" NUMBER(*,0),
     PRIMARY KEY ("IDADMISSION", "ANNEE")
         USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255
             TABLESPACE "ANNEE1"  ENABLE
) SEGMENT CREATION DEFERRED
    PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
    NOCOMPRESS LOGGING
    TABLESPACE "ANNEE1" ;

CREATE UNIQUE INDEX "FIEVETL"."SYS_C00977294" ON "FIEVETL"."ASSOBACANNEE" ("IDADMISSION", "ANNEE")
    PCTFREE 10 INITRANS 2 MAXTRANS 255
    TABLESPACE "ANNEE1" ;
;

CREATE TABLE "FIEVETL"."ASSOMODULE"
(	"IDMODULE" VARCHAR2(50),
     "IDUE" VARCHAR2(50),
     PRIMARY KEY ("IDMODULE", "IDUE")
         USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255
             TABLESPACE "ANNEE1"  ENABLE
) SEGMENT CREATION DEFERRED
    PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
    NOCOMPRESS LOGGING
    TABLESPACE "ANNEE1" ;

CREATE UNIQUE INDEX "FIEVETL"."SYS_C00977288" ON "FIEVETL"."ASSOMODULE" ("IDMODULE", "IDUE")
    PCTFREE 10 INITRANS 2 MAXTRANS 255
    TABLESPACE "ANNEE1" ;
;

CREATE TABLE "FIEVETL"."ASSOVILLECODEPOSTAL"
(	"NOMVILLE" VARCHAR2(100),
     "CODEPOSTALE" NUMBER(*,0),
     PRIMARY KEY ("NOMVILLE", "CODEPOSTALE")
         USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255
             TABLESPACE "ANNEE1"  ENABLE
) SEGMENT CREATION DEFERRED
    PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
    NOCOMPRESS LOGGING
    TABLESPACE "ANNEE1" ;

CREATE UNIQUE INDEX "FIEVETL"."SYS_C00977297" ON "FIEVETL"."ASSOVILLECODEPOSTAL" ("NOMVILLE", "CODEPOSTALE")
    PCTFREE 10 INITRANS 2 MAXTRANS 255
    TABLESPACE "ANNEE1" ;
;

CREATE TABLE "FIEVETL"."AVOIRETUDIE"
(	"CODELYCEE" VARCHAR2(100),
     "IDADMISSION" NUMBER(15,10),
     PRIMARY KEY ("CODELYCEE", "IDADMISSION")
         USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255
             TABLESPACE "ANNEE1"  ENABLE
) SEGMENT CREATION DEFERRED
    PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
    NOCOMPRESS LOGGING
    TABLESPACE "ANNEE1" ;

CREATE UNIQUE INDEX "FIEVETL"."SYS_C00977268" ON "FIEVETL"."AVOIRETUDIE" ("CODELYCEE", "IDADMISSION")
    PCTFREE 10 INITRANS 2 MAXTRANS 255
    TABLESPACE "ANNEE1" ;
;

CREATE TABLE "FIEVETL"."BAC"
(	"APPELATIONBAC" VARCHAR2(50),
     PRIMARY KEY ("APPELATIONBAC")
         USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255
             TABLESPACE "ANNEE1"  ENABLE
) SEGMENT CREATION DEFERRED
    PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
    NOCOMPRESS LOGGING
    TABLESPACE "ANNEE1" ;

CREATE UNIQUE INDEX "FIEVETL"."SYS_C00977214" ON "FIEVETL"."BAC" ("APPELATIONBAC")
    PCTFREE 10 INITRANS 2 MAXTRANS 255
    TABLESPACE "ANNEE1" ;
;

CREATE TABLE "FIEVETL"."BUREAU"
(	"NUMBUREAU" VARCHAR2(50),
     "TELEPHONEBUREAU" VARCHAR2(50),
     PRIMARY KEY ("NUMBUREAU")
         USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255
             TABLESPACE "ANNEE1"  ENABLE
) SEGMENT CREATION DEFERRED
    PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
    NOCOMPRESS LOGGING
    TABLESPACE "ANNEE1" ;

CREATE UNIQUE INDEX "FIEVETL"."SYS_C00977221" ON "FIEVETL"."BUREAU" ("NUMBUREAU")
    PCTFREE 10 INITRANS 2 MAXTRANS 255
    TABLESPACE "ANNEE1" ;
;

CREATE TABLE "FIEVETL"."COURS"
(	"IDCOURS" VARCHAR2(50),
     "IDUTILISATEUR" VARCHAR2(50),
     "IDSEMESTRE" VARCHAR2(50) NOT NULL ENABLE,
     "IDMODULE" VARCHAR2(50) NOT NULL ENABLE,
     PRIMARY KEY ("IDCOURS")
         USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255
             TABLESPACE "ANNEE1"  ENABLE
) SEGMENT CREATION DEFERRED
    PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
    NOCOMPRESS LOGGING
    TABLESPACE "ANNEE1" ;

CREATE UNIQUE INDEX "FIEVETL"."SYS_C00977255" ON "FIEVETL"."COURS" ("IDCOURS")
    PCTFREE 10 INITRANS 2 MAXTRANS 255
    TABLESPACE "ANNEE1" ;
;

CREATE TABLE "FIEVETL"."COURS_ENSEIGNANTS_DATA"
(	"IDCOURS" VARCHAR2(100),
     "IDSEMESTRE" VARCHAR2(100),
     "PROMOTION" VARCHAR2(100),
     "NUMSEMESTRE" VARCHAR2(100),
     "IDMODULE" VARCHAR2(100),
     "NOMMODULE" VARCHAR2(100),
     "CODEMODULE" VARCHAR2(100),
     "HEURES_CM" VARCHAR2(100),
     "HEURES_TD" VARCHAR2(100),
     "HEURES_TP" VARCHAR2(100),
     "COEFFICIENTMODULE" VARCHAR2(100),
     "IDUE" VARCHAR2(100),
     "NOMUE" VARCHAR2(100),
     "CODEUE" VARCHAR2(100),
     "COEFFICIENTFUE" VARCHAR2(100),
     "ECTS" VARCHAR2(100),
     "IDENSEIGNANTRESPONSABLE" VARCHAR2(100),
     "NOMENSEIGNANTRESPONSABLE" VARCHAR2(100),
     "PRENOMENSEIGNANTRESPONSABLE" VARCHAR2(100),
     "IDINTERVENANT" VARCHAR2(100),
     "NOMINTERVENANT" VARCHAR2(100),
     "PRENOMINTERVENANT" VARCHAR2(100)
) SEGMENT CREATION IMMEDIATE
    PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
    NOCOMPRESS LOGGING
    STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
    PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
    BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
    TABLESPACE "ANNEE1" ;
;

CREATE TABLE "FIEVETL"."DATES"
(	"DATES" VARCHAR2(50),
     PRIMARY KEY ("DATES")
         USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255
             TABLESPACE "ANNEE1"  ENABLE
) SEGMENT CREATION DEFERRED
    PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
    NOCOMPRESS LOGGING
    TABLESPACE "ANNEE1" ;

CREATE UNIQUE INDEX "FIEVETL"."SYS_C00977215" ON "FIEVETL"."DATES" ("DATES")
    PCTFREE 10 INITRANS 2 MAXTRANS 255
    TABLESPACE "ANNEE1" ;
;

CREATE TABLE "FIEVETL"."DEPARTEMENT"
(	"NOMDEPARTEMENT" VARCHAR2(50),
     PRIMARY KEY ("NOMDEPARTEMENT")
         USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255
             TABLESPACE "ANNEE1"  ENABLE
) SEGMENT CREATION DEFERRED
    PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
    NOCOMPRESS LOGGING
    TABLESPACE "ANNEE1" ;

CREATE UNIQUE INDEX "FIEVETL"."SYS_C00977213" ON "FIEVETL"."DEPARTEMENT" ("NOMDEPARTEMENT")
    PCTFREE 10 INITRANS 2 MAXTRANS 255
    TABLESPACE "ANNEE1" ;
;

CREATE TABLE "FIEVETL"."DOMICILE"
(	"ADRESSEDOMICILE" VARCHAR2(50),
     "TYPEDEDOMICILE" VARCHAR2(50) NOT NULL ENABLE,
     "CODEPOSTALE" NUMBER(*,0) NOT NULL ENABLE,
     "NOMVILLE" VARCHAR2(100) NOT NULL ENABLE,
     PRIMARY KEY ("ADRESSEDOMICILE")
         USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255
             TABLESPACE "ANNEE1"  ENABLE
) SEGMENT CREATION DEFERRED
    PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
    NOCOMPRESS LOGGING
    TABLESPACE "ANNEE1" ;

CREATE UNIQUE INDEX "FIEVETL"."SYS_C00977238" ON "FIEVETL"."DOMICILE" ("ADRESSEDOMICILE")
    PCTFREE 10 INITRANS 2 MAXTRANS 255
    TABLESPACE "ANNEE1" ;
;

CREATE TABLE "FIEVETL"."ENSEIGNEMENT"
(	"IDCOURS_ENSEIGNANT" VARCHAR2(50),
     "IDUTILISATEUR" VARCHAR2(50),
     PRIMARY KEY ("IDCOURS_ENSEIGNANT", "IDUTILISATEUR")
         USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255
             TABLESPACE "ANNEE1"  ENABLE
) SEGMENT CREATION DEFERRED
    PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
    NOCOMPRESS LOGGING
    TABLESPACE "ANNEE1" ;

CREATE UNIQUE INDEX "FIEVETL"."SYS_C00977291" ON "FIEVETL"."ENSEIGNEMENT" ("IDCOURS_ENSEIGNANT", "IDUTILISATEUR")
    PCTFREE 10 INITRANS 2 MAXTRANS 255
    TABLESPACE "ANNEE1" ;
;

CREATE TABLE "FIEVETL"."ETREABSENT"
(	"IDETUDIANT" VARCHAR2(100),
     "DATES" VARCHAR2(50),
     "IDCOURS" VARCHAR2(50),
     "MATIN" VARCHAR2(50),
     "JUSTIFIEE" VARCHAR2(50),
     "MOTIFABSENCE" VARCHAR2(50),
     "ESTABSENT" VARCHAR2(50),
     PRIMARY KEY ("IDETUDIANT", "DATES", "IDCOURS", "MATIN")
         USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255
             TABLESPACE "ANNEE1"  ENABLE
) SEGMENT CREATION DEFERRED
    PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
    NOCOMPRESS LOGGING
    TABLESPACE "ANNEE1" ;

CREATE UNIQUE INDEX "FIEVETL"."SYS_C00977280" ON "FIEVETL"."ETREABSENT" ("IDETUDIANT", "DATES", "IDCOURS", "MATIN")
    PCTFREE 10 INITRANS 2 MAXTRANS 255
    TABLESPACE "ANNEE1" ;
;

CREATE TABLE "FIEVETL"."ETREFORME"
(	"CODETYPEFORMATION" VARCHAR2(50),
     "IDSEMESTRE" VARCHAR2(50),
     PRIMARY KEY ("CODETYPEFORMATION", "IDSEMESTRE")
         USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255
             TABLESPACE "ANNEE1"  ENABLE
) SEGMENT CREATION DEFERRED
    PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
    NOCOMPRESS LOGGING
    TABLESPACE "ANNEE1" ;

CREATE UNIQUE INDEX "FIEVETL"."SYS_C00977306" ON "FIEVETL"."ETREFORME" ("CODETYPEFORMATION", "IDSEMESTRE")
    PCTFREE 10 INITRANS 2 MAXTRANS 255
    TABLESPACE "ANNEE1" ;
;

CREATE TABLE "FIEVETL"."ETREINTERVENANT"
(	"IDCOURS_INTERVENANT" VARCHAR2(50),
     "IDUTILISATEUR" VARCHAR2(50),
     PRIMARY KEY ("IDCOURS_INTERVENANT", "IDUTILISATEUR")
         USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255
             TABLESPACE "ANNEE1"  ENABLE
) SEGMENT CREATION DEFERRED
    PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
    NOCOMPRESS LOGGING
    TABLESPACE "ANNEE1" ;

CREATE UNIQUE INDEX "FIEVETL"."SYS_C00977300" ON "FIEVETL"."ETREINTERVENANT" ("IDCOURS_INTERVENANT", "IDUTILISATEUR")
    PCTFREE 10 INITRANS 2 MAXTRANS 255
    TABLESPACE "ANNEE1" ;
;

CREATE TABLE "FIEVETL"."ETUDIANTCOURS"
(	"IDETUDIANT" VARCHAR2(100),
     "IDCOURS" VARCHAR2(50),
     PRIMARY KEY ("IDETUDIANT", "IDCOURS")
         USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255
             TABLESPACE "ANNEE1"  ENABLE
) SEGMENT CREATION DEFERRED
    PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
    NOCOMPRESS LOGGING
    TABLESPACE "ANNEE1" ;

CREATE UNIQUE INDEX "FIEVETL"."SYS_C00977285" ON "FIEVETL"."ETUDIANTCOURS" ("IDETUDIANT", "IDCOURS")
    PCTFREE 10 INITRANS 2 MAXTRANS 255
    TABLESPACE "ANNEE1" ;
;

CREATE TABLE "FIEVETL"."ETUDIANTS"
(	"IDETUDIANT" VARCHAR2(100),
     "PRENOMETUDIANT" VARCHAR2(100),
     "NOMETUDIANT" VARCHAR2(100),
     "CIVILITÉ" VARCHAR2(100),
     "NOMNATIONALITE" VARCHAR2(50) NOT NULL ENABLE,
     "DATENAISSANCE" VARCHAR2(100),
     "BOURSIER" VARCHAR2(100),
     "IDADMISSION" VARCHAR2(100),
     "EMAILETUDIANT" VARCHAR2(100),
     "MAILPERSO" VARCHAR2(100),
     "NUMEROFIX" VARCHAR2(100) NOT NULL ENABLE,
     "ETATINSCRIPTION" VARCHAR2(50),
     "NUMEROPORTABLE" VARCHAR2(100),
     "IDGROUPE" VARCHAR2(50),
     "ADRESSEDOMICILE" VARCHAR2(50) NOT NULL ENABLE,
     "NOMVILLE" VARCHAR2(100) NOT NULL ENABLE,
     PRIMARY KEY ("IDETUDIANT")
         USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255
             TABLESPACE "ANNEE1"  ENABLE
) SEGMENT CREATION DEFERRED
    PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
    NOCOMPRESS LOGGING
    TABLESPACE "ANNEE1" ;

CREATE UNIQUE INDEX "FIEVETL"."SYS_C00977246" ON "FIEVETL"."ETUDIANTS" ("IDETUDIANT")
    PCTFREE 10 INITRANS 2 MAXTRANS 255
    TABLESPACE "ANNEE1" ;
;

CREATE TABLE "FIEVETL"."ETUDIANTS_DATA"
(	"IDETUDIANT" VARCHAR2(100),
     "NOM" VARCHAR2(100),
     "PRENOM" VARCHAR2(100),
     "CIVILITE" VARCHAR2(100),
     "DATE_NAISSANCE" VARCHAR2(100),
     "LIEU_NAISSANCE" VARCHAR2(100),
     "DEPT_NAISSANCE" VARCHAR2(100),
     "NATIONALITE" VARCHAR2(100),
     "EMAIL" VARCHAR2(100),
     "EMAILPERSO" VARCHAR2(100),
     "DOMICILE" VARCHAR2(100),
     "CODEPOSTALDOMICILE" VARCHAR2(100),
     "VILLEDOMICILE" VARCHAR2(100),
     "PAYSDOMICILE" VARCHAR2(100),
     "TELEPHONE" VARCHAR2(100),
     "TELEPHONEMOBILE" VARCHAR2(100),
     "TYPEADRESSE" VARCHAR2(100),
     "BOURSIER" VARCHAR2(100),
     "IDADMISSION" VARCHAR2(100),
     "ANNEEADMISSION" VARCHAR2(100),
     "BAC" VARCHAR2(100),
     "SPECIALITE" VARCHAR2(100),
     "ANNEE_BAC" VARCHAR2(100),
     "MATH" VARCHAR2(100),
     "PHYSIQUE" VARCHAR2(100),
     "ANGLAIS" VARCHAR2(100),
     "FRANCAIS" VARCHAR2(100),
     "CODELYCEE" VARCHAR2(100),
     "NOMLYCEE" VARCHAR2(100),
     "VILLELYCEE" VARCHAR2(100),
     "CODEPOSTALLYCEE" VARCHAR2(100)
) SEGMENT CREATION IMMEDIATE
    PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
    NOCOMPRESS LOGGING
    STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
    PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
    BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
    TABLESPACE "ANNEE1" ;
;

CREATE TABLE "FIEVETL"."ETUDIANT_COURS_DATA"
(	"IDETUDIANT" VARCHAR2(100),
     "NOM" VARCHAR2(100),
     "PRENOM" VARCHAR2(100),
     "IDCOURS" VARCHAR2(100),
     "IDMODULE" VARCHAR2(100),
     "NOMMODULE" VARCHAR2(100),
     "IDSEMESTRE" VARCHAR2(100),
     "NUMEROSEMESTRE" VARCHAR2(100),
     "PROMOTION" VARCHAR2(100)
) SEGMENT CREATION IMMEDIATE
    PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
    NOCOMPRESS LOGGING
    STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
    PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
    BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
    TABLESPACE "ANNEE1" ;
;

CREATE TABLE "FIEVETL"."ETUDIANT_SEMESTRE_DATA"
(	"IDETUDIANT" VARCHAR2(100),
     "NOM" VARCHAR2(100),
     "PRENOM" VARCHAR2(100),
     "ETATINSCRIPTION" VARCHAR2(100),
     "IDSEMESTRE" VARCHAR2(100),
     "NUMEROSEMESTRE" VARCHAR2(100),
     "PROMOTION" VARCHAR2(100),
     "DATEDEBUTSEMESTRE" VARCHAR2(100),
     "DATEFINSEMESTRE" VARCHAR2(100),
     "CODETYPEFORMATION" VARCHAR2(100),
     "NOMTYPEFORMATION" VARCHAR2(100)
) SEGMENT CREATION IMMEDIATE
    PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
    NOCOMPRESS LOGGING
    STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
    PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
    BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
    TABLESPACE "ANNEE1" ;
;

CREATE TABLE "FIEVETL"."ETUDIERSEMESTRE"
(	"IDETUDIANT" VARCHAR2(100),
     "IDSEMESTRE" VARCHAR2(50),
     "ETATINSCRIPTION" VARCHAR2(50),
     PRIMARY KEY ("IDETUDIANT", "IDSEMESTRE")
         USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255
             TABLESPACE "ANNEE1"  ENABLE
) SEGMENT CREATION DEFERRED
    PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
    NOCOMPRESS LOGGING
    TABLESPACE "ANNEE1" ;

CREATE UNIQUE INDEX "FIEVETL"."SYS_C00977274" ON "FIEVETL"."ETUDIERSEMESTRE" ("IDETUDIANT", "IDSEMESTRE")
    PCTFREE 10 INITRANS 2 MAXTRANS 255
    TABLESPACE "ANNEE1" ;
;

CREATE TABLE "FIEVETL"."EVALUATIONS"
(	"IDEVALUATION" VARCHAR2(50),
     "COEFFICIENT" VARCHAR2(50),
     "IDUTILISATEUR" VARCHAR2(50),
     "IDCOURS" VARCHAR2(50),
     PRIMARY KEY ("IDEVALUATION")
         USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255
             TABLESPACE "ANNEE1"  ENABLE
) SEGMENT CREATION DEFERRED
    PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
    NOCOMPRESS LOGGING
    TABLESPACE "ANNEE1" ;

CREATE UNIQUE INDEX "FIEVETL"."SYS_C00977259" ON "FIEVETL"."EVALUATIONS" ("IDEVALUATION")
    PCTFREE 10 INITRANS 2 MAXTRANS 255
    TABLESPACE "ANNEE1" ;
;

CREATE TABLE "FIEVETL"."GROUPES"
(	"IDGROUPE" VARCHAR2(50),
     "NOMGROUPE" VARCHAR2(50),
     PRIMARY KEY ("IDGROUPE")
         USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255
             TABLESPACE "ANNEE1"  ENABLE
) SEGMENT CREATION DEFERRED
    PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
    NOCOMPRESS LOGGING
    TABLESPACE "ANNEE1" ;

CREATE UNIQUE INDEX "FIEVETL"."SYS_C00977218" ON "FIEVETL"."GROUPES" ("IDGROUPE")
    PCTFREE 10 INITRANS 2 MAXTRANS 255
    TABLESPACE "ANNEE1" ;
;

CREATE TABLE "FIEVETL"."GROUPES_DATA"
(	"IDETUDIANT" VARCHAR2(100),
     "NOM" VARCHAR2(100),
     "PRENOM" VARCHAR2(100),
     "IDGROUPE" VARCHAR2(100),
     "NOMGROUPE" VARCHAR2(100),
     "IDSEMESTRE" VARCHAR2(100),
     "NUMEROSEMESTRE" VARCHAR2(100),
     "PROMOTION" VARCHAR2(100)
) SEGMENT CREATION IMMEDIATE
    PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
    NOCOMPRESS LOGGING
    STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
    PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
    BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
    TABLESPACE "ANNEE1" ;
;

CREATE TABLE "FIEVETL"."LYCEES"
(	"CODELYCEE" VARCHAR2(100),
     "NOMLYCEE" VARCHAR2(100),
     "CODEPOSTALE" NUMBER(*,0),
     "NOMVILLE" VARCHAR2(100),
     PRIMARY KEY ("CODELYCEE")
         USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255
             TABLESPACE "ANNEE1"  ENABLE
) SEGMENT CREATION DEFERRED
    PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
    NOCOMPRESS LOGGING
    TABLESPACE "ANNEE1" ;

CREATE UNIQUE INDEX "FIEVETL"."SYS_C00977250" ON "FIEVETL"."LYCEES" ("CODELYCEE")
    PCTFREE 10 INITRANS 2 MAXTRANS 255
    TABLESPACE "ANNEE1" ;
;

CREATE TABLE "FIEVETL"."MODULES"
(	"IDMODULE" VARCHAR2(50),
     "HEURECM" VARCHAR2(50),
     "HEURETD" VARCHAR2(50),
     "HEURETP" VARCHAR2(50),
     "COEFFICIENT" VARCHAR2(50),
     "NOMMODULE" VARCHAR2(50),
     "CODEMODULE" VARCHAR2(50),
     PRIMARY KEY ("IDMODULE")
         USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255
             TABLESPACE "ANNEE1"  ENABLE
) SEGMENT CREATION DEFERRED
    PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
    NOCOMPRESS LOGGING
    TABLESPACE "ANNEE1" ;

CREATE UNIQUE INDEX "FIEVETL"."SYS_C00977216" ON "FIEVETL"."MODULES" ("IDMODULE")
    PCTFREE 10 INITRANS 2 MAXTRANS 255
    TABLESPACE "ANNEE1" ;
;

CREATE TABLE "FIEVETL"."NOTER"
(	"IDETUDIANT" VARCHAR2(100),
     "IDEVALUATION" VARCHAR2(50),
     "NOTE" VARCHAR2(50),
     PRIMARY KEY ("IDETUDIANT", "IDEVALUATION")
         USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255
             TABLESPACE "ANNEE1"  ENABLE
) SEGMENT CREATION DEFERRED
    PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
    NOCOMPRESS LOGGING
    TABLESPACE "ANNEE1" ;

CREATE UNIQUE INDEX "FIEVETL"."SYS_C00977303" ON "FIEVETL"."NOTER" ("IDETUDIANT", "IDEVALUATION")
    PCTFREE 10 INITRANS 2 MAXTRANS 255
    TABLESPACE "ANNEE1" ;
;

CREATE TABLE "FIEVETL"."NOTES_DATA"
(	"IDETUDIANT" VARCHAR2(100),
     "NOM" VARCHAR2(100),
     "PRENOM" VARCHAR2(100),
     "NOTE" VARCHAR2(100),
     "IDEVALUATION" VARCHAR2(100),
     "COEFFICIENT" VARCHAR2(100),
     "NOTE_MAX" VARCHAR2(100),
     "IDCOURS" VARCHAR2(100),
     "IDMODULE" VARCHAR2(100),
     "NOMMODULE" VARCHAR2(100),
     "IDSEMESTRE" VARCHAR2(100),
     "PROMOTION" VARCHAR2(100),
     "NUMSEMESTRE" VARCHAR2(100),
     "IDUTILISATEUR" VARCHAR2(100),
     "NOMUTILISATEUR" VARCHAR2(100),
     "PRENOMUTILISATEUR" VARCHAR2(100)
) SEGMENT CREATION IMMEDIATE
    PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
    NOCOMPRESS LOGGING
    STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
    PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
    BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
    TABLESPACE "ANNEE1" ;
;

CREATE TABLE "FIEVETL"."PAYS"
(	"NOMPAYS" VARCHAR2(50),
     PRIMARY KEY ("NOMPAYS")
         USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255
             TABLESPACE "ANNEE1"  ENABLE
) SEGMENT CREATION DEFERRED
    PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
    NOCOMPRESS LOGGING
    TABLESPACE "ANNEE1" ;

CREATE UNIQUE INDEX "FIEVETL"."SYS_C00977226" ON "FIEVETL"."PAYS" ("NOMPAYS")
    PCTFREE 10 INITRANS 2 MAXTRANS 255
    TABLESPACE "ANNEE1" ;
;

CREATE TABLE "FIEVETL"."POSTALE"
(	"CODEPOSTALE" NUMBER(*,0),
     PRIMARY KEY ("CODEPOSTALE")
         USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255
             TABLESPACE "ANNEE1"  ENABLE
) SEGMENT CREATION DEFERRED
    PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
    NOCOMPRESS LOGGING
    TABLESPACE "ANNEE1" ;

CREATE UNIQUE INDEX "FIEVETL"."SYS_C00977223" ON "FIEVETL"."POSTALE" ("CODEPOSTALE")
    PCTFREE 10 INITRANS 2 MAXTRANS 255
    TABLESPACE "ANNEE1" ;
;

CREATE TABLE "FIEVETL"."ROLES"
(	"NOMROLE" VARCHAR2(50),
     PRIMARY KEY ("NOMROLE")
         USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255
             TABLESPACE "ANNEE1"  ENABLE
) SEGMENT CREATION DEFERRED
    PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
    NOCOMPRESS LOGGING
    TABLESPACE "ANNEE1" ;

CREATE UNIQUE INDEX "FIEVETL"."SYS_C00977225" ON "FIEVETL"."ROLES" ("NOMROLE")
    PCTFREE 10 INITRANS 2 MAXTRANS 255
    TABLESPACE "ANNEE1" ;
;

CREATE TABLE "FIEVETL"."SEMESTRE"
(	"IDSEMESTRE" VARCHAR2(50),
     "NUMEROSEMESTRE" VARCHAR2(50),
     "DATEDEBUT" VARCHAR2(50),
     "DATEFIN" VARCHAR2(50),
     "NOMPROMOTION" VARCHAR2(50),
     PRIMARY KEY ("IDSEMESTRE")
         USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255
             TABLESPACE "ANNEE1"  ENABLE
) SEGMENT CREATION DEFERRED
    PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
    NOCOMPRESS LOGGING
    TABLESPACE "ANNEE1" ;

CREATE UNIQUE INDEX "FIEVETL"."SYS_C00977219" ON "FIEVETL"."SEMESTRE" ("IDSEMESTRE")
    PCTFREE 10 INITRANS 2 MAXTRANS 255
    TABLESPACE "ANNEE1" ;
;

CREATE TABLE "FIEVETL"."SPECIALITES"
(	"NOMSPECIALITE" VARCHAR2(50),
     PRIMARY KEY ("NOMSPECIALITE")
         USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255
             TABLESPACE "ANNEE1"  ENABLE
) SEGMENT CREATION DEFERRED
    PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
    NOCOMPRESS LOGGING
    TABLESPACE "ANNEE1" ;

CREATE UNIQUE INDEX "FIEVETL"."SYS_C00977212" ON "FIEVETL"."SPECIALITES" ("NOMSPECIALITE")
    PCTFREE 10 INITRANS 2 MAXTRANS 255
    TABLESPACE "ANNEE1" ;
;

CREATE TABLE "FIEVETL"."TEMPS"
(	"MATIN" VARCHAR2(50),
     PRIMARY KEY ("MATIN")
         USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255
             TABLESPACE "ANNEE1"  ENABLE
) SEGMENT CREATION DEFERRED
    PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
    NOCOMPRESS LOGGING
    TABLESPACE "ANNEE1" ;

CREATE UNIQUE INDEX "FIEVETL"."SYS_C00977228" ON "FIEVETL"."TEMPS" ("MATIN")
    PCTFREE 10 INITRANS 2 MAXTRANS 255
    TABLESPACE "ANNEE1" ;
;

CREATE TABLE "FIEVETL"."TYPEDOMICILE"
(	"TYPEDEDOMICILE" VARCHAR2(50),
     PRIMARY KEY ("TYPEDEDOMICILE")
         USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255
             TABLESPACE "ANNEE1"  ENABLE
) SEGMENT CREATION DEFERRED
    PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
    NOCOMPRESS LOGGING
    TABLESPACE "ANNEE1" ;

CREATE UNIQUE INDEX "FIEVETL"."SYS_C00977222" ON "FIEVETL"."TYPEDOMICILE" ("TYPEDEDOMICILE")
    PCTFREE 10 INITRANS 2 MAXTRANS 255
    TABLESPACE "ANNEE1" ;
;

CREATE TABLE "FIEVETL"."TYPEENSEIGNANT"
(	"TYPEENSEIGNANT" VARCHAR2(50),
     PRIMARY KEY ("TYPEENSEIGNANT")
         USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255
             TABLESPACE "ANNEE1"  ENABLE
) SEGMENT CREATION DEFERRED
    PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
    NOCOMPRESS LOGGING
    TABLESPACE "ANNEE1" ;

CREATE UNIQUE INDEX "FIEVETL"."SYS_C00977224" ON "FIEVETL"."TYPEENSEIGNANT" ("TYPEENSEIGNANT")
    PCTFREE 10 INITRANS 2 MAXTRANS 255
    TABLESPACE "ANNEE1" ;
;

CREATE TABLE "FIEVETL"."TYPEFORMATION"
(	"CODETYPEFORMATION" VARCHAR2(50),
     "NOMTYPEFORMATION" VARCHAR2(50),
     PRIMARY KEY ("CODETYPEFORMATION")
         USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255
             TABLESPACE "ANNEE1"  ENABLE
) SEGMENT CREATION DEFERRED
    PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
    NOCOMPRESS LOGGING
    TABLESPACE "ANNEE1" ;

CREATE UNIQUE INDEX "FIEVETL"."SYS_C00977217" ON "FIEVETL"."TYPEFORMATION" ("CODETYPEFORMATION")
    PCTFREE 10 INITRANS 2 MAXTRANS 255
    TABLESPACE "ANNEE1" ;
;

CREATE TABLE "FIEVETL"."UE"
(	"IDUE" VARCHAR2(50),
     "CODEUE" VARCHAR2(100),
     "NOMUE" VARCHAR2(100),
     "COEFFICIENTUE" VARCHAR2(50),
     "NOMBREECTS" VARCHAR2(50),
     PRIMARY KEY ("IDUE")
         USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255
             TABLESPACE "ANNEE1"  ENABLE
) SEGMENT CREATION DEFERRED
    PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
    NOCOMPRESS LOGGING
    TABLESPACE "ANNEE1" ;

CREATE UNIQUE INDEX "FIEVETL"."SYS_C00977220" ON "FIEVETL"."UE" ("IDUE")
    PCTFREE 10 INITRANS 2 MAXTRANS 255
    TABLESPACE "ANNEE1" ;
;

CREATE TABLE "FIEVETL"."UTILISATEURS"
(	"IDUTILISATEUR" VARCHAR2(50),
     "PRENOMUTILISATEUR" VARCHAR2(50),
     "NOMUTILISATEUR" VARCHAR2(50),
     "MAILUTILISATEUR" VARCHAR2(50),
     "TYPEENSEIGNANT" VARCHAR2(50),
     "NUMBUREAU" VARCHAR2(50),
     PRIMARY KEY ("IDUTILISATEUR")
         USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255
             TABLESPACE "ANNEE1"  ENABLE
) SEGMENT CREATION DEFERRED
    PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
    NOCOMPRESS LOGGING
    TABLESPACE "ANNEE1" ;

CREATE UNIQUE INDEX "FIEVETL"."SYS_C00977232" ON "FIEVETL"."UTILISATEURS" ("IDUTILISATEUR")
    PCTFREE 10 INITRANS 2 MAXTRANS 255
    TABLESPACE "ANNEE1" ;
;

CREATE TABLE "FIEVETL"."UTILISATEURSROLES"
(	"IDUTILISATEUR" VARCHAR2(50),
     "NOMROLE" VARCHAR2(50),
     PRIMARY KEY ("IDUTILISATEUR", "NOMROLE")
         USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255
             TABLESPACE "ANNEE1"  ENABLE
) SEGMENT CREATION DEFERRED
    PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
    NOCOMPRESS LOGGING
    TABLESPACE "ANNEE1" ;

CREATE UNIQUE INDEX "FIEVETL"."SYS_C00977277" ON "FIEVETL"."UTILISATEURSROLES" ("IDUTILISATEUR", "NOMROLE")
    PCTFREE 10 INITRANS 2 MAXTRANS 255
    TABLESPACE "ANNEE1" ;
;

CREATE TABLE "FIEVETL"."UTILISATEURS_DATA"
(	"IDUTILISATEUR" VARCHAR2(100),
     "NOM" VARCHAR2(100),
     "PRENOM" VARCHAR2(100),
     "EMAIL" VARCHAR2(100),
     "TYPEENSEIGNANT" VARCHAR2(100),
     "NUMBUREAU" VARCHAR2(100),
     "TELEPHONEBUREAU" VARCHAR2(100),
     "ROLE" VARCHAR2(100)
) SEGMENT CREATION IMMEDIATE
    PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
    NOCOMPRESS LOGGING
    STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
    PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
    BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
    TABLESPACE "ANNEE1" ;
;

CREATE TABLE "FIEVETL"."VILLES"
(	"NOMVILLE" VARCHAR2(100),
     "NOMPAYS" VARCHAR2(50),
     "NOMDEPARTEMENT" VARCHAR2(50),
     PRIMARY KEY ("NOMVILLE")
         USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255
             TABLESPACE "ANNEE1"  ENABLE
) SEGMENT CREATION DEFERRED
    PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
    NOCOMPRESS LOGGING
    TABLESPACE "ANNEE1" ;

CREATE UNIQUE INDEX "FIEVETL"."SYS_C00977229" ON "FIEVETL"."VILLES" ("NOMVILLE")
    PCTFREE 10 INITRANS 2 MAXTRANS 255
    TABLESPACE "ANNEE1" ;
;