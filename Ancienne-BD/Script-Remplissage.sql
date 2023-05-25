INSERT INTO fievetl.nationalite
SELECT DISTINCT nationalite
FROM fievetl.etudiants_data
WHERE nationalite NOT IN (SELECT DISTINCT nationalite FROM fievetl.nationalite);
commit;

INSERT INTO fievetl.inscription
SELECT DISTINCT etatinscription
FROM fievetl.Etudiant_Semestre_data
WHERE etatinscription NOT IN (SELECT DISTINCT etatinscription FROM fievetl.inscription);
commit;

INSERT INTO fievetl.groupes
SELECT DISTINCT idgroupe, nomgroupe
FROM fievetl.groupes_data
WHERE idgroupe NOT IN (SELECT DISTINCT idgroupe FROM fievetl.groupes)
  AND idgroupe IS NOT NULL;
commit;


INSERT INTO fievetl.bac
SELECT DISTINCT bac
FROM fievetl.etudiants_data
WHERE bac NOT IN (SELECT DISTINCT bac FROM fievetl.bac)
  AND bac IS NOT NULL;
commit;

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

INSERT INTO fievetl.TypeFormation
SELECT DISTINCT CodeTypeFormation, NomTypeFormation
FROM fievetl.Etudiant_Semestre_data
WHERE CodeTypeFormation NOT IN (SELECT DISTINCT CodeTypeFormation FROM fievetl.TypeFormation)
  AND CodeTypeFormation IS NOT NULL;
commit;

INSERT INTO fievetl.roles
SELECT DISTINCT role
FROM fievetl.utilisateurs_data
WHERE role NOT IN (SELECT DISTINCT role FROM fievetl.roles)
  AND role IS NOT NULL;
commit;

INSERT INTO fievetl.Dates
SELECT DISTINCT jourAbsence
FROM fievetl.Absences_DATA
WHERE jourAbsence IN (SELECT jourAbsence
                      FROM fievetl.Absences_DATA
                      minus
                      SELECT dateS
                      FROM fievetl.Dates);
Commit;

INSERT INTO fievetl.Dates
SELECT DISTINCT datedebutsemestre
FROM fievetl.Etudiant_Semestre_data
WHERE datedebutsemestre in (SELECT datedebutsemestre
                            FROM fievetl.Etudiant_Semestre_data
                            minus
                            SELECT dateS
                            FROM fievetl.Dates)
  AND datedebutsemestre IS NOT NULL;
Commit;

INSERT INTO fievetl.Dates
SELECT DISTINCT datefinsemestre
FROM fievetl.Etudiant_Semestre_data
WHERE datefinsemestre IN (SELECT datefinsemestre
                          FROM fievetl.Etudiant_Semestre_data
                          minus
                          SELECT dateS
                          FROM fievetl.Dates);
Commit;

INSERT INTO fievetl.Dates
SELECT DISTINCT date_naissance
FROM fievetl.Etudiants_data
WHERE date_naissance IN (SELECT date_naissance
                         FROM fievetl.Etudiants_data
                         minus
                         SELECT dateS
                         FROM fievetl.Dates);
commit;


INSERT INTO fievetl.Semestre
SELECT DISTINCT IdSemestre, Numerosemestre, DateDebutSemestre, DateFinSemestre
FROM fievetl.Etudiant_Semestre_data
WHERE IdSemestre NOT IN (SELECT DISTINCT IdSemestre FROM fievetl.Semestre)
  AND IdSemestre IS NOT NULL;
commit;

INSERT INTO fievetl.Bureau
SELECT DISTINCT numBureau, telephonebureau
FROM fievetl.utilisateurs_data
WHERE numBureau NOT IN (SELECT DISTINCT numBureau FROM fievetl.Bureau)
  AND numBureau IS NOT NULL;
commit;

INSERT INTO fievetl.departement
SELECT DISTINCT dept_naissance
FROM fievetl.etudiants_data
WHERE dept_naissance NOT IN (SELECT DISTINCT dept_naissance FROM fievetl.departement)
  AND dept_naissance IS NOT NULL;
commit;

