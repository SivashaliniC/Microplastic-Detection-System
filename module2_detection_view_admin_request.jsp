<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Water Properties Data</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f4f4f4;
            background-image: url('ad.jpeg'); /* Path to your background image */
            background-size: cover; /* Ensure the background image covers the whole page */
            background-position: center; /* Center the background image */
            background-attachment: fixed; /* Fix the background image so it stays in place on scroll */
            position: relative; /* Ensure the back button can be positioned at the bottom right */
        }
        h1 {
            color: white; /* White color for the heading text */
            text-transform: uppercase; /* Convert text to uppercase */
            margin-bottom: 20px; /* Add some space below the heading */
        }
        table {
            width: 100%;
            border-collapse: separate; /* Separate borders to allow for rounded corners */
            border-spacing: 0; /* Remove spacing between cells */
            margin: 20px 0;
            background-color: rgba(255, 255, 255, 0.8); /* Make table background color semi-transparent */
            border-radius: 10px; /* Curved edges */
            overflow: hidden; /* Hide overflow to keep curved edges */
        }
        th, td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
        }
        th {
            background-color: #4CAF50;
            color: white;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        tr:hover {
            background-color: #ddd;
        }
        /* Back button styling */
        .back-button {
            position: fixed; /* Fix the button to the bottom right corner */
            bottom: 20px;
            right: 20px;
            padding: 10px 20px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            font-size: 16px;
        }
        .back-button:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
    <h1>Water Properties Data</h1>
    <table>
        <thead>
            <tr>
                <th>Client ID</th>
                <th>Property</th>
                <th>Volume (km³)</th>
                <th>Density (kg/m³)</th>
                <th>Salinity (PSU)</th>
                <th>Dissolved Oxygen (mg/L)</th>
                <th>Major Minerals</th>
                <th>Total Dissolved Solids (mg/L)</th>
            </tr>
        </thead>
        <tbody>
            <% 
                String jdbcUrl = "jdbc:mysql://localhost:3306/water_filteration"; // Replace with your database URL
                String jdbcUser = "root"; // Replace with your database username
                String jdbcPassword = "root"; // Replace with your database password

                Connection conn = null;
                Statement stmt = null;
                ResultSet rs = null;

                try {
                    Class.forName("com.mysql.jdbc.Driver"); // Updated driver class name
                    conn = DriverManager.getConnection(jdbcUrl, jdbcUser, jdbcPassword);
                    stmt = conn.createStatement();
                    String sql = "SELECT * FROM WaterProperties";
                    rs = stmt.executeQuery(sql);

                    while (rs.next()) {
                        String clientId = rs.getString("client_id");
                        String property = rs.getString("Property");
                        String volume = rs.getString("Volume_km3");
                        String density = rs.getString("Density_kg_per_m3");
                        String salinity = rs.getString("Salinity_PSU");
                        String dissolvedOxygen = rs.getString("Dissolved_Oxygen_mg_per_L");
                        String majorMinerals = rs.getString("Major_Minerals");
                        String totalDissolvedSolids = rs.getString("Total_Dissolved_Solids_mg_per_L");
            %>
                    <tr>
                        <td><%= clientId %></td>
                        <td><%= property %></td>
                        <td><%= volume %></td>
                        <td><%= density %></td>
                        <td><%= salinity %></td>
                        <td><%= dissolvedOxygen %></td>
                        <td><%= majorMinerals %></td>
                        <td><%= totalDissolvedSolids %></td>
                    </tr>
            <% 
                    }
                } catch (Exception e) {
                    e.printStackTrace();
            %>
                    <tr>
                        <td colspan="8">Error fetching data: <%= e.getMessage() %></td>
                    </tr>
            <% 
                } finally {
                    try {
                        if (rs != null) rs.close();
                        if (stmt != null) stmt.close();
                        if (conn != null) conn.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            %>
        </tbody>
    </table>
    <a href="Detectionhomepage.html" class="back-button">Back to Admin Homepage</a>
</body>
</html>
