import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class grantAll {
    public static void main(String[] args) {
        // List tables
        String data = """
                Specialites = (NomSpecialite VARCHAR(50));
                Departement = (NomDepartement VARCHAR(50));
                Bac = (AppelationBac VARCHAR(50));
                Dates = (Dates DATE);
                Modules = (IdModule INT, HeureCM REAL, HeureTD REAL, HeureTP REAL, Coefficient REAL, NomModule VARCHAR(50), CodeModule VARCHAR(50));
                TypeFormation = (CodeTypeFormation VARCHAR(50), NomTypeFormation VARCHAR(50));
                Groupes = (IdGroupe INT, NomGroupe VARCHAR(50));
                Semestre = (IdSemestre INT, NumeroSemestre INT, DateDebut DATE, DateFin DATE, NomPromotion VARCHAR(50));
                Evaluations = (IdEvaluation INT, Coefficient REAL, NoteMax REAL);
                UE = (IdUe INT, CodeUE VARCHAR(100), NomUE VARCHAR(100), CoefficientUE REAL, NombreECTS REAL);
                Bureau = (NumBureau VARCHAR(50), TelephoneBureau INT);
                TypeDomicile = (TypeDeDomicile VARCHAR(50));
                Postale = (CodePostale INT);
                TypeEnseignant = (TypeEnseignant VARCHAR(50));
                Roles = (NomRole VARCHAR(50));
                Pays = (NomPays VARCHAR(50));
                Annee = (Annee INT);
                Admissions = (IdAdmission INT, NoteFrancais REAL, NoteAnglais REAL, NotePhysique REAL, NoteMath REAL, #NomSpecialite*, #AppelationBac*);
                Villes = (NomVille VARCHAR(100), #NomPays*, #NomDepartement*);
                Utilisateurs = (IdUtilisateur INT, PrenomUtilisateur VARCHAR(50), NomUtilisateur VARCHAR(50), MailUtilisateur VARCHAR(50), #TypeEnseignant*, #NumBureau*);
                Domicile = (AdresseDomicile VARCHAR(100), #TypeDeDomicile, #CodePostale, #NomVille);
                Etudiants = (IdEtudiant INT, PrenomEtudiant VARCHAR(100), NomEtudiant VARCHAR(100), Civilité VARCHAR(100), NomNationalite VARCHAR(100), DateNaissance DATE, Boursier VARCHAR(100), IdAdmission VARCHAR(100), EmailEtudiant VARCHAR(100), MailPerso VARCHAR(100), NumeroFix VARCHAR(100), EtatInscription VARCHAR(100), NumeroPortable VARCHAR(100), #IdAdmission_1*, #IdGroupe*, #AdresseDomicile, #NomVille);
                Lycees = (CodeLycee VARCHAR(100), NomLycee VARCHAR(100), #CodePostale*, #NomVille*);
                Cours = (IdCours INT, #IdUtilisateur*, #IdSemestre, #IdModule);
                EtreAbsent = (idAbsence INT, Justifiee VARCHAR(50), MotifAbsence VARCHAR(50), EstAbsent VARCHAR(50), Matin VARCHAR(50), #IdCours*, #IdEtudiant, #Dates*);
                AvoirEtudie = (#CodeLycee, #IdAdmission);
                AssoAnneeAdmission = (#IdAdmission, #Annee);
                EtudierSemestre = (#IdEtudiant, #IdSemestre, EtatInscription VARCHAR(50));
                UtilisateursRoles = (#IdUtilisateur, #NomRole);
                EtudiantCours = (#IdEtudiant, #IdEvaluation, note REAL, #IdCours);
                AssoModule = (#IdModule, #IdUe);
                EvaluerParUtilisateur = (#IdEvaluation, #IdUtilisateur);
                Enseignement = (#IdCours_Enseignant, #IdUtilisateur);
                AssoBacAnnee = (#IdAdmission, #Annee);
                AssoVilleCodePostal = (#NomVille, #CodePostale);
                etreIntervenant = (#IdCours_Intervenant, #IdUtilisateur);
                EtreForme = (#CodeTypeFormation, #IdSemestre);
                ABSENCES_DATA =
                COURS_ENSEIGNANTS_DATA =
                ETUDIANTS_DATA =
                ETUDIANT_COURS_DATA =
                ETUDIANT_SEMESTRE_DATA =
                GROUPES_DATA =
                NOTES_DATA =
                UTILISATEURS_DATA =
                """
                ;

        List<String> tables = extractTableNames(data);

        // List users
        List<String> users = Arrays.asList("Caminadea", "Grelierq", "Lorenzinir"); // Ajoutez d'autres noms d'utilisateur si nécessaire

        for (String table : tables) {
            for (String user : users) {
                System.out.println("GRANT ALL PRIVILEGES ON " + table + " TO " + user + " WITH GRANT OPTION;");
            }
        }
    }
    public static List<String> extractTableNames(String data) {
        Pattern pattern = Pattern.compile("([a-zA-Z_][a-zA-Z0-9_]*)\\s*=");
        Matcher matcher = pattern.matcher(data);
        List<String> tables = new ArrayList<>();
        while (matcher.find()) {
            tables.add(matcher.group(1));
        }
        return tables;
    }
}
