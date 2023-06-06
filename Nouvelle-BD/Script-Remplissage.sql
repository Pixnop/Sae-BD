
--specialites
INSERT INTO FIEVETL.SPECIALITES
SELECT DISTINCT SPECIALITE
From FIEVETL.ETUDIANTS_DATA
WHERE SPECIALITE NOT IN (SELECT DISTINCT SPECIALITE FROM FIEVETL.SPECIALITES)
  AND SPECIALITE IS NOT NULL;
commit;

--departement
INSERT INTO fievetl.departement
SELECT DISTINCT dept_naissance
FROM fievetl.etudiants_data
WHERE dept_naissance NOT IN (SELECT DISTINCT dept_naissance FROM fievetl.departement)
  AND dept_naissance IS NOT NULL;
commit;

--bac
INSERT INTO fievetl.bac
SELECT DISTINCT bac
FROM fievetl.etudiants_data
WHERE bac NOT IN (SELECT DISTINCT bac FROM fievetl.bac)
  AND bac IS NOT NULL;
commit;

--dates
INSERT INTO fievetl.Dates
SELECT DISTINCT jourAbsence
FROM fievetl.Absences_DATA
WHERE jourAbsence IN (SELECT jourAbsence
                      FROM fievetl.Absences_DATA
                      minus
                      SELECT dateS
                      FROM fievetl.Dates);
Commit;

--Module
INSERT INTO FIEVETL.Modules (idModule, heureCM, heureTD, heureTP, coefficient,
                             nomModule, codeModule)
SELECT te3.idModule,
       te3.heures_CM,
       te3.heures_TD,
       te3.heures_TP,
       te3.coefficientmodule,
       te3.nomModule,
       te3.codeModule
FROM (SELECT idModule,
             heures_CM,
             heures_TD,
             heures_TP,
             coefficientmodule,
             nomModule,
             codeModule,
             ROW_NUMBER() OVER (PARTITION BY idModule ORDER BY idModule) AS rn
      FROM fievetl.cours_enseignants_data
      WHERE idModule IS NOT NULL) te3
WHERE te3.rn = 1
  AND NOT EXISTS (SELECT 1
                  FROM FIEVETL.Modules m
                  WHERE m.idModule = te3.idModule);
commit;


INSERT INTO FIEVETL.MODULES (IDMODULE, HEURECM, HEURETD, HEURETP, COEFFICIENT,
                             NOMMODULE, CODEMODULE)
SELECT DISTINCT IDMODULE, null, null, null,null,NOMMODULE, null
FROM fievetl.Notes_data
WHERE IDMODULE IS NOT NULL
  AND IDMODULE IN (SELECT DISTINCT IDMODULE FROM FIEVETL.NOTES_DATA MINUS SELECT DISTINCT IDMODULE FROM FIEVETL.MODULES);


INSERT INTO FIEVETL.Modules (idModule, heureCM, heureTD, heureTP, coefficient,
                             nomModule, codeModule)
SELECT FIEVETL.ABSENCES_DATA.IDMODULE, null, null, null,null,FIEVETL.ABSENCES_DATA.NOMMODULE, null
FROM FIEVETL.ABSENCES_DATA
WHERE IDMODULE IS NOT NULL
  AND IDMODULE IN (SELECT DISTINCT IDMODULE FROM FIEVETL.ABSENCES_DATA MINUS SELECT DISTINCT IDMODULE FROM FIEVETL.MODULES);
commit;


INSERT INTO FIEVETL.MODULES (IDMODULE, HEURECM, HEURETD, HEURETP, COEFFICIENT,
                             NOMMODULE, CODEMODULE)
SELECT DISTINCT IDMODULE, null, null, null,null,NOMMODULE, null
FROM fievetl.ETUDIANT_COURS_DATA
WHERE IDMODULE IS NOT NULL
  AND IDMODULE IN (SELECT DISTINCT IDMODULE FROM FIEVETL.ETUDIANT_COURS_DATA MINUS SELECT DISTINCT IDMODULE FROM FIEVETL.MODULES);
