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

--Vue donnant la fréquence et le nombre d'effectifs des étudiants par année


CREATE OR REPLACE VIEW FIEVETL.VueEffectifs2019 AS
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

CREATE OR REPLACE VIEW FIEVETL.VueEffectifs202O AS
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


CREATE OR REPLACE VIEW FIEVETL.VueEffectifsParAnnee AS
SELECT COALESCE(v.appelationBac, v1.appelationBac) AS appelationBac,
       v.effectif2019,
       v.frequence2019,
       v1.effectif2020,
       v1.frequence2020
FROM FIEVETL.VueEffectifs2019 v
         FULL JOIN FIEVETL.VueEffectifs202O v1 ON v.appelationBac = v1.appelationBac
UNION ALL
SELECT 'Total' AS appelationBac,
       SUM(v.effectif2019) AS effectif2019,
       SUM(v.frequence2019) AS frequence2019,
       SUM(v1.effectif2020) AS effectif2020,
       SUM(v1.frequence2020) AS frequence2020
FROM FIEVETL.VueEffectifs2019 v
         FULL JOIN FIEVETL.VueEffectifs202O v1 ON v.appelationBac = v1.appelationBac;

------------------------------------------------------------------------------------------------------------------------
-- Vue donnant l'effectif par spécialité des etudiants ayant eu un bac de type "S" en 2019 et le total de ces derniers

CREATE OR REPLACE VIEW FIEVETL.VueEffectifsParSpecialite2019 AS
SELECT a.NOMSPECIALITE, count(*) as effectif2019
FROM FIEVETL.Etudiants e
    JOIN FIEVETL.ADMISSIONS a on e.IDADMISSION = a.IDADMISSION
    JOIN FIEVETL.ASSOANNEEADMISSION an on a.IDADMISSION = an.IDADMISSION
    JOIN FIEVETL.BAC b on a.APPELATIONBAC = b.APPELATIONBAC
WHERE an.ANNEE = 2019 AND b.APPELATIONBAC = 'S'
group by a.NOMSPECIALITE
Order by effectif2019 desc;


-- Vue donnant l'effectif par spécialité des etudiants ayant eu un bac de type "S" en 2020

CREATE OR REPLACE VIEW FIEVETL.VueEffectifsParSpecialite2020 AS
SELECT a.NOMSPECIALITE, count(*) as effectif2020
FROM FIEVETL.Etudiants e
    JOIN FIEVETL.ADMISSIONS a on e.IDADMISSION = a.IDADMISSION
    JOIN FIEVETL.ASSOANNEEADMISSION an on a.IDADMISSION = an.IDADMISSION
    JOIN FIEVETL.BAC b on a.APPELATIONBAC = b.APPELATIONBAC
WHERE an.ANNEE = 2020 AND b.APPELATIONBAC = 'S'
group by a.NOMSPECIALITE
Order by effectif2020 desc;

------------------------------------------------------------------------------------------------------------------------

-- Vue donnant respectivement les effectifs, les fréquences, les amplitudes et la valeur de la l'histogramme sur chaque classe

-- 0-2
CREATE OR REPLACE VIEW FIEVETL.VueEffectifsParNoteInf2 AS
SELECT '0-2' AS classeNote,
       COUNT(*) AS effectifInf2,
       COUNT(*) * 100 / (
           SELECT COUNT(*)
           FROM FIEVETL.EtudiantCours ec
                    JOIN FIEVETL.Cours c ON ec.IDCOURS = c.IDCOURS
                    JOIN FIEVETL.Modules m ON c.IDMODULE = m.IDMODULE
                    JOIN FIEVETL.ETUDIANTS e ON ec.IDETUDIANT = e.IDETUDIANT
                    JOIN FIEVETL.ASSOANNEEADMISSION an ON e.IDADMISSION = an.IDADMISSION
           WHERE m.NOMMODULE = 'M3201' AND an.ANNEE = 2020
       ) AS frequenceInf2
FROM FIEVETL.EtudiantCours ec
         JOIN FIEVETL.Cours c ON ec.IDCOURS = c.IDCOURS
         JOIN FIEVETL.Modules m ON c.IDMODULE = m.IDMODULE
         JOIN FIEVETL.ETUDIANTS e ON ec.IDETUDIANT = e.IDETUDIANT
         JOIN FIEVETL.ASSOANNEEADMISSION an ON e.IDADMISSION = an.IDADMISSION
WHERE m.NOMMODULE = 'M3201' AND an.ANNEE = 2020 AND ec.NOTE < 2
GROUP BY '0-2';


