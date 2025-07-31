package Detection;
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

@WebServlet("/Detectcalculation")
public class Detectcalculation extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // Database connection parameters
    private static final String DB_URL = "jdbc:mysql://localhost:3306/water_filteration";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "root";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get form values
        String clientId = request.getParameter("clientId");
        String property = request.getParameter("property");
        String volumeKm3 = request.getParameter("volume");
        String densityKgM3 = request.getParameter("density");
        String salinityPSU = request.getParameter("salinity");
        String dissolvedOxygenMgL = request.getParameter("dissolvedOxygen");
        String majorMinerals = request.getParameter("majorMinerals");
        String totalDissolvedSolidsMgL = request.getParameter("totalDissolvedSolids");
        String sampleVolumeL = request.getParameter("sampleVolumeL");
        String microplasticConcentration = request.getParameter("microplasticConcentration");
        String calculatedMicroplasticsG = request.getParameter("calculatedMicroplastics");
        String totalWaterMassKg = request.getParameter("totalWaterMass");
        String percentageMicroplastics = request.getParameter("percentageMicroplastics");
        String totalDissolvedSolidsContentG = request.getParameter("totalDissolvedSolidsContent");

        // Database connection variables
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            // Load MySQL JDBC driver
            Class.forName("com.mysql.jdbc.Driver");
            
            // Establish connection
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            
            // Check if the property already exists
            String checkQuery = "SELECT * FROM detectioncalculation WHERE property = ?";
            ps = conn.prepareStatement(checkQuery);
            ps.setString(1, property);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                // Property already exists, send alert to the user
                response.getWriter().println("<script type='text/javascript'>");
                response.getWriter().println("alert('This property already exists in the database!');");
                response.getWriter().println("location='module2_calculation_process.jsp';"); // Redirect back to the form page
                response.getWriter().println("</script>");
            } else {
                // Prepare SQL insert query
                String query = "INSERT INTO detectioncalculation (client_id, property, volume_km3, density_kg_m3, salinity_psu, dissolved_oxygen_mg_l, major_minerals, total_dissolved_solids_mg_l, sample_volume_l, microplastic_concentration, calculated_microplastics_g, total_water_mass_kg, percentage_microplastics_in_total_water_mass, total_dissolved_solids_content_mg, collection_method) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                
                ps = conn.prepareStatement(query);
                
                // Set parameters
                ps.setString(1, clientId);
                ps.setString(2, property);
                ps.setString(3, volumeKm3);
                ps.setString(4, densityKgM3);
                ps.setString(5, salinityPSU);
                ps.setString(6, dissolvedOxygenMgL);
                ps.setString(7, majorMinerals);
                ps.setString(8, totalDissolvedSolidsMgL);
                ps.setString(9, sampleVolumeL);
                ps.setString(10, microplasticConcentration);
                ps.setString(11, calculatedMicroplasticsG);
                ps.setString(12, totalWaterMassKg);
                ps.setString(13, percentageMicroplastics);
                ps.setString(14, totalDissolvedSolidsContentG);
                ps.setString(15, "Manual collection");

                // Execute the query
                int result = ps.executeUpdate();

                // Send success alert to the user
                if (result > 0) {
                    response.getWriter().println("<script type='text/javascript'>");
                    response.getWriter().println("alert('Data successfully inserted!');");
                    response.getWriter().println("location='module2_calculation_process.jsp';");  // Redirect to success page
                    response.getWriter().println("</script>");
                } else {
                    // If data insertion fails, send error alert
                    response.getWriter().println("<script type='text/javascript'>");
                    response.getWriter().println("alert('Error inserting data! Please try again.');");
                    response.getWriter().println("location='module2_calculation_process.jsp';");  // Redirect back to the form page
                    response.getWriter().println("</script>");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            // Handle exceptions with error message
            response.getWriter().println("<script type='text/javascript'>");
            response.getWriter().println("alert('An error occurred: " + e.getMessage() + "');");
            response.getWriter().println("location='module2_calculation_process.jsp';");  // Redirect to error page
            response.getWriter().println("</script>");
        } finally {
            // Close resources
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