commit;

--typeformation
INSERT INTO fievetl.TypeFormation
SELECT DISTINCT CodeTypeFormation, NomTypeFormation
FROM fievetl.Etudiant_Semestre_data
WHERE CodeTypeFormation NOT IN (SELECT DISTINCT CodeTypeFormation FROM fievetl.TypeFormation)
  AND CodeTypeFormation IS NOT NULL;
commit;

--groupes
INSERT INTO fievetl.groupes
SELECT DISTINCT idgroupe, nomgroupe
FROM fievetl.groupes_data
WHERE idgroupe NOT IN (SELECT DISTINCT idgroupe FROM fievetl.groupes)
  AND idgroupe IS NOT NULL;
commit;

--semestre
INSERT INTO fievetl.Semestre
SELECT DISTINCT IdSemestre, Numerosemestre, DateDebutSemestre, DateFinSemestre,PROMOTION
FROM fievetl.Etudiant_Semestre_data
WHERE IdSemestre IN (SELECT IdSemestre FROM fievetl.Etudiant_Semestre_data  MINUS SELECT IdSemestre FROM fievetl.Semestre )
  AND IdSemestre IS NOT NULL;
commit;

INSERT INTO fievetl.Semestre
SELECT DISTINCT IdSemestre, NUMSEMESTRE, null, null, PROMOTION
FROM fievetl.COURS_ENSEIGNANTS_DATA
WHERE IdSemestre IN (SELECT IdSemestre FROM COURS_ENSEIGNANTS_DATA
                                       MINUS SELECT IdSemestre FROM fievetl.Semestre )
  AND IdSemestre IS NOT NULL;
commit;

INSERT INTO fievetl.Semestre
SELECT DISTINCT IdSemestre, NUMSEMESTRE, null, null, PROMOTION
FROM fievetl.NOTES_DATA
WHERE IdSemestre IN (SELECT IdSemestre FROM NOTES_DATA
                                       MINUS SELECT IdSemestre FROM fievetl.Semestre )
  AND IdSemestre IS NOT NULL;
commit;

INSERT INTO fievetl.Semestre
SELECT DISTINCT IdSemestre, NUMSEMESTRE, null, null, PROMOTION
FROM fievetl.Absences_DATA
WHERE IdSemestre IN (SELECT IdSemestre FROM Absences_DATA
                                       MINUS SELECT IdSemestre FROM fievetl.Semestre )
  AND IdSemestre IS NOT NULL;
commit;

INSERT INTO fievetl.Semestre
SELECT DISTINCT IdSemestre, NUMEROSEMESTRE, null, null, PROMOTION
FROM fievetl.ETUDIANT_COURS_DATA
WHERE IdSemestre IN (SELECT IdSemestre FROM ETUDIANT_COURS_DATA
                                       MINUS SELECT IdSemestre FROM fievetl.Semestre )
  AND IdSemestre IS NOT NULL;
commit;

-- Evaluations
INSERT INTO FIEVETL.Evaluations
SELECT DISTINCT IDEVALUATION, COEFFICIENT
FROM fievetl.NOTES_DATA
WHERE IDEVALUATION IS NOT NULL;
commit;

--UE
INSERT INTO fievetl.UE
SELECT DISTINCT IDUE, NomUE, codeUE, coefficientfUE, ECTS
FROM fievetl.Cours_enseignants_data
WHERE IDUE NOT IN (SELECT DISTINCT IDUE FROM fievetl.UE)
  AND IDUE IS NOT NULL;
commit;

--bureau
INSERT INTO fievetl.Bureau
SELECT DISTINCT numBureau, telephonebureau
FROM fievetl.utilisateurs_data
WHERE numBureau NOT IN (SELECT DISTINCT numBureau FROM fievetl.Bureau)
  AND numBureau IS NOT NULL;
