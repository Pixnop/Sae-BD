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
                Dates = (Dates VARCHAR(50));
                TypeFormation = (CodeTypeFormation VARCHAR(50), NomTypeFormation VARCHAR(50));
                Groupes = (IdGroupe VARCHAR(50), NomGroupe VARCHAR(50));
                Semestre = (IdSemestre VARCHAR(50), NumeroSemestre VARCHAR(50), DateDebut VARCHAR(50), DateFin VARCHAR(50), NomPromotion VARCHAR(50));
                UE = (IdUe VARCHAR(50), CodeUE VARCHAR(100), NomUE VARCHAR(100), CoefficientUE VARCHAR(50), NombreECTS VARCHAR(50));
                Bureau = (NumBureau VARCHAR(50), TelephoneBureau VARCHAR(50));
                TypeDomicile = (TypeDeDomicile VARCHAR(50));
                TypeEnseignant = (TypeEnseignant VARCHAR(50));
                Roles = (NomRole VARCHAR(50));
                Pays = (NomPays VARCHAR(50));
                Annee = (Annee INT);
                Villes = (NomVille VARCHAR(100), #NomPays*, #NomDepartement*);
                Utilisateurs = (IdUtilisateur VARCHAR(50), PrenomUtilisateur VARCHAR(50), NomUtilisateur VARCHAR(50), MailUtilisateur VARCHAR(50), #TypeEnseignant*, #NumBureau*);
                Postale = (CodePostale INT, #NomVille*);
                Lycees = (CodeLycee VARCHAR(100), NomLycee VARCHAR(100), #CodePostale*, #NomVille*);
                Modules = (IdModule VARCHAR(50), HeureCM VARCHAR(50), HeureTD VARCHAR(50), HeureTP VARCHAR(50), Coefficient VARCHAR(50), NomModule VARCHAR(50), CodeModule VARCHAR(50), #IdUe, #IdUtilisateur);
                Cours = (IdCours VARCHAR(50), #IdSemestre, #IdModule);
                Evaluations = (IdEvaluation VARCHAR(50), Coefficient VARCHAR(50), #IdUtilisateur, #IdCours*);
                Domicile = (AdresseDomicile VARCHAR(50), #TypeDeDomicile, #CodePostale, #NomVille);
                Etudiants = (IdEtudiant VARCHAR(100), PrenomEtudiant VARCHAR(100), NomEtudiant VARCHAR(100), Civilité VARCHAR(100), NomNationalite VARCHAR(50), DateNaissance VARCHAR(100), Boursier VARCHAR(100), IdAdmission VARCHAR(100), EmailEtudiant VARCHAR(100), MailPerso VARCHAR(100), NumeroFix VARCHAR(100), EtatInscription VARCHAR(50), NumeroPortable VARCHAR(100), #IdGroupe*, #AdresseDomicile, #NomVille);
                Admissions = (IdAdmission DECIMAL(15,10), NoteFrancais VARCHAR(50), NoteAnglais VARCHAR(50), NotePhysique VARCHAR(50), NoteMath VARCHAR(50), #NomSpecialite*, #AppelationBac*, #IdEtudiant);
                AvoirEtudie = (#CodeLycee, #IdAdmission);
                AssoAnneeAdmission = (#IdAdmission, #Annee);
                EtudierSemestre = (#IdEtudiant, #IdSemestre, EtatInscription VARCHAR(50));
                UtilisateursRoles = (#IdUtilisateur, #NomRole);
                EtreAbsent = (#Dates, #IdCours, Matin VARCHAR(50), Justifiee VARCHAR(50), MotifAbsence VARCHAR(50), EstAbsent VARCHAR(50), #IdEtudiant);
                EtudiantCours = (#IdEtudiant, #IdCours);
                Enseignement = (#IdCours, #IdUtilisateur);
                AssoBacAnnee = (#IdAdmission, #Annee);
                etre_intervenant = (#IdCours, #IdUtilisateur);
                noter = (#IdEtudiant, #IdEvaluation, note VARCHAR(50));
                EtreForme = (#CodeTypeFormation, #IdSemestre);                             
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
