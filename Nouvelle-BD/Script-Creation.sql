CREATE TABLE Specialites(
                            NomSpecialite VARCHAR(100),
                            PRIMARY KEY(NomSpecialite)
);

CREATE TABLE Departement(
                            NomDepartement VARCHAR(100),
                            PRIMARY KEY(NomDepartement)
);

CREATE TABLE Bac(
                    AppelationBac VARCHAR(100),
                    PRIMARY KEY(AppelationBac)
);

CREATE TABLE Dates(
                      Dates DATE,
                      PRIMARY KEY(Dates)
);

CREATE TABLE Modules(
                        IdModule VARCHAR(100),
                        HeureCM INT,
                        HeureTD INT,
                        HeureTP INT,
                        Coefficient REAL,
                        NomModule VARCHAR(100),
                        CodeModule VARCHAR(100),
                        PRIMARY KEY(IdModule)
);

CREATE TABLE TypeFormation(
                              CodeTypeFormation VARCHAR(100),
                              NomTypeFormation VARCHAR(100),
                              PRIMARY KEY(CodeTypeFormation)
);

CREATE TABLE Groupes(
                        IdGroupe INT,
                        NomGroupe VARCHAR(100),
                        PRIMARY KEY(IdGroupe)
);

CREATE TABLE Semestre(
                         IdSemestre INT,
                         NumeroSemestre INT,
                         DateDebut DATE,
                         DateFin DATE,
                         NomPromotion VARCHAR(100),
                         PRIMARY KEY(IdSemestre)
);

CREATE TABLE Evaluations(
                            IdEvaluation INT,
                            Coefficient REAL,
                            PRIMARY KEY(IdEvaluation)
);

CREATE TABLE UE(
                   IdUe VARCHAR(100),
                   CodeUE VARCHAR(100),
                   NomUE VARCHAR(100),
                   CoefficientUE REAL,
                   NombreECTS VARCHAR(100),
                   PRIMARY KEY(IdUe)
);

CREATE TABLE Bureau(
                       NumBureau VARCHAR(100),
                       TelephoneBureau VARCHAR(100),
                       PRIMARY KEY(NumBureau)
);

CREATE TABLE TypeDomicile(
                             TypeDeDomicile VARCHAR(100),
                             PRIMARY KEY(TypeDeDomicile)
);

CREATE TABLE Postale(
                        CodePostale INT,
                        PRIMARY KEY(CodePostale)
);

CREATE TABLE TypeEnseignant(
                               TypeEnseignant VARCHAR(100),
                               PRIMARY KEY(TypeEnseignant)
);

CREATE TABLE Roles(
                      NomRole VARCHAR(100),
                      PRIMARY KEY(NomRole)
);

CREATE TABLE Pays(
                     NomPays VARCHAR(100),
                     PRIMARY KEY(NomPays)
);

CREATE TABLE Annee(
                      Annee VARCHAR(100),
                      PRIMARY KEY(Annee)
);

CREATE TABLE Admissions(
                           IdAdmission VARCHAR(100),
                           NoteFrancais VARCHAR(100),
                           NoteAnglais VARCHAR(100),
                           NotePhysique VARCHAR(100),
                           NoteMath VARCHAR(100),
                           NomSpecialite VARCHAR(100),
                           AppelationBac VARCHAR(100),
                           PRIMARY KEY(IdAdmission),
                           FOREIGN KEY(NomSpecialite) REFERENCES Specialites(NomSpecialite),
                           FOREIGN KEY(AppelationBac) REFERENCES Bac(AppelationBac)
);

CREATE TABLE Villes(
                       NomVille VARCHAR(100),
                       NomPays VARCHAR(100),
                       NomDepartement VARCHAR(100),
                       PRIMARY KEY(NomVille),
                       FOREIGN KEY(NomPays) REFERENCES Pays(NomPays),
                       FOREIGN KEY(NomDepartement) REFERENCES Departement(NomDepartement)
);