commit;

--typeDomicile
INSERT INTO fievetl.TypeDomicile
SELECT DISTINCT typeadresse
FROM fievetl.etudiants_data
WHERE typeadresse NOT IN (SELECT DISTINCT typeadresse FROM fievetl.TypeDomicile)
  AND typeadresse IS NOT NULL;
commit;


--Postale
INSERT INTO fievetl.Postale
SELECT DISTINCT CodePostalDomicile
FROM fievetl.etudiants_data
WHERE (CodePostalDomicile) in (
    SELECT CodePostalDomicile
    FROM fievetl.etudiants_data
    MINUS
    SELECT CodePostale
    FROM fievetl.Postale
) AND ETUDIANTS_DATA.CODEPOSTALDOMICILE IS NOT NULL;
commit;

INSERT INTO fievetl.Postale
SELECT DISTINCT CODEPOSTALLYCEE
FROM fievetl.etudiants_data ed
WHERE (CODEPOSTALLYCEE) in (
    SELECT CODEPOSTALLYCEE
    FROM fievetl.etudiants_data --minus qui empeche l'insertion de valeurs
) AND ed.CODEPOSTALLYCEE IS NOT NULL;

--typeEnseignant
INSERT INTO fievetl.TypeEnseignant
SELECT DISTINCT typeenseignant
FROM fievetl.utilisateurs_data
WHERE typeenseignant NOT IN (SELECT DISTINCT typeenseignant FROM fievetl.TypeEnseignant)
  AND typeenseignant IS NOT NULL;
commit;

--Roles
INSERT INTO fievetl.Roles
SELECT DISTINCT ut.role
FROM fievetl.utilisateurs_data ut
WHERE role NOT IN (SELECT DISTINCT role FROM fievetl.Roles)
  AND role IS NOT NULL;
commit;

--Pays
INSERT INTO fievetl.Pays
SELECT DISTINCT paysdomicile
FROM fievetl.etudiants_data
WHERE paysdomicile NOT IN (SELECT DISTINCT paysdomicile FROM fievetl.Pays)
  AND paysdomicile IS NOT NULL;
commit;

--Année
INSERT INTO fievetl.annee
SELECT DISTINCT annee_bac
FROM fievetl.etudiants_data
WHERE annee_bac IN (SELECT annee_bac
                    FROM fievetl.etudiants_data
                    minus
                    SELECT ANNEE
                    FROM fievetl.annee);
commit;

INSERT INTO fievetl.annee
SELECT DISTINCT ANNEEADMISSION
FROM fievetl.etudiants_data
WHERE ANNEEADMISSION IN (SELECT ANNEEADMISSION
                         FROM fievetl.etudiants_data
                         minus
                         SELECT ANNEE
                         FROM fievetl.annee);
commit;

--Admissions
INSERT INTO FIEVETL.ADMISSIONS
SELECT DISTINCT ed.idadmission, ed.Francais, ed.Anglais, ed.physique, ed.math, ed.specialite, ed.bac
FROM FIEVETL.ETUDIANTS_DATA ed
WHERE IDADMISSION is not null AND IDADMISSION IN (
    SELECT DISTINCT IDADMISSION FROM FIEVETL.ETUDIANTS_DATA MINUS SELECT DISTINCT IDADMISSION FROM FIEVETL.ADMISSIONS);
commit;


--Villes
INSERT INTO fievetl.Villes
SELECT DISTINCT lieu_Naissance, null, DEPT_NAISSANCE
FROM fievetl.etudiants_data
WHERE lieu_Naissance in (select lieu_Naissance
                         from fievetl.etudiants_data
                         minus
                         select nomVille
                         from fievetl.Villes)
  AND lieu_Naissance IS NOT NULL;
commit;