INSERT INTO fievetl.UE
SELECT DISTINCT IDUE, NomUE, codeUE, coefficientfUE, ECTS
FROM fievetl.Cours_enseignants_data
WHERE IDUE NOT IN (SELECT DISTINCT IDUE FROM fievetl.UE)
  AND IDUE IS NOT NULL;
commit;

INSERT INTO fievetl.Postale
SELECT DISTINCT CodePostalDomicile
FROM fievetl.etudiants_data
WHERE CodePostalDomicile in (SELECT CodePostalDomicile
                             FROM fievetl.etudiants_data
                             minus
                             SELECT CodePostale
                             FROM fievetl.Postale);
commit;

INSERT INTO fievetl.Postale
SELECT DISTINCT CodePostallycee
FROM fievetl.etudiants_data
WHERE CodePostallycee IN (SELECT CodePostallycee
                          FROM fievetl.etudiants_data
                          minus
                          SELECT CodePostale
                          FROM fievetl.Postale);
commit;

SELECT COUNT(DISTINCT CodePostallycee)
FROM fievetl.etudiants_data
where CodePostallycee IS NOT NULL;
commit;

INSERT INTO fievetl.bac
SELECT DISTINCT bac
FROM fievetl.etudiants_data
WHERE bac NOT IN (SELECT DISTINCT bac FROM fievetl.bac)
  AND bac IS NOT NULL;
commit;

INSERT INTO fievetl.TypeEnseignant
SELECT DISTINCT typeenseignant
FROM fievetl.utilisateurs_data
WHERE typeenseignant NOT IN (SELECT DISTINCT typeenseignant FROM fievetl.TypeEnseignant)
  AND typeenseignant IS NOT NULL;
commit;

INSERT INTO fievetl.Promotion
SELECT DISTINCT Promotion
FROM fievetl.Etudiant_Semestre_data
WHERE Promotion IN (SELECT Promotion
                    FROM fievetl.Etudiant_Semestre_data
                    minus
                    SELECT Promotion
                    FROM fievetl.Promotion);
commit;

INSERT INTO fievetl.Promotion
SELECT DISTINCT promotion
FROM fievetl.groupes_data
WHERE promotion IN (SELECT promotion
                    FROM fievetl.groupes_data
                    minus
                    SELECT Promotion
                    FROM fievetl.Promotion);
commit;

INSERT INTO fievetl.Utilisateurs
SELECT DISTINCT IdUtilisateur, Prenom, nom, Email, typeenseignant, numbureau
FROM fievetl.utilisateurs_data
WHERE IdUtilisateur NOT IN (SELECT DISTINCT IdUtilisateur FROM fievetl.Utilisateurs)
  AND IdUtilisateur IS NOT NULL;
commit;

INSERT INTO fievetl.Pays
SELECT DISTINCT paysdomicile
FROM fievetl.etudiants_data
WHERE paysdomicile NOT IN (SELECT DISTINCT paysdomicile FROM fievetl.Pays)
  AND paysdomicile IS NOT NULL;
commit;


INSERT INTO fievetl.note
SELECT DISTINCT math
FROM fievetl.etudiants_data
WHERE math IN (SELECT math
               FROM fievetl.etudiants_data
               minus
               SELECT NOTE
               FROM fievetl.note);
commit;

INSERT INTO fievetl.note
SELECT DISTINCT physique
FROM fievetl.etudiants_data
WHERE physique IN (SELECT physique
                   FROM fievetl.etudiants_data
                   minus
                   SELECT NOTE
                   FROM fievetl.note);
commit;

INSERT INTO fievetl.note
SELECT DISTINCT anglais
FROM fievetl.etudiants_data
WHERE anglais IN (SELECT anglais
                  FROM fievetl.etudiants_data
                  minus
                  SELECT NOTE
                  FROM fievetl.note);
commit;

INSERT INTO fievetl.note
SELECT DISTINCT francais
FROM fievetl.etudiants_data
WHERE francais in (SELECT francais
                   FROM fievetl.etudiants_data
                   minus
                   SELECT NOTE
                   FROM fievetl.note);
commit;

INSERT INTO fievetl.TypeDomicile
SELECT DISTINCT typeadresse
FROM fievetl.etudiants_data
WHERE typeadresse NOT IN (SELECT DISTINCT typeadresse FROM fievetl.TypeDomicile)
  AND typeadresse IS NOT NULL;
