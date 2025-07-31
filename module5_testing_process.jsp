<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Filtration Calculation Data</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            background-image: url('en2.jpg'); /* Path to your background image */
            background-size: cover; /* Cover the entire background */
            background-repeat: no-repeat; /* Do not repeat the image */
        }

        .container {
            width: 90%;
            margin: 50px auto;
            background-color: rgba(255, 255, 255, 0.9); /* Semi-transparent background */
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        h1 {
            text-align: center;
            color: #333;
        }

        .table-container {
            max-height: 500px; /* Set maximum height for the scrollable area */
            overflow-y: auto;  /* Enable vertical scrolling */
            margin-top: 20px;
            border: 1px solid #ddd; /* Optional border for better visibility */
            border-radius: 5px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        th {
            background-color: #4CAF50;
            color: white;
        }

        tr:hover {
            background-color: #f1f1f1;
        }

        .back-button, .calculate-button {
            display: block;
            width: 100px;
            margin: 20px auto;
            padding: 10px;
            text-align: center;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            text-decoration: none;
        }

        .back-button:hover, .calculate-button:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>

<div class="container">
    <h1>PROCESSING DATA</h1>
    <div class="table-container">
        <table>
            <thead>
                <tr>
                    <th>Employee ID</th>
                    <th>Water Body</th>
                    <th>Remaining Calcium</th>
                    <th>Remaining Magnesium</th>
                    <th>Remaining Sodium</th>
                    <th>Remaining Potassium</th>
                    <th>Remaining Chloride</th>
                    <th>Remaining Sulfate</th>
                    <th>Remaining Nitrate</th>
                    <th>Remaining Bicarbonate</th>
                    <th>Remaining Iron</th>
                    <th>Remaining TDS</th>
                    <th>Microplastics Post Filtration</th>
                    <th>Total Water Mass</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
            <%
                // JDBC code to fetch data from enrichment_calculation table
                String url = "jdbc:mysql://localhost:3306/water_filteration"; // replace with your database name
                String username = "root"; // replace with your database username
                String password = "root"; // replace with your database password
                Connection conn = null;
                Statement stmt = null;
                ResultSet rs = null;

                try {
                    Class.forName("com.mysql.jdbc.Driver");
                    conn = DriverManager.getConnection(url, username, password);
                    stmt = conn.createStatement();
                    String query = "SELECT * FROM enrichment_calculation"; // Use the correct table name
                    rs = stmt.executeQuery(query);

                    // Loop through the result set and display the data
                    while (rs.next()) {
                        String employeeId = rs.getString("employee_id");
                        String waterBody = rs.getString("water_body");
                        String remainingCalcium = rs.getString("remaining_calcium");
                        String remainingMagnesium = rs.getString("remaining_magnesium");
                        String remainingSodium = rs.getString("remaining_sodium");
                        String remainingPotassium = rs.getString("remaining_potassium");
                        String remainingChloride = rs.getString("remaining_chloride");
                        String remainingSulfate = rs.getString("remaining_sulfate");
                        String remainingNitrate = rs.getString("remaining_nitrate");
                        String remainingBicarbonate = rs.getString("remaining_bicarbonate");
                        String remainingIron = rs.getString("remaining_iron");
                        String remainingTDS = rs.getString("remaining_tds");
                        String microplasticsPostFiltration = rs.getString("microplastics_post_filtration");
                        String totalWaterMass = rs.getString("total_water_mass");

                        %>
                        <tr>
                            <td><%= employeeId %></td>
                            <td><%= waterBody %></td>
                            <td><%= remainingCalcium %></td>
                            <td><%= remainingMagnesium %></td>
                            <td><%= remainingSodium %></td>
                            <td><%= remainingPotassium %></td>
                            <td><%= remainingChloride %></td>
                            <td><%= remainingSulfate %></td>
                            <td><%= remainingNitrate %></td>
                            <td><%= remainingBicarbonate %></td>
                            <td><%= remainingIron %></td>
                            <td><%= remainingTDS %></td>
                            <td><%= microplasticsPostFiltration %></td>
                            <td><%= totalWaterMass %></td>
                            <td>
                                <form action="module5_calculate_data.jsp" method="post">
                                    <input type="hidden" name="employeeId" value="<%= employeeId %>">
                                    <input type="hidden" name="waterBody" value="<%= waterBody %>">
                                    <input type="hidden" name="remainingCalcium" value="<%= remainingCalcium %>">
                                    <input type="hidden" name="remainingMagnesium" value="<%= remainingMagnesium %>">
                                    <input type="hidden" name="remainingSodium" value="<%= remainingSodium %>">
                                    <input type="hidden" name="remainingPotassium" value="<%= remainingPotassium %>">
                                    <input type="hidden" name="remainingChloride" value="<%= remainingChloride %>">
                                    <input type="hidden" name="remainingSulfate" value="<%= remainingSulfate %>">
                                    <input type="hidden" name="remainingNitrate" value="<%= remainingNitrate %>">
                                    <input type="hidden" name="remainingBicarbonate" value="<%= remainingBicarbonate %>">
                                    <input type="hidden" name="remainingIron" value="<%= remainingIron %>">
                                    <input type="hidden" name="remainingTDS" value="<%= remainingTDS %>">
                                    <input type="hidden" name="microplasticsPostFiltration" value="<%= microplasticsPostFiltration %>">
                                    <input type="hidden" name="totalWaterMass" value="<%= totalWaterMass %>">
                                    <button type="submit" class="calculate-button">Calculate</button>
                                </form>
                            </td>
                        </tr>
                        <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                    try { if (stmt != null) stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                    try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                }
            %>
            </tbody>
        </table>
    </div>
    <a href="module5_testing_homepage.html" class="back-button">Back</a>
</div>

</body>
</html>