INSERT INTO fievetl.Villes
SELECT DISTINCT Villelycee, null, null
FROM fievetl.etudiants_data
WHERE VILLELYCEE in (select VILLELYCEE
                     from fievetl.etudiants_data
                     minus
                     select nomVille
                     from fievetl.Villes)
  AND Villelycee IS NOT NULL;

INSERT INTO fievetl.Villes
SELECT DISTINCT VilleDomicile, paysdomicile, null
FROM fievetl.etudiants_data
WHERE VILLEDOMICILE in (select VILLEDOMICILE
                        from fievetl.etudiants_data
                        minus
                        select nomVille
                        from fievetl.Villes)
  AND VilleDomicile IS NOT NULL;
commit;

--utilisateurs--
INSERT INTO fievetl.Utilisateurs
SELECT DISTINCT IdUtilisateur, Prenom, nom, Email, typeenseignant, numbureau
FROM fievetl.utilisateurs_data
WHERE IdUtilisateur IN (SELECT DISTINCT IdUtilisateur FROM fievetl.utilisateurs_data MINUS SELECT DISTINCT IdUtilisateur FROM fievetl.Utilisateurs)
  AND IdUtilisateur IS NOT NULL;
commit;

INSERT INTO fievetl.Utilisateurs
SELECT DISTINCT IDENSEIGNANTRESPONSABLE, PRENOMENSEIGNANTRESPONSABLE, NOMENSEIGNANTRESPONSABLE, null, null, null
FROM fievetl.COURS_ENSEIGNANTS_DATA
WHERE IDENSEIGNANTRESPONSABLE IN (SELECT DISTINCT IDENSEIGNANTRESPONSABLE FROM fievetl.COURS_ENSEIGNANTS_DATA MINUS SELECT DISTINCT IDUTILISATEUR FROM fievetl.Utilisateurs)
  AND IDENSEIGNANTRESPONSABLE IS NOT NULL;
commit;

INSERT INTO fievetl.Utilisateurs
SELECT DISTINCT IDINTERVENANT, PRENOMINTERVENANT, NOMINTERVENANT, null, null, null
FROM FIEVETL.COURS_ENSEIGNANTS_DATA
WHERE IDINTERVENANT IN (SELECT DISTINCT IDINTERVENANT FROM FIEVETL.COURS_ENSEIGNANTS_DATA MINUS SELECT DISTINCT IDUTILISATEUR FROM fievetl.Utilisateurs)
  AND IDINTERVENANT IS NOT NULL;
commit;

INSERT INTO fievetl.Utilisateurs
SELECT DISTINCT IDUTILISATEUR, PRENOMUTILISATEUR, NOMUTILISATEUR, null, null, null
FROM fievetl.NOTES_DATA
WHERE IDUTILISATEUR IN (SELECT DISTINCT IDUTILISATEUR FROM fievetl.NOTES_DATA MINUS SELECT DISTINCT IDUTILISATEUR FROM fievetl.Utilisateurs)
  AND IDUTILISATEUR IS NOT NULL;
commit;

--domicile--
INSERT INTO FIEVETL.domicile (adresseDomicile, TypedeDomicile, CodePostale, nomVille)
SELECT te3.domicile, te3.typeadresse, te3.codePostalDomicile, te3.villedomicile
FROM (SELECT domicile,
             typeadresse,
             codePostalDomicile,
             villedomicile,
             ROW_NUMBER() OVER (PARTITION BY domicile ORDER BY domicile) AS rn
      FROM fievetl.Etudiants_data
      WHERE domicile IS NOT NULL) te3
WHERE te3.rn = 1
  AND NOT EXISTS (SELECT 1
                  FROM FIEVETL.domicile d
                  WHERE d.adresseDomicile = te3.domicile);
commit;


--etudiants--
INSERT INTO fievetl.Etudiants (IdEtudiant, prenomEtudiant, NomEtudiant, civilité,NOMNATIONALITE,DATENAISSANCE, boursier, EmailEtudiant,
                               mailPerso, numeroFix,ETATINSCRIPTION, numeroPortable,IdAdmission,idGroupe,
                               Adressedomicile,nomVille)