commit;

INSERT INTO fievetl.matiere
VALUES ('Math');
commit;
INSERT INTO fievetl.matiere
VALUES ('Physique');
commit;
INSERT INTO fievetl.matiere
VALUES ('Anglais');
commit;
INSERT INTO fievetl.matiere
VALUES ('Francais');
commit;

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

INSERT INTO FIEVETL.UtilisateursRoles (idUtilisateur, nomRole)
SELECT te3.IdUtilisateur, te3.role
FROM (SELECT IdUtilisateur,
             role,
             ROW_NUMBER() OVER (PARTITION BY IdUtilisateur, role ORDER BY IdUtilisateur, role) AS rn
      FROM fievetl.Utilisateurs_data
      WHERE IdUtilisateur IS NOT NULL
        AND role IS NOT NULL) te3
WHERE te3.rn = 1
  AND NOT EXISTS (SELECT 1
                  FROM FIEVETL.UtilisateursRoles ur
                  WHERE ur.idUtilisateur = te3.IdUtilisateur
                    AND ur.nomRole = te3.role);

INSERT INTO FIEVETL.Etre_absent (idetudiant, dates, idcours, matin, justifiee, motifabsence, estabsent)
SELECT te3.idetudiant, te3.jourabsence, te3.idCours, te3.matin, te3.estjust, te3.motifabsence, te3.estabs
FROM (SELECT ad.idetudiant,
             ad.jourabsence,
             ad.idCours,
             ad.matin,
             ad.estjust,
             ad.motifabsence,
             ad.estabs,
             ROW_NUMBER() OVER (PARTITION BY ad.idetudiant, ad.jourabsence, ad.idCours ORDER BY ad.idetudiant, ad.jourabsence, ad.idCours) AS rn
      FROM fievetl.Absences_data ad) te3
WHERE te3.rn = 1
  AND NOT EXISTS (SELECT 1
                  FROM FIEVETL.Etre_absent ea
                  WHERE ea.idetudiant = te3.idetudiant
                    AND ea.dates = te3.jourabsence
                    AND ea.idcours = te3.idCours);

INSERT INTO FIEVETL.CoursEvaluation (idCours, idEvaluation)
SELECT te3.idCours, te3.idEvaluation
FROM (SELECT nd.idCours,
             nd.idEvaluation,
             ROW_NUMBER() OVER (PARTITION BY nd.idCours, nd.idEvaluation ORDER BY nd.idCours, nd.idEvaluation) AS rn
      FROM fievetl.notes_data nd) te3
WHERE te3.rn = 1
  AND NOT EXISTS (SELECT 1
                  FROM FIEVETL.CoursEvaluation ce
                  WHERE ce.idCours = te3.idCours
                    AND ce.idEvaluation = te3.idEvaluation);

INSERT INTO FIEVETL.EtudiantCours (idetudiant, idcours)
SELECT te3.idetudiant, te3.idCours
FROM (SELECT nc.idetudiant,
             nc.idCours,
             ROW_NUMBER() OVER (PARTITION BY nc.idetudiant, nc.idCours ORDER BY nc.idetudiant, nc.idCours) AS rn
      FROM fievetl.notes_data nc) te3
WHERE te3.rn = 1
  AND NOT EXISTS (SELECT 1
                  FROM FIEVETL.EtudiantCours ec
                  WHERE ec.idetudiant = te3.idetudiant
                    AND ec.idcours = te3.idCours);

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

INSERT INTO FIEVETL.UtilisateursRoles (idUtilisateur, nomRole)
SELECT IdUtilisateur, role
FROM fievetl.Utilisateurs_data;

INSERT INTO fievetl.Etudiants (IdEtudiant, prenomEtudiant, NomEtudiant, civilité, boursier, idAdmission, EmailEtudiant,
                               mailPerso, numeroFix, numeroPortable, appelationBac, nomSpecialite, Annee, ANNEE_1,
                               codeLycee, Adressedomicile, nomnationalite, nomVille, idGroupe, NomPromotion,
                               etatinscription)
