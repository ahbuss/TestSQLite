package sqlite;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import static java.lang.Integer.min;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;
import static org.sqlite.JDBC.PREFIX;

/**
 *
 * @author ahbuss
 */
public class ReadData {

    private static final Logger LOGGER = Logger.getLogger(ReadData.class.getName());

    public static final String DRIVER_NAME = "org.sqlite.JDBC";

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) throws ClassNotFoundException, IOException {
        Class.forName(DRIVER_NAME);
        String inputFileName = args.length > 0 ? args[0] : "db/WIOMdb.SQLite.zip";
        File zippedDBFile = new File(inputFileName);
        System.out.println("Zipped input file: " + zippedDBFile.getAbsolutePath());
        String fileName = zippedDBFile.getName().substring(0, zippedDBFile.getName().lastIndexOf("."));
        System.out.println("DB File Name: " + fileName);
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
            Connection connection = DriverManager.getConnection(PREFIX + dbFile.getAbsolutePath());
            Statement statement = connection.createStatement();
            DatabaseMetaData dbmd = connection.getMetaData();
            ResultSet tablesRS = dbmd.getTables(null, null, null, null);
            List<String> tableNames = new ArrayList<>();
            while (tablesRS.next()) {
                if ("TABLE".equals(tablesRS.getString("TABLE_TYPE"))) {
                    String tableName = tablesRS.getString("TABLE_NAME");
                    tableNames.add(tableName);
//                    System.out.printf("Table: %s%n", tableName);
//                    ResultSet rs = statement.executeQuery("SELECT * FROM " + tableName);
//                    ResultSetMetaData rsmd = rs.getMetaData();
//                    for (int column = 1; column <= rsmd.getColumnCount(); ++column) {
//                        System.out.printf("\t%s", rsmd.getColumnName(column));
//                    }
//                    System.out.println();
//                    for (int column = 1; column <= rsmd.getColumnCount(); ++column) {
//                        System.out.printf("\t%s", rsmd.getColumnTypeName(column));
//                    }
//                    System.out.println();
//                    rs.close();
                }
            }
            tablesRS.close();

            for (String tableName : tableNames) {

                ResultSet rs = statement.executeQuery("SELECT * FROM " + tableName);
                System.out.printf("Table %s:%n", tableName);
                ResultSetMetaData rsmd = rs.getMetaData();
                for (int column = 1; column <= rsmd.getColumnCount(); ++column) {
                    System.out.printf("\t%s", rsmd.getColumnName(column));
                }
                System.out.println();
                for (int column = 1; column <= rsmd.getColumnCount(); ++column) {
                    System.out.printf("\t%s", rsmd.getColumnTypeName(column));
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
                rs.close();
            }
            ResultSet rs = statement.executeQuery("select RTAT_OBS.RTAT from RTAT_OBS "
                    + "inner join master_data on rtat_obs.key = master_data.key "
                    + "where master_data.MATNR = '000014321' ");
            System.out.println("Result of: select RTAT_OBS.RTAT from RTAT_OBS "
                    + "inner join master_data on rtat_obs.key = master_data.key "
                    + "where master_data.MATNR = '000014321' ");
            while (rs.next()) {
                System.out.println(rs.getObject(1));
            }

            if (tableNames.contains("due_in")) {
                System.out.println("Due-ins Ordered by Key");
                rs = statement.executeQuery("SELECT * FROM due_in ORDER BY Key, DUEDATE");
                ResultSetMetaData rsmd = rs.getMetaData();
                for (int column = 1; column <= rsmd.getColumnCount(); ++column) {
                    System.out.print("\t" + rsmd.getColumnName(column));
                }
                System.out.println();
                int count = 0;
                while (rs.next()) {
                    count += 1;
                    for (int column = 1; column <= rsmd.getColumnCount(); ++column) {
                        if (rsmd.getColumnName(column).equalsIgnoreCase("DUEDATE") || 
                                rsmd.getColumnName(column).equalsIgnoreCase("DATE")) {
                            System.out.print("\t" + LocalDate.ofEpochDay(rs.getLong(column)));
                        } else {
                            System.out.print("\t" + rs.getObject(column));
                        }
                    }
                    System.out.println();
                }
                System.out.printf("%,d due-ins%n", count);

            }
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
