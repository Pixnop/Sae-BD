CREATE OR REPLACE VIEW FIEVETL.EvaluationsNonZero AS
SELECT *
FROM FIEVETL.Evaluations
WHERE Coefficient > 0;

CREATE OR REPLACE VIEW FIEVETL.ModulesNonZero AS
SELECT *
FROM FIEVETL.Modules
WHERE Coefficient > 0;

CREATE OR REPLACE VIEW FIEVETL.UENonZero AS
SELECT *
FROM FIEVETL.UE
WHERE CoefficientUE > 0;

-- Créer une vue pour calculer le score total de chaque étudiant pour chaque semestre
CREATE OR REPLACE VIEW FIEVETL.ScoreTotal AS
SELECT
    e.IdEtudiant,
    es.IdSemestre,
    avg((CASE WHEN ec.note >= 0 THEN ec.note ELSE 0 END * ev.COEFFICIENT * m.Coefficient * u.COEFFICIENTUE)/(ev.NOTEMAX * ev.COEFFICIENT * m.Coefficient * u.COEFFICIENTUE)) AS ScoreTotal
FROM
    FIEVETL.EtudiantCours ec
        JOIN
    FIEVETL.Etudiants e ON ec.IdEtudiant = e.IdEtudiant
        JOIN
    FIEVETL.EtudierSemestre es ON e.IdEtudiant = es.IdEtudiant
        JOIN
    FIEVETL.Cours c ON ec.IdCours = c.IdCours
        JOIN
    (SELECT * FROM FIEVETL.EvaluationsNonZero) ev ON ec.IDEVALUATION= ev.IDEVALUATION
        JOIN
    (SELECT * FROM FIEVETL.ModulesNonZero) m ON c.IdModule = m.IdModule
        JOIN
    FIEVETL.ASSOMODULE a on m.IDMODULE = a.IDMODULE
        JOIN
    (SELECT * FROM FIEVETL.UENonZero) u on a.IDUE = u.IDUE
GROUP BY
    e.IdEtudiant,
    es.IdSemestre;

-- Créer une vue pour calculer le classement des étudiants à chaque semestre
CREATE OR REPLACE VIEW FIEVETL.ClassementEtudiants AS
SELECT
    st.IdEtudiant,
    st.IdSemestre,
    st.ScoreTotal * 20 AS ScoreTotalSur20,
    RANK() OVER (PARTITION BY st.IdSemestre ORDER BY st.ScoreTotal DESC) AS Classement
FROM
    FIEVETL.ScoreTotal st;


------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE VIEW FIEVETL.AgeEtudiants AS
SELECT
    e.IdEtudiant,
    e.DateNaissance,
    (SYSDATE - e.DateNaissance) / 365 AS Age
FROM
    FIEVETL.Etudiants e;

CREATE OR REPLACE VIEW FIEVETL.SigneAstrologiqueEtudiants AS
SELECT
    a.IdEtudiant,
    CASE
        WHEN TO_CHAR(a.DateNaissance, 'MMDD') BETWEEN '0321' AND '0419' THEN 'Bélier'
        WHEN TO_CHAR(a.DateNaissance, 'MMDD') BETWEEN '0420' AND '0520' THEN 'Taureau'
        WHEN TO_CHAR(a.DateNaissance, 'MMDD') BETWEEN '0521' AND '0620' THEN 'Gémeaux'
        WHEN TO_CHAR(a.DateNaissance, 'MMDD') BETWEEN '0621' AND '0722' THEN 'Cancer'
        WHEN TO_CHAR(a.DateNaissance, 'MMDD') BETWEEN '0723' AND '0822' THEN 'Lion'
        WHEN TO_CHAR(a.DateNaissance, 'MMDD') BETWEEN '0823' AND '0922' THEN 'Vierge'
        WHEN TO_CHAR(a.DateNaissance, 'MMDD') BETWEEN '0923' AND '1022' THEN 'Balance'
        WHEN TO_CHAR(a.DateNaissance, 'MMDD') BETWEEN '1023' AND '1121' THEN 'Scorpion'
        WHEN TO_CHAR(a.DateNaissance, 'MMDD') BETWEEN '1122' AND '1221' THEN 'Sagittaire'
        WHEN TO_CHAR(a.DateNaissance, 'MMDD') BETWEEN '1222' AND '0119' THEN 'Capricorne'
        WHEN TO_CHAR(a.DateNaissance, 'MMDD') BETWEEN '0120' AND '0218' THEN 'Verseau'
        ELSE 'Poissons'
        END AS SigneAstrologique
FROM
    FIEVETL.AgeEtudiants a;

CREATE OR REPLACE VIEW FIEVETL.ModuleSigneAstrologique AS
SELECT
    ec.IdEtudiant,
    c.IdModule,
    m.NomModule,
    s.SigneAstrologique,
    AVG(ec.note) OVER (PARTITION BY c.IdModule, s.SigneAstrologique) AS MoyenneNote
FROM
    FIEVETL.EtudiantCours ec
        JOIN
    FIEVETL.Cours c ON ec.IdCours = c.IdCours
        JOIN
    FIEVETL.Modules m ON c.IdModule = m.IdModule
        JOIN
    FIEVETL.SigneAstrologiqueEtudiants s ON ec.IdEtudiant = s.IdEtudiant;


------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE VIEW FIEVETL.MoyenneModuleBac AS
SELECT
    m.IdModule,
    m.NomModule,
    b.APPELATIONBAC,
    AVG(st.ScoreTotal * 20) AS MoyenneEtudiants
