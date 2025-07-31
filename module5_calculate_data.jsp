<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Water Quality Testing Results</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-image: url('tet.jpg'); /* Set your background image URL here */
            background-size: cover; /* Cover the entire viewport */
            background-repeat: no-repeat; /* Do not repeat the image */
            background-attachment: fixed; /* Fix the background image during scrolling */
            margin: 0;
            padding: 20px;
            color: #fff; /* Change text color to white for better contrast */
        }
        h1 {
            text-align: center;
            color: #fff; /* Change the title color to white */
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
            background-color: rgba(255, 255, 255, 0.9); /* Semi-transparent background for the table */
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #007BFF;
            color: white;
        }
        tr:hover {
            background-color: #f1f1f1;
        }
        td {
            color: black; /* Set table data text color to black */
        }
        .submit-button {
            display: block;
            margin: 20px auto;
            padding: 10px 20px;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
        }
        .submit-button:hover {
            background-color: #218838;
        }
        .back-button {
            position: fixed; /* Fixed position for the button */
            bottom: 20px; /* Distance from the bottom */
            right: 20px; /* Distance from the right */
            padding: 10px 20px;
            background-color: #007BFF;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            text-align: center;
            text-decoration: none;
        }
        .back-button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <h1>Water Quality Testing Results</h1>
    
    <form action="TestResultsServlet" method="post">
        <table border="1">
            <thead>
                <tr>
                    <th>Employee ID</th>
                    <th>Test ID</th>
                    <th>Water Resource Type</th>
                    <th>Microplastics Concentration</th>
                    <th>Organic Substances</th>
                    <th>Global Warming Impact</th>
                    <th>Chemical Contaminants</th>
                    <th>pH Level</th>
                    <th>Temperature</th>
                    <th>Dissolved Oxygen</th>
                    <th>Other Factors</th>
                    <th>Water Purity (%)</th>
                </tr>
            </thead>
            <tbody>
            <%
                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;

                // Replace these values with your actual database connection details
                String url = "jdbc:mysql://localhost:3306/water_filteration";
                String username = "root";
                String password = "root";
                String waterBody = request.getParameter("waterBody");
                String totalWaterMass = request.getParameter("totalWaterMass");

                // Fetch remaining parameters
                String remainingCalcium = request.getParameter("remainingCalcium");
                String remainingMagnesium = request.getParameter("remainingMagnesium");
                String remainingSodium = request.getParameter("remainingSodium");
                String remainingPotassium = request.getParameter("remainingPotassium");
                String remainingChloride = request.getParameter("remainingChloride");
                String remainingSulfate = request.getParameter("remainingSulfate");
                String remainingNitrate = request.getParameter("remainingNitrate");
                String remainingBicarbonate = request.getParameter("remainingBicarbonate");
                String remainingTDS = request.getParameter("remainingTDS");
                String microplasticsPostFiltration = request.getParameter("microplasticsPostFiltration");

                try {
                    Class.forName("com.mysql.jdbc.Driver");
                    conn = DriverManager.getConnection(url, username, password);

                    // Prepare a query to fetch relevant data from WaterTesting
                    String query = "SELECT * FROM WaterTesting WHERE water_resource_type = ?";
                    pstmt = conn.prepareStatement(query);
                    pstmt.setString(1, waterBody);
                    rs = pstmt.executeQuery();

                    // Loop through the result set and display the data
                    while (rs.next()) {
                        String employeeId = rs.getString("employee_id");
                        String testId = rs.getString("test_id");
                        String microplasticsConcentration = rs.getString("microplastics_concentration");
                        String organicSubstances = rs.getString("organic_substances");
                        String globalWarmingImpact = rs.getString("global_warming_impact");
                        String chemicalContaminants = rs.getString("chemical_contaminants");
                        String pHLevel = rs.getString("pH_level");
                        String temperature = rs.getString("temperature");
                        String dissolvedOxygen = rs.getString("dissolved_oxygen");
                        String otherFactors = rs.getString("other_factors");

                        // Perform calculations based on the fetched data and input parameters
                        double microplasticsConc = Double.parseDouble(microplasticsConcentration);
                        double waterMass = Double.parseDouble(totalWaterMass);
                        double calcium = Double.parseDouble(remainingCalcium);
                        double magnesium = Double.parseDouble(remainingMagnesium);
                        double sodium = Double.parseDouble(remainingSodium);
                        double potassium = Double.parseDouble(remainingPotassium);
                        double chloride = Double.parseDouble(remainingChloride);
                        double sulfate = Double.parseDouble(remainingSulfate);
                        double nitrate = Double.parseDouble(remainingNitrate);
                        double bicarbonate = Double.parseDouble(remainingBicarbonate);
                        double tds = Double.parseDouble(remainingTDS);
                        double postFiltration = Double.parseDouble(microplasticsPostFiltration);

                        // Calculate totalMicroplastics
                        double totalMicroplastics = microplasticsConc - postFiltration; // Example calculation

                        // Calculate totalOrganicImpact
                        double totalRemainingElements = calcium + magnesium + sodium + potassium + chloride + sulfate + nitrate + bicarbonate;
                        double totalOrganicImpact = totalRemainingElements * Double.parseDouble(organicSubstances); // Example calculation

                        // Calculate water purity
                        double totalContaminants = totalMicroplastics + Double.parseDouble(chemicalContaminants);
                        double totalPossibleContaminants = waterMass; // Assuming total water mass is the total possible contaminants
                        double waterPurity = 100 - (totalContaminants / totalPossibleContaminants * 100); // Water purity percentage

                        %>
                        <tr>
                            <td><%= employeeId %></td>
                            <td><%= testId %></td>
                            <td><%= waterBody %></td>
                            <td><%= microplasticsConcentration %> (Calculated: <%= totalMicroplastics %>)</td>
                            <td><%= organicSubstances %> (Calculated: <%= totalOrganicImpact %>)</td>
                            <td><%= globalWarmingImpact %></td>
                            <td><%= chemicalContaminants %></td>
                            <td><%= pHLevel %></td>
                            <td><%= temperature %></td>
                            <td><%= dissolvedOxygen %></td>
                            <td><%= otherFactors %></td>
                            <td><%= String.format("%.2f", waterPurity) %></td> <!-- Display water purity -->
                        </tr>
                        <input type="hidden" name="employeeId" value="<%= employeeId %>">
                        <input type="hidden" name="testId" value="<%= testId %>">
                        <input type="hidden" name="waterBody" value="<%= waterBody %>">
                        <input type="hidden" name="microplasticsConcentration" value="<%= microplasticsConcentration %>">
                        <input type="hidden" name="organicSubstances" value="<%= organicSubstances %>">
                        <input type="hidden" name="globalWarmingImpact" value="<%= globalWarmingImpact %>">
                        <input type="hidden" name="chemicalContaminants" value="<%= chemicalContaminants %>">
                        <input type="hidden" name="pHLevel" value="<%= pHLevel %>">
                        <input type="hidden" name="temperature" value="<%= temperature %>">
                        <input type="hidden" name="dissolvedOxygen" value="<%= dissolvedOxygen %>">
                        <input type="hidden" name="otherFactors" value="<%= otherFactors %>">
                        <input type="hidden" name="waterPurity" value="<%= waterPurity %>">
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
        <input type="submit" value="Submit" class="submit-button">
    </form>

    <a href="module5_testing_process.jsp" class="back-button">Back</a> <!-- Back button positioned at the bottom right -->
</body>
</html>
