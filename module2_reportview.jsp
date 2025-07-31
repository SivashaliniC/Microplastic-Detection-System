<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detection Calculation Data</title>
    <style>
        html,
        body {
            height: 100%;
            margin: 0;
            padding: 0;
        }

        body {
            background: linear-gradient(45deg, #49a09d, #5f2c82);
            font-family: sans-serif;
            font-weight: 100;
        }

        .container {
            width: 90%;
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            box-sizing: border-box;
            overflow-x: auto; /* Allows horizontal scrolling if needed */
        }

        .heading {
            text-align: center;
            font-size: 2rem;
            font-weight: bold;
            color: #ffffff;
            text-transform: uppercase; /* Capitalizes the text */
            margin-bottom: 20px; /* Space between heading and table */
        }

        table {
            width: 100%; /* Ensures the table fits the container width */
            border-collapse: collapse;
            overflow: hidden;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
        }

        th,
        td {
            padding: 15px;
            background-color: rgba(255, 255, 255, 0.2);
            color: #fff;
            text-align: left;
        }

        thead th {
            background-color: #55608f;
        }

        tbody tr:hover {
            background-color: rgba(255, 255, 255, 0.3);
        }

        tbody td:hover {
            position: relative;
        }

        tbody td:hover:before {
            content: "";
            position: absolute;
            left: 0;
            right: 0;
            top: -9999px;
            bottom: -9999px;
            background-color: rgba(255, 255, 255, 0.2);
            z-index: -1;
        }

        .back-button {
            position: fixed;
            bottom: 20px;
            right: 20px;
            background-color: #55608f;
            color: #fff;
            border: none;
            padding: 10px 20px;
            font-size: 1rem;
            cursor: pointer;
            border-radius: 5px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }

        .back-button:hover {
            background-color: #4a4a6c;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="heading">Calculated Values</div>
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
                    <th>Microplastic Concentration</th>
                    <th>Calculated Microplastics (g)</th>
                    <th>Total Water Mass (kg)</th>
                    <th>Percentage Microplastics in Total Water Mass</th>
                </tr>
            </thead>
            <tbody>
                <%
                    // Database connection setup
                    String url = "jdbc:mysql://localhost:3306/water_filteration";
                    String username = "root";
                    String password = "root";
                    Connection conn = null;
                    Statement stmt = null;
                    ResultSet rs = null;

                    try {
                        Class.forName("com.mysql.jdbc.Driver");
                        conn = DriverManager.getConnection(url, username, password);
                        stmt = conn.createStatement();
                        String query = "SELECT client_id, property, volume_km3, density_kg_m3, salinity_psu, dissolved_oxygen_mg_l, major_minerals, total_dissolved_solids_mg_l, microplastic_concentration, calculated_microplastics_g, total_water_mass_kg, percentage_microplastics_in_total_water_mass FROM detectioncalculation";
                        rs = stmt.executeQuery(query);

                        // Loop through the result set and display the data in table rows
                        while (rs.next()) {
                            String clientId = rs.getString("client_id");
                            String property = rs.getString("property");
                            String volume = rs.getString("volume_km3");
                            String density = rs.getString("density_kg_m3");
                            String salinity = rs.getString("salinity_psu");
                            String oxygen = rs.getString("dissolved_oxygen_mg_l");
                            String minerals = rs.getString("major_minerals");
                            String dissolvedSolids = rs.getString("total_dissolved_solids_mg_l");
                            String microConcentration = rs.getString("microplastic_concentration");
                            String microPlastics = rs.getString("calculated_microplastics_g");
                            String totalWaterMass = rs.getString("total_water_mass_kg");
                            String percentageMicroPlastics = rs.getString("percentage_microplastics_in_total_water_mass");

                            // Print each row into the table
                            out.println("<tr>");
                            out.println("<td>" + clientId + "</td>");
                            out.println("<td>" + property + "</td>");
                            out.println("<td>" + volume + "</td>");
                            out.println("<td>" + density + "</td>");
                            out.println("<td>" + salinity + "</td>");
                            out.println("<td>" + oxygen + "</td>");
                            out.println("<td>" + minerals + "</td>");
                            out.println("<td>" + dissolvedSolids + "</td>");
                            out.println("<td>" + microConcentration + "</td>");
                            out.println("<td>" + microPlastics + "</td>");
                            out.println("<td>" + totalWaterMass + "</td>");
                            out.println("<td>" + percentageMicroPlastics + "</td>");
                            out.println("</tr>");
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                        if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                    }
                %>
            </tbody>
        </table>
        <!-- Back Button -->
        <a href="Detectionhomepage.html" class="back-button">Back</a>
    </div>
</body>
</html>
