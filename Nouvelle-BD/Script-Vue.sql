
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
SELECT IdEtudiant, DateOfBirth,
    CASE
        WHEN MONTH(DateOfBirth) = 1 AND DAY(DateOfBirth) >= 20 OR MONTH(DateOfBirth) = 2 AND DAY(DateOfBirth) <= 18 THEN 'Aquarius'
        WHEN MONTH(DateOfBirth) = 2 AND DAY(DateOfBirth) >= 19 OR MONTH(DateOfBirth) = 3 AND DAY(DateOfBirth) <= 20 THEN 'Pisces'
        WHEN MONTH(DateOfBirth) = 3 AND DAY(DateOfBirth) >= 21 OR MONTH(DateOfBirth) = 4 AND DAY(DateOfBirth) <= 19 THEN 'Aries'
        WHEN MONTH(DateOfBirth) = 4 AND DAY(DateOfBirth) >= 20 OR MONTH(DateOfBirth) = 5 AND DAY(DateOfBirth) <= 20 THEN 'Taurus'
        WHEN MONTH(DateOfBirth) = 5 AND DAY(DateOfBirth) >= 21 OR MONTH(DateOfBirth) = 6 AND DAY(DateOfBirth) <= 20 THEN 'Gemini'
        WHEN MONTH(DateOfBirth) = 6 AND DAY(DateOfBirth) >= 21 OR MONTH(DateOfBirth) = 7 AND DAY(DateOfBirth) <= 22 THEN 'Cancer'
        WHEN MONTH(DateOfBirth) = 7 AND DAY(DateOfBirth) >= 23 OR MONTH(DateOfBirth) = 8 AND DAY(DateOfBirth) <= 22 THEN 'Leo'
        WHEN MONTH(DateOfBirth) = 8 AND DAY(DateOfBirth) >= 23 OR MONTH(DateOfBirth) = 9 AND DAY(DateOfBirth) <= 22 THEN 'Virgo'
        WHEN MONTH(DateOfBirth) = 9 AND DAY(DateOfBirth) >= 23 OR MONTH(DateOfBirth) = 10 AND DAY(DateOfBirth) <= 22 THEN 'Libra'
        WHEN MONTH(DateOfBirth) = 10 AND DAY(DateOfBirth) >= 23 OR MONTH(DateOfBirth) = 11 AND DAY(DateOfBirth) <= 21 THEN 'Scorpio'
        WHEN MONTH(DateOfBirth) = 11 AND DAY(DateOfBirth) >= 22 OR MONTH(DateOfBirth) = 12 AND DAY(DateOfBirth) <= 21 THEN 'Sagittarius'
        ELSE 'Capricorn'
    END AS SigneAstro
FROM Etudiants;


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