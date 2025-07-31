package Testing;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/Testupload")
public class Testupload extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Database connection parameters
    private static final String URL = "jdbc:mysql://localhost:3306/water_filteration"; // Replace with your database URL
    private static final String USER = "root"; // Replace with your database username
    private static final String PASSWORD = "root"; // Replace with your database password

    // Path to the CSV file
    private static final String CSV_FILE_PATH = "D:/water_purifier/water_purifier/WebContent/datasheet/module5_testing_upload_file1.csv"; // Replace with your CSV file path

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        // Retrieve employee ID from the request or use a default value
        String employeeId = request.getParameter("employeeId");
        if (employeeId == null || employeeId.isEmpty()) {
            employeeId = "t_7568"; // Default employee ID
        }

        // SQL query to insert data into WaterTesting table
        String insertDataQuery = "INSERT INTO WaterTesting (employee_id, water_resource_type, microplastics_concentration, organic_substances, global_warming_impact, chemical_contaminants, pH_level, temperature, dissolved_oxygen, other_factors) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try {
            // Load MySQL JDBC driver
            Class.forName("com.mysql.jdbc.Driver");

            // Establish connection to the database
            try (Connection connection = DriverManager.getConnection(URL, USER, PASSWORD);
                 PreparedStatement insertStatement = connection.prepareStatement(insertDataQuery);
                 BufferedReader br = new BufferedReader(new FileReader(CSV_FILE_PATH))) {

                String line;
                int lineNumber = 0;

                // Read CSV file line by line
                while ((line = br.readLine()) != null) {
                    if (lineNumber == 0) {
                        // Skip the header line
                        lineNumber++;
                        continue;
                    }

                    // Split the line by comma
                    String[] values = line.split(",");

                    // Trim whitespace and handle any quotes
                    for (int i = 0; i < values.length; i++) {
                        values[i] = values[i].trim().replaceAll("\"", "");
                    }

                    // Set parameters for the prepared statement
                    insertStatement.setString(1, employeeId); // Employee ID
                    insertStatement.setString(2, values[1]); // Water Resource Type
                    insertStatement.setDouble(3, Double.parseDouble(values[2])); // Microplastics Concentration
                    insertStatement.setDouble(4, Double.parseDouble(values[3])); // Organic Substances
                    insertStatement.setString(5, values[4]); // Global Warming Impact
                    insertStatement.setDouble(6, Double.parseDouble(values[5])); // Chemical Contaminants
                    insertStatement.setDouble(7, Double.parseDouble(values[6])); // pH Level
                    insertStatement.setDouble(8, Double.parseDouble(values[7])); // Temperature
                    insertStatement.setDouble(9, Double.parseDouble(values[8])); // Dissolved Oxygen
                    insertStatement.setString(10, values[9]); // Other Factors

                    // Execute the insertion
                    insertStatement.executeUpdate();
                    lineNumber++;
                }

                // Success response
                out.println("<html><body>");
                out.println("<script>");
                out.println("alert('Data loaded successfully from CSV!');");
                out.println("window.location.href = 'module5_testing_homepage.html';"); // Redirect to homepage
                out.println("</script>");
                out.println("</body></html>");
            } catch (SQLException e) {
                e.printStackTrace();
                out.println("<html><body>");
                out.println("<script>");
                out.println("alert('Failed to insert data: " + e.getMessage() + "');");
                out.println("window.location.href = 'module5_testing_homepage.html';"); // Redirect to error page
                out.println("</script>");
                out.println("</body></html>");
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            out.println("<html><body>");
            out.println("<script>");
            out.println("alert('JDBC Driver not found: " + e.getMessage() + "');");
            out.println("window.location.href = 'module5_testing_homepage.html';"); // Redirect to error page
            out.println("</script>");
            out.println("</body></html>");
        }
    }
}
