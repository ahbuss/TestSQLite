package sqlite;

import java.io.File;
import static java.lang.Double.NaN;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import static org.sqlite.JDBC.PREFIX;

/**
 *
 * @author ahbuss
 */
public class TestROPRead {

    private static final String CREATE = "CREATE TABLE CIP("
            + "CIP_ID             TEXT PRIMARY KEY,"
            + "Family_ID           TEXT,"
            + "Sim_ID              TEXT,"
            + "PMSS                Real,"
            + "ROP                 Real,"
            + "Order_Up_To         Real)";

    private static final String DRIVER_NAME = "org.sqlite.JDBC";

    private static final String INSERT = "INSERT INTO CIP VALUES("
            + "?, ?, ?, ?, ?, ?)";

    /**
     * @param args the command line arguments
     * @throws java.lang.ClassNotFoundException
     * @throws java.sql.SQLException
     */
    public static void main(String[] args) throws ClassNotFoundException, SQLException {
        Class.forName(DRIVER_NAME);
        File dbFile = new File("db/CIP.SQLite");
        if (dbFile.exists()) {
            dbFile.delete();
        }
        String dbURL = PREFIX + dbFile.getAbsolutePath();

        Connection connection = DriverManager.getConnection(dbURL);
        Statement statement = connection.createStatement();
        statement.executeUpdate(CREATE);

        PreparedStatement ps = connection.prepareStatement(INSERT);
        for (int i = 0; i < 10; ++i) {
            ps.setString(1, "" + i);
            ps.setString(2, "10");
            ps.setString(3, "20");
            ps.setDouble(4, (10 + 10 * i));
            ps.setDouble(5, NaN);
            ps.setDouble(6, NaN);
            ps.execute();
        }

        for (int i = 10; i < 20; ++i) {
            ps.setString(1, "" + i);
            ps.setString(2, "10");
            ps.setString(3, "20");
            ps.setDouble(4, NaN);
            ps.setDouble(5, i + 1);
            ps.setDouble(6, i + 10);
            ps.execute();
        }
        ps.close();

        ResultSet rs = statement.executeQuery("SELECT * FROM CIP");

        while (rs.next()) {
            if (rs.getObject("PMSS") != null) {
                System.out.printf("%s: Using PMSS: %,.1f%n", rs.getString("CIP_ID"), rs.getDouble("PMSS"));
            } else if (rs.getObject("ROP") != null && rs.getObject("Order_Up_To") != null) {
                System.out.printf("%s: Using ROP/Order_Up_To: (%,.1f,%,.1f)%n", rs.getString("CIP_ID"), rs.getDouble("ROP"), rs.getDouble("Order_Up_To"));
            }
        }

        rs.close();
        statement.close();
        connection.close();
    }

}