FROM
    FIEVETL.EtudiantCours ec
        JOIN
    FIEVETL.Etudiants e ON ec.IdEtudiant = e.IdEtudiant
        JOIN
    FIEVETL.Cours c ON ec.IdCours = c.IdCours
        JOIN
    FIEVETL.Modules m ON c.IdModule = m.IdModule
        JOIN
    FIEVETL.ADMISSIONS a ON e.IDADMISSION = a.IDADMISSION
        JOIN
    FIEVETL.BAC b ON a.APPELATIONBAC = b.APPELATIONBAC
        JOIN
    (SELECT * FROM FIEVETL.ScoreTotal) st ON e.IdEtudiant = st.IdEtudiant
GROUP BY
    m.IdModule,
    m.NomModule,
    b.APPELATIONBAC;

------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE VIEW FIEVETL.MoyenneNotesEnseignant AS
SELECT U.IdUtilisateur, U.NomUtilisateur, AVG((CASE WHEN EC.note >= 0 THEN EC.note ELSE 0 END / E.NoteMax) * 20) AS MoyenneNotes
FROM FIEVETL.Utilisateurs U
         JOIN FIEVETL.EvaluerParUtilisateur EU ON U.IdUtilisateur = EU.IdUtilisateur
         JOIN FIEVETL.Evaluations E ON EU.IdEvaluation = E.IdEvaluation
         JOIN FIEVETL.EtudiantCours EC ON E.IdEvaluation = EC.IdEvaluation
GROUP BY U.IdUtilisateur, U.NomUtilisateur;

------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE VIEW FIEVETL.NombreAbsencesParMois AS
SELECT TO_CHAR(EA.Dates, 'YYYY-MM') AS MoisAnnee,
       COUNT(*) AS NombreAbsences
FROM FIEVETL.EtreAbsent EA
GROUP BY TO_CHAR(EA.Dates, 'YYYY-MM');

------------------------------------------------------------------------------------------------------------------------
--taux d'abscence par mois
CREATE OR REPLACE VIEW TauxAbsencesParMois AS
SELECT NAPM.MoisAnnee,
       NAPM.NombreAbsences,
       (NAPM.NombreAbsences / (SELECT COUNT(*) FROM FIEVETL.EtudiantCours)) * 100 AS TauxAbsences
FROM FIEVETL.NombreAbsencesParMois NAPM;


------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE VIEW FIEVETL.TopEnseignements AS
SELECT
    m.NomModule,
    AVG(CASE WHEN ec.note >= 0 THEN ec.note ELSE 0 END) AS MoyenneNote
FROM
    FIEVETL.EtudiantCours ec
        JOIN
    FIEVETL.Cours c ON ec.IdCours = c.IdCours
        JOIN
    FIEVETL.Modules m ON c.IdModule = m.IdModule
GROUP BY
    m.NomModule
ORDER BY MoyenneNote DESC;
COMMIT;

------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE VIEW FIEVETL.BottomEnseignements AS
SELECT
    NomModule,
    MoyenneNote
FROM
    FIEVETL.TopEnseignements
ORDER BY MoyenneNote ASC;

------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE VIEW FIEVETL.Top3AnneesUniversitaires AS
SELECT
    a.ANNEE,
    AVG(CASE WHEN ec.note >= 0 THEN ec.note ELSE 0 END) AS MoyenneNote
FROM
    FIEVETL.EtudiantCours ec
        JOIN
    FIEVETL.Etudiants e ON ec.IdEtudiant = e.IdEtudiant
        JOIN
    FIEVETL.ASSOANNEEADMISSION a ON e.IDADMISSION = a.IDADMISSION
GROUP BY
    a.ANNEE
ORDER BY MoyenneNote DESC;

commit;

------------------------------------------------------------------------------------------------------------------------
--taux de réussite par module
CREATE OR REPLACE VIEW FIEVETL.TauxReussiteModule AS
SELECT
    m.NomModule,
    COUNT(CASE WHEN ec.note >= 10 THEN ec.note ELSE NULL END) AS NombreReussite,
    COUNT(CASE WHEN ec.note < 10 THEN ec.note ELSE NULL END) AS NombreEchec,
    COUNT(ec.note) AS NombreTotal,
    (COUNT(CASE WHEN ec.note >= 10 THEN ec.note ELSE NULL END) / COUNT(ec.note)) * 100 AS TauxReussite
FROM
    FIEVETL.EtudiantCours ec
        JOIN
    FIEVETL.Cours c ON ec.IdCours = c.IdCours
        JOIN
    FIEVETL.Modules m ON c.IdModule = m.IdModule
GROUP BY
    m.NomModule;


-----------------------------------------------  Statistiques ----------------------------------------------------------

-- Vues associées au livrable de statistiques

-- Nombre d'absence justifiee par etudiant
CREATE OR REPLACE VIEW FIEVETL.vueNbrAbsJustifiee AS
SELECT e.IDETUDIANT, COUNT(abs.idabsence) AS NombreAbsencesJustifiees, abs.DATES
FROM FIEVETL.ETUDIANTS e
         JOIN FIEVETL.ETREABSENT abs ON e.IDETUDIANT = abs.IDETUDIANT
WHERE abs.JUSTIFIEE = 'true'
GROUP BY e.IDETUDIANT, abs.DATES;

-- Toutes les infos des étudiants de l'année 2019 inscrits au 1er semestre

