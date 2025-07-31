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
                    <th>Water Type</th>
                    <th>Microplastics Collected</th>
                    <th>Total Dissolved Solids Ratio</th>
                    <th>Microplastics Per Volume Sample</th>
                    <th>Total Microplastics in Sample</th>
                    <th>Filter Efficiency</th>
                    <th>Effective Filtration Rate</th>
                    <th>Contaminant Removal Efficiency</th>
                    <th>Total Water Mass</th>
                    <th>Weight of Water After Removal</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
            <%
                // JDBC code to fetch data from Filtration_calculation table
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
                    String query = "SELECT * FROM Filtration_calculation";
                    rs = stmt.executeQuery(query);

                    // Loop through the result set and display the data
                    while (rs.next()) {
                        String waterType = rs.getString("water_type");
                        String microplasticsCollected = rs.getString("microplastics_collected");
                        String totalDissolvedSolidsRatio = rs.getString("total_dissolved_solids_ratio");
                        String microplasticsPerVolumeSample = rs.getString("microplastics_per_volume_sample");
                        String totalMicroplasticsInSample = rs.getString("total_microplastics_in_sample");
                        String filterEfficiency = rs.getString("filter_efficiency");
                        String effectiveFiltrationRate = rs.getString("effective_filtration_rate");
                        String contaminantRemovalEfficiency = rs.getString("contaminant_removal_efficiency");
                        String totalWaterMass = rs.getString("total_water_mass");
                        String weightAfterRemoval = rs.getString("weight_of_water_after_removal");

                        %>
                        <tr>
                            <td><%= waterType %></td>
                            <td><%= microplasticsCollected %></td>
                            <td><%= totalDissolvedSolidsRatio %></td>
                            <td><%= microplasticsPerVolumeSample %></td>
                            <td><%= totalMicroplasticsInSample %></td>
                            <td><%= filterEfficiency %></td>
                            <td><%= effectiveFiltrationRate %></td>
                            <td><%= contaminantRemovalEfficiency %></td>
                            <td><%= totalWaterMass %></td>
                            <td><%= weightAfterRemoval %></td>
                            <td>
                                <form action="module4_calculation_enrichment.jsp" method="post"> <!-- Change to your next JSP page -->
                                    <input type="hidden" name="waterType" value="<%= waterType %>">
                                    <input type="hidden" name="microplasticsCollected" value="<%= microplasticsCollected %>">
                                    <input type="hidden" name="totalDissolvedSolidsRatio" value="<%= totalDissolvedSolidsRatio %>">
                                    <input type="hidden" name="microplasticsPerVolumeSample" value="<%= microplasticsPerVolumeSample %>">
                                    <input type="hidden" name="totalMicroplasticsInSample" value="<%= totalMicroplasticsInSample %>">
                                    <input type="hidden" name="filterEfficiency" value="<%= filterEfficiency %>">
                                    <input type="hidden" name="effectiveFiltrationRate" value="<%= effectiveFiltrationRate %>">
                                    <input type="hidden" name="contaminantRemovalEfficiency" value="<%= contaminantRemovalEfficiency %>">
                                    <input type="hidden" name="totalWaterMass" value="<%= totalWaterMass %>">
                                    <input type="hidden" name="weightAfterRemoval" value="<%= weightAfterRemoval %>">
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
    <a href="module4_enrichment_home_page.html" class="back-button">Back</a>
</div>

</body>
</html>
