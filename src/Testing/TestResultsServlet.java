package Testing;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/TestResultsServlet")
public class TestResultsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Database connection details
    private static final String DB_URL = "jdbc:mysql://localhost:3306/water_filteration"; // Replace with your DB name
    private static final String DB_USER = "root"; // Replace with your DB username
    private static final String DB_PASSWORD = "root"; // Replace with your DB password

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve hidden input values from the form
        String employeeId = request.getParameter("employeeId");
        String testId = request.getParameter("testId");
        String waterBody = request.getParameter("waterBody");
        String microplasticsConcentration = request.getParameter("microplasticsConcentration");
        String organicSubstances = request.getParameter("organicSubstances");
        String globalWarmingImpact = request.getParameter("globalWarmingImpact");
        String chemicalContaminants = request.getParameter("chemicalContaminants");
        String pHLevel = request.getParameter("pHLevel");
        String temperature = request.getParameter("temperature");
        String dissolvedOxygen = request.getParameter("dissolvedOxygen");
        String otherFactors = request.getParameter("otherFactors");
        String waterPurity = request.getParameter("waterPurity");

        // Database insert operation
        String insertSQL = "INSERT INTO testing_result (employeeId, testId, waterBody, microplasticsConcentration, organicSubstances, "
                         + "globalWarmingImpact, chemicalContaminants, pHLevel, temperature, dissolvedOxygen, otherFactors, waterPurity) "
                         + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        // Check if waterBody already exists
        String checkSQL = "SELECT COUNT(*) FROM testing_result WHERE waterBody = ?";
        String redirectURL = "module5_testing_process.jsp"; // Replace with the page to redirect after success

        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement checkStatement = connection.prepareStatement(checkSQL)) {

            checkStatement.setString(1, waterBody);
            ResultSet resultSet = checkStatement.executeQuery();

            if (resultSet.next() && resultSet.getInt(1) > 0) {
                // Water body already exists
                response.getWriter().write("<script>alert('This water body has already been added.'); window.location='" + redirectURL + "';</script>");
                return; // Exit the servlet
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("<script>alert('Error: " + e.getMessage() + "'); window.location='" + redirectURL + "';</script>");
            return; // Exit the servlet
        }

        // Proceed with the insert operation
        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement preparedStatement = connection.prepareStatement(insertSQL)) {
             
            preparedStatement.setString(1, employeeId);
            preparedStatement.setString(2, testId);
            preparedStatement.setString(3, waterBody);
            preparedStatement.setString(4, microplasticsConcentration);
            preparedStatement.setString(5, organicSubstances);
            preparedStatement.setString(6, globalWarmingImpact);
            preparedStatement.setString(7, chemicalContaminants);
            preparedStatement.setString(8, pHLevel);
            preparedStatement.setString(9, temperature);
            preparedStatement.setString(10, dissolvedOxygen);
            preparedStatement.setString(11, otherFactors);
            preparedStatement.setString(12, waterPurity);

            // Execute the insert operation
            int rowsAffected = preparedStatement.executeUpdate();
            if (rowsAffected > 0) {
                response.getWriter().write("<script>alert('Data inserted successfully!'); window.location='" + redirectURL + "';</script>");
            } else {
                response.getWriter().write("<script>alert('Failed to insert data.'); window.location='" + redirectURL + "';</script>");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("<script>alert('Error: " + e.getMessage() + "'); window.location='" + redirectURL + "';</script>");
        }
    }
}