CREATE OR REPLACE VIEW FIEVETL.VueInfosEtudiant2019S1 AS
SELECT e.IDETUDIANT, e.CIVILITÉ, e.NOMETUDIANT, e.PRENOMETUDIANT, g.NOMGROUPE, COUNT(abs.idabsence) AS NombreAbsences,absjust.NombreAbsencesJustifiees,
       vm1.moyenneEtudiant, vm2.moyenneEtudiant, vm3.moyenneEtudiant, vm4.moyenneEtudiant,
       vm5.moyenneEtudiant, vm6.moyenneEtudiant, vm7.moyenneEtudiant, vm8.moyenneEtudiant,
       vm9.moyenneEtudiant, vm10.moyenneEtudiant, vm11.moyenneEtudiant, vm12.moyenneEtudiant,
       vm13.moyenneEtudiant
       , a.APPELATIONBAC, a.NOMSPECIALITE
FROM FIEVETL.ETUDIANTS e
JOIN FIEVETL.ADMISSIONS a ON e.IDADMISSION = a.IDADMISSION
JOIN FIEVETL.vueNbrAbsJustifiee absjust ON e.IDETUDIANT = absjust.IDETUDIANT
JOIN FIEVETL.GROUPES g ON e.IDGROUPE = g.IDGROUPE
JOIN FIEVETL.EtreAbsent abs ON e.IDETUDIANT = abs.IDETUDIANT
JOIN FIEVETL.VueNotesEtudiant2019S1 vm ON e.IDETUDIANT = vm.IDETUDIANT
JOIN FIEVETL.ETUDIANTCOURS ec ON e.IDETUDIANT = ec.IDETUDIANT
JOIN FIEVETL.COURS c ON ec.IDCOURS = c.IDCOURS
JOIN FIEVETL.SEMESTRE s ON c.IDSEMESTRE = s.IDSEMESTRE
Left JOIN FIEVETL.VueMoyenne2019EtuM1101 vm1 ON e.IDETUDIANT = vm1.IDETUDIANT
Left JOIN FIEVETL.VueMoyenne2019EtuM1102 vm2 ON e.IDETUDIANT = vm2.IDETUDIANT
Left JOIN FIEVETL.VueMoyenne2019EtuM1103 vm3 ON e.IDETUDIANT = vm3.IDETUDIANT
Left JOIN FIEVETL.VueMoyenne2019EtuM1104 vm4 ON e.IDETUDIANT = vm4.IDETUDIANT
Left JOIN FIEVETL.VueMoyenne2019EtuM1105 vm5 ON e.IDETUDIANT = vm5.IDETUDIANT
Left JOIN FIEVETL.VueMoyenne2019EtuM1106 vm6 ON e.IDETUDIANT = vm6.IDETUDIANT
Left JOIN FIEVETL.VueMoyenne2019EtuM1201 vm7 ON e.IDETUDIANT = vm7.IDETUDIANT
Left JOIN FIEVETL.VueMoyenne2019EtuM1202 vm8 ON e.IDETUDIANT = vm8.IDETUDIANT
Left JOIN FIEVETL.VueMoyenne2019EtuM1203 vm9 ON e.IDETUDIANT = vm9.IDETUDIANT
Left JOIN FIEVETL.VueMoyenne2019EtuM1204 vm10 ON e.IDETUDIANT = vm10.IDETUDIANT
Left JOIN FIEVETL.VueMoyenne2019EtuM1205 vm11 ON e.IDETUDIANT = vm11.IDETUDIANT
Left JOIN FIEVETL.VueMoyenne2019EtuM1206 vm12 ON e.IDETUDIANT = vm12.IDETUDIANT
Left JOIN FIEVETL.VueMoyenne2019EtuM1207 vm13 ON e.IDETUDIANT = vm13.IDETUDIANT
WHERE abs.DATES BETWEEN '01/09/2019' AND '01/01/2020' AND absjust.DATES BETWEEN '01/09/2019' AND '31/12/2019' AND s.NUMEROSEMESTRE = 1
GROUP BY e.IDETUDIANT, e.CIVILITÉ, e.NOMETUDIANT, e.PRENOMETUDIANT, g.NOMGROUPE, absjust.NombreAbsencesJustifiees ,
         a.APPELATIONBAC, a.NOMSPECIALITE, vm1.moyenneEtudiant, vm2.moyenneEtudiant, vm3.moyenneEtudiant,
         vm4.moyenneEtudiant, vm5.moyenneEtudiant, vm6.moyenneEtudiant, vm7.moyenneEtudiant, vm8.moyenneEtudiant,
         vm9.moyenneEtudiant, vm10.moyenneEtudiant, vm11.moyenneEtudiant, vm12.moyenneEtudiant, vm13.moyenneEtudiant


-- Toutes les infos des étudiants de l'année 2020 inscrits au 1er semestre

CREATE OR REPLACE VIEW FIEVETL.VueInfosEtudiant2020S1 AS
SELECT e.IDETUDIANT, e.CIVILITÉ, e.NOMETUDIANT, e.PRENOMETUDIANT, g.NOMGROUPE, COUNT(abs.idabsence) AS NombreAbsences, absjust.NombreAbsencesJustifiees,
       vm1.moyenneEtudiant, vm2.moyenneEtudiant, vm3.moyenneEtudiant, vm4.moyenneEtudiant,
       vm5.moyenneEtudiant, vm6.moyenneEtudiant, vm7.moyenneEtudiant, vm8.moyenneEtudiant,
       vm9.moyenneEtudiant, vm10.moyenneEtudiant, vm11.moyenneEtudiant, vm12.moyenneEtudiant, a.APPELATIONBAC, a.NOMSPECIALITE
