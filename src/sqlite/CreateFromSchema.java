package sqlite;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;
import static sqlite.CreateDB.DRIVER_NAME;
import static sqlite.CreateDB.URL_PREFIX;

/**
 *
 * @author ahbuss
 */
public class CreateFromSchema {

    
    static {
        try {
            Class.forName(DRIVER_NAME);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(CreateFromSchema.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        String schemaFileName = args.length > 0 ? args[0] : "db/schema.sql";
        File schemaFile = new File(schemaFileName);
        if (!schemaFile.exists()) {
            System.err.printf("Schema file not found: %s%n", schemaFile.getAbsoluteFile());
            return;
        } else {
            System.out.printf("Schema file found: %s%n", schemaFile.getAbsoluteFile());
        }
        try {
            String sqlCreate = new String(Files.readAllBytes(schemaFile.toPath()));
//            System.out.println(sqlCreate);

            String outputFileName = "db/Copy.SQLite";
            File outputFile = new File(outputFileName);
            String url = URL_PREFIX.concat(outputFile.getAbsolutePath());
            Connection connection = DriverManager.getConnection(url);
            Statement statement = connection.createStatement();
            
            statement.executeUpdate(sqlCreate);
            
            statement.close();
            connection.close();
            
        } catch (IOException | SQLException ex) {
            Logger.getLogger(CreateFromSchema.class.getName()).log(Level.SEVERE, null, ex);
        }
        
    }
    
}
