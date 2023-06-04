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
WHERE IdSemestre NOT IN (SELECT DISTINCT IdSemestre FROM fievetl.Semestre)
  AND IdSemestre IS NOT NULL;
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
WHERE IdUtilisateur NOT IN (SELECT DISTINCT IdUtilisateur FROM fievetl.Utilisateurs)
  AND IdUtilisateur IS NOT NULL;
commit;


--Postale
INSERT INTO fievetl.Postale
SELECT DISTINCT CodePostalDomicile, VILLEDOMICILE
FROM fievetl.etudiants_data
WHERE (CodePostalDomicile, VILLEDOMICILE) in (
    SELECT CodePostalDomicile, VILLEDOMICILE
    FROM fievetl.etudiants_data
    MINUS
    SELECT CodePostale, NomVille
    FROM fievetl.Postale
) AND ETUDIANTS_DATA.CODEPOSTALDOMICILE IS NOT NULL;
commit;


INSERT INTO fievetl.Postale
SELECT DISTINCT CodePostalDomicile, VILLELYCEE
FROM fievetl.etudiants_data
WHERE CodePostalDomicile in (SELECT CodePostalDomicile
                             FROM fievetl.etudiants_data
                             minus
                             SELECT CodePostale
                             FROM fievetl.Postale);
commit;

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
WHERE te3.rn = 1;
commit;
--Module
INSERT INTO FIEVETL.Modules (idModule, heureCM, heureTD, heureTP, coefficient, nomModule, codeModule, idUE,
                             IdUtilisateur)
SELECT te3.idModule,
       te3.heures_CM,
       te3.heures_TD,
       te3.heures_TP,
       te3.coefficientmodule,
       te3.nomModule,
       te3.codeModule,
       te3.idUE,
       te3.idintervenant
FROM (SELECT idModule,
             heures_CM,
             heures_TD,
             heures_TP,
             coefficientmodule,
             nomModule,
             codeModule,
             idUE,
             idintervenant,
             ROW_NUMBER() OVER (PARTITION BY idModule ORDER BY idModule) AS rn
      FROM fievetl.cours_enseignants_data
      WHERE idModule IS NOT NULL) te3
WHERE te3.rn = 1
  AND NOT EXISTS (SELECT 1
                  FROM FIEVETL.Modules m
                  WHERE m.idModule = te3.idModule);
commit;

--cours--
INSERT INTO FIEVETL.Cours (idCours, idSemestre, idModule)
SELECT te3.idCours, te3.idSemestre, te3.idModule
FROM (SELECT idCours,
             idSemestre,
             idModule,
             ROW_NUMBER() OVER (PARTITION BY idCours ORDER BY idCours) AS rn
      FROM fievetl.cours_enseignants_data
      WHERE idCours IS NOT NULL) te3
WHERE te3.rn = 1
  AND NOT EXISTS (SELECT 1
                  FROM FIEVETL.Cours c
                  WHERE c.idCours = te3.idCours);
commit;

-- Evaluations
INSERT INTO FIEVETL.Evaluations
SELECT DISTINCT IDEVALUATION, COEFFICIENT, IDUTILISATEUR, IDCOURS
FROM fievetl.NOTES_DATA
WHERE IDEVALUATION IS NOT NULL AND IDEVALUATION NOT IN (SELECT DISTINCT IDEVALUATION FROM FIEVETL.EVALUATIONS);
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
                               mailPerso, numeroFix,ETATINSCRIPTION, numeroPortable,idGroupe,
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
             gd.idGroupe,
             ed.domicile,
             ed.lieu_naissance,
             ROW_NUMBER() OVER (PARTITION BY ed.idetudiant ORDER BY ed.idetudiant) AS rn
      FROM fievetl.ETudiants_data ed
               JOIN fievetl.Groupes_data gd ON ed.idetudiant = gd.IDetudiant
               JOIN fievetl.Etudiant_semestre_data es ON ed.idetudiant = es.IDetudiant) te3
WHERE te3.rn = 1
  AND NOT EXISTS (SELECT 1
                  FROM fievetl.Etudiants e
                  WHERE e.IdEtudiant = te3.IdEtudiant);

COMMIT;
--Admissions
INSERT INTO FIEVETL.ADMISSIONS
SELECT ed.idadmission, ed.Francais, ed.Anglais, ed.physique, ed.math, ed.specialite, ed.bac, ed.idEtudiant
FROM FIEVETL.ETUDIANTS_DATA ed
WHERE IDADMISSION is not null AND IDETUDIANT is not null;
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
WHERE IDADMISSION IS NOT NULL;