FROM FIEVETL.ETUDIANTS e
         JOIN FIEVETL.ADMISSIONS a ON e.IDADMISSION = a.IDADMISSION
         JOIN FIEVETL.GROUPES g ON e.IDGROUPE = g.IDGROUPE
         JOIN FIEVETL.vueNbrAbsJustifiee absjust ON e.IDETUDIANT = absjust.IDETUDIANT
         JOIN FIEVETL.EtreAbsent abs ON e.IDETUDIANT = abs.IDETUDIANT
         JOIN FIEVETL.VueNotesEtudiant2020S1 vm ON e.IDETUDIANT = vm.IDETUDIANT
         JOIN FIEVETL.VueNbrAbsJustifiee VueNbrAbsJust ON e.IDETUDIANT = VueNbrAbsJust.IDETUDIANT
         JOIN FIEVETL.ETUDIANTCOURS ec ON e.IDETUDIANT = ec.IDETUDIANT
         JOIN FIEVETL.COURS c ON ec.IDCOURS = c.IDCOURS
         JOIN FIEVETL.SEMESTRE s ON c.IDSEMESTRE = s.IDSEMESTRE
         LEFT JOIN FIEVETL.VueMoyenne2020EtuM1101 vm ON e.IDETUDIANT = vm.IDETUDIANT
         LEFT JOIN FIEVETL.VueMoyenne2020EtuM1102 vm1 ON vm1.IDETUDIANT = e.IDETUDIANT
         LEFT JOIN FIEVETL.VueMoyenne2020EtuM1103 vm2 ON vm2.IDETUDIANT = e.IDETUDIANT
         LEFT JOIN FIEVETL.VueMoyenne2020EtuM1104 vm3 ON vm3.IDETUDIANT = e.IDETUDIANT
         LEFT JOIN FIEVETL.VueMoyenne2020EtuM1105 vm4 ON vm4.IDETUDIANT = e.IDETUDIANT
         LEFT JOIN FIEVETL.VueMoyenne2020EtuM1106 vm5 ON vm5.IDETUDIANT = e.IDETUDIANT
         LEFT JOIN FIEVETL.VueMoyenne2020EtuM1201 vm6 ON vm6.IDETUDIANT = e.IDETUDIANT
         LEFT JOIN FIEVETL.VueMoyenne2020EtuM1202 vm7 ON vm7.IDETUDIANT = e.IDETUDIANT
         LEFT JOIN FIEVETL.VueMoyenne2020EtuM1203 vm8 ON vm8.IDETUDIANT = e.IDETUDIANT
         LEFT JOIN FIEVETL.VueMoyenne2020EtuM1204 vm9 ON vm9.IDETUDIANT = e.IDETUDIANT
         LEFT JOIN FIEVETL.VueMoyenne2020EtuM1205 vm10 ON vm10.IDETUDIANT = e.IDETUDIANT
         LEFT JOIN FIEVETL.VueMoyenne2020EtuM1206 vm11 ON vm11.IDETUDIANT = e.IDETUDIANT
         LEFT JOIN FIEVETL.VueMoyenne2020EtuM1207 vm12 ON vm12.IDETUDIANT = e.IDETUDIANT
WHERE abs.DATES BETWEEN '01/09/2020' AND '01/01/2021' AND VueNbrAbsJust.DATES BETWEEN '01/09/2019' AND '01/01/2021' AND s.NUMEROSEMESTRE = 1
GROUP BY e.IDETUDIANT, e.CIVILITÉ, e.NOMETUDIANT, e.PRENOMETUDIANT, g.NOMGROUPE, absjust.NombreAbsencesJustifiees,
         vm1.moyenneEtudiant, vm2.moyenneEtudiant, vm3.moyenneEtudiant, vm4.moyenneEtudiant,
         vm5.moyenneEtudiant, vm6.moyenneEtudiant, vm7.moyenneEtudiant, vm8.moyenneEtudiant,
         vm9.moyenneEtudiant, vm10.moyenneEtudiant, vm11.moyenneEtudiant, vm12.moyenneEtudiant, a.APPELATIONBAC, a.NOMSPECIALITE




