package sqlite;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

/**
 *
 * @author ahbuss
 */
public class ReadData {

    private static final Logger LOGGER = Logger.getLogger(ReadData.class.getName());

    public static final String DRIVER_NAME = "org.sqlite.JDBC";
    public static final String URL_PREFIX = "jdbc:sqlite:";

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) throws ClassNotFoundException, IOException {
        Class.forName(DRIVER_NAME);
        File zippedDBFile = new File("db/WIOMdb.SQLite.zip");
        String fileName = zippedDBFile.getName().substring(0, zippedDBFile.getName().lastIndexOf("."));
        File dbFile = File.createTempFile(fileName, "");
//        System.out.printf("%.2f secs to create Temp file: %s%n", 0.001 * (System.currentTimeMillis() - start), dbFile.getAbsolutePath());
        dbFile.deleteOnExit();
        long start = System.currentTimeMillis();
        unzip(zippedDBFile, dbFile);
        System.out.printf("%.2f sec to unzip file (%,dmb -> %,dmb)%n", 0.001 * (System.currentTimeMillis() - start),
                zippedDBFile.length() / (1024 * 1024), dbFile.length() / (1024 * 1024));
        if (!dbFile.exists()) {
            LOGGER.log(Level.SEVERE, "File not found: {0}", dbFile.getAbsolutePath());
            return;
        }
        try {
            Connection connection = DriverManager.getConnection(URL_PREFIX + dbFile.getAbsolutePath());
            Statement statement = connection.createStatement();
            DatabaseMetaData dbmd = connection.getMetaData();
            ResultSet tablesRS = dbmd.getTables(null, null, null, null);
            while (tablesRS.next()) {
                if ("TABLE".equals(tablesRS.getString("TABLE_TYPE"))) {
                    String tableName = tablesRS.getString("TABLE_NAME");
                    System.out.printf("Table: %s%n", tableName);
                    ResultSet rs = statement.executeQuery("SELECT * FROM " + tableName);
                    ResultSetMetaData rsmd = rs.getMetaData();
                    for (int column = 1; column <= rsmd.getColumnCount(); ++column) {
                        System.out.printf("\t%s", rsmd.getColumnName(column));
                    }
                    System.out.println();
                    for (int column = 1; column <= rsmd.getColumnCount(); ++column) {
                        System.out.printf("\t%s", rsmd.getColumnTypeName(column));
                    }
                    System.out.println();
                    rs.close();
                }
            }
            tablesRS.close();

            ResultSet rs = statement.executeQuery("SELECT * FROM recurring_demand");
            ResultSetMetaData rsmd = rs.getMetaData();
            for (int column = 1; column <= rsmd.getColumnCount(); ++column) {
                System.out.printf("\t%s", rsmd.getColumnName(column));
            }
            System.out.println();
            int count = 0;
            while (rs.next() && count < 200) {
                count += 1;
                for (int column = 1; column <= rsmd.getColumnCount(); ++column) {
                    System.out.printf("\t%s", rs.getObject(column));
                }
                System.out.println();
            }
            
//            ResultSet rs = statement.executeQuery("SELECT MATNR,KWMENG FROM recurring_demand");
//            int count = 0;
//            while (rs.next() && count < 100) {
//                System.out.printf("%s %s%n", rs.getString("MATNR"), rs.getString("KWMENG"));
//                count++;
//            }
            rs.close();
            statement.close();
            connection.close();
        } catch (SQLException ex) {
            Logger.getLogger(ReadData.class.getName()).log(Level.SEVERE, null, ex);
        }

    }

    private static void unzip(File inputFile, File outputFile) {
        byte[] buffer = new byte[1024];
        try {
            FileInputStream inputStream = new FileInputStream(inputFile);
            ZipInputStream zipInputStream = new ZipInputStream(inputStream);
//            for (ZipEntry entry = zipInputStream.getNextEntry(); entry != null;
//                    entry = zipInputStream.getNextEntry()) {
//                System.out.println(entry.getName());
//            }
            ZipEntry entry = zipInputStream.getNextEntry();
            if (entry != null) {
                FileOutputStream outputStream = new FileOutputStream(outputFile);
                for (int read = zipInputStream.read(buffer); read > 0; read = zipInputStream.read(buffer)) {
                    outputStream.write(buffer, 0, read);
                }
                outputStream.close();
            }
            zipInputStream.closeEntry();
            zipInputStream.close();
        } catch (FileNotFoundException ex) {
            LOGGER.log(Level.SEVERE, null, ex);
        } catch (IOException ex) {
            LOGGER.log(Level.SEVERE, null, ex);
        }
    }

}
