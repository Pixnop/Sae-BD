import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class grantAll {
    public static void main(String[] args) {
        // List tables
        String data = """
                Nationalite = (NomNationalite VARCHAR(50));
                Specialites = (NomSpecialite VARCHAR(50));
                Departement = (NomDepartement VARCHAR(50));
                Bac = (AppelationBac VARCHAR(50));
                Dates = (Dates VARCHAR(50));
                TypeFormation = (CodeTypeFormation VARCHAR(50), NomTypeFormation VARCHAR(50));
                Inscription = (EtatInscription VARCHAR(50));
                Groupes = (IdGroupe VARCHAR(50), NomGroupe VARCHAR(50));
                Semestre = (IdSemestre VARCHAR(50), NumeroSemestre VARCHAR(50), #Dates, #Dates_1);
                Promotion = (NomPromotion VARCHAR(50));
                UE = (IdUe VARCHAR(50), CodeUE VARCHAR(100), NomUE VARCHAR(100), CoefficientUE VARCHAR(50), NombreECTS VARCHAR(50));
                Bureau = (NumBureau VARCHAR(50), TelephoneBureau VARCHAR(50));
                TypeDomicile = (TypeDeDomicile VARCHAR(50));
                Postale = (CodePostale INT);
                TypeEnseignant = (TypeEnseignant VARCHAR(50));
                Roles = (NomRole VARCHAR(50));
                Pays = (NomPays VARCHAR(50));
                Annee = (Annee INT);
                note = (note DECIMAL(15,10));
                Matiere = (matiere VARCHAR(50));
                Villes = (NomVille VARCHAR(100), #NomPays*, #NomDepartement*);
                Utilisateurs = (IdUtilisateur VARCHAR(50), PrenomUtilisateur VARCHAR(50), NomUtilisateur VARCHAR(50), MailUtilisateur VARCHAR(50), #TypeEnseignant*, #NumBureau*);
                Domicile = (AdresseDomicile VARCHAR(50), #TypeDeDomicile, #CodePostale, #NomVille);
                Lycees = (CodeLycee VARCHAR(100), NomLycee VARCHAR(100), #CodePostale*, #NomVille*);
                Modules = (IdModule VARCHAR(50), HeureCM VARCHAR(50), HeureTD VARCHAR(50), HeureTP VARCHAR(50), Coefficient VARCHAR(50), NomModule VARCHAR(50), CodeModule VARCHAR(50), #IdUe, #IdUtilisateur);
                Cours = (IdCours VARCHAR(50), #IdSemestre, #IdModule);
                Evaluations = (IdEvaluation VARCHAR(50), Coefficient VARCHAR(50), #IdUtilisateur);
                Etudiants = (IdEtudiant VARCHAR(50), PrenomEtudiant VARCHAR(50), NomEtudiant VARCHAR(50), Civilité VARCHAR(50), Boursier VARCHAR(50), IdAdmission VARCHAR(50), EmailEtudiant VARCHAR(50), MailPerso VARCHAR(50), NumeroFix VARCHAR(50), NumeroPortable VARCHAR(50), #AppelationBac*, #NomSpecialite*, #Annee*, #IdGroupe*, #CodeTypeFormation, #NomPromotion*, #EtatInscription, #Annee_1*, #CodeLycee*, #AdresseDomicile, #NomNationalite, #NomVille, #Dates*);
                UtilisateursRoles = (#IdUtilisateur, #NomRole);
                Etre_absent = (#IdEtudiant, #Dates, #IdCours, Matin VARCHAR(50), Justifiee VARCHAR(50), MotifAbsence VARCHAR(50), EstAbsent VARCHAR(50));
                EtudiantCours = (#IdEtudiant, #IdCours);
                CoursEvaluation = (#IdCours, #IdEvaluation);
                Enseignement = (#IdCours, #IdUtilisateur);
                AssoVilleCodePostal = (#NomVille, #CodePostale);
                etre_intervenant = (#IdModule, #IdUtilisateur);
                noter = (#IdEtudiant, #IdEvaluation, note VARCHAR(50));
                bacNote = (#IdEtudiant, #matiere, #note);
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
