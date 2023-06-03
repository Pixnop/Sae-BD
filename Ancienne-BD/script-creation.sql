CREATE TABLE Nationalite(
                            NomNationalite VARCHAR(50),
                            PRIMARY KEY(NomNationalite)
);

CREATE TABLE Specialites(
                            NomSpecialite VARCHAR(50),
                            PRIMARY KEY(NomSpecialite)
);

CREATE TABLE Departement(
                            NomDepartement VARCHAR(50),
                            PRIMARY KEY(NomDepartement)
);

CREATE TABLE Bac(
                    AppelationBac VARCHAR(50),
                    PRIMARY KEY(AppelationBac)
);

CREATE TABLE Dates(
                      Dates VARCHAR(50),
                      PRIMARY KEY(Dates)
);

CREATE TABLE TypeFormation(
                              CodeTypeFormation VARCHAR(50),
                              NomTypeFormation VARCHAR(50),
                              PRIMARY KEY(CodeTypeFormation)
);

CREATE TABLE Inscription(
                            EtatInscription VARCHAR(50),
                            PRIMARY KEY(EtatInscription)
);

CREATE TABLE Groupes(
                        IdGroupe VARCHAR(50),
                        NomGroupe VARCHAR(50),
                        PRIMARY KEY(IdGroupe)
);

CREATE TABLE Semestre(
                         IdSemestre VARCHAR(50),
                         NumeroSemestre VARCHAR(50),
                         Dates VARCHAR(50) NOT NULL,
                         Dates_1 VARCHAR(50) NOT NULL,
                         PRIMARY KEY(IdSemestre),
                         FOREIGN KEY(Dates) REFERENCES Dates(Dates),
                         FOREIGN KEY(Dates_1) REFERENCES Dates(Dates)
);

CREATE TABLE Promotion(
                          NomPromotion VARCHAR(50),
                          PRIMARY KEY(NomPromotion)
);

CREATE TABLE UE(
                   IdUe VARCHAR(50),
                   CodeUE VARCHAR(100),
                   NomUE VARCHAR(100),
                   CoefficientUE VARCHAR(50),
                   NombreECTS VARCHAR(50),
                   PRIMARY KEY(IdUe)
);

CREATE TABLE Bureau(
                       NumBureau VARCHAR(50),
                       TelephoneBureau VARCHAR(50),
                       PRIMARY KEY(NumBureau)
);

CREATE TABLE TypeDomicile(
                             TypeDeDomicile VARCHAR(50),
                             PRIMARY KEY(TypeDeDomicile)
);

CREATE TABLE Postale(
                        CodePostale INT,
                        PRIMARY KEY(CodePostale)
);

CREATE TABLE TypeEnseignant(
                               TypeEnseignant VARCHAR(50),
                               PRIMARY KEY(TypeEnseignant)
);

CREATE TABLE Roles(
                      NomRole VARCHAR(50),
                      PRIMARY KEY(NomRole)
);

CREATE TABLE Pays(
                     NomPays VARCHAR(50),
                     PRIMARY KEY(NomPays)
);

CREATE TABLE Annee(
                      Annee INT,
                      PRIMARY KEY(Annee)
);

CREATE TABLE note(
                     note DECIMAL(15,10),
                     PRIMARY KEY(note)
);

CREATE TABLE Matiere(
                        matiere VARCHAR(50),
                        PRIMARY KEY(matiere)
);

CREATE TABLE Villes(
                       NomVille VARCHAR(100),
                       NomPays VARCHAR(50),
                       NomDepartement VARCHAR(50),
                       PRIMARY KEY(NomVille),
                       FOREIGN KEY(NomPays) REFERENCES Pays(NomPays),
                       FOREIGN KEY(NomDepartement) REFERENCES Departement(NomDepartement)
);

CREATE TABLE Utilisateurs(
                             IdUtilisateur VARCHAR(50),
                             PrenomUtilisateur VARCHAR(50),
                             NomUtilisateur VARCHAR(50),
                             MailUtilisateur VARCHAR(50),
                             TypeEnseignant VARCHAR(50),
                             NumBureau VARCHAR(50),
                             PRIMARY KEY(IdUtilisateur),
                             FOREIGN KEY(TypeEnseignant) REFERENCES TypeEnseignant(TypeEnseignant),
                             FOREIGN KEY(NumBureau) REFERENCES Bureau(NumBureau)
);

