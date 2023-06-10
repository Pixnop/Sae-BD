CREATE VIEW EvaluationsNonZero AS
SELECT *
FROM FIEVETL.Evaluations
WHERE Coefficient > 0;

CREATE VIEW ModulesNonZero AS
SELECT *
FROM FIEVETL.Modules
WHERE Coefficient > 0;

CREATE VIEW UENonZero AS
SELECT *
FROM FIEVETL.UE
WHERE CoefficientUE > 0;

-- Créer une vue pour calculer le score total de chaque étudiant pour chaque semestre
CREATE OR REPLACE VIEW ScoreTotal AS
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
    (SELECT * FROM EvaluationsNonZero) ev ON ec.IDEVALUATION= ev.IDEVALUATION
        JOIN
    (SELECT * FROM ModulesNonZero) m ON c.IdModule = m.IdModule
        JOIN
    FIEVETL.ASSOMODULE a on m.IDMODULE = a.IDMODULE
        JOIN
    (SELECT * FROM UENonZero) u on a.IDUE = u.IDUE
GROUP BY
    e.IdEtudiant,
    es.IdSemestre;

-- Créer une vue pour calculer le classement des étudiants à chaque semestre
CREATE OR REPLACE VIEW ClassementEtudiants AS
SELECT
    st.IdEtudiant,
    st.IdSemestre,
    st.ScoreTotal * 20 AS ScoreTotalSur20,
    RANK() OVER (PARTITION BY st.IdSemestre ORDER BY st.ScoreTotal DESC) AS Classement
FROM
    ScoreTotal st;


------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE VIEW AgeEtudiants AS
SELECT
    e.IdEtudiant,
    e.DateNaissance,
    (SYSDATE - e.DateNaissance) / 365 AS Age
FROM
    FIEVETL.Etudiants e;

CREATE OR REPLACE VIEW SigneAstrologiqueEtudiants AS
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
    AgeEtudiants a;

CREATE OR REPLACE VIEW ModuleSigneAstrologique AS
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
    SigneAstrologiqueEtudiants s ON ec.IdEtudiant = s.IdEtudiant;


------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE VIEW MoyenneModuleBac AS
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
    (SELECT * FROM ScoreTotal) st ON e.IdEtudiant = st.IdEtudiant
GROUP BY
    m.IdModule,
    m.NomModule,
    b.APPELATIONBAC;

------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE VIEW MoyenneNotesEnseignant AS
SELECT U.IdUtilisateur, U.NomUtilisateur, AVG((CASE WHEN EC.note >= 0 THEN EC.note ELSE 0 END / E.NoteMax) * 20) AS MoyenneNotes
FROM FIEVETL.Utilisateurs U
         JOIN FIEVETL.EvaluerParUtilisateur EU ON U.IdUtilisateur = EU.IdUtilisateur
         JOIN FIEVETL.Evaluations E ON EU.IdEvaluation = E.IdEvaluation
         JOIN FIEVETL.EtudiantCours EC ON E.IdEvaluation = EC.IdEvaluation
GROUP BY U.IdUtilisateur, U.NomUtilisateur;

------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE VIEW NombreAbsencesParMois AS
SELECT TO_CHAR(EA.Dates, 'YYYY-MM') AS MoisAnnee,
       COUNT(*) AS NombreAbsences
FROM FIEVETL.EtreAbsent EA
GROUP BY TO_CHAR(EA.Dates, 'YYYY-MM');

------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE VIEW TopEnseignements AS
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

------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE VIEW BottomEnseignements AS
SELECT
    NomModule,
    MoyenneNote
FROM
    FIEVETL.TopEnseignements
ORDER BY MoyenneNote ASC;

------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE VIEW Top3AnneesUniversitaires AS
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
CREATE OR REPLACE VIEW TauxReussiteModule AS
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

--Vue donnant la fréquence et le nombre d'effectifs des étudiants par année



CREATE OR REPLACE VIEW VueEffectifs2019 AS
SELECT b.APPELATIONBAC, count(*) as effectif2019, count(*) * 100 / (SELECT count(*) FROM FIEVETL.Etudiants e
    JOIN FIEVETL.ADMISSIONS a on e.IDADMISSION = a.IDADMISSION
    JOIN FIEVETL.ASSOANNEEADMISSION an on a.IDADMISSION = an.IDADMISSION
    JOIN FIEVETL.BAC b on a.APPELATIONBAC = b.APPELATIONBAC
WHERE an.ANNEE = 2019) as frequence2019
FROM FIEVETL.Etudiants e
    JOIN FIEVETL.ADMISSIONS a on e.IDADMISSION = a.IDADMISSION
    JOIN FIEVETL.ASSOANNEEADMISSION an on a.IDADMISSION = an.IDADMISSION
    JOIN FIEVETL.BAC b on a.APPELATIONBAC = b.APPELATIONBAC
WHERE an.ANNEE = 2019
group by b.APPELATIONBAC
Order by effectif2019 desc;

-- des bacs qui n'existent pas ont été ajoutés car erreur dans la base de données originelle.

CREATE VIEW VueEffectifs202O AS
SELECT b.APPELATIONBAC, count(*) as effectif2020, count(*) * 100 / (SELECT count(*) FROM FIEVETL.Etudiants e
     JOIN FIEVETL.ADMISSIONS a on e.IDADMISSION = a.IDADMISSION
     JOIN FIEVETL.ASSOANNEEADMISSION an on a.IDADMISSION = an.IDADMISSION
     JOIN FIEVETL.BAC b on a.APPELATIONBAC = b.APPELATIONBAC
WHERE an.ANNEE = 2020) as frequence2020
FROM FIEVETL.Etudiants e
         JOIN FIEVETL.ADMISSIONS a on e.IDADMISSION = a.IDADMISSION
         JOIN FIEVETL.ASSOANNEEADMISSION an on a.IDADMISSION = an.IDADMISSION
         JOIN FIEVETL.BAC b on a.APPELATIONBAC = b.APPELATIONBAC
WHERE an.ANNEE = 2020
group by b.APPELATIONBAC
Order by effectif2020 desc;


CREATE OR REPLACE VIEW VueEffectifsParAnnee AS
SELECT COALESCE(v.appelationBac, v1.appelationBac) AS appelationBac,
       v.effectif2019,
       v.frequence2019,
       v1.effectif2020,
       v1.frequence2020
FROM VueEffectifs2019 v
         FULL JOIN VueEffectifs202O v1 ON v.appelationBac = v1.appelationBac
UNION ALL
SELECT 'Total' AS appelationBac,
       SUM(v.effectif2019) AS effectif2019,
       SUM(v.frequence2019) AS frequence2019,
       SUM(v1.effectif2020) AS effectif2020,
       SUM(v1.frequence2020) AS frequence2020
FROM VueEffectifs2019 v
         FULL JOIN VueEffectifs202O v1 ON v.appelationBac = v1.appelationBac;









------------------------------------------------------------------------------------------------------------------------