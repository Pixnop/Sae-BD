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
    avg((ec.note * ev.COEFFICIENT * m.Coefficient * u.COEFFICIENTUE)/(ev.NOTEMAX * ev.COEFFICIENT * m.Coefficient * u.COEFFICIENTUE)) AS ScoreTotal
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


































































































































































































































/*
CREATE OR REPLACE VIEW Vue_Classement_Semestre (IdSemestre, IdEtudiant, NomEtudiant, PrenomEtudiant )AS
SELECT S.IdSemestre, E.IdEtudiant, E.NomEtudiant,E.PrenomEtudiant, SUM(N.note * EV.Coefficient) AS TotalNote
FROM fievetl.Etudiants E
        JOIN fievetl.EtudierSemestre ES ON E.IdEtudiant = ES.IdEtudiant
        JOIN fievetl.Semestre S ON ES.idSemestre = S.IdSemestre
        JOIN fievetl.EtudiantCours EC ON E.IdEtudiant = EC.IdEtudiant
        JOIN fievetl.Cours C ON EC.IdCours = C.IdCours
        LEFT JOIN fievetl.Evaluations EV ON C.IdCours = EV.IdCours
        LEFT JOIN fievetl.Noter N ON E.IdEtudiant = N.IdEtudiant AND EV.IdEvaluation = N.IdEvaluation
GROUP BY (S.IdSemestre, E.IdEtudiant, E.NomEtudiant, E.PrenomEtudiant)
ORDER BY TotalNote DESC;


CREATE OR REPLACE VIEW Vue_Signe_Astrologique (IdEtudiant, SigneAstro) AS
SELECT IdEtudiant, DATENAISSANCE,
    CASE
        WHEN MONTH(DATENAISSANCE) = 1 AND DAY(DATENAISSANCE) >= 20 OR MONTH(DATENAISSANCE) = 2 AND DAY(DATENAISSANCE) <= 18 THEN 'Aquarius'
        WHEN MONTH(DATENAISSANCE) = 2 AND DAY(DATENAISSANCE) >= 19 OR MONTH(DATENAISSANCE) = 3 AND DAY(DATENAISSANCE) <= 20 THEN 'Pisces'
        WHEN MONTH(DATENAISSANCE) = 3 AND DAY(DATENAISSANCE) >= 21 OR MONTH(DATENAISSANCE) = 4 AND DAY(DATENAISSANCE) <= 19 THEN 'Aries'
        WHEN MONTH(DATENAISSANCE) = 4 AND DAY(DATENAISSANCE) >= 20 OR MONTH(DATENAISSANCE) = 5 AND DAY(DATENAISSANCE) <= 20 THEN 'Taurus'
        WHEN MONTH(DATENAISSANCE) = 5 AND DAY(DATENAISSANCE) >= 21 OR MONTH(DATENAISSANCE) = 6 AND DAY(DATENAISSANCE) <= 20 THEN 'Gemini'
        WHEN MONTH(DATENAISSANCE) = 6 AND DAY(DATENAISSANCE) >= 21 OR MONTH(DATENAISSANCE) = 7 AND DAY(DATENAISSANCE) <= 22 THEN 'Cancer'
        WHEN MONTH(DATENAISSANCE) = 7 AND DAY(DATENAISSANCE) >= 23 OR MONTH(DATENAISSANCE) = 8 AND DAY(DATENAISSANCE) <= 22 THEN 'Leo'
        WHEN MONTH(DATENAISSANCE) = 8 AND DAY(DATENAISSANCE) >= 23 OR MONTH(DATENAISSANCE) = 9 AND DAY(DATENAISSANCE) <= 22 THEN 'Virgo'
        WHEN MONTH(DATENAISSANCE) = 9 AND DAY(DATENAISSANCE) >= 23 OR MONTH(DATENAISSANCE) = 10 AND DAY(DATENAISSANCE) <= 22 THEN 'Libra'
        WHEN MONTH(DATENAISSANCE) = 10 AND DAY(DATENAISSANCE) >= 23 OR MONTH(DATENAISSANCE) = 11 AND DAY(DATENAISSANCE) <= 21 THEN 'Scorpio'
        WHEN MONTH(DATENAISSANCE) = 11 AND DAY(DATENAISSANCE) >= 22 OR MONTH(DATENAISSANCE) = 12 AND DAY(DATENAISSANCE) <= 21 THEN 'Sagittarius'
        ELSE 'Capricorn'
    END AS SigneAstro
FROM FIEVETL.ETUDIANTS;


CREATE OR REPLACE VIEW Vue_Moyenne_Module_SigneAstro AS
SELECT M.IdModule, S.SigneAstro, AVG(N.note) AS Moyenne
FROM fievetl.Modules M
         JOIN fievetl.Cours C ON M.IdModule = C.IdModule
         JOIN fievetl.Evaluations E ON C.IdCours = E.IdCours
         JOIN fievetl.Noter N ON E.IdEvaluation = N.idEvaluation
         JOIN fievetl.Etudiants Et ON E.IdUtilisateur = Et.IdEtudiant
         JOIN Vue_Signe_Astrologique S ON Et.IdEtudiant = S.IdEtudiant
GROUP BY M.IdModule, S.SigneAstro;

CREATE OR REPLACE VIEW Vue_Moyenne_Module_Bac AS
SELECT M.IdModule, M.NomModule, A.AppelationBac, AVG(n.note) AS AverageGrade
FROM fievetl.Modules M
         JOIN fievetl.Cours C ON M.IdModule = C.IdModule
         JOIN fievetl.Evaluations E ON C.IdCours = E.IdCours
         JOIN fievetl.noter N ON E.IdEvaluation = N.IdEvaluation
         JOIN fievetl.Admissions A ON N.IdEtudiant = A.IdEtudiant
GROUP BY M.IdModule, M.NomModule, A.AppelationBac;


CREATE OR REPLACE VIEW Vue_Moyenne_Enseignant AS
SELECT u.IdUtilisateur, u.NomUtilisateur, AVG(n.note) AS AverageGrade
FROM fievetl.Utilisateurs u
         JOIN fievetl.Evaluations e ON u.IdUtilisateur = e.IdUtilisateur
         JOIN fievetl.noter n ON e.IdEvaluation = n.IdEvaluation
GROUP BY u.IdUtilisateur, u.NomUtilisateur;

*/
