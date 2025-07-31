<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.ResultSet, java.sql.SQLException, java.sql.Statement" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Calculated Water Properties</title>
    <style>
        /* General styling */
        body {
            background: url('detect.jpg') no-repeat center center fixed;
            background-size: cover;
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            color: #333;
        }

        h2 {
            text-align: center;
            font-size: 28px;
            text-transform: uppercase;
            margin-top: 20px;
            color: #333;
        }

        /* Table styling */
        table {
            width: 80%;
            margin: 20px auto;
            border-collapse: collapse;
            background-color: #ffffff;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
            overflow: hidden; /* Ensures the rounded corners apply to the table */
        }

        th, td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        th {
            background: linear-gradient(135deg, #4CAF50, #45a049); /* Gradient header background */
            color: white;
            font-weight: bold;
        }

        td {
            background-color: #f9f9f9; /* Light background for table cells */
            color: #333;
        }

        tr:nth-child(even) {
            background-color: #f2f2f2; /* Alternating row colors */
        }

        tr:hover {
            background-color: #e0e0e0; /* Highlight row on hover */
        }

        /* Style for the back button */
        .back-button {
            display: inline-block;
            margin: 20px 0;
            padding: 10px 20px;
            background-color: #4CAF50;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-size: 16px;
            text-align: center;
        }

        .back-button:hover {
            background-color: #45a049;
        }

        /* Style for the submit button */
        .submit-button {
            display: block;
            width: 200px;
            margin: 20px auto;
            padding: 10px 20px;
            background-color: #4CAF50;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-size: 16px;
            text-align: center;
            border: none;
        }

        .submit-button:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>

<h2 style="color: white;">Calculated Water Properties</h2>

<%
    // Get parameters from the form submission
    String clientId = request.getParameter("clientId");
    String property = request.getParameter("property");
    String volume = request.getParameter("volume");
    String density = request.getParameter("density");
    String salinity = request.getParameter("salinity");
    String dissolvedOxygen = request.getParameter("dissolvedOxygen");
    String majorMinerals = request.getParameter("majorMinerals");
    String totalDissolvedSolids = request.getParameter("totalDissolvedSolids");

    // JDBC connection details
    String url = "jdbc:mysql://localhost:3306/water_filteration";
    String username = "root";
    String password = "root";

    Connection connection = null;
    Statement statement = null;
    ResultSet resultSet = null;

    // Values from the water_resource_table
    double sampleVolumeL = 0.0;
    double microplasticConcentration = 0.0;
    double calculatedMicroplastics = 0.0;
    double totalWaterMass = 0.0;
    double percentageMicroplastics = 0.0;
    double totalDissolvedSolidsContent = 0.0;
    String collectionMethod = "";
    String analysisLab = "";

    try {
        Class.forName("com.mysql.jdbc.Driver");
        connection = DriverManager.getConnection(url, username, password);
        statement = connection.createStatement();

        // Query to get values based on the property
        String resourceQuery = "SELECT * FROM watersampledata WHERE water_resource_type = '" + property + "'";
        resultSet = statement.executeQuery(resourceQuery);

        if (resultSet.next()) {
            sampleVolumeL = resultSet.getDouble("sample_volume_l");
            microplasticConcentration = resultSet.getDouble("microplastic_concentration");
            collectionMethod = resultSet.getString("collection_method");
            analysisLab = resultSet.getString("analysis_lab");
        }

        // Perform calculations
        try {
            double volumeValue = Double.parseDouble(volume);
            double densityValue = Double.parseDouble(density);

            // Convert volume from km³ to liters (1 km³ = 10^15 liters)
            double volumeInLiters = volumeValue * Math.pow(10, 15);

            // Calculate microplastics content
            calculatedMicroplastics = volumeInLiters * microplasticConcentration;

            // Calculate total water mass in tons (kg / 1000)
            totalWaterMass = (volumeInLiters * densityValue) / 1000;

            // Calculate percentage of microplastics in the total water mass
            percentageMicroplastics = (calculatedMicroplastics / totalWaterMass) * 100;

            // Calculate total dissolved solids content
            double totalDissolvedSolidsValue = Double.parseDouble(totalDissolvedSolids);
            totalDissolvedSolidsContent = volumeInLiters * totalDissolvedSolidsValue;

        } catch (NumberFormatException e) {
            e.printStackTrace();
        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (resultSet != null) try { resultSet.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (statement != null) try { statement.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (connection != null) try { connection.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>

<form action="Detectcalculation" method="post">
    <table>
        <tr>
            <th>Client ID</th>
            <td><%= clientId %></td>
            <input type="hidden" name="clientId" value="<%= clientId %>">
        </tr>
        <tr>
            <th>Property</th>
            <td><%= property %></td>
            <input type="hidden" name="property" value="<%= property %>">
        </tr>
        <tr>
            <th>Volume (km<sup>3</sup>)</th>
            <td><%= volume %></td>
            <input type="hidden" name="volume" value="<%= volume %>">
        </tr>
        <tr>
            <th>Density (kg/m<sup>3</sup>)</th>
            <td><%= density %></td>
            <input type="hidden" name="density" value="<%= density %>">
        </tr>
        <tr>
            <th>Salinity (PSU)</th>
            <td><%= salinity %></td>
            <input type="hidden" name="salinity" value="<%= salinity %>">
        </tr>
        <tr>
            <th>Dissolved Oxygen (mg/L)</th>
            <td><%= dissolvedOxygen %></td>
            <input type="hidden" name="dissolvedOxygen" value="<%= dissolvedOxygen %>">
        </tr>
        <tr>
            <th>Major Minerals</th>
            <td><%= majorMinerals %></td>
            <input type="hidden" name="majorMinerals" value="<%= majorMinerals %>">
        </tr>
        <tr>
            <th>Total Dissolved Solids (mg/L)</th>
            <td><%= totalDissolvedSolids %></td>
            <input type="hidden" name="totalDissolvedSolids" value="<%= totalDissolvedSolids %>">
        </tr>
        <tr>
            <th>Sample Volume (L)</th>
            <td><%= sampleVolumeL %></td>
            <input type="hidden" name="sampleVolumeL" value="<%= sampleVolumeL %>">
        </tr>
        <tr>
            <th>Microplastic Concentration</th>
            <td><%= microplasticConcentration %></td>
            <input type="hidden" name="microplasticConcentration" value="<%= microplasticConcentration %>">
        </tr>
        <tr>
            <th>Calculated Microplastics (mg)</th>
            <td><%= calculatedMicroplastics %></td>
            <input type="hidden" name="calculatedMicroplastics" value="<%= calculatedMicroplastics %>">
        </tr>
        <tr>
            <th>Total Water Mass (tons)</th>
            <td><%= totalWaterMass %></td> <!-- Now displayed in tons -->
            <input type="hidden" name="totalWaterMass" value="<%= totalWaterMass %>">
        </tr>
        <tr>
            <th>Percentage of Microplastics (%)</th>
            <td><%= percentageMicroplastics %></td>
            <input type="hidden" name="percentageMicroplastics" value="<%= percentageMicroplastics %>">
        </tr>
        <tr>
            <th>Total Dissolved Solids Content (g)</th>
            <td><%= totalDissolvedSolidsContent %></td>
            <input type="hidden" name="totalDissolvedSolidsContent" value="<%= totalDissolvedSolidsContent %>">
        </tr>
    </table>
    <a href="module2_calculation_process.jsp" class="back-button">Back</a>
    <input type="submit" class="submit-button" value="Submit">
</form>

</body>
</html>
