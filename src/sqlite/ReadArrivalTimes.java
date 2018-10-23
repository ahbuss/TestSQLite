package sqlite;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.SortedSet;
import java.util.TreeSet;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;
import simkit.Schedule;
import simkit.examples.ArrivalProcess;
import simkit.random.RandomVariate;
import simkit.random.RandomVariateFactory;

/**
 *
 * @author ahbuss
 */
public class ReadArrivalTimes {

    private static final Logger LOGGER = Logger.getLogger(ReadArrivalTimes.class.getName());

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
       

            ResultSet rs = statement.executeQuery("SELECT MATNR, AUDAT FROM recurring_demand WHERE MATNR='000014076'");
            
            SortedSet<Date> arrivals = new TreeSet<>();
            DateFormat format = new SimpleDateFormat("yyyyMMdd");
            while (rs.next()) {
//                System.out.printf("%s %s%n", rs.getString("MATNR"), rs.getString("AUDAT"));
                Date date = format.parse(rs.getString("AUDAT"));
                arrivals.add(date);
            }
            rs.close();
            statement.close();
            connection.close();
            System.out.printf("%s had %,d arrivals:%n", "000030392", arrivals.size());
//            for (Date date: arrivals) {
//                System.out.println(date);
//            }
            SortedSet<Integer> sorted = new TreeSet<>();
            Date[] asArray = arrivals.toArray(new Date[0]);
            for (int i = 1; i < asArray.length; ++i) {
                long diff = asArray[i].getTime() - asArray[i - 1].getTime();
                long days = diff / (1000 * 60 * 60 * 24);
//                System.out.println(days);
                sorted.add((int)days);
            }
            int[] interarrivaltimes = new int[sorted.size()];
            double[] frequencies = new double[interarrivaltimes.length];
            Arrays.fill(frequencies, 1);
            int count = 0;
            for (int x: sorted) {
                interarrivaltimes[count++] = x;
            }
            
//            for (int i = 0; i < frequencies.length; ++i) {
//                frequencies[i] *= 1 + i;
//            }
            
            RandomVariate rv = RandomVariateFactory.getInstance("DiscreteInteger", interarrivaltimes, frequencies);
            System.out.println(rv);
            
            ArrivalProcess arrivalProcess = new ArrivalProcess(rv);
            
            Schedule.stopAtTime(50 * 365);
            Schedule.reset();
            Schedule.startSimulation();
            
            System.out.printf("At time %,.2f there have been %,d Demands of NIIN %s%n",
                    Schedule.getSimTime(), arrivalProcess.getNumberArrivals(),
                    "000030392");
            
        } catch (SQLException | ParseException ex) {
            Logger.getLogger(ReadArrivalTimes.class.getName()).log(Level.SEVERE, null, ex);
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