CREATE TABLE Domicile(
                         AdresseDomicile VARCHAR(50),
                         TypeDeDomicile VARCHAR(50) NOT NULL,
                         CodePostale INT NOT NULL,
                         NomVille VARCHAR(100) NOT NULL,
                         PRIMARY KEY(AdresseDomicile),
                         FOREIGN KEY(TypeDeDomicile) REFERENCES TypeDomicile(TypeDeDomicile),
                         FOREIGN KEY(CodePostale) REFERENCES Postale(CodePostale),
                         FOREIGN KEY(NomVille) REFERENCES Villes(NomVille)
);

CREATE TABLE Lycees(
                       CodeLycee VARCHAR(100),
                       NomLycee VARCHAR(100),
                       CodePostale INT,
                       NomVille VARCHAR(100),
                       PRIMARY KEY(CodeLycee),
                       FOREIGN KEY(CodePostale) REFERENCES Postale(CodePostale),
                       FOREIGN KEY(NomVille) REFERENCES Villes(NomVille)
);

CREATE TABLE Modules(
                        IdModule VARCHAR(50),
                        HeureCM VARCHAR(50),
                        HeureTD VARCHAR(50),
                        HeureTP VARCHAR(50),
                        Coefficient VARCHAR(50),
                        NomModule VARCHAR(50),
                        CodeModule VARCHAR(50),
                        IdUe VARCHAR(50) NOT NULL,
                        IdUtilisateur VARCHAR(50) NOT NULL,
                        PRIMARY KEY(IdModule),
                        FOREIGN KEY(IdUe) REFERENCES UE(IdUe),
                        FOREIGN KEY(IdUtilisateur) REFERENCES Utilisateurs(IdUtilisateur)
);

CREATE TABLE Cours(
                      IdCours VARCHAR(50),
                      IdSemestre VARCHAR(50) NOT NULL,
                      IdModule VARCHAR(50) NOT NULL,
                      PRIMARY KEY(IdCours),
                      FOREIGN KEY(IdSemestre) REFERENCES Semestre(IdSemestre),
                      FOREIGN KEY(IdModule) REFERENCES Modules(IdModule)
);

CREATE TABLE Evaluations(
                            IdEvaluation VARCHAR(50),
                            Coefficient VARCHAR(50),
                            IdUtilisateur VARCHAR(50) NOT NULL,
                            PRIMARY KEY(IdEvaluation),
                            FOREIGN KEY(IdUtilisateur) REFERENCES Utilisateurs(IdUtilisateur)
);

CREATE TABLE Etudiants(
                          IdEtudiant VARCHAR(50),
                          PrenomEtudiant VARCHAR(50),
                          NomEtudiant VARCHAR(50),
                          Civilité VARCHAR(50),
                          Boursier VARCHAR(50),
                          IdAdmission VARCHAR(50),
                          EmailEtudiant VARCHAR(50),
                          MailPerso VARCHAR(50),
                          NumeroFix VARCHAR(50) NOT NULL,
                          NumeroPortable VARCHAR(50),
                          AppelationBac VARCHAR(50),
                          NomSpecialite VARCHAR(50),
                          Annee INT,
                          IdGroupe VARCHAR(50),
                          CodeTypeFormation VARCHAR(50) NOT NULL,
                          NomPromotion VARCHAR(50),
                          EtatInscription VARCHAR(50) NOT NULL,
                          Annee_1 INT,
                          CodeLycee VARCHAR(100),
                          AdresseDomicile VARCHAR(50) NOT NULL,
                          NomNationalite VARCHAR(50) NOT NULL,
                          NomVille VARCHAR(100) NOT NULL,
                          Dates VARCHAR(50),
                          PRIMARY KEY(IdEtudiant),
                          FOREIGN KEY(AppelationBac) REFERENCES Bac(AppelationBac),
                          FOREIGN KEY(NomSpecialite) REFERENCES Specialites(NomSpecialite),
                          FOREIGN KEY(Annee) REFERENCES Annee(Annee),
                          FOREIGN KEY(IdGroupe) REFERENCES Groupes(IdGroupe),
                          FOREIGN KEY(CodeTypeFormation) REFERENCES TypeFormation(CodeTypeFormation),
                          FOREIGN KEY(NomPromotion) REFERENCES Promotion(NomPromotion),
                          FOREIGN KEY(EtatInscription) REFERENCES Inscription(EtatInscription),
                          FOREIGN KEY(Annee_1) REFERENCES Annee(Annee),
                          FOREIGN KEY(CodeLycee) REFERENCES Lycees(CodeLycee),
                          FOREIGN KEY(AdresseDomicile) REFERENCES Domicile(AdresseDomicile),
                          FOREIGN KEY(NomNationalite) REFERENCES Nationalite(NomNationalite),
                          FOREIGN KEY(NomVille) REFERENCES Villes(NomVille),
                          FOREIGN KEY(Dates) REFERENCES Dates(Dates)
);