-- Toutes les infos des étudiants de l'année 2020 qui sont inscrit au 3ème semestre
CREATE OR REPLACE VIEW FIEVETL.VueInfosEtudiant2020S3 AS
SELECT e.IDETUDIANT, e.CIVILITÉ, e.NOMETUDIANT, e.PRENOMETUDIANT, g.NOMGROUPE, COUNT(abs.idabsence) AS NombreAbsences, absjust.NombreAbsencesJustifiees, , a.APPELATIONBAC, a.NOMSPECIALITE
FROM FIEVETL.ETUDIANTS e
         JOIN FIEVETL.ADMISSIONS a ON e.IDADMISSION = a.IDADMISSION
         JOIN FIEVETL.GROUPES g ON e.IDGROUPE = g.IDGROUPE
         JOIN FIEVETL.vueNbrAbsJustifiee absjust ON e.IDETUDIANT = absjust.IDETUDIANT
         JOIN FIEVETL.EtreAbsent abs ON e.IDETUDIANT = abs.IDETUDIANT
         JOIN FIEVETL.VueNotesEtudiant2020S3 vm ON e.IDETUDIANT = vm.IDETUDIANT
         JOIN FIEVETL.VueNbrAbsJustifiee VueNbrAbsJust ON e.IDETUDIANT = VueNbrAbsJust.IDETUDIANT
         JOIN FIEVETL.ETUDIANTCOURS ec ON e.IDETUDIANT = ec.IDETUDIANT
         JOIN FIEVETL.COURS c ON ec.IDCOURS = c.IDCOURS
         JOIN FIEVETL.SEMESTRE s ON c.IDSEMESTRE = s.IDSEMESTRE
        LEFT JOIN FIEVETL.VueMoyenne2020EtuM3101 vm ON e.IDETUDIANT = vm.IDETUDIANT
        LEFT JOIN FIEVETL.VueMoyenne2020EtuM3102 vm1 ON vm1.IDETUDIANT = e.IDETUDIANT
        LEFT JOIN FIEVETL.VueMoyenne2020EtuM3103 vm2 ON vm2.IDETUDIANT = e.IDETUDIANT
        LEFT JOIN FIEVETL.VueMoyenne2020EtuM3104 vm3 ON vm3.IDETUDIANT = e.IDETUDIANT
        LEFT JOIN FIEVETL.VueMoyenne2020EtuM3105 vm4 ON vm4.IDETUDIANT = e.IDETUDIANT
        LEFT JOIN FIEVETL.VueMoyenne2020EtuM3106C vm5 ON vm5.IDETUDIANT = e.IDETUDIANT
        LEFT JOIN FIEVETL.VueMoyenne2020EtuM3201 vm6 ON vm6.IDETUDIANT = e.IDETUDIANT
        LEFT JOIN FIEVETL.VueMoyenne2020EtuM3202C vm7 ON vm7.IDETUDIANT = e.IDETUDIANT
        LEFT JOIN FIEVETL.VueMoyenne2020EtuM4201C vm8 ON vm8.IDETUDIANT = e.IDETUDIANT
        LEFT JOIN FIEVETL.VueMoyenne2020EtuM3204 vm9 ON vm9.IDETUDIANT = e.IDETUDIANT
        LEFT JOIN FIEVETL.VueMoyenne2020EtuM3205 vm10 ON vm10.IDETUDIANT = e.IDETUDIANT
        LEFT JOIN FIEVETL.VueMoyenne2020EtuM3206 vm11 ON vm11.IDETUDIANT = e.IDETUDIANT
        LEFT JOIN FIEVETL.VueMoyenne2020EtuM3301 vm12 ON vm12.IDETUDIANT = e.IDETUDIANT
        LEFT JOIN FIEVETL.VueMoyenne2020EtuM3302 vm13 ON vm13.IDETUDIANT = e.IDETUDIANT
        LEFT JOIN FIEVETL.VueMoyenne2020EtuM3303 vm14 ON vm14.IDETUDIANT = e.IDETUDIANT
WHERE abs.DATES BETWEEN '01/09/2020' AND '01/01/2021' AND VueNbrAbsJust.DATES BETWEEN '01/09/2019' AND '01/01/2021' AND s.NUMEROSEMESTRE = 3
GROUP BY e.IDETUDIANT, e.CIVILITÉ, e.NOMETUDIANT, e.PRENOMETUDIANT, g.NOMGROUPE, absjust.NombreAbsencesJustifiees, a.APPELATIONBAC, a.NOMSPECIALITE




-- Vue 1 : Moyenne des notes par module
CREATE OR REPLACE VIEW FIEVETL.VueNotesEtudiantModule AS
SELECT e.IDETUDIANT, m.CODEMODULE, a.ANNEE, s.NUMEROSEMESTRE, AVG((CASE WHEN ec.note >= 0 THEN ec.note ELSE NULL END / ev.NoteMax) * 20) AS MoyenneEtudiant
FROM FIEVETL.ETUDIANTS e
         JOIN FIEVETL.EtudiantCours ec ON e.IDETUDIANT = ec.IDETUDIANT
         JOIN FIEVETL.EVALUATIONS ev ON ec.IDEVALUATION = ev.IDEVALUATION
         JOIN FIEVETL.COURS c ON ec.IDCOURS = c.IDCOURS
         JOIN FIEVETL.ETUDIERSEMESTRE es ON c.IDSEMESTRE = es.IDSEMESTRE
         JOIN FIEVETL.SEMESTRE s ON es.IDSEMESTRE = s.IDSEMESTRE
         JOIN FIEVETL.MODULES m ON c.IDMODULE = m.IDMODULE
         JOIN FIEVETL.ASSOANNEEADMISSION a ON e.IDADMISSION = a.IDADMISSION
         join FIEVETL.ASSOANNEEADMISSION a on e.IDADMISSION = a.IDADMISSION
GROUP BY e.IDETUDIANT, m.CODEMODULE, a.ANNEE, s.NUMEROSEMESTRE;

--vue 2 : Moyenne des notes par module pour le 1er semestre de l'année universitaire 2019 de chaque étudiant
CREATE OR REPLACE VIEW FIEVETL.VueNotesEtudiant2019S1 AS
SELECT IDETUDIANT, CODEMODULE, moyenneEtudiant
FROM FIEVETL.VueNotesEtudiantModule
WHERE ANNEE = 2019 AND NUMEROSEMESTRE = 1;

--vue 3 : Moyenne des notes par module pour le 1ème semestre de l'année universitaire 2020 de chaque étudiant

CREATE OR REPLACE VIEW FIEVETL.VueNotesEtudiant2020S1 AS
SELECT IDETUDIANT, CODEMODULE, moyenneEtudiant
FROM FIEVETL.VueNotesEtudiantModule
WHERE ANNEE = 2020 AND NUMEROSEMESTRE = 1;

--vue 4 : Moyenne des notes par module pour le 3ème semestre de l'année universitaire 2020 de chaque étudiant

CREATE OR REPLACE VIEW FIEVETL.VueNotesEtudiant2020S3 AS
SELECT IDETUDIANT, CODEMODULE, moyenneEtudiant
FROM FIEVETL.VueNotesEtudiantModule
WHERE ANNEE = 2020 AND NUMEROSEMESTRE = 3;



-- Pour 2019 le premier semestre
CREATE OR REPLACE VIEW FIEVETL.VueMoyenne2019EtuM1101 AS
    SELECT IDETUDIANT, moyenneEtudiant