-- 2-4
CREATE OR REPLACE VIEW FIEVETL.VueEffectifsParNoteInf4 AS
SELECT '2-4' AS classeNote,
       COUNT(*) AS effectifInf4,
       COUNT(*) * 100 / (
           SELECT COUNT(*)
           FROM FIEVETL.EtudiantCours ec
                    JOIN FIEVETL.Cours c ON ec.IDCOURS = c.IDCOURS
                    JOIN FIEVETL.Modules m ON c.IDMODULE = m.IDMODULE
                    JOIN FIEVETL.ETUDIANTS e ON ec.IDETUDIANT = e.IDETUDIANT
                    JOIN FIEVETL.ASSOANNEEADMISSION an ON e.IDADMISSION = an.IDADMISSION
           WHERE m.NOMMODULE = 'M3201' AND an.ANNEE = 2020
       ) AS frequenceInf4 -- frequenceInf4
FROM FIEVETL.EtudiantCours ec
         JOIN FIEVETL.Cours c ON ec.IDCOURS = c.IDCOURS
         JOIN FIEVETL.Modules m ON c.IDMODULE = m.IDMODULE
         JOIN FIEVETL.ETUDIANTS e ON ec.IDETUDIANT = e.IDETUDIANT
         JOIN FIEVETL.ASSOANNEEADMISSION an ON e.IDADMISSION = an.IDADMISSION
WHERE m.NOMMODULE = 'M3201' AND an.ANNEE = 2020 AND ec.NOTE >= 2 AND ec.NOTE < 4
GROUP BY '2-4';

-- 4-6
CREATE OR REPLACE VIEW FIEVETL.VueEffectifsParNoteInf6 AS
SELECT '4-6' AS classeNote,
       COUNT(*) AS effectifInf6,
       COUNT(*) * 100 / (
           SELECT COUNT(*)
           FROM FIEVETL.EtudiantCours ec
                    JOIN FIEVETL.Cours c ON ec.IDCOURS = c.IDCOURS
                    JOIN FIEVETL.Modules m ON c.IDMODULE = m.IDMODULE
                    JOIN FIEVETL.ETUDIANTS e ON ec.IDETUDIANT = e.IDETUDIANT
                    JOIN FIEVETL.ASSOANNEEADMISSION an ON e.IDADMISSION = an.IDADMISSION
           WHERE m.NOMMODULE = 'M3201' AND an.ANNEE = 2020
       ) AS frequenceInf6
FROM FIEVETL.EtudiantCours ec
         JOIN FIEVETL.Cours c ON ec.IDCOURS = c.IDCOURS
         JOIN FIEVETL.Modules m ON c.IDMODULE = m.IDMODULE
         JOIN FIEVETL.ETUDIANTS e ON ec.IDETUDIANT = e.IDETUDIANT
         JOIN FIEVETL.ASSOANNEEADMISSION an ON e.IDADMISSION = an.IDADMISSION
WHERE m.NOMMODULE = 'M3201' AND an.ANNEE = 2020 AND ec.NOTE >= 4 AND ec.NOTE < 6
GROUP BY '4-6';

-- 6-8
CREATE OR REPLACE VIEW FIEVETL.VueEffectifsParNoteInf8 AS
SELECT '6-8' AS classeNote,
       COUNT(*) AS effectifInf8,
       COUNT(*) * 100 / (
           SELECT COUNT(*)
           FROM FIEVETL.EtudiantCours ec
                    JOIN FIEVETL.Cours c ON ec.IDCOURS = c.IDCOURS
                    JOIN FIEVETL.Modules m ON c.IDMODULE = m.IDMODULE
                    JOIN FIEVETL.ETUDIANTS e ON ec.IDETUDIANT = e.IDETUDIANT
                    JOIN FIEVETL.ASSOANNEEADMISSION an ON e.IDADMISSION = an.IDADMISSION
           WHERE m.NOMMODULE = 'M3201' AND an.ANNEE = 2020
       ) AS frequenceInf8
FROM FIEVETL.EtudiantCours ec
         JOIN FIEVETL.Cours c ON ec.IDCOURS = c.IDCOURS
         JOIN FIEVETL.Modules m ON c.IDMODULE = m.IDMODULE
         JOIN FIEVETL.ETUDIANTS e ON ec.IDETUDIANT = e.IDETUDIANT
         JOIN FIEVETL.ASSOANNEEADMISSION an ON e.IDADMISSION = an.IDADMISSION
WHERE m.NOMMODULE = 'M3201' AND an.ANNEE = 2020 AND ec.NOTE >= 6 AND ec.NOTE < 8
GROUP BY '6-8';