SELECT te3.idetudiant,
       te3.prenom,
       te3.nom,
       te3.civilite,
       te3.nationalite,
       te3.date_naissance,
       te3.boursier,
       te3.email,
       te3.emailperso,
       te3.telephone,
       te3.ETATINSCRIPTION,
       te3.telephonemobile,
       te3.idAdmission,
       te3.idGroupe,
       te3.domicile,
       te3.lieu_naissance
FROM (SELECT ed.idetudiant,
             ed.prenom,
             ed.nom,
             ed.civilite,
             ed.NATIONALITE,
             ed.date_naissance,
             ed.boursier,
             ed.email,
             ed.emailperso,
             ed.telephone,
             es.ETATINSCRIPTION,
             ed.telephonemobile,
             ed.idAdmission,
             gd.idGroupe,
             ed.domicile,
             ed.lieu_naissance,
             ROW_NUMBER() OVER (PARTITION BY ed.idetudiant ORDER BY ed.idetudiant) AS rn
      FROM fievetl.ETudiants_data ed
               left JOIN fievetl.Groupes_data gd ON ed.idetudiant = gd.IDetudiant
               left JOIN fievetl.Etudiant_semestre_data es ON ed.idetudiant = es.IDetudiant) te3
WHERE te3.rn = 1
  AND NOT EXISTS (SELECT 1
                  FROM fievetl.Etudiants e
                  WHERE e.IdEtudiant = te3.IdEtudiant);
COMMIT;

--lycees--
INSERT INTO FIEVETL.lycees (CODELYCEE, NOMLYCEE, CodePostale, NomVille)
SELECT te3.CODELYCEE, te3.NOMLYCEE, te3.codepostallycee, te3.villelycee
FROM (SELECT CODELYCEE,
             NOMLYCEE,
             codepostallycee,
             villelycee,
             ROW_NUMBER() OVER (PARTITION BY CODELYCEE ORDER BY CODELYCEE) AS rn
      FROM fievetl.etudiants_data
      WHERE CODELYCEE IS NOT NULL) te3
WHERE te3.rn = 1 and not exists (select 1 from FIEVETL.lycees l where l.CODELYCEE = te3.CODELYCEE);
commit;

--EtreAbsent--
CREATE SEQUENCE idBidonAbsence
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE;

CREATE OR REPLACE TRIGGER TriggerAbsence
    BEFORE INSERT ON FIEVETL.EtreAbsent
    FOR EACH ROW
BEGIN
    SELECT idBidonAbsence.NEXTVAL INTO : NEW.IdAbsence FROM DUAL;
END;
commit;

INSERT INTO FIEVETL.EtreAbsent (IDABSENCE, Justifiee, MotifAbsence, EstAbsent, Matin, IdCours, IdEtudiant, Dates)
SELECT DISTINCT idBidonAbsence.nextval,te3.ESTJUST ,te3.MotifAbsence, te3.ESTABS, te3.Matin, te3.IdCours,te3.IDETUDIANT, te3.JOURABSENCE
FROM (
         SELECT idBidonAbsence.nextval,ESTJUST ,MotifAbsence, ESTABS, Matin, IdCours,IDETUDIANT, JOURABSENCE
         FROM fievetl.Absences_data
         WHERE idEtudiant IS NOT NULL
     ) te3;

COMMIT;


--Cours--
INSERT INTO FIEVETL.Cours (IDCOURS, IDUTILISATEUR, IDSEMESTRE, IDMODULE)
SELECT DISTINCT IDCOURS, null ,IDSEMESTRE, IDMODULE
FROM fievetl.NOTES_DATA
WHERE IDCOURS IS NOT NULL AND IDSEMESTRE IS NOT NULL AND IDMODULE IS NOT NULL AND IDCOURS
      IN (SELECT DISTINCT IDCOURS FROM FIEVETL.NOTES_DATA MINUS SELECT DISTINCT IDCOURS FROM FIEVETL.COURS);