FROM FIEVETL.VueNotesEtudiant2019S1
WHERE CODEMODULE = 'M1101'
GROUP BY IDETUDIANT, moyenneEtudiant;

CREATE OR REPLACE VIEW FIEVETL.VueMoyenne2019EtuM1102 AS
    SELECT IDETUDIANT, moyenneEtudiant
FROM FIEVETL.VueNotesEtudiant2019S1
WHERE CODEMODULE = 'M1102'
GROUP BY IDETUDIANT, moyenneEtudiant;

CREATE OR REPLACE VIEW FIEVETL.VueMoyenne2019EtuM1103 AS
    SELECT IDETUDIANT, moyenneEtudiant
FROM FIEVETL.VueNotesEtudiant2019S1
WHERE CODEMODULE = 'M1103'
GROUP BY IDETUDIANT, moyenneEtudiant;

CREATE OR REPLACE VIEW FIEVETL.VueMoyenne2019EtuM1104 AS
    SELECT IDETUDIANT, moyenneEtudiant
FROM FIEVETL.VueNotesEtudiant2019S1
WHERE CODEMODULE = 'M1104'
GROUP BY IDETUDIANT, moyenneEtudiant;

CREATE OR REPLACE VIEW FIEVETL.VueMoyenne2019EtuM1105 AS
    SELECT IDETUDIANT, moyenneEtudiant
FROM FIEVETL.VueNotesEtudiant2019S1
WHERE CODEMODULE = 'M1105'
GROUP BY IDETUDIANT, moyenneEtudiant;

CREATE OR REPLACE VIEW FIEVETL.VueMoyenne2019EtuM1106 AS
    SELECT IDETUDIANT, moyenneEtudiant
FROM FIEVETL.VueNotesEtudiant2019S1
WHERE CODEMODULE = 'M1106'
GROUP BY IDETUDIANT, moyenneEtudiant;


CREATE OR REPLACE VIEW FIEVETL.VueMoyenne2019EtuM1201 AS
    SELECT IDETUDIANT, moyenneEtudiant
FROM FIEVETL.VueNotesEtudiant2019S1
WHERE CODEMODULE = 'M1201'
GROUP BY IDETUDIANT, moyenneEtudiant;

CREATE OR REPLACE VIEW FIEVETL.VueMoyenne2019EtuM1202 AS
    SELECT IDETUDIANT, moyenneEtudiant
FROM FIEVETL.VueNotesEtudiant2019S1
WHERE CODEMODULE = 'M1202'
GROUP BY IDETUDIANT, moyenneEtudiant;

CREATE OR REPLACE VIEW FIEVETL.VueMoyenne2019EtuM1203 AS
    SELECT IDETUDIANT, moyenneEtudiant
FROM FIEVETL.VueNotesEtudiant2019S1
WHERE CODEMODULE = 'M1203'
GROUP BY IDETUDIANT, moyenneEtudiant;

CREATE OR REPLACE VIEW FIEVETL.VueMoyenne2019EtuM1204 AS
    SELECT IDETUDIANT, moyenneEtudiant
FROM FIEVETL.VueNotesEtudiant2019S1
WHERE CODEMODULE = 'M1204'
GROUP BY IDETUDIANT, moyenneEtudiant;

CREATE OR REPLACE VIEW FIEVETL.VueMoyenne2019EtuM1205 AS
    SELECT IDETUDIANT, moyenneEtudiant
FROM FIEVETL.VueNotesEtudiant2019S1
WHERE CODEMODULE = 'M1205'
GROUP BY IDETUDIANT, moyenneEtudiant;

CREATE OR REPLACE VIEW FIEVETL.VueMoyenne2019EtuM1206 AS
    SELECT IDETUDIANT, moyenneEtudiant
FROM FIEVETL.VueNotesEtudiant2019S1
WHERE CODEMODULE = 'M1206'
GROUP BY IDETUDIANT, moyenneEtudiant;

CREATE OR REPLACE VIEW FIEVETL.VueMoyenne2019EtuM1207 AS
    SELECT IDETUDIANT, moyenneEtudiant
FROM FIEVETL.VueNotesEtudiant2019S1
WHERE CODEMODULE = 'M1207'
GROUP BY IDETUDIANT, moyenneEtudiant;


-- Pour 2020 le 1er semestre
CREATE OR REPLACE VIEW FIEVETL.VueMoyenne2020EtuM1101 AS
SELECT IDETUDIANT, moyenneEtudiant
FROM FIEVETL.VueNotesEtudiant2020S1
WHERE CODEMODULE = 'M1101'
GROUP BY IDETUDIANT, moyenneEtudiant;

CREATE OR REPLACE VIEW FIEVETL.VueMoyenne2020EtuM1102 AS
SELECT IDETUDIANT, moyenneEtudiant
FROM FIEVETL.VueNotesEtudiant2020S1
WHERE CODEMODULE = 'M1102'
GROUP BY IDETUDIANT, moyenneEtudiant;

CREATE OR REPLACE VIEW FIEVETL.VueMoyenne2020EtuM1103 AS
SELECT IDETUDIANT, moyenneEtudiant
FROM FIEVETL.VueNotesEtudiant2020S1
WHERE CODEMODULE = 'M1103'
GROUP BY IDETUDIANT, moyenneEtudiant;

CREATE OR REPLACE VIEW FIEVETL.VueMoyenne2020EtuM1104 AS
SELECT IDETUDIANT, moyenneEtudiant
FROM FIEVETL.VueNotesEtudiant2020S1
WHERE CODEMODULE = 'M1104'
GROUP BY IDETUDIANT, moyenneEtudiant;

