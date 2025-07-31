package Filteration;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/FiltrationCalculationServlet")
public class FiltrationCalculationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve parameters from the request
        String waterType = request.getParameter("waterType");
        String microplasticsCollected = request.getParameter("microplasticsCollected");
        String totalDissolvedSolidsRatio = request.getParameter("totalDissolvedSolidsRatio");
        String microplasticsPerVolumeSample = request.getParameter("microplasticsPerVolume");
        String totalMicroplasticsInSample = request.getParameter("totalMicroplasticsInSample");
        String filterEfficiency = request.getParameter("filterEfficiency");
        String effectiveFiltrationRate = request.getParameter("effectiveFiltrationRate");
        String contaminantRemovalEfficiency = request.getParameter("contaminantRemovalEfficiency");
        String totalWaterMass = request.getParameter("totalWaterMass");
        String weightOfWaterAfterRemoval = request.getParameter("weightAfterRemoval");

        // Hardcoded customer ID
        String customerId = "fi_9876";

        // Database connection details
        String jdbcUrl = "jdbc:mysql://localhost:3306/water_filteration"; // Adjust as necessary
        String jdbcUser = "root"; // Adjust as necessary
        String jdbcPassword = "root"; // Adjust as necessary

        Connection conn = null;
        PreparedStatement pstmt = null;
        PrintWriter out = response.getWriter();
        response.setContentType("text/html");

        try {
            // Load MySQL JDBC driver
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(jdbcUrl, jdbcUser, jdbcPassword);

            // Check if water_type already exists
            String checkSql = "SELECT COUNT(*) FROM Filtration_calculation WHERE water_type = ?";
            pstmt = conn.prepareStatement(checkSql);
            pstmt.setString(1, waterType);
            ResultSet rs = pstmt.executeQuery();

            int count = 0;
            if (rs.next()) {
                count = rs.getInt(1);
            }

            // If water_type does not exist, insert the new record
            if (count == 0) {
                // Prepare the SQL query to insert data
                String sql = "INSERT INTO Filtration_calculation (customer_id, water_type, microplastics_collected, "
                        + "total_dissolved_solids_ratio, microplastics_per_volume_sample, total_microplastics_in_sample, "
                        + "filter_efficiency, effective_filtration_rate, contaminant_removal_efficiency, "
                        + "total_water_mass, weight_of_water_after_removal) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                pstmt = conn.prepareStatement(sql);

                // Set parameters
                pstmt.setString(1, customerId);
                pstmt.setString(2, waterType);
                pstmt.setString(3, microplasticsCollected);
                pstmt.setString(4, totalDissolvedSolidsRatio);
                pstmt.setString(5, microplasticsPerVolumeSample);
                pstmt.setString(6, totalMicroplasticsInSample);
                pstmt.setString(7, filterEfficiency);
                pstmt.setString(8, effectiveFiltrationRate);
                pstmt.setString(9, contaminantRemovalEfficiency);
                pstmt.setString(10, totalWaterMass);
                pstmt.setString(11, weightOfWaterAfterRemoval);

                // Execute update
                int rowsInserted = pstmt.executeUpdate();
                if (rowsInserted > 0) {
                    out.println("<script type='text/javascript'>");
                    out.println("alert('Data inserted successfully!');");
                    out.println("window.location.href ='module3_filteration_process.jsp';"); // Redirect to a success page
                    out.println("</script>");
                } else {
                    out.println("<script type='text/javascript'>");
                    out.println("alert('Failed to insert data.');");
                    out.println("window.location.href ='module3_filteration_process.jsp';"); // Redirect to a retry page
                    out.println("</script>");
                }
            } else {
                out.println("<script type='text/javascript'>");
                out.println("alert('This water type already exists in the database.');");
                out.println("window.location.href ='module3_filteration_process.jsp';"); // Redirect to a page indicating the water type already exists
                out.println("</script>");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<script type='text/javascript'>");
            out.println("alert('Error: " + e.getMessage() + "');");
            out.println("window.location.href ='module3_filteration_process.jsp';"); // Redirect to an error page
            out.println("</script>");
        } finally {
            // Close resources
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
