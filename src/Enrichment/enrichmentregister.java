package Enrichment;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Random;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/enrichmentregister")
public class enrichmentregister extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Database credentials
    private static final String DB_URL = "jdbc:mysql://localhost:3306/water_filteration";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "root";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        // Retrieve form data
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phone_number");
        String address = request.getParameter("address");

        // Generate a random employee ID with prefix 'EMP' and 4 random digits
        String empId = "en_" + generateRandomNumber(4);
        
        // Generate a random 4-letter password
        String password = generateRandomPassword(4);
        
        String status = "Pending";

        // Database insertion
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            // Load and register JDBC driver
            Class.forName("com.mysql.jdbc.Driver");
            // Establish connection
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            
            // Prepare SQL query
            String sql = "INSERT INTO enrichment(id, name, email, phone_number, address, password, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, empId);
            pstmt.setString(2, name);
            pstmt.setString(3, email);
            pstmt.setString(4, phoneNumber);
            pstmt.setString(5, address);
            pstmt.setString(6, password);
            pstmt.setString(7, status);

            // Execute update
            int rowsAffected = pstmt.executeUpdate();
           
            if (rowsAffected > 0) {
                // Output HTML with JavaScript for alert and redirection
                out.println("<html>");
                out.println("<head><title>Registration Status</title></head>");
                out.println("<body>");
                out.println("<script type='text/javascript'>");
                out.println("alert('Registration Successful');");
                out.println("window.location.href = 'module4_login.html';");
                out.println("</script>");
                out.println("</body>");
                out.println("</html>");
            } else {
                out.println("<html>");
                out.println("<head><title>Registration Status</title></head>");
                out.println("<body>");
                out.println("<h3>Registration Failed</h3>");
                out.println("window.location.href = 'module4_register.html';");
                out.println("</body>");
                out.println("</html>");
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            out.println("<html>");
            out.println("<head><title>Error</title></head>");
            out.println("<body>");
            out.println("<h3>Error: " + e.getMessage() + "</h3>");
            out.println("</body>");
            out.println("</html>");
        } finally {
            // Clean up environment
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // Method to generate a random number of specified length
    private String generateRandomNumber(int length) {
        Random random = new Random();
        StringBuilder sb = new StringBuilder(length);
        for (int i = 0; i < length; i++) {
            sb.append(random.nextInt(10));
        }
        return sb.toString();
    }

    // Method to generate a random 4-letter password (uppercase letters only)
    private String generateRandomPassword(int length) {
        if (length != 4) {
            throw new IllegalArgumentException("Password length must be exactly 4 characters");
        }
        
        String upperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        Random random = new Random();
        StringBuilder password = new StringBuilder(length);

        // Generate a password of 4 uppercase letters
        for (int i = 0; i < length; i++) {
            password.append(upperCase.charAt(random.nextInt(upperCase.length())));
        }

        return password.toString();
    }
}