CREATE OR REPLACE VIEW FIEVETL.VueMoyenne2020EtuM1105 AS
SELECT IDETUDIANT, moyenneEtudiant
FROM FIEVETL.VueNotesEtudiant2020S1
WHERE CODEMODULE = 'M1105'
GROUP BY IDETUDIANT, moyenneEtudiant;

CREATE OR REPLACE VIEW FIEVETL.VueMoyenne2020EtuM1106 AS
SELECT IDETUDIANT, moyenneEtudiant
FROM FIEVETL.VueNotesEtudiant2020S1
WHERE CODEMODULE = 'M1106'
GROUP BY IDETUDIANT, moyenneEtudiant;

-- Pour 2020
CREATE OR REPLACE VIEW FIEVETL.VueMoyenne2020EtuM1201 AS
SELECT IDETUDIANT, moyenneEtudiant
FROM FIEVETL.VueNotesEtudiant2020S1
WHERE CODEMODULE = 'M1201'
GROUP BY IDETUDIANT, moyenneEtudiant;

CREATE OR REPLACE VIEW FIEVETL.VueMoyenne2020EtuM1202 AS
SELECT IDETUDIANT, moyenneEtudiant
FROM FIEVETL.VueNotesEtudiant2020S1
WHERE CODEMODULE = 'M1202'
GROUP BY IDETUDIANT, moyenneEtudiant;

CREATE OR REPLACE VIEW FIEVETL.VueMoyenne2020EtuM1203 AS
SELECT IDETUDIANT, moyenneEtudiant
FROM FIEVETL.VueNotesEtudiant2020S1
WHERE CODEMODULE = 'M1203'
GROUP BY IDETUDIANT, moyenneEtudiant;

CREATE OR REPLACE VIEW FIEVETL.VueMoyenne2020EtuM1204 AS
SELECT IDETUDIANT, moyenneEtudiant
FROM FIEVETL.VueNotesEtudiant2020S1
WHERE CODEMODULE = 'M1204'
GROUP BY IDETUDIANT, moyenneEtudiant;

CREATE OR REPLACE VIEW FIEVETL.VueMoyenne2020EtuM1205 AS
SELECT IDETUDIANT, moyenneEtudiant
FROM FIEVETL.VueNotesEtudiant2020S1
WHERE CODEMODULE = 'M1205'
GROUP BY IDETUDIANT, moyenneEtudiant;

CREATE OR REPLACE VIEW FIEVETL.VueMoyenne2020EtuM1206 AS
SELECT IDETUDIANT, moyenneEtudiant
FROM FIEVETL.VueNotesEtudiant2020S1
WHERE CODEMODULE = 'M1206'
GROUP BY IDETUDIANT, moyenneEtudiant;

CREATE OR REPLACE VIEW FIEVETL.VueMoyenne2020EtuM1207 AS
SELECT IDETUDIANT, moyenneEtudiant
FROM FIEVETL.VueNotesEtudiant2020S1
WHERE CODEMODULE = 'M1207'
GROUP BY IDETUDIANT, moyenneEtudiant;


-- Pour 2020 le 3eme semestre

CREATE OR REPLACE VIEW FIEVETL.VueMoyenne2020EtuM3101 AS
    SELECT IDETUDIANT, moyenneEtudiant
FROM FIEVETL.VueNotesEtudiant2020S3
WHERE CODEMODULE = 'M3101'
GROUP BY IDETUDIANT, moyenneEtudiant;

CREATE OR REPLACE VIEW FIEVETL.VueMoyenne2020EtuM3102 AS
    SELECT IDETUDIANT, moyenneEtudiant
FROM FIEVETL.VueNotesEtudiant2020S3
WHERE CODEMODULE = 'M3102'
GROUP BY IDETUDIANT, moyenneEtudiant;

CREATE OR REPLACE VIEW FIEVETL.VueMoyenne2020EtuM3103 AS
    SELECT IDETUDIANT, moyenneEtudiant
FROM FIEVETL.VueNotesEtudiant2020S3
WHERE CODEMODULE = 'M3103'
GROUP BY IDETUDIANT, moyenneEtudiant;

CREATE OR REPLACE VIEW FIEVETL.VueMoyenne2020EtuM3104 AS
    SELECT IDETUDIANT, moyenneEtudiant
FROM FIEVETL.VueNotesEtudiant2020S3
WHERE CODEMODULE = 'M3104'
GROUP BY IDETUDIANT, moyenneEtudiant;

CREATE OR REPLACE VIEW FIEVETL.VueMoyenne2020EtuM3105 AS
SELECT IDETUDIANT, moyenneEtudiant
FROM FIEVETL.VueNotesEtudiant2020S3
WHERE CODEMODULE = 'M3105'
GROUP BY IDETUDIANT, moyenneEtudiant;

CREATE OR REPLACE VIEW FIEVETL.VueMoyenne2020EtuM3106C AS
SELECT IDETUDIANT, moyenneEtudiant
FROM FIEVETL.VueNotesEtudiant2020S3
WHERE CODEMODULE = 'M3106C'
GROUP BY IDETUDIANT, moyenneEtudiant;

CREATE OR REPLACE VIEW FIEVETL.VueMoyenne2020EtuM3201 AS
SELECT IDETUDIANT, moyenneEtudiant
FROM FIEVETL.VueNotesEtudiant2020S3
WHERE CODEMODULE = 'M3201'
GROUP BY IDETUDIANT, moyenneEtudiant;

CREATE OR REPLACE VIEW FIEVETL.VueMoyenne2020EtuM3202C AS
SELECT IDETUDIANT, moyenneEtudiant
FROM FIEVETL.VueNotesEtudiant2020S3
WHERE CODEMODULE = 'M3202C'
GROUP BY IDETUDIANT, moyenneEtudiant;