-- 8-10
CREATE OR REPLACE VIEW FIEVETL.VueEffectifsParNoteInf10 AS
SELECT '8-10' AS classeNote,
       COUNT(*) AS effectifInf10,
       COUNT(*) * 100 / (
           SELECT COUNT(*)
           FROM FIEVETL.EtudiantCours ec
                    JOIN FIEVETL.Cours c ON ec.IDCOURS = c.IDCOURS
                    JOIN FIEVETL.Modules m ON c.IDMODULE = m.IDMODULE
                    JOIN FIEVETL.ETUDIANTS e ON ec.IDETUDIANT = e.IDETUDIANT
                    JOIN FIEVETL.ASSOANNEEADMISSION an ON e.IDADMISSION = an.IDADMISSION
           WHERE m.NOMMODULE = 'M3201' AND an.ANNEE = 2020
       ) AS frequenceInf10
FROM FIEVETL.EtudiantCours ec
         JOIN FIEVETL.Cours c ON ec.IDCOURS = c.IDCOURS
         JOIN FIEVETL.Modules m ON c.IDMODULE = m.IDMODULE
         JOIN FIEVETL.ETUDIANTS e ON ec.IDETUDIANT = e.IDETUDIANT
         JOIN FIEVETL.ASSOANNEEADMISSION an ON e.IDADMISSION = an.IDADMISSION
WHERE m.NOMMODULE = 'M3201' AND an.ANNEE = 2020 AND ec.NOTE >= 8 AND ec.NOTE <= 10
GROUP BY '8-10';

-- 10-12
CREATE OR REPLACE VIEW FIEVETL.VueEffectifsParNoteInf12 AS
SELECT '10-12' AS classeNote,
       COUNT(*) AS effectifInf12,
       COUNT(*) * 100 / (
           SELECT COUNT(*)
           FROM FIEVETL.EtudiantCours ec
                    JOIN FIEVETL.Cours c ON ec.IDCOURS = c.IDCOURS
                    JOIN FIEVETL.Modules m ON c.IDMODULE = m.IDMODULE
                    JOIN FIEVETL.ETUDIANTS e ON ec.IDETUDIANT = e.IDETUDIANT
                    JOIN FIEVETL.ASSOANNEEADMISSION an ON e.IDADMISSION = an.IDADMISSION
           WHERE m.NOMMODULE = 'M3201' AND an.ANNEE = 2020
       ) AS frequenceInf12
FROM FIEVETL.EtudiantCours ec
         JOIN FIEVETL.Cours c ON ec.IDCOURS = c.IDCOURS
         JOIN FIEVETL.Modules m ON c.IDMODULE = m.IDMODULE
         JOIN FIEVETL.ETUDIANTS e ON ec.IDETUDIANT = e.IDETUDIANT
         JOIN FIEVETL.ASSOANNEEADMISSION an ON e.IDADMISSION = an.IDADMISSION
WHERE m.NOMMODULE = 'M3201' AND an.ANNEE = 2020 AND ec.NOTE >= 10 AND ec.NOTE < 12
GROUP BY '10-12';

-- 12-14
CREATE OR REPLACE VIEW FIEVETL.VueEffectifsParNoteInf14 AS
SELECT '12-14' AS classeNote,
       COUNT(*) AS effectifInf14,
       COUNT(*) * 100 / (
           SELECT COUNT(*)
           FROM FIEVETL.EtudiantCours ec
                    JOIN FIEVETL.Cours c ON ec.IDCOURS = c.IDCOURS
                    JOIN FIEVETL.Modules m ON c.IDMODULE = m.IDMODULE
                    JOIN FIEVETL.ETUDIANTS e ON ec.IDETUDIANT = e.IDETUDIANT
                    JOIN FIEVETL.ASSOANNEEADMISSION an ON e.IDADMISSION = an.IDADMISSION
           WHERE m.NOMMODULE = 'M3201' AND an.ANNEE = 2020
       ) AS frequenceInf14
FROM FIEVETL.EtudiantCours ec
         JOIN FIEVETL.Cours c ON ec.IDCOURS = c.IDCOURS
         JOIN FIEVETL.Modules m ON c.IDMODULE = m.IDMODULE
         JOIN FIEVETL.ETUDIANTS e ON ec.IDETUDIANT = e.IDETUDIANT
         JOIN FIEVETL.ASSOANNEEADMISSION an ON e.IDADMISSION = an.IDADMISSION
WHERE m.NOMMODULE = 'M3201' AND an.ANNEE = 2020 AND ec.NOTE >= 12 AND ec.NOTE < 14
GROUP BY '12-14';

