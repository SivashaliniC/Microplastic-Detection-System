package Enrichment;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServlet;

@WebServlet("/enrichmentcalculation")
public class enrichmentcalculation extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Database connection details
    private static final String DB_URL = "jdbc:mysql://localhost:3306/water_filteration"; // Update with your DB details
    private static final String DB_USER = "root"; // Update with your DB username
    private static final String DB_PASSWORD = "root"; // Update with your DB password

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get parameters from the request as strings
        String customerId = "enr_8765"; // Hardcoded customer ID
        String waterBody = request.getParameter("waterBody");
        String remainingCalcium = request.getParameter("remainingCalcium");
        String remainingMagnesium = request.getParameter("remainingMagnesium");
        String remainingSodium = request.getParameter("remainingSodium");
        String remainingPotassium = request.getParameter("remainingPotassium");
        String remainingChloride = request.getParameter("remainingChloride");
        String remainingSulfate = request.getParameter("remainingSulfate");
        String remainingNitrate = request.getParameter("remainingNitrate");
        String remainingBicarbonate = request.getParameter("remainingBicarbonate");
        String remainingIron = request.getParameter("remainingIron");
        String remainingTDS = request.getParameter("remainingTDS");
        String microplasticsPostFiltration = request.getParameter("microplasticsPostFiltration");
        String totalWaterMass = request.getParameter("totalWaterMass");

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            // Check if the waterBody already exists
            String checkSql = "SELECT COUNT(*) FROM enrichment_calculation WHERE water_body = ?";
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setString(1, waterBody);
                ResultSet rs = checkStmt.executeQuery();
                if (rs.next() && rs.getInt(1) > 0) {
                    // If waterBody exists, show alert and redirect
                    showAlertAndRedirect(response, "Water body already exists!", "module4_process_details.jsp");
                    return;
                }
            }

            // Database insertion
            String sql = "INSERT INTO enrichment_calculation(employee_id, water_body, remaining_calcium, remaining_magnesium, remaining_sodium, remaining_potassium, remaining_chloride, remaining_sulfate, remaining_nitrate, remaining_bicarbonate, remaining_iron, remaining_tds, microplastics_post_filtration, total_water_mass) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, customerId); // Now this will be employee_id
                pstmt.setString(2, waterBody);
                pstmt.setString(3, remainingCalcium);
                pstmt.setString(4, remainingMagnesium);
                pstmt.setString(5, remainingSodium);
                pstmt.setString(6, remainingPotassium);
                pstmt.setString(7, remainingChloride);
                pstmt.setString(8, remainingSulfate);
                pstmt.setString(9, remainingNitrate);
                pstmt.setString(10, remainingBicarbonate);
                pstmt.setString(11, remainingIron);
                pstmt.setString(12, remainingTDS);
                pstmt.setString(13, microplasticsPostFiltration);
                pstmt.setString(14, totalWaterMass);

                pstmt.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error occurred");
            return;
        }

        // Send a response with alert for successful insert
        showAlertAndRedirect(response, "Data saved successfully!", "module4_process_details.jsp");
    }

    private void showAlertAndRedirect(HttpServletResponse response, String message, String redirectPage) throws IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        out.println("<html><head>");
        out.println("<script type='text/javascript'>");
        out.println("alert('" + message + "');");
        out.println("window.location.href='" + redirectPage + "';");
        out.println("</script>");
        out.println("</head><body>");
        out.println("</body></html>");
    }
}
