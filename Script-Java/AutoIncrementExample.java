import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AutoIncrementExample {
    public static void main(String[] args) {
        try {
            // Établir la connexion à la base de données Oracle
            Connection connection = DriverManager.getConnection("http://orainfo.iutmontp.univ-montp2.fr:5560/isqlplusE", "FIEVETL", "password");

            // Créer la requête SQL avec un paramètre pour l'insertion
            String sql = "INSERT INTO EtreAbsent (idAbsence, Justifiee, MotifAbsence, EstAbsent, Matin, IdCours, IdEtudiant, Dates) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

            // Préparer la requête avec l'option RETURN_GENERATED_KEYS pour récupérer l'identifiant généré
            PreparedStatement preparedStatement = connection.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);

            // Exécuter la requête pour insérer une nouvelle ligne
            preparedStatement.setInt(1, 0); // L'identifiant sera généré automatiquement
            preparedStatement.setString(2, "Justification");
            preparedStatement.setString(3, "Motif");
            preparedStatement.setString(4, "Oui");
            preparedStatement.setString(5, "Matin");
            preparedStatement.setString(6, "IdCours");
            preparedStatement.setString(7, "IdEtudiant");
            preparedStatement.setString(8, "Date");

            // Exécuter la requête
            int rowsAffected = preparedStatement.executeUpdate();

            // Vérifier si des lignes ont été affectées
            if (rowsAffected > 0) {
                // Récupérer l'identifiant auto-incrémenté
                ResultSet generatedKeys = preparedStatement.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int idBidon = generatedKeys.getInt(1);
                    System.out.println("Identifiant auto-incrémenté : " + idBidon);
                }
            }

            // Fermer les ressources
            preparedStatement.close();
            connection.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}