-- 14-16
CREATE OR REPLACE VIEW FIEVETL.VueEffectifsParNoteInf16 AS
SELECT '14-16' AS classeNote,
       COUNT(*) AS effectifInf16,
       COUNT(*) * 100 / (
           SELECT COUNT(*)
           FROM FIEVETL.EtudiantCours ec
                    JOIN FIEVETL.Cours c ON ec.IDCOURS = c.IDCOURS
                    JOIN FIEVETL.Modules m ON c.IDMODULE = m.IDMODULE
                    JOIN FIEVETL.ETUDIANTS e ON ec.IDETUDIANT = e.IDETUDIANT
                    JOIN FIEVETL.ASSOANNEEADMISSION an ON e.IDADMISSION = an.IDADMISSION
           WHERE m.NOMMODULE = 'M3201' AND an.ANNEE = 2020
       ) AS frequenceInf16
FROM FIEVETL.EtudiantCours ec
         JOIN FIEVETL.Cours c ON ec.IDCOURS = c.IDCOURS
         JOIN FIEVETL.Modules m ON c.IDMODULE = m.IDMODULE
         JOIN FIEVETL.ETUDIANTS e ON ec.IDETUDIANT = e.IDETUDIANT
         JOIN FIEVETL.ASSOANNEEADMISSION an ON e.IDADMISSION = an.IDADMISSION
WHERE m.NOMMODULE = 'M3201' AND an.ANNEE = 2020 AND ec.NOTE >= 14 AND ec.NOTE < 16
GROUP BY '14-16';

-- 16-18
CREATE OR REPLACE VIEW FIEVETL.VueEffectifsParNoteInf18 AS
SELECT '16-18' AS classeNote,
       COUNT(*) AS effectifInf18,
       COUNT(*) * 100 / (
           SELECT COUNT(*)
           FROM FIEVETL.EtudiantCours ec
                    JOIN FIEVETL.Cours c ON ec.IDCOURS = c.IDCOURS
                    JOIN FIEVETL.Modules m ON c.IDMODULE = m.IDMODULE
                    JOIN FIEVETL.ETUDIANTS e ON ec.IDETUDIANT = e.IDETUDIANT
                    JOIN FIEVETL.ASSOANNEEADMISSION an ON e.IDADMISSION = an.IDADMISSION
           WHERE m.NOMMODULE = 'M3201' AND an.ANNEE = 2020
       ) AS frequenceInf18
FROM FIEVETL.EtudiantCours ec
         JOIN FIEVETL.Cours c ON ec.IDCOURS = c.IDCOURS
         JOIN FIEVETL.Modules m ON c.IDMODULE = m.IDMODULE
         JOIN FIEVETL.ETUDIANTS e ON ec.IDETUDIANT = e.IDETUDIANT
         JOIN FIEVETL.ASSOANNEEADMISSION an ON e.IDADMISSION = an.IDADMISSION
WHERE m.NOMMODULE = 'M3201' AND an.ANNEE = 2020 AND ec.NOTE >= 16 AND ec.NOTE < 18
GROUP BY '16-18';

-- 18-20
CREATE OR REPLACE VIEW FIEVETL.VueEffectifsParNoteInf20 AS
SELECT '18-20' AS classeNote,
       COUNT(*) AS effectifInf20,
       COUNT(*) * 100 / (
           SELECT COUNT(*)
           FROM FIEVETL.EtudiantCours ec
                    JOIN FIEVETL.Cours c ON ec.IDCOURS = c.IDCOURS
                    JOIN FIEVETL.Modules m ON c.IDMODULE = m.IDMODULE
                    JOIN FIEVETL.ETUDIANTS e ON ec.IDETUDIANT = e.IDETUDIANT
                    JOIN FIEVETL.ASSOANNEEADMISSION an ON e.IDADMISSION = an.IDADMISSION
           WHERE m.NOMMODULE = 'M3201' AND an.ANNEE = 2020
       ) AS frequenceInf20
FROM FIEVETL.EtudiantCours ec
         JOIN FIEVETL.Cours c ON ec.IDCOURS = c.IDCOURS
         JOIN FIEVETL.Modules m ON c.IDMODULE = m.IDMODULE
         JOIN FIEVETL.ETUDIANTS e ON ec.IDETUDIANT = e.IDETUDIANT
         JOIN FIEVETL.ASSOANNEEADMISSION an ON e.IDADMISSION = an.IDADMISSION
WHERE m.NOMMODULE = 'M3201' AND an.ANNEE = 2020 AND ec.NOTE >= 18 AND ec.NOTE <= 20
GROUP BY '18-20';


-- Vue globale des effectifs par note

CREATE OR REPLACE VIEW FIEVETL.VueEffectifsParNote AS
SELECT classeNote,
       effectifInf14,
       frequenceInf14,
       effectifInf16,
       frequenceInf16,
       effectifInf18,
       frequenceInf18,
       effectifInf20,
       frequenceInf20,


------------------------------------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------------------------------------
