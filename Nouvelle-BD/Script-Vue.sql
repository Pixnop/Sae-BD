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

-- Vue 1 : Moyenne des notes par module pour le 1er semestre de l'année universitaire 2019 de chaque étudiant

CREATE OR REPLACE VIEW FIEVETL.VueInfosEtudiant2019 AS
SELECT e.IDETUDIANT, e.CIVILITE, e.nom, e.prenom, g.idgroupe, COUNT()



-- Vue 2 Moyenne de chaque étudiant pour le module M1101 en 2019

CREATE OR REPLACE VIEW FIEVETL.VueMoyenneEtudiantM1101 AS
SELECT e.IDETUDIANT, m.idModule, AVG(ec.note) AS MoyenneEtudiant
FROM FIEVETL.ETUDIANTS e
JOIN FIEVETL.EtudiantCours ec ON e.IDETUDIANT = ec.IDETUDIANT



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

