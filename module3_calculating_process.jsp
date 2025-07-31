<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Calculation Result</title>
    <style>
     body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            background: url('fil.jpg') no-repeat center center fixed;
            background-size: cover;
        }
        .container {
            max-width: 95%;
            margin: 50px auto;
            background-color: rgba(255, 255, 255, 0.8);
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0px 6px 18px rgba(0, 0, 0, 0.1);
            overflow-x: auto;
        }
        h1 {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
        }
        .button-container {
            text-align: center; /* Center align the button */
            margin-top: 20px; /* Space above the button */
        }
        .back-btn {
            background-color: #4CAF50;
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.2);
            transition: background-color 0.3s, box-shadow 0.3s;
        }
        .back-btn:hover {
            background-color: #45a049;
            box-shadow: 0px 6px 12px rgba(0, 0, 0, 0.3);
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 8px;
            border: 1px solid #ddd;
            text-align: left;
            font-size: 0.9em;
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
    </style>
</head>
<body>

<div class="container">
    <h1>Filtration Data and Calculations</h1>
     <form action="FiltrationCalculationServlet" method="post"> <!-- Change 'YourServletURL' to the actual servlet URL -->
   
    <%
        // Retrieve parameters as strings
        String property = request.getParameter("property");
       
        String volumeStr = request.getParameter("volume");
        String densityStr = request.getParameter("density");
        String salinityStr = request.getParameter("salinity");
        String dissolvedOxygenStr = request.getParameter("dissolvedOxygen");
        String microplasticConcentrationStr = request.getParameter("microplasticConcentration");
        String totalWaterMassStr = request.getParameter("totalWaterMass");
        String totalDissolvedSolidsStr = request.getParameter("totalDissolvedSolids");
        String sampleVolumeStr = request.getParameter("sampleVolume");
        String calculatedMicroplasticsStr = request.getParameter("calculatedMicroplastics");
        String percentageMicroplasticsStr = request.getParameter("percentageMicroplastics");
        String totalDissolvedSolidsContentStr = request.getParameter("totalDissolvedSolidsContent");

        // Convert parameters to double
        double volumeKm3 = Double.parseDouble(volumeStr);
        double densityKgM3 = Double.parseDouble(densityStr);
        double salinityPsu = Double.parseDouble(salinityStr);
        double dissolvedOxygen = Double.parseDouble(dissolvedOxygenStr);
        double microplasticConcentration = Double.parseDouble(microplasticConcentrationStr);
        double totalWaterMass = Double.parseDouble(totalWaterMassStr);
        double totalDissolvedSolids = Double.parseDouble(totalDissolvedSolidsStr);
        double sampleVolume = Double.parseDouble(sampleVolumeStr);
        double calculatedMicroplastics = Double.parseDouble(calculatedMicroplasticsStr);
        double percentageMicroplastics = Double.parseDouble(percentageMicroplasticsStr);
        double totalDissolvedSolidsContent = Double.parseDouble(totalDissolvedSolidsContentStr);

        // Initialize database variables
        double totalDissolvedSolidsTdsMgL = 0;
        double microplasticConcentrationMicroplasticsL = 0;

        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            // Load MySQL JDBC driver
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/water_filteration", "root", "root");
            stmt = conn.createStatement();
            
            // Query to fetch additional data related to the selected property
            String query = "SELECT * FROM filteration_data WHERE Water_Type = '" + property + "'";
            rs = stmt.executeQuery(query);

            if (rs.next()) {
                // Retrieve the relevant data
                totalDissolvedSolidsTdsMgL = rs.getDouble("Total_Dissolved_Solids_TDS_mg_L");
                microplasticConcentrationMicroplasticsL = rs.getDouble("Microplastic_Concentration_microplastics_L");
            }

            // Perform calculations
            double microplasticsCollected = calculatedMicroplastics * (percentageMicroplastics / 100);
            double totalDissolvedSolidsRatio = totalDissolvedSolids / totalDissolvedSolidsTdsMgL;
            double microplasticsPerVolume = microplasticConcentration * microplasticConcentrationMicroplasticsL;

            // Additional Calculations
            double totalMicroplasticsInSample = microplasticConcentration * sampleVolume;
            double filterEfficiency = (microplasticsCollected / totalMicroplasticsInSample) * 100;
            double effectiveFiltrationRate = sampleVolume / totalWaterMass;
            double contaminantRemovalEfficiency = (totalDissolvedSolids - totalDissolvedSolidsContent) / totalDissolvedSolids * 100;

            // Calculating weight of the water after microplastics removal
            double weightAfterRemoval = totalWaterMass - (microplasticsCollected / 1000); // Assuming 1 microplastic = 1 mg for simplicity

            %>
            <table>
                <thead>
                    <tr>
                        <th>Water Type</th>
                        <th>Source</th>
                        <th>Typical Temperature (°C)</th>
                        <th>pH</th>
                        <th>Turbidity (NTU)</th>
                        <th>Total Dissolved Solids (mg/L)</th>
                        <th>Microplastic Concentration (microplastics/L)</th>
                        <th>Volume per Unit</th>
                        <th>Typical Contaminants</th>
                        <th>Typical Flow Rate (L/min)</th>
                    </tr>
                </thead>
                <tbody>
    <%
            rs.beforeFirst(); // Move cursor to the beginning of the result set
            while (rs.next()) {
    %>
                    <tr>
                        <td><%= rs.getString("Water_Type") %></td>
                        <td><%= rs.getString("Source") %></td>
                        <td><%= rs.getString("Typical_Temperature_C") %></td>
                        <td><%= rs.getString("pH") %></td>
                        <td><%= rs.getString("Turbidity_NTU") %></td>
                        <td><%= rs.getString("Total_Dissolved_Solids_TDS_mg_L") %></td>
                        <td><%= rs.getString("Microplastic_Concentration_microplastics_L") %></td>
                        <td><%= rs.getString("Volume_per_Unit") %></td>
                        <td><%= rs.getString("Typical_Contaminants") %></td>
                        <td><%= rs.getString("Typical_Flow_Rate_L_min") %></td>
                    </tr>
    <%
            }
    %>
                </tbody>
            </table>

            <!-- Displaying calculation results -->
            <h2>Calculation Results</h2>
            <p><strong>Water Type:</strong> <%= property %></p>
            <p>Microplastics Collected by the Filter: <%= microplasticsCollected %> microplastics</p>
            <p>Total Dissolved Solids Ratio: <%= totalDissolvedSolidsRatio %></p>
            <p>Microplastics Per Volume Sample: <%= microplasticsPerVolume %> microplastics</p>
            <p>Total Microplastics in Sample: <%= totalMicroplasticsInSample %> microplastics</p>
            <p>Filter Efficiency: <%= filterEfficiency %> %</p>
            <p>Effective Filtration Rate: <%= effectiveFiltrationRate %> L/kg</p>
            <p>Contaminant Removal Efficiency: <%= contaminantRemovalEfficiency %> %</p>
            <p>Total Water Mass (kg): <%= totalWaterMass %> kg</p>
            <p>Weight of Water After Microplastics Removal: <%= weightAfterRemoval %> kg</p>
            
                <!-- Hidden inputs to pass calculated results to the servlet -->
                
             <input type="hidden" name="waterType" value="<%= property %>">
    <input type="hidden" name="microplasticsCollected" value="<%= microplasticsCollected %>">
    <input type="hidden" name="totalDissolvedSolidsRatio" value="<%= totalDissolvedSolidsRatio %>">
    <input type="hidden" name="microplasticsPerVolume" value="<%= microplasticsPerVolume %>">
    <input type="hidden" name="totalMicroplasticsInSample" value="<%= totalMicroplasticsInSample %>">
    <input type="hidden" name="filterEfficiency" value="<%= filterEfficiency %>">
    <input type="hidden" name="effectiveFiltrationRate" value="<%= effectiveFiltrationRate %>">
    <input type="hidden" name="contaminantRemovalEfficiency" value="<%= contaminantRemovalEfficiency %>">
    <input type="hidden" name="totalWaterMass" value="<%= totalWaterMass %>">
    <input type="hidden" name="weightAfterRemoval" value="<%= weightAfterRemoval %>">
            
            
            <button type="submit" class="back-btn">Submit Calculations</button> <!-- Submit button for the form -->
    </form>

    <%
        } catch (Exception e) {
            e.printStackTrace();
    %>
            <p>Error retrieving data from the database: <%= e.getMessage() %></p>
    <%
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
            if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
        }
    %>
</div>

<!-- Back button -->
<button onclick="window.location.href='module3_filteration_process.jsp'" class="back-btn">Back</button>

</body>
</html>