--EtudierSemestre
INSERT INTO FIEVETL.ETUDIERSEMESTRE
SELECT DISTINCT esd.idetudiant, esd.idsemestre, esd.ETATINSCRIPTION
FROM FIEVETL.ETUDIANT_SEMESTRE_DATA esd
WHERE esd.IDETUDIANT IS NOT NULL;

--UtilisateursRoles
INSERT INTO FIEVETL.UTILISATEURSROLES
SELECT Distinct ur.idutilisateur, ur.role
FROM FIEVETL.UTILISATEURS_DATA ur
WHERE IDUTILISATEUR IS NOT NULL;


--etre_absent--
INSERT INTO FIEVETL.Etre_absent (Dates, IdCours, Matin, Justifiee, MotifAbsence, EstAbsent, IdEtudiant)
SELECT te3.jourabsence, te3.idCours, te3.matin, te3.estjust, te3.motifabsence, te3.estabs, te3.idEtudiant
FROM (SELECT ad.jourabsence,
             ad.idCours,
             ad.matin,
             ad.estjust,
             ad.motifabsence,
             ad.estabs,
             ad.idEtudiant,
             ROW_NUMBER() OVER (PARTITION BY ad.idEtudiant, ad.jourabsence, ad.idCours ORDER BY ad.idEtudiant, ad.jourabsence, ad.idCours) AS rn
      FROM fievetl.Absences_data ad) te3
WHERE te3.rn = 1
  AND NOT EXISTS (SELECT 1
                  FROM FIEVETL.Etre_absent ea
                  WHERE ea.idetudiant = te3.idetudiant
                    AND ea.dates = te3.JOURABSENCE
                    AND ea.idcours = te3.idcours);
COMMIT;


--EtudiantCours
INSERT INTO FIEVETL.ETUDIANTCOURS
SELECT ec.idEtudiant, ec.idCours
FROM FIEVETL.ETUDIANT_COURS_DATA ec
WHERE IDETUDIANT IS NOT NULL AND IDCOURS IS NOT NULL;
COMMIT;

--Enseignement--
INSERT INTO FIEVETL.Enseignement (idCours, idUtilisateur)
SELECT te3.idCours, te3.idIntervenant
FROM (SELECT ced.idCours,
             ced.idIntervenant,
             ROW_NUMBER() OVER (PARTITION BY ced.idCours, ced.idIntervenant ORDER BY ced.idCours, ced.idIntervenant) AS rn
      FROM fievetl.cours_enseignants_data ced) te3
WHERE te3.rn = 1
  AND NOT EXISTS (SELECT 1
                  FROM FIEVETL.Enseignement e
                  WHERE e.idCours = te3.idCours
                    AND e.idUtilisateur = te3.idIntervenant);
COMMIT;

--AssoBacAnnee
INSERT INTO FIEVETL.ASSOBACANNEE
SELECT DISTINCT ed.IDADMISSION, ed.ANNEE_BAC
FROM FIEVETL.ETUDIANTS_DATA ed
WHERE BAC IS NOT NULL;
COMMIT;

-- Etre_intervenant
INSERT INTO FIEVETL.etre_intervenant (IdCours, idUtilisateur)
SELECT te3.IdCours, te3.idIntervenant
FROM (SELECT IdCours,
             idIntervenant,
             ROW_NUMBER() OVER (PARTITION BY IdCours, idIntervenant ORDER BY IdCours, idIntervenant) AS rn
      FROM fievetl.cours_enseignants_data) te3
WHERE te3.rn = 1
  AND NOT EXISTS (SELECT 1
                  FROM FIEVETL.etre_intervenant ei
                  WHERE ei.IdCours = te3.IdCours
                    AND ei.idUtilisateur = te3.idIntervenant);
COMMIT;


--noter

INSERT INTO FIEVETL.NOTER
SELECT n.IdEtudiant, n.IdEvaluation, n.note
FROM FIEVETL.NOTES_DATA n
WHERE IDETUDIANT IS NOT NULL AND IDEVALUATION IS NOT NULL;
COMMIT;

--etre_forme--
INSERT INTO FIEVETL.ETREFORME
SELECT es.codeTypeFormation, es.idSemestre
FROM FIEVETL.ETUDIANT_SEMESTRE_DATA es
WHERE IDSEMESTRE IS NOT NULL AND IDSEMESTRE IS NOT NULL;
COMMIT;