commit;

INSERT INTO FIEVETL.Cours (IDCOURS, IDUTILISATEUR ,IDSEMESTRE, IDMODULE)
SELECT DISTINCT IDCOURS, null, IDSEMESTRE, IDMODULE
FROM fievetl.ETUDIANT_COURS_DATA
WHERE IDCOURS IS NOT NULL AND IDSEMESTRE IS NOT NULL AND IDMODULE IS NOT NULL
AND IDCOURS IN (SELECT DISTINCT IDCOURS FROM FIEVETL.ETUDIANT_COURS_DATA MINUS SELECT DISTINCT IDCOURS FROM FIEVETL.COURS);


INSERT INTO FIEVETL.Cours (IDCOURS, IDUTILISATEUR, IDSEMESTRE, IDMODULE)
SELECT DISTINCT IDCOURS, null, IDSEMESTRE, IDMODULE
FROM fievetl.ABSENCES_DATA
WHERE IDCOURS IS NOT NULL AND IDSEMESTRE IS NOT NULL AND IDMODULE IS NOT NULL
AND IDCOURS IN (SELECT DISTINCT IDCOURS FROM FIEVETL.ABSENCES_DATA MINUS SELECT DISTINCT IDCOURS FROM FIEVETL.COURS);
commit;


--AvoirEtudie
INSERT INTO FIEVETL.AVOIRETUDIE
SELECT DISTINCT ed.codelycee, ed.idadmission
FROM fievetl.etudiants_data ed
where ed.CODELYCEE is not null AND ed.IDADMISSION is not null;
commit;

--AssoAnneeAdmission
INSERT INTO FIEVETL.ASSOANNEEADMISSION
SELECT DISTINCT ed.idadmission, ed.ANNEEADMISSION
FROM FIEVETL.ETUDIANTS_DATA ed
WHERE IDADMISSION IS NOT NULL AND ANNEEADMISSION IS NOT NULL AND IDADMISSION
      IN (SELECT DISTINCT IDADMISSION FROM FIEVETL.ETUDIANTS_DATA MINUS SELECT DISTINCT IDADMISSION FROM FIEVETL.ASSOANNEEADMISSION);
commit;

--EtudierSemestre
INSERT INTO FIEVETL.ETUDIERSEMESTRE
SELECT DISTINCT esd.idetudiant, esd.idsemestre, esd.ETATINSCRIPTION
FROM FIEVETL.ETUDIANT_SEMESTRE_DATA esd
WHERE esd.IDETUDIANT IS NOT NULL;

--UtilisateursRoles
INSERT INTO FIEVETL.UTILISATEURSROLES
SELECT Distinct ur.idutilisateur, ur.role
FROM FIEVETL.UTILISATEURS_DATA ur
WHERE IDUTILISATEUR IS NOT NULL and role is not null;


--etre_absent--
INSERT INTO FIEVETL.EtreAbsent (IdEtudiant, Dates, Matin, Justifiee, MotifAbsence, EstAbsent, IdCours)
SELECT DISTINCT te3.idEtudiant, te3.JOURABSENCE, te3.Matin, te3.ESTJUST, te3.MotifAbsence, te3.ESTABS, te3.IdCours
FROM fievetl.Absences_data te3
WHERE te3.idEtudiant IS NOT NULL;

COMMIT;


--EtudiantCours
INSERT INTO FIEVETL.ETUDIANTCOURS
SELECT ec.idEtudiant, ec.IDEVALUATION, ec.NOTE, ec.IDCOURS
FROM FIEVETL.NOTES_DATA ec
WHERE IDETUDIANT IS NOT NULL AND IDCOURS IS NOT NULL;
COMMIT;