--M4201C  me paraît être lié au semestre 4 ??
CREATE OR REPLACE VIEW FIEVETL.VueMoyenne2020EtuM4201C AS
SELECT IDETUDIANT, moyenneEtudiant
FROM FIEVETL.VueNotesEtudiant2020S3
WHERE CODEMODULE = 'M4201C'
GROUP BY IDETUDIANT, moyenneEtudiant;

CREATE OR REPLACE VIEW FIEVETL.VueMoyenne2020EtuM3204 AS
SELECT IDETUDIANT, moyenneEtudiant
FROM FIEVETL.VueNotesEtudiant2020S3
WHERE CODEMODULE = 'M3204'
GROUP BY IDETUDIANT, moyenneEtudiant;

CREATE OR REPLACE VIEW FIEVETL.VueMoyenne2020EtuM3205 AS
SELECT IDETUDIANT, moyenneEtudiant
FROM FIEVETL.VueNotesEtudiant2020S3
WHERE CODEMODULE = 'M3205'
GROUP BY IDETUDIANT, moyenneEtudiant;

CREATE OR REPLACE VIEW FIEVETL.VueMoyenne2020EtuM3206 AS
SELECT IDETUDIANT, moyenneEtudiant
FROM FIEVETL.VueNotesEtudiant2020S3
WHERE CODEMODULE = 'M3206'
GROUP BY IDETUDIANT, moyenneEtudiant;

CREATE OR REPLACE VIEW FIEVETL.VueMoyenne2020EtuM3301 AS
SELECT IDETUDIANT, moyenneEtudiant
FROM FIEVETL.VueNotesEtudiant2020S3
WHERE CODEMODULE = 'M3301'
GROUP BY IDETUDIANT, moyenneEtudiant;


CREATE OR REPLACE VIEW FIEVETL.VueMoyenne2020EtuM3302 AS
SELECT IDETUDIANT, moyenneEtudiant
FROM FIEVETL.VueNotesEtudiant2020S3
WHERE CODEMODULE = 'M3302'
GROUP BY IDETUDIANT, moyenneEtudiant;

CREATE OR REPLACE VIEW FIEVETL.VueMoyenne2020EtuM3303 AS
SELECT IDETUDIANT, moyenneEtudiant
FROM FIEVETL.VueNotesEtudiant2020S3
WHERE CODEMODULE = 'M3303'
GROUP BY IDETUDIANT, moyenneEtudiant;





------------------------ Livrable de Gestion ---------------------------------------------------------------------------

--taux de réussite par année
CREATE OR REPLACE VIEW TauxReussiteAnnee AS
SELECT
    a.ANNEE,
    COUNT(CASE WHEN ec.note >= 10 THEN ec.note ELSE NULL END) AS NombreReussite,
    COUNT(CASE WHEN ec.note < 10 THEN ec.note ELSE NULL END) AS NombreEchec,
    COUNT(ec.note) AS NombreTotal,
    (COUNT(CASE WHEN ec.note >= 10 THEN ec.note ELSE NULL END) / COUNT(ec.note)) * 100 AS TauxReussite
FROM
    FIEVETL.EtudiantCours ec
        JOIN
    FIEVETL.Etudiants e ON ec.IdEtudiant = e.IdEtudiant
        JOIN
    FIEVETL.ASSOANNEEADMISSION a ON e.IDADMISSION = a.IDADMISSION
GROUP BY
    a.ANNEE
ORDER BY a.ANNEE ASC;

------------------------------------------------------------------------------------------------------------------------
--taux de reusite du module Bonus Sport ci la note est supérieur 0 (donc si l'étudiant a participé)
CREATE OR REPLACE VIEW TauxReussiteBonusSport AS
SELECT
    m.NomModule,
    COUNT(CASE WHEN ec.note > 0 THEN ec.note ELSE NULL END) AS NombreReussite,
    COUNT(CASE WHEN ec.note <= 0 THEN ec.note ELSE NULL END) AS NombreEchec,
    COUNT(ec.note) AS NombreTotal,
    (COUNT(CASE WHEN ec.note > 0 THEN ec.note ELSE NULL END) / COUNT(ec.note)) * 100 AS TauxReussite
FROM
    FIEVETL.EtudiantCours ec
        JOIN
    FIEVETL.Cours c ON ec.IdCours = c.IdCours
        JOIN
    FIEVETL.Modules m ON c.IdModule = m.IdModule
WHERE
        m.NomModule = 'Bonus Sport'
  AND ec.note >= 0
GROUP BY
    m.NomModule;

------------------------------------------------------------------------------------------------------------------------
--nombre devaluation par module
CREATE OR REPLACE VIEW NombreEvaluationModule AS
SELECT
    m.NomModule,
    COUNT(ec.note) AS NombreEvaluation
FROM
    FIEVETL.EtudiantCours ec
        JOIN
    FIEVETL.Cours c ON ec.IdCours = c.IdCours
        JOIN
    FIEVETL.Modules m ON c.IdModule = m.IdModule
GROUP BY
    m.NomModule;

------------------------------------------------------------------------------------------------------------------------
--totes les notes du module 'M3201'
CREATE OR REPLACE VIEW NotesModule AS
SELECT
    ec.note
FROM
    FIEVETL.EtudiantCours ec
        JOIN
    FIEVETL.Cours c ON ec.IdCours = c.IdCours
        JOIN
    FIEVETL.Modules m ON c.IdModule = m.IdModule
WHERE
        m.NomModule = 'M3201';



------------------------------------------------------------------------------------------------------------------------