CREATE TABLE Utilisateurs(
                             IdUtilisateur INT,
                             PrenomUtilisateur VARCHAR(100),
                             NomUtilisateur VARCHAR(100),
                             MailUtilisateur VARCHAR(100),
                             TypeEnseignant VARCHAR(100),
                             NumBureau VARCHAR(100),
                             PRIMARY KEY(IdUtilisateur),
                             FOREIGN KEY(TypeEnseignant) REFERENCES TypeEnseignant(TypeEnseignant),
                             FOREIGN KEY(NumBureau) REFERENCES Bureau(NumBureau)
);

CREATE TABLE Domicile(
                         AdresseDomicile VARCHAR(100),
                         TypeDeDomicile VARCHAR(100) NOT NULL,
                         CodePostale INT NOT NULL,
                         NomVille VARCHAR(100) NOT NULL,
                         PRIMARY KEY(AdresseDomicile),
                         FOREIGN KEY(TypeDeDomicile) REFERENCES TypeDomicile(TypeDeDomicile),
                         FOREIGN KEY(CodePostale) REFERENCES Postale(CodePostale),
                         FOREIGN KEY(NomVille) REFERENCES Villes(NomVille)
);

CREATE TABLE Etudiants(
                          IdEtudiant INT,
                          PrenomEtudiant VARCHAR(100),
                          NomEtudiant VARCHAR(100),
                          Civilité VARCHAR(100),
                          NomNationalite VARCHAR(100) NOT NULL,
                          DateNaissance DATE,
                          Boursier VARCHAR(100),
                          IdAdmission VARCHAR(100),
                          EmailEtudiant VARCHAR(100),
                          MailPerso VARCHAR(100),
                          NumeroFix VARCHAR(100) NOT NULL,
                          EtatInscription VARCHAR(100),
                          NumeroPortable VARCHAR(100),
                          IdAdmission_1 VARCHAR(100),
                          IdGroupe INT,
                          AdresseDomicile VARCHAR(100) NOT NULL,
                          NomVille VARCHAR(100) NOT NULL,
                          PRIMARY KEY(IdEtudiant),
                          UNIQUE(IdAdmission_1),
                          FOREIGN KEY(IdAdmission_1) REFERENCES Admissions(IdAdmission),
                          FOREIGN KEY(IdGroupe) REFERENCES Groupes(IdGroupe),
                          FOREIGN KEY(AdresseDomicile) REFERENCES Domicile(AdresseDomicile),
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

CREATE TABLE Cours(
                      IdCours INT,
                      IdUtilisateur INT,
                      IdSemestre INT NOT NULL,
                      IdModule VARCHAR(100) NOT NULL,
                      PRIMARY KEY(IdCours),
                      FOREIGN KEY(IdUtilisateur) REFERENCES Utilisateurs(IdUtilisateur),
                      FOREIGN KEY(IdSemestre) REFERENCES Semestre(IdSemestre),
                      FOREIGN KEY(IdModule) REFERENCES Modules(IdModule)
);

CREATE TABLE EtreAbsent(
                           idAbsence INT,
                           Justifiee VARCHAR(100),
                           MotifAbsence VARCHAR(100),
                           EstAbsent VARCHAR(100),
                           Matin VARCHAR(100),
                           IdCours INT,
                           IdEtudiant INT NOT NULL,
                           Dates DATE,
                           PRIMARY KEY(idAbsence),
                           FOREIGN KEY(IdCours) REFERENCES Cours(IdCours),
                           FOREIGN KEY(IdEtudiant) REFERENCES Etudiants(IdEtudiant),
                           FOREIGN KEY(Dates) REFERENCES Dates(Dates)
);

CREATE TABLE AvoirEtudie(
                            CodeLycee VARCHAR(100),
                            IdAdmission VARCHAR(100),
                            PRIMARY KEY(CodeLycee, IdAdmission),
                            FOREIGN KEY(CodeLycee) REFERENCES Lycees(CodeLycee),
                            FOREIGN KEY(IdAdmission) REFERENCES Admissions(IdAdmission)
);

CREATE TABLE AssoAnneeAdmission(
                                   IdAdmission VARCHAR(100),
                                   Annee VARCHAR(100),
                                   PRIMARY KEY(IdAdmission, Annee),
                                   FOREIGN KEY(IdAdmission) REFERENCES Admissions(IdAdmission),
                                   FOREIGN KEY(Annee) REFERENCES Annee(Annee)
);

CREATE TABLE EtudierSemestre(
                                IdEtudiant INT,
                                IdSemestre INT,
                                EtatInscription VARCHAR(100),
                                PRIMARY KEY(IdEtudiant, IdSemestre),
                                FOREIGN KEY(IdEtudiant) REFERENCES Etudiants(IdEtudiant),
                                FOREIGN KEY(IdSemestre) REFERENCES Semestre(IdSemestre)
);

CREATE TABLE UtilisateursRoles(
                                  IdUtilisateur INT,
                                  NomRole VARCHAR(100),
                                  PRIMARY KEY(IdUtilisateur, NomRole),
                                  FOREIGN KEY(IdUtilisateur) REFERENCES Utilisateurs(IdUtilisateur),
                                  FOREIGN KEY(NomRole) REFERENCES Roles(NomRole)
);

CREATE TABLE EtudiantCours(
                              IdEtudiant INT,
                              IdEvaluation INT,
                              note DOUBLE,
                              IdCours INT NOT NULL,
                              PRIMARY KEY(IdEtudiant, IdEvaluation),
                              FOREIGN KEY(IdEtudiant) REFERENCES Etudiants(IdEtudiant),
                              FOREIGN KEY(IdEvaluation) REFERENCES Evaluations(IdEvaluation),
                              FOREIGN KEY(IdCours) REFERENCES Cours(IdCours)
);

CREATE TABLE AssoModule(
                           IdModule VARCHAR(100),
                           IdUe VARCHAR(100),
                           PRIMARY KEY(IdModule, IdUe),
                           FOREIGN KEY(IdModule) REFERENCES Modules(IdModule),
                           FOREIGN KEY(IdUe) REFERENCES UE(IdUe)
);

CREATE TABLE EvaluerParUtilisateur(
                                      IdEvaluation INT,
                                      IdUtilisateur INT,
                                      PRIMARY KEY(IdEvaluation, IdUtilisateur),
                                      FOREIGN KEY(IdEvaluation) REFERENCES Evaluations(IdEvaluation),
                                      FOREIGN KEY(IdUtilisateur) REFERENCES Utilisateurs(IdUtilisateur)
);

CREATE TABLE Enseignement(
                             IdCours_Enseignant INT,
                             IdUtilisateur INT,
                             PRIMARY KEY(IdCours_Enseignant, IdUtilisateur),
                             FOREIGN KEY(IdCours_Enseignant) REFERENCES Cours(IdCours),
                             FOREIGN KEY(IdUtilisateur) REFERENCES Utilisateurs(IdUtilisateur)
);

CREATE TABLE AssoBacAnnee(
                             IdAdmission VARCHAR(100),
                             Annee VARCHAR(100),
                             PRIMARY KEY(IdAdmission, Annee),
                             FOREIGN KEY(IdAdmission) REFERENCES Admissions(IdAdmission),
                             FOREIGN KEY(Annee) REFERENCES Annee(Annee)
);

CREATE TABLE AssoVilleCodePostal(
                                    NomVille VARCHAR(100),
                                    CodePostale INT,
                                    PRIMARY KEY(NomVille, CodePostale),
                                    FOREIGN KEY(NomVille) REFERENCES Villes(NomVille),
                                    FOREIGN KEY(CodePostale) REFERENCES Postale(CodePostale)
);

CREATE TABLE etreIntervenant(
                                IdCours_Intervenant INT,
                                IdUtilisateur INT,
                                PRIMARY KEY(IdCours_Intervenant, IdUtilisateur),
                                FOREIGN KEY(IdCours_Intervenant) REFERENCES Cours(IdCours),
                                FOREIGN KEY(IdUtilisateur) REFERENCES Utilisateurs(IdUtilisateur)
);

CREATE TABLE EtreForme(
                          CodeTypeFormation VARCHAR(100),
                          IdSemestre INT,
                          PRIMARY KEY(CodeTypeFormation, IdSemestre),
                          FOREIGN KEY(CodeTypeFormation) REFERENCES TypeFormation(CodeTypeFormation),
                          FOREIGN KEY(IdSemestre) REFERENCES Semestre(IdSemestre)
);