--AssoModule
INSERT INTO FIEVETL.ASSOMODULE
SELECT DISTINCT ed.IDMODULE, ed.IDUE
FROM FIEVETL.COURS_ENSEIGNANTS_DATA ed
WHERE IDMODULE IS NOT NULL AND IDUE IS NOT NULL
  AND IDMODULE IN (SELECT IDMODULE FROM FIEVETL.COURS_ENSEIGNANTS_DATA MINUS SELECT IDMODULE FROM FIEVETL.ASSOMODULE);

--EvaluerParUtilisateur
INSERT INTO FIEVETL.EVALUERPARUTILISATEUR
SELECT DISTINCT ed.IDEVALUATION, ed.IDUTILISATEUR
FROM FIEVETL.NOTES_DATA ed
WHERE IDEVALUATION IS NOT NULL AND IDUTILISATEUR IS NOT NULL
  AND IDEVALUATION IN (SELECT IDEVALUATION FROM FIEVETL.COURS_ENSEIGNANTS_DATA MINUS SELECT IDEVALUATION FROM FIEVETL.EVALUERPARUTILISATEUR);

--Enseignement--
INSERT INTO FIEVETL.Enseignement (IDCOURS_ENSEIGNANT, idUtilisateur)
SELECT te3.idCours, te3.idIntervenant
FROM (SELECT ced.idCours,
             ced.idIntervenant,
             ROW_NUMBER() OVER (PARTITION BY ced.idCours, ced.idIntervenant ORDER BY ced.idCours, ced.idIntervenant) AS rn
      FROM fievetl.cours_enseignants_data ced) te3
WHERE te3.rn = 1
  AND NOT EXISTS (SELECT 1
                  FROM FIEVETL.Enseignement e
                  WHERE e.IDCOURS_ENSEIGNANT = te3.idCours
                    AND e.idUtilisateur = te3.idIntervenant);
COMMIT;

--AssoBacAnnee
INSERT INTO FIEVETL.ASSOBACANNEE
SELECT DISTINCT ed.IDADMISSION, ed.ANNEE_BAC
FROM FIEVETL.ETUDIANTS_DATA ed
WHERE BAC IS NOT NULL;
COMMIT;


--AssoVilleCodePostale
INSERT INTO FIEVETL.ASSOVILLECODEPOSTAL
SELECT DISTINCT ed.VILLEDOMICILE, ed.CODEPOSTALDOMICILE
FROM FIEVETL.ETUDIANTS_DATA ed
WHERE CODEPOSTALDOMICILE IS NOT NULL AND VILLEDOMICILE IS NOT NULL;

INSERT INTO FIEVETL.ASSOVILLECODEPOSTAL
SELECT DISTINCT ed.VILLELYCEE, ed.CODEPOSTALLYCEE
FROM FIEVETL.ETUDIANTS_DATA ed
WHERE CODEPOSTALLYCEE IS NOT NULL AND VILLELYCEE IS NOT NULL;



-- Etre_intervenant
INSERT INTO FIEVETL.etreIntervenant (IDCOURS_INTERVENANT, idUtilisateur)
SELECT te3.IdCours, te3.idIntervenant
FROM (SELECT IdCours,
             idIntervenant,
             ROW_NUMBER() OVER (PARTITION BY IdCours, idIntervenant ORDER BY IdCours, idIntervenant) AS rn
      FROM fievetl.cours_enseignants_data) te3
WHERE te3.rn = 1
  AND NOT EXISTS (SELECT 1
                  FROM FIEVETL.etreIntervenant ei
                  WHERE ei.IDCOURS_INTERVENANT = te3.IdCours
                    AND ei.idUtilisateur = te3.idIntervenant);
COMMIT;


--etre_forme--
INSERT INTO FIEVETL.ETREFORME
SELECT es.codeTypeFormation, es.idSemestre
FROM FIEVETL.ETUDIANT_SEMESTRE_DATA es
WHERE IDSEMESTRE IS NOT NULL AND IDSEMESTRE IS NOT NULL;
COMMIT;







