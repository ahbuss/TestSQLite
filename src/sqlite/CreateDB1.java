package sqlite;

import java.io.File;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import static java.sql.Types.NULL;
import java.time.LocalDate;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author ahbuss
 */
public class CreateDB1 {

    private static final Logger LOGGER = Logger.getLogger(CreateDB1.class.getName());
    public static final String DRIVER_NAME = "org.sqlite.JDBC";
    public static final String URL_PREFIX = "jdbc:sqlite:";

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) throws ClassNotFoundException {
        Class.forName(DRIVER_NAME);
        File dbFile = new File("db/hello.db");
        if (dbFile.exists()) {
            dbFile.delete();
        }
        String dbURL = URL_PREFIX + dbFile.getAbsolutePath();
        String createQuery = "CREATE TABLE Test (id INTEGER, message VARCHAR(255), date TEXT, minutes TEXT)";
        String insertQuery = "INSERT INTO Test VALUES( %d, 'Hello %d from SQLite!', '"
                + LocalDate.now().plusDays(0).toEpochDay() + "', '" + LocalDate.now().plusMonths(5).toEpochDay() + " ')";

        String selectQuery = "SELECT * FROM Test";
        try {
            Connection connection = DriverManager.getConnection(dbURL);
            Statement statement = connection.createStatement();
            statement.executeUpdate(createQuery);
            for (int i = 1; i < 10; ++i) {
                statement.executeUpdate(String.format(insertQuery, i, i));
            }

            PreparedStatement preparedStatement = connection.prepareStatement("INSERT INTO Test VALUES (?, ?, ?, ?)");
            preparedStatement.setNull(1, Types.INTEGER);
            preparedStatement.setString(2, "Setting NULL values");
            preparedStatement.setNull(3, NULL);
            preparedStatement.setNull(4, NULL);
            preparedStatement.executeUpdate();
            
            
            ResultSet resultSet = statement.executeQuery(selectQuery);
            ResultSetMetaData rsmd = resultSet.getMetaData();
            for (int column = 1; column <= rsmd.getColumnCount(); ++column) {
                System.out.printf("\t%s", rsmd.getColumnName(column));
            }
            System.out.println();

            for (int column = 1; column <= rsmd.getColumnCount(); ++column) {
                System.out.printf("\t%s", rsmd.getColumnTypeName(column));
            }
            System.out.println();

            while (resultSet.next()) {
                System.out.printf("%d: %s: today is %s; in 5 months it will be: %s%n", resultSet.getInt("id"),
                        resultSet.getString("message"), LocalDate.ofEpochDay(resultSet.getLong("date")),
                        LocalDate.ofEpochDay(resultSet.getLong("minutes")));
            }
            resultSet.close();
            statement.close();

            connection.close();
        } catch (SQLException ex) {
            Logger.getLogger(CreateDB1.class.getName()).log(Level.SEVERE, null, ex);
        }

    }

}