SELECT te3.idetudiant,
       te3.prenom,
       te3.nom,
       te3.civilite,
       te3.boursier,
       te3.idadmission,
       te3.email,
       te3.emailperso,
       te3.telephone,
       te3.telephonemobile,
       te3.bac,
       te3.specialite,
       te3.annee_bac,
       te3.anneeadmission,
       te3.codepostalLycee,
       te3.domicile,
       te3.nationalite,
       te3.lieu_naissance,
       te3.idGroupe,
       te3.promotion,
       te3.etatinscription
FROM (SELECT ed.idetudiant,
             ed.prenom,
             ed.nom,
             ed.civilite,
             ed.boursier,
             ed.idadmission,
             ed.email,
             ed.emailperso,
             ed.telephone,
             ed.telephonemobile,
             ed.bac,
             ed.specialite,
             ed.annee_bac,
             ed.anneeadmission,
             ed.codepostalLycee,
             ed.domicile,
             ed.nationalite,
             ed.lieu_naissance,
             gd.idGroupe,
             es.promotion,
             es.etatinscription,
             ROW_NUMBER() OVER (PARTITION BY ed.idetudiant ORDER BY ed.idetudiant) AS rn
      FROM fievetl.ETudiants_data ed
               JOIN fievetl.Groupes_data gd ON ed.idetudiant = gd.IDetudiant
               JOIN fievetl.Etudiant_semestre_data es ON ed.idetudiant = es.IDetudiant) te3
WHERE te3.rn = 1
  AND NOT EXISTS (SELECT 1
                  FROM fievetl.Etudiants e
                  WHERE e.IdEtudiant = te3.IdEtudiant);

INSERT INTO FIEVETL.Etre_absent (idetudiant, dates, idcours, matin, justifiee, motifabsence, estabsent)
SELECT te3.idetudiant, te3.JOURABSENCE, te3.idCours, te3.matin, te3.estjust, te3.motifabsence, te3.estabs
FROM (SELECT ad.idEtudiant,
             ad.jourabsence,
             ad.idCours,
             ad.matin,
             ad.estjust,
             ad.motifabsence,
             ad.estabs,
             ROW_NUMBER() OVER (PARTITION BY ad.idEtudiant, ad.jourabsence, ad.idCours ORDER BY ad.idEtudiant, ad.jourabsence, ad.idCours) AS rn
      FROM fievetl.Absences_data ad) te3
WHERE te3.rn = 1
  AND NOT EXISTS (SELECT 1
                  FROM FIEVETL.Etre_absent ea
                  WHERE ea.idetudiant = te3.idetudiant
                    AND ea.dates = te3.JOURABSENCE
                    AND ea.idcours = te3.idcours);

INSERT INTO FIEVETL.EtudiantCours (idetudiant, idcours)
SELECT te3.idetudiant, te3.idcours
FROM (SELECT nd.idetudiant,
             nd.idCours,
             ROW_NUMBER() OVER (PARTITION BY nd.idetudiant, nd.idCours ORDER BY nd.idetudiant, nd.idCours) AS rn
      FROM fievetl.notes_data nd) te3
WHERE te3.rn = 1
  AND NOT EXISTS (SELECT 1
                  FROM FIEVETL.EtudiantCours ec
                  WHERE ec.idetudiant = te3.idetudiant
                    AND ec.idcours = te3.idcours);

INSERT INTO FIEVETL.CoursEvaluation (idCours, idEvaluation)
SELECT te3.idCours, te3.idEvaluation
FROM (SELECT nd.idCours,
             nd.idEvaluation,
             ROW_NUMBER() OVER (PARTITION BY nd.idCours, nd.idEvaluation ORDER BY nd.idCours, nd.idEvaluation) AS rn
      FROM fievetl.notes_data nd) te3
WHERE te3.rn = 1
  AND NOT EXISTS (SELECT 1
                  FROM FIEVETL.CoursEvaluation ce
                  WHERE ce.idCours = te3.idCours
                    AND ce.idEvaluation = te3.idEvaluation);

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

INSERT INTO FIEVETL.AssoVilleCodePostal (nomVille, codePostale)
SELECT te3.villeDomicile, te3.codePostalDomicile
FROM (SELECT villeDomicile,
             codePostalDomicile,
             ROW_NUMBER() OVER (PARTITION BY villeDomicile, codePostalDomicile ORDER BY villeDomicile, codePostalDomicile) AS rn
      FROM fievetl.Etudiants_data) te3
WHERE te3.rn = 1
  AND NOT EXISTS (SELECT 1
                  FROM FIEVETL.AssoVilleCodePostal avc
                  WHERE avc.nomVille = te3.villeDomicile
                    AND avc.codePostale = te3.codePostalDomicile);

INSERT INTO FIEVETL.AssoVilleCodePostal (nomVille, codePostale)
SELECT te3.villelycee, te3.codepostallycee
FROM (SELECT villelycee,
             codepostallycee,
             ROW_NUMBER() OVER (PARTITION BY villelycee, codepostallycee ORDER BY villelycee, codepostallycee) AS rn
      FROM fievetl.Etudiants_data) te3
WHERE te3.rn = 1
  AND NOT EXISTS (SELECT 1
                  FROM FIEVETL.AssoVilleCodePostal avc
                  WHERE avc.nomVille = te3.villelycee
                    AND avc.codePostale = te3.codepostallycee);

INSERT INTO FIEVETL.AssoVilleCodePostal (nomVille, codePostale)
SELECT te3.villeDomicile, te3.codePostalDomicile
FROM (SELECT villeDomicile,
             codePostalDomicile,
             ROW_NUMBER() OVER (PARTITION BY villeDomicile, codePostalDomicile ORDER BY villeDomicile, codePostalDomicile) AS rn
      FROM fievetl.Etudiants_data) te3
WHERE te3.rn = 1
  AND NOT EXISTS (SELECT 1
                  FROM FIEVETL.AssoVilleCodePostal avc
                  WHERE avc.nomVille = te3.villeDomicile
                    AND avc.codePostale = te3.codePostalDomicile);

INSERT INTO FIEVETL.etre_intervenant (idModule, idUtilisateur)
SELECT te3.idModule, te3.idIntervenant
FROM (SELECT idModule,
             idIntervenant,
             ROW_NUMBER() OVER (PARTITION BY idModule, idIntervenant ORDER BY idModule, idIntervenant) AS rn
      FROM fievetl.cours_enseignants_data) te3
WHERE te3.rn = 1
  AND NOT EXISTS (SELECT 1
                  FROM FIEVETL.etre_intervenant ei
                  WHERE ei.idModule = te3.idModule
                    AND ei.idUtilisateur = te3.idIntervenant);

INSERT INTO FIEVETL.noter (idEtudiant, idEvaluation, note)
SELECT te3.idEtudiant, te3.idEvaluation, te3.note
FROM (SELECT idEtudiant,
             idEvaluation,
             note,
             ROW_NUMBER() OVER (PARTITION BY idEtudiant, idEvaluation ORDER BY idEtudiant, idEvaluation) AS rn
      FROM fievetl.notes_data) te3
WHERE te3.rn = 1
  AND NOT EXISTS (SELECT 1
                  FROM FIEVETL.noter n
                  WHERE n.idEtudiant = te3.idEtudiant
                    AND n.idEvaluation = te3.idEvaluation);

INSERT INTO FIEVETL.bacNote (IdEtudiant, matiere, note)
SELECT te3.IdEtudiant, te3.matiere, te3.note
FROM (SELECT IdEtudiant,
             matiere,
             note,
             ROW_NUMBER() OVER (PARTITION BY IdEtudiant, matiere ORDER BY IdEtudiant, matiere) AS rn
      FROM (SELECT IdEtudiant, 'Francais' AS matiere, Francais AS note
            FROM fievetl.etudiants_data
            UNION ALL
            SELECT IdEtudiant, 'Anglais' AS matiere, anglais AS note
            FROM fievetl.etudiants_data
            UNION ALL
            SELECT IdEtudiant, 'Physique' AS matiere, physique AS note
            FROM fievetl.etudiants_data
            UNION ALL
            SELECT IdEtudiant, 'Math' AS matiere, math AS note
            FROM fievetl.etudiants_data) data) te3
WHERE te3.rn = 1
  AND NOT EXISTS (SELECT 1
                  FROM FIEVETL.bacNote b
                  WHERE b.IdEtudiant = te3.IdEtudiant
                    AND b.matiere = te3.matiere);
