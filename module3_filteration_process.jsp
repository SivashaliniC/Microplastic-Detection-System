<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Stylish and Transparent Table</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            background: url('fil.jpg') no-repeat center center fixed;
            background-size: cover;
        }

        .container {
            width: 90%;
            margin: 50px auto;
            background-color: rgba(255, 255, 255, 0.8);
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0px 6px 18px rgba(0, 0, 0, 0.1);
        }

        h1 {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
        }

        .table-container {
            max-width: 100%;
            overflow-x: auto; /* Makes table scrollable horizontally on small screens */
            margin-bottom: 20px;
        }

        table {
            width: 100%;
            max-width: 100%; /* Ensures table doesn't exceed container width */
            border-collapse: collapse;
            font-size: 0.9em;
            background-color: rgba(255, 255, 255, 0.7);
        }

        th, td {
            padding: 10px 12px;
            text-align: left;
            white-space: nowrap; /* Prevents wrapping of table content */
        }

        th {
            background: linear-gradient(135deg, rgba(111, 159, 255, 0.8), rgba(76, 175, 80, 0.8));
            color: white;
            cursor: pointer;
            text-transform: uppercase;
        }

        th:hover {
            background-color: rgba(62, 142, 65, 0.8);
        }

        td {
            color: #333;
        }

        tr:nth-child(even) {
            background-color: rgba(242, 242, 242, 0.5);
        }

        tr:hover {
            background-color: rgba(224, 247, 250, 0.6);
        }

        .back-btn {
            position: fixed;
            bottom: 30px;
            right: 30px;
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

        @media (max-width: 768px) {
            th, td {
                padding: 8px 10px;
            }
            table {
                font-size: 0.8em;
            }
        }
    </style>
</head>
<body>

<div class="container">
    <h1>CALCULATION PROCESS</h1>
    <div class="table-container">
        <table id="myTable">
            <thead>
                <tr>
                    <th>Property</th>
                    <th>Volume (km³)</th>
                    <th>Density (kg/m³)</th>
                    <th>Salinity (PSU)</th>
                    <th>Dissolved Oxygen (mg/L)</th>
                    <th>Major Minerals</th>
                    <th>Total Dissolved Solids (mg/L)</th>
                    <th>Sample Volume (L)</th>
                    <th>Microplastic Concentration</th>
                    <th>Calculated Microplastics (g)</th>
                    <th>Total Water Mass (kg)</th>
                    <th>Percentage Microplastics in Total Water Mass</th>
                    <th>Total Dissolved Solids Content (mg)</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Connection conn = null;
                    Statement stmt = null;
                    ResultSet rs = null;
                    try {
                        Class.forName("com.mysql.jdbc.Driver");
                        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/water_filteration", "root", "root");
                        stmt = conn.createStatement();
                        String query = "SELECT * FROM detectioncalculation";
                        rs = stmt.executeQuery(query);

                        while (rs.next()) {
                            String property = rs.getString("property");
                            String volumeKm3 = rs.getString("volume_km3");
                            String densityKgM3 = rs.getString("density_kg_m3");
                            String salinityPsu = rs.getString("salinity_psu");
                            String dissolvedOxygen = rs.getString("dissolved_oxygen_mg_l");
                            String majorMinerals = rs.getString("major_minerals");
                            String totalDissolvedSolids = rs.getString("total_dissolved_solids_mg_l");
                            String sampleVolume = rs.getString("sample_volume_l");
                            String microplasticConcentration = rs.getString("microplastic_concentration");
                            String calculatedMicroplastics = rs.getString("calculated_microplastics_g");
                            String totalWaterMass = rs.getString("total_water_mass_kg");
                            String percentageMicroplastics = rs.getString("percentage_microplastics_in_total_water_mass");
                            String totalDissolvedSolidsContent = rs.getString("total_dissolved_solids_content_mg");
                %>
                <tr>
                    <td><%= property %></td>
                    <td><%= volumeKm3 %></td>
                    <td><%= densityKgM3 %></td>
                    <td><%= salinityPsu %></td>
                    <td><%= dissolvedOxygen %></td>
                    <td><%= majorMinerals %></td>
                    <td><%= totalDissolvedSolids %></td>
                    <td><%= sampleVolume %></td>
                    <td><%= microplasticConcentration %></td>
                    <td><%= calculatedMicroplastics %></td>
                    <td><%= totalWaterMass %></td>
                    <td><%= percentageMicroplastics %></td>
                    <td><%= totalDissolvedSolidsContent %></td>
                    <td>
                        <button onclick="window.location.href='module3_calculating_process.jsp?property=<%= property %>&volume=<%= volumeKm3 %>&density=<%= densityKgM3 %>&salinity=<%= salinityPsu %>&dissolvedOxygen=<%= dissolvedOxygen %>&majorMinerals=<%= majorMinerals %>&totalDissolvedSolids=<%= totalDissolvedSolids %>&sampleVolume=<%= sampleVolume %>&microplasticConcentration=<%= microplasticConcentration %>&calculatedMicroplastics=<%= calculatedMicroplastics %>&totalWaterMass=<%= totalWaterMass %>&percentageMicroplastics=<%= percentageMicroplastics %>&totalDissolvedSolidsContent=<%= totalDissolvedSolidsContent %>'">
                            Calculate
                        </button>
                    </td>
                </tr>
                <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
                        if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
                        if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
                    }
                %>
            </tbody>
        </table>
    </div>
</div>

<button class="back-btn" onclick="window.location.href='module3_filterationhomepage.html'">Back </button>

</body>
</html>
