<%@ page import="java.sql.*" %>
<%@ page import="java.text.DecimalFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Filtration Data Calculation Result</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            background-image: url('en2.jpg');
            background-size: cover;
            background-repeat: no-repeat;
        }

        .container {
            width: 90%;
            margin: 50px auto;
            background-color: rgba(255, 255, 255, 0.9);
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        h1 {
            text-align: center;
            color: #333;
        }

        .table-wrapper {
            overflow-x: auto;
            margin-top: 20px;
            border: 1px solid #ddd;
            border-radius: 10px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 12px;
            border-bottom: 1px solid #ddd;
        }

        th {
            background-color: #4CAF50;
            color: white;
            text-align: center;
        }

        td {
            background-color: #f9f9f9;
            text-align: center;
        }

        .back-button {
            position: absolute;
            bottom: 20px;
            right: 20px;
            display: block;
            width: 100px;
            padding: 10px;
            text-align: center;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            text-decoration: none;
        }

        .back-button:hover {
            background-color: #45a049;
        }

        .calculate-button {
            background-color: #2196F3;
            color: white;
            border: none;
            border-radius: 5px;
            padding: 5px 10px;
            cursor: pointer;
            display: block;
            margin: 20px auto; /* Center the button */
        }

        .calculate-button:hover {
            background-color: #1E88E5;
        }
    </style>
</head>
<body>

<div class="container">
    <h2 style="text-align: center; text-transform: uppercase;">Water Body Analysis and Post Filtration Mineral Levels</h2>

    <form action="enrichmentcalculation" method="post"> <!-- Start the form here -->
        <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>Water Body</th>
                        <th>Calcium (mg/L)</th>
                        <th>Magnesium (mg/L)</th>
                        <th>Sodium (mg/L)</th>
                        <th>Potassium (mg/L)</th>
                        <th>Chloride (mg/L)</th>
                        <th>Sulfate (mg/L)</th>
                        <th>Nitrate (mg/L)</th>
                        <th>Bicarbonate (mg/L)</th>
                        <th>Iron (mg/L)</th>
                        <th>TDS (mg/L)</th>
                        <th>Microplastics Post Filtration</th>
                        <th>Total Water Mass (tons)</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    // Initialize variables
                    double remainingCalcium = 0, remainingMagnesium = 0, remainingSodium = 0;
                    double remainingPotassium = 0, remainingChloride = 0, remainingSulfate = 0;
                    double remainingNitrate = 0, remainingBicarbonate = 0, remainingIron = 0;
                    double remainingTDS = 0, microplasticsPostFiltration = 0;

                    // Retrieve request parameters
                    String microplasticsCollected = request.getParameter("microplasticsCollected");
                    String totalDissolvedSolidsRatio = request.getParameter("totalDissolvedSolidsRatio");
                    String microplasticsPerVolumeSample = request.getParameter("microplasticsPerVolumeSample");
                    String totalMicroplasticsInSample = request.getParameter("totalMicroplasticsInSample");
                    String filterEfficiency = request.getParameter("filterEfficiency");
                    String effectiveFiltrationRate = request.getParameter("effectiveFiltrationRate");
                    String contaminantRemovalEfficiency = request.getParameter("contaminantRemovalEfficiency");
                    String totalWaterMass = request.getParameter("totalWaterMass");
                    String weightAfterRemoval = request.getParameter("weightAfterRemoval");

                    double filterEfficiencyValue = Double.parseDouble(filterEfficiency);
                    double totalWaterMassValue = Double.parseDouble(totalWaterMass); // Convert to double

                    String waterType = request.getParameter("waterType");
                    String url = "jdbc:mysql://localhost:3306/water_filteration";
                    String username = "root";
                    String password = "root";
                    Connection conn = null;
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;

                    try {
                        // Establishing database connection
                        Class.forName("com.mysql.jdbc.Driver");
                        conn = DriverManager.getConnection(url, username, password);

                        // SQL query to fetch water body analysis data
                        String query = "SELECT * FROM waterbodyanalysis WHERE water_body = ?";
                        pstmt = conn.prepareStatement(query);
                        pstmt.setString(1, waterType);

                        rs = pstmt.executeQuery();

                        // Fetching data from the result set
                        while (rs.next()) {
                            String waterBody = rs.getString("water_body");
                            double calcium = rs.getDouble("calcium_mg_per_L");
                            double magnesium = rs.getDouble("magnesium_mg_per_L");
                            double sodium = rs.getDouble("sodium_mg_per_L");
                            double potassium = rs.getDouble("potassium_mg_per_L");
                            double chloride = rs.getDouble("chloride_mg_per_L");
                            double sulfate = rs.getDouble("sulfate_mg_per_L");
                            double nitrate = rs.getDouble("nitrate_mg_per_L");
                            double bicarbonate = rs.getDouble("bicarbonate_mg_per_L");
                            double iron = rs.getDouble("iron_mg_per_L");
                            double tds = rs.getDouble("tds_mg_per_L");
                            microplasticsPostFiltration = rs.getDouble("microplastics_post_filtration");

                            // Calculating remaining mineral levels post-filtration
                            remainingCalcium = calcium * ((filterEfficiencyValue / 100) - 1);
                            remainingMagnesium = magnesium * ((filterEfficiencyValue / 100) - 1);
                            remainingSodium = sodium * ((filterEfficiencyValue / 100) - 1);
                            remainingPotassium = potassium * ((filterEfficiencyValue / 100) - 1);
                            remainingChloride = chloride * ((filterEfficiencyValue / 100) - 1);
                            remainingSulfate = sulfate * ((filterEfficiencyValue / 100) - 1);
                            remainingNitrate = nitrate * ((filterEfficiencyValue / 100) - 1);
                            remainingBicarbonate = bicarbonate * ((filterEfficiencyValue / 100) - 1);
                            remainingIron = iron * ((filterEfficiencyValue / 100) - 1);
                            remainingTDS = tds * (1 - (Double.parseDouble(totalDissolvedSolidsRatio) / 100));

                            // Output the calculated values in the table
                            %>
                            <tr>
                                <td><%= waterBody %></td>
                                <td><%= new DecimalFormat("0.00").format(remainingCalcium) %> mg/L</td>
                                <td><%= new DecimalFormat("0.00").format(remainingMagnesium) %> mg/L</td>
                                <td><%= new DecimalFormat("0.00").format(remainingSodium) %> mg/L</td>
                                <td><%= new DecimalFormat("0.00").format(remainingPotassium) %> mg/L</td>
                                <td><%= new DecimalFormat("0.00").format(remainingChloride) %> mg/L</td>
                                <td><%= new DecimalFormat("0.00").format(remainingSulfate) %> mg/L</td>
                                <td><%= new DecimalFormat("0.00").format(remainingNitrate) %> mg/L</td>
                                <td><%= new DecimalFormat("0.00").format(remainingBicarbonate) %> mg/L</td>
                                <td><%= new DecimalFormat("0.00").format(remainingIron) %> mg/L</td>
                                <td><%= new DecimalFormat("0.00").format(remainingTDS) %> mg/L</td>
                                <td><%= new DecimalFormat("0.00").format(microplasticsPostFiltration) %> mg/L</td>
                                <td><%= new DecimalFormat("0.00").format(totalWaterMassValue) %> tons</td> <!-- Display total water mass -->
                            </tr>
                            <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        try {
                            if (rs != null) rs.close();
                            if (pstmt != null) pstmt.close();
                            if (conn != null) conn.close();
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    }
                    %>
                </tbody>
            </table>
        </div>
        <input type="hidden" name="waterBody" value="<%= waterType %>"> <!-- Pass the water body -->
        
        <input type="hidden" name="remainingCalcium" value="<%= new DecimalFormat("0.00").format(remainingCalcium) %>">
        <input type="hidden" name="remainingMagnesium" value="<%= new DecimalFormat("0.00").format(remainingMagnesium) %>">
        <input type="hidden" name="remainingSodium" value="<%= new DecimalFormat("0.00").format(remainingSodium) %>">
        <input type="hidden" name="remainingPotassium" value="<%= new DecimalFormat("0.00").format(remainingPotassium) %>">
        <input type="hidden" name="remainingChloride" value="<%= new DecimalFormat("0.00").format(remainingChloride) %>">
        <input type="hidden" name="remainingSulfate" value="<%= new DecimalFormat("0.00").format(remainingSulfate) %>">
        <input type="hidden" name="remainingNitrate" value="<%= new DecimalFormat("0.00").format(remainingNitrate) %>">
        <input type="hidden" name="remainingBicarbonate" value="<%= new DecimalFormat("0.00").format(remainingBicarbonate) %>">
        <input type="hidden" name="remainingIron" value="<%= new DecimalFormat("0.00").format(remainingIron) %>">
        <input type="hidden" name="remainingTDS" value="<%= new DecimalFormat("0.00").format(remainingTDS) %>">
        <input type="hidden" name="microplasticsPostFiltration" value="<%= new DecimalFormat("0.00").format(microplasticsPostFiltration) %>">
        <input type="hidden" name="totalWaterMass" value="<%= new DecimalFormat("0.00").format(totalWaterMassValue) %>">
        

        <button type="submit" class="calculate-button">Submit</button>
        <a href="module4_process_details.jsp" class="back-button">Back</a>
    </form>
</div>

</body>
</html>
