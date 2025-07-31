package Filteration;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/Filterupload")
public class Filterupload extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Database connection parameters
    private static final String URL = "jdbc:mysql://localhost:3306/water_filteration"; // Replace with your database URL
    private static final String USER = "root"; // Replace with your database username
    private static final String PASSWORD = "root"; // Replace with your database password

    // Path to the CSV file
    private static final String CSV_FILE_PATH = "D:/water_purifier/water_purifier/WebContent/datasheet/module3_filteration_upload_data.csv";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        // Retrieve employee ID from the request or use a default value
        String employeeId = "dt_5633"; // Default employee ID

        // SQL query to load data from CSV
        String loadDataQuery = "LOAD DATA LOCAL INFILE '" + CSV_FILE_PATH  + "' INTO TABLE filteration_data "
                + "FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"' "
                + "(Water_Type, Source, Typical_Temperature_C, pH, Turbidity_NTU, Total_Dissolved_Solids_TDS_mg_L, "
                + "Microplastic_Concentration_microplastics_L, Volume_per_unit, Typical_Contaminants, Filter_Efficiency_Needed, Typical_Flow_Rate_L_min) "
                + "SET Employee_id = '" + employeeId + "'";

        try {
            // Load MySQL JDBC driver
            Class.forName("com.mysql.jdbc.Driver"); // Use the correct driver class

            // Establish connection to the database
            try (Connection connection = DriverManager.getConnection(URL, USER, PASSWORD);
                 Statement statement = connection.createStatement()) {

                // Execute the load data query
                statement.execute(loadDataQuery);
                out.println("<html><body>");
                out.println("<script>");
                out.println("alert('Data loaded successfully!');");
                out.println("window.location.href = 'module3_filterationhomepage.html';"); // Redirect to homepage
                out.println("</script>");
                out.println("</body></html>");
            } catch (SQLException e) {
                e.printStackTrace();
                out.println("<html><body>");
                out.println("<script>");
                out.println("alert('Failed to load data: " + e.getMessage() + "');");
                out.println("window.location.href = 'module3_filterationhomepage.html';"); // Redirect to error page
                out.println("</script>");
                out.println("</body></html>");
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            out.println("<html><body>");
            out.println("<script>");
            out.println("alert('JDBC Driver not found: " + e.getMessage() + "');");
            out.println("window.location.href = 'module3_filterationhomepage.html';"); // Redirect to error page
            out.println("</script>");
            out.println("</body></html>");
        }
    }
}
