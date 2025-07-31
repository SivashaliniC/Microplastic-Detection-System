package admin;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/ApproveServlet")
public class ApproveServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String url = "jdbc:mysql://localhost:3306/water_filteration";
        String username = "root";
        String password = "root";

        Connection conn = null;
        PreparedStatement pstmtInsert = null;
        PreparedStatement pstmtDelete = null;
        PreparedStatement pstmtCheck = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(url, username, password);

            // Prepare statements
            String checkQuery = "SELECT COUNT(*) FROM Admin_approven_detection WHERE client_id = ? AND property = ?";
            String insertQuery = "INSERT INTO Admin_approven_detection "
                    + "(client_id, property, volume_km3, density_kg_m3, salinity_psu, dissolved_oxygen_mg_l, "
                    + "major_minerals, total_dissolved_solids_mg_l, microplastic_concentration, calculated_microplastics_g, "
                    + "total_water_mass_kg, percentage_microplastics_in_total_water_mass) "
                    + "SELECT client_id, property, volume_km3, density_kg_m3, salinity_psu, dissolved_oxygen_mg_l, "
                    + "major_minerals, total_dissolved_solids_mg_l, microplastic_concentration, calculated_microplastics_g, "
                    + "total_water_mass_kg, percentage_microplastics_in_total_water_mass "
                    + "FROM detectioncalculation WHERE NOT EXISTS ("
                    + "SELECT 1 FROM Admin_approven_detection WHERE Admin_approven_detection.client_id = detectioncalculation.client_id "
                    + "AND Admin_approven_detection.property = detectioncalculation.property)";
            String deleteQuery = "DELETE FROM detectioncalculation";

            // Insert data into Admin_approven_detection only if it does not already exist
            pstmtInsert = conn.prepareStatement(insertQuery);
            pstmtInsert.executeUpdate();

            // Delete data from detectioncalculation
            pstmtDelete = conn.prepareStatement(deleteQuery);
            pstmtDelete.executeUpdate();

            // Redirect or forward to a confirmation page
            response.sendRedirect("admin_approval_detection_report.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin_approval_detection_report.jsp");
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (pstmtInsert != null) try { pstmtInsert.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (pstmtDelete != null) try { pstmtDelete.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (pstmtCheck != null) try { pstmtCheck.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
}
