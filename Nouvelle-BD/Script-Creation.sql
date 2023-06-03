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

CREATE TABLE Groupes(
                        IdGroupe VARCHAR(50),
                        NomGroupe VARCHAR(50),
                        PRIMARY KEY(IdGroupe)
);

CREATE TABLE Semestre(
                         IdSemestre VARCHAR(50),
                         NumeroSemestre VARCHAR(50),
                         DateDebut VARCHAR(50),
                         DateFin VARCHAR(50),
                         NomPromotion VARCHAR(50),
                         PRIMARY KEY(IdSemestre)
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

CREATE TABLE Postale(
                        CodePostale INT,
                        NomVille VARCHAR(100),
                        PRIMARY KEY(CodePostale),
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
                            IdCours VARCHAR(50),
                            PRIMARY KEY(IdEvaluation),
                            FOREIGN KEY(IdUtilisateur) REFERENCES Utilisateurs(IdUtilisateur),
                            FOREIGN KEY(IdCours) REFERENCES Cours(IdCours)
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

CREATE TABLE Etudiants(
                          IdEtudiant VARCHAR(100),
                          PrenomEtudiant VARCHAR(100),
                          NomEtudiant VARCHAR(100),
                          Civilité VARCHAR(100),
                          NomNationalite VARCHAR(50) NOT NULL,
                          DateNaissance VARCHAR(100),
                          Boursier VARCHAR(100),
                          IdAdmission VARCHAR(100),
                          EmailEtudiant VARCHAR(100),
                          MailPerso VARCHAR(100),
                          NumeroFix VARCHAR(100) NOT NULL,
                          EtatInscription VARCHAR(50),
                          NumeroPortable VARCHAR(100),
                          IdGroupe VARCHAR(50),
                          AdresseDomicile VARCHAR(50) NOT NULL,
                          NomVille VARCHAR(100) NOT NULL,
                          PRIMARY KEY(IdEtudiant),
                          FOREIGN KEY(IdGroupe) REFERENCES Groupes(IdGroupe),
                          FOREIGN KEY(AdresseDomicile) REFERENCES Domicile(AdresseDomicile),
                          FOREIGN KEY(NomVille) REFERENCES Villes(NomVille)
);

CREATE TABLE Admissions(
                           IdAdmission DECIMAL(15,10),
                           NoteFrancais VARCHAR(50),
                           NoteAnglais VARCHAR(50),
                           NotePhysique VARCHAR(50),
                           NoteMath VARCHAR(50),
                           NomSpecialite VARCHAR(50),
                           AppelationBac VARCHAR(50),
                           IdEtudiant VARCHAR(100) NOT NULL,
                           PRIMARY KEY(IdAdmission),
                           UNIQUE(IdEtudiant),
                           FOREIGN KEY(NomSpecialite) REFERENCES Specialites(NomSpecialite),
                           FOREIGN KEY(AppelationBac) REFERENCES Bac(AppelationBac),
                           FOREIGN KEY(IdEtudiant) REFERENCES Etudiants(IdEtudiant)
);

CREATE TABLE AvoirEtudie(
                            CodeLycee VARCHAR(100),
                            IdAdmission DECIMAL(15,10),
                            PRIMARY KEY(CodeLycee, IdAdmission),
                            FOREIGN KEY(CodeLycee) REFERENCES Lycees(CodeLycee),
                            FOREIGN KEY(IdAdmission) REFERENCES Admissions(IdAdmission)
);

CREATE TABLE AssoAnneeAdmission(
                                   IdAdmission DECIMAL(15,10),
                                   Annee INT,
                                   PRIMARY KEY(IdAdmission, Annee),
                                   FOREIGN KEY(IdAdmission) REFERENCES Admissions(IdAdmission),
                                   FOREIGN KEY(Annee) REFERENCES Annee(Annee)
);

CREATE TABLE EtudierSemestre(
                                IdEtudiant VARCHAR(100),
                                IdSemestre VARCHAR(50),
                                EtatInscription VARCHAR(50),
                                PRIMARY KEY(IdEtudiant, IdSemestre),
                                FOREIGN KEY(IdEtudiant) REFERENCES Etudiants(IdEtudiant),
                                FOREIGN KEY(IdSemestre) REFERENCES Semestre(IdSemestre)
);

CREATE TABLE UtilisateursRoles(
                                  IdUtilisateur VARCHAR(50),
                                  NomRole VARCHAR(50),
                                  PRIMARY KEY(IdUtilisateur, NomRole),
                                  FOREIGN KEY(IdUtilisateur) REFERENCES Utilisateurs(IdUtilisateur),
                                  FOREIGN KEY(NomRole) REFERENCES Roles(NomRole)
);

CREATE TABLE Etre_absent(
                            Dates VARCHAR(50),
                            IdCours VARCHAR(50),
                            Matin VARCHAR(50),
                            Justifiee VARCHAR(50),
                            MotifAbsence VARCHAR(50),
                            EstAbsent VARCHAR(50),
                            IdEtudiant VARCHAR(100) NOT NULL,
                            PRIMARY KEY(Dates, IdCours),
                            FOREIGN KEY(Dates) REFERENCES Dates(Dates),
                            FOREIGN KEY(IdCours) REFERENCES Cours(IdCours),
                            FOREIGN KEY(IdEtudiant) REFERENCES Etudiants(IdEtudiant)
);

CREATE TABLE EtudiantCours(
                              IdEtudiant VARCHAR(100),
                              IdCours VARCHAR(50),
                              PRIMARY KEY(IdEtudiant, IdCours),
                              FOREIGN KEY(IdEtudiant) REFERENCES Etudiants(IdEtudiant),
                              FOREIGN KEY(IdCours) REFERENCES Cours(IdCours)
);

CREATE TABLE Enseignement(
                             IdCours VARCHAR(50),
                             IdUtilisateur VARCHAR(50),
                             PRIMARY KEY(IdCours, IdUtilisateur),
                             FOREIGN KEY(IdCours) REFERENCES Cours(IdCours),
                             FOREIGN KEY(IdUtilisateur) REFERENCES Utilisateurs(IdUtilisateur)
);

CREATE TABLE AssoBacAnnee(
                             IdAdmission DECIMAL(15,10),
                             Annee INT,
                             PRIMARY KEY(IdAdmission, Annee),
                             FOREIGN KEY(IdAdmission) REFERENCES Admissions(IdAdmission),
                             FOREIGN KEY(Annee) REFERENCES Annee(Annee)
);

CREATE TABLE etre_intervenant(
                                 IdModule VARCHAR(50),
                                 IdUtilisateur VARCHAR(50),
                                 PRIMARY KEY(IdModule, IdUtilisateur),
                                 FOREIGN KEY(IdModule) REFERENCES Modules(IdModule),
                                 FOREIGN KEY(IdUtilisateur) REFERENCES Utilisateurs(IdUtilisateur)
);

CREATE TABLE noter(
                      IdEtudiant VARCHAR(100),
                      IdEvaluation VARCHAR(50),
                      note VARCHAR(50),
                      PRIMARY KEY(IdEtudiant, IdEvaluation),
                      FOREIGN KEY(IdEtudiant) REFERENCES Etudiants(IdEtudiant),
                      FOREIGN KEY(IdEvaluation) REFERENCES Evaluations(IdEvaluation)
);

CREATE TABLE EtreForme(
                          CodeTypeFormation VARCHAR(50),
                          IdSemestre VARCHAR(50),
                          PRIMARY KEY(CodeTypeFormation, IdSemestre),
                          FOREIGN KEY(CodeTypeFormation) REFERENCES TypeFormation(CodeTypeFormation),
                          FOREIGN KEY(IdSemestre) REFERENCES Semestre(IdSemestre)
);