CREATE TABLE UtilisateursRoles(
                                  IdUtilisateur VARCHAR(50),
                                  NomRole VARCHAR(50),
                                  PRIMARY KEY(IdUtilisateur, NomRole),
                                  FOREIGN KEY(IdUtilisateur) REFERENCES Utilisateurs(IdUtilisateur),
                                  FOREIGN KEY(NomRole) REFERENCES Roles(NomRole)
);

CREATE TABLE Etre_absent(
                            IdEtudiant VARCHAR(50),
                            Dates VARCHAR(50),
                            IdCours VARCHAR(50),
                            Matin VARCHAR(50),
                            Justifiee VARCHAR(50),
                            MotifAbsence VARCHAR(50),
                            EstAbsent VARCHAR(50),
                            PRIMARY KEY(IdEtudiant, Dates, IdCours),
                            FOREIGN KEY(IdEtudiant) REFERENCES Etudiants(IdEtudiant),
                            FOREIGN KEY(Dates) REFERENCES Dates(Dates),
                            FOREIGN KEY(IdCours) REFERENCES Cours(IdCours)
);

CREATE TABLE EtudiantCours(
                              IdEtudiant VARCHAR(50),
                              IdCours VARCHAR(50),
                              PRIMARY KEY(IdEtudiant, IdCours),
                              FOREIGN KEY(IdEtudiant) REFERENCES Etudiants(IdEtudiant),
                              FOREIGN KEY(IdCours) REFERENCES Cours(IdCours)
);

CREATE TABLE CoursEvaluation(
                                IdCours VARCHAR(50),
                                IdEvaluation VARCHAR(50),
                                PRIMARY KEY(IdCours, IdEvaluation),
                                FOREIGN KEY(IdCours) REFERENCES Cours(IdCours),
                                FOREIGN KEY(IdEvaluation) REFERENCES Evaluations(IdEvaluation)
);

CREATE TABLE Enseignement(
                             IdCours VARCHAR(50),
                             IdUtilisateur VARCHAR(50),
                             PRIMARY KEY(IdCours, IdUtilisateur),
                             FOREIGN KEY(IdCours) REFERENCES Cours(IdCours),
                             FOREIGN KEY(IdUtilisateur) REFERENCES Utilisateurs(IdUtilisateur)
);

CREATE TABLE AssoVilleCodePostal(
                                    NomVille VARCHAR(100),
                                    CodePostale INT,
                                    PRIMARY KEY(NomVille, CodePostale),
                                    FOREIGN KEY(NomVille) REFERENCES Villes(NomVille),
                                    FOREIGN KEY(CodePostale) REFERENCES Postale(CodePostale)
);

CREATE TABLE etre_intervenant(
                                 IdModule VARCHAR(50),
                                 IdUtilisateur VARCHAR(50),
                                 PRIMARY KEY(IdModule, IdUtilisateur),
                                 FOREIGN KEY(IdModule) REFERENCES Modules(IdModule),
                                 FOREIGN KEY(IdUtilisateur) REFERENCES Utilisateurs(IdUtilisateur)
);

CREATE TABLE noter(
                      IdEtudiant VARCHAR(50),
                      IdEvaluation VARCHAR(50),
                      note VARCHAR(50),
                      PRIMARY KEY(IdEtudiant, IdEvaluation),
                      FOREIGN KEY(IdEtudiant) REFERENCES Etudiants(IdEtudiant),
                      FOREIGN KEY(IdEvaluation) REFERENCES Evaluations(IdEvaluation)
);

CREATE TABLE bacNote(
                        IdEtudiant VARCHAR(50),
                        matiere VARCHAR(50),
                        note DECIMAL(15,10) NOT NULL,
                        PRIMARY KEY(IdEtudiant, matiere),
                        FOREIGN KEY(IdEtudiant) REFERENCES Etudiants(IdEtudiant),
                        FOREIGN KEY(matiere) REFERENCES Matiere(matiere),
                        FOREIGN KEY(note) REFERENCES note(note)
);
