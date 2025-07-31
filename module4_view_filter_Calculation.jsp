<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
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
            background: url('fil.jpg') no-repeat center center fixed; /* Add your background image URL here */
            background-size: cover;
        }

        .container {
            width: 90%;
            margin: 50px auto;
            background-color: rgba(255, 255, 255, 0.8); /* Slightly transparent container */
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0px 6px 18px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(5px); /* Adds a nice blur effect */
        }

        h1 {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
        }

        .table-container {
            max-height: 400px; /* Set the maximum height for vertical scrolling */
            overflow-y: auto;  /* Enable vertical scrolling */
            overflow-x: auto;  /* Enable horizontal scrolling */
            margin-bottom: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
            font-size: 1em;
            background-color: rgba(255, 255, 255, 0.7); /* Transparent table background */
        }

        th, td {
            padding: 14px 18px;
            text-align: left;
        }

        th {
            background: linear-gradient(135deg, rgba(111, 159, 255, 0.8), rgba(76, 175, 80, 0.8));
            color: white;
            cursor: pointer;
            text-transform: uppercase;
            white-space: nowrap;
        }

        th:hover {
            background-color: rgba(62, 142, 65, 0.8);
        }

        td {
            color: #333;
            white-space: nowrap; /* Prevents text wrapping inside cells */
        }

        tr:nth-child(even) {
            background-color: rgba(242, 242, 242, 0.5);
        }

        tr:hover {
            background-color: rgba(224, 247, 250, 0.6);
        }

        .back-button {
            position: fixed;
            bottom: 20px;
            right: 20px;
            background-color: #4CAF50; /* Green color */
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            text-decoration: none;
        }

        .back-button:hover {
            background-color: #45a049;
        }

        @media (max-width: 768px) {
            table, thead, tbody, th, td, tr {
                display: block;
            }

            th {
                display: none;
            }

            tr {
                margin-bottom: 20px;
                box-shadow: 0px 2px 6px rgba(0, 0, 0, 0.1);
                border-radius: 10px;
            }

            td {
                position: relative;
                padding-left: 50%;
                text-align: right;
                background-color: rgba(255, 255, 255, 0.8);
                border-bottom: 1px solid #ddd;
            }

            td:before {
                content: attr(data-label);
                position: absolute;
                left: 0;
                width: 45%;
                padding-left: 15px;
                text-align: left;
                font-weight: bold;
                text-transform: uppercase;
            }

            tr:hover {
                background-color: rgba(255, 255, 255, 0.8);
            }
        }

        @media (max-width: 480px) {
            td {
                font-size: 0.9em;
            }
        }
    </style>
</head>
<body>

<div class="container">
    <h1>Filtration Calculation Data</h1>
    <div class="table-container">
        <table id="myTable">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Customer ID</th>
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
                </tr>
            </thead>
            <tbody>
            <%
                // JDBC code to fetch data from Filtration_calculation table
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
                    String query = "SELECT * FROM Filtration_calculation";
                    rs = stmt.executeQuery(query);

                    // Loop through the result set and display the data
                    while (rs.next()) {
                        int id = rs.getInt("id");
                        String customerId = rs.getString("customer_id");
                        String waterType = rs.getString("water_type");
                        double microplasticsCollected = rs.getDouble("microplastics_collected");
                        double totalDissolvedSolidsRatio = rs.getDouble("total_dissolved_solids_ratio");
                        double microplasticsPerVolumeSample = rs.getDouble("microplastics_per_volume_sample");
                        double totalMicroplasticsInSample = rs.getDouble("total_microplastics_in_sample");
                        double filterEfficiency = rs.getDouble("filter_efficiency");
                        double effectiveFiltrationRate = rs.getDouble("effective_filtration_rate");
                        double contaminantRemovalEfficiency = rs.getDouble("contaminant_removal_efficiency");
                        double totalWaterMass = rs.getDouble("total_water_mass");
                        double weightAfterRemoval = rs.getDouble("weight_of_water_after_removal");

                        %>
                        <tr>
                            <td data-label="ID"><%= id %></td>
                            <td data-label="Customer ID"><%= customerId %></td>
                            <td data-label="Water Type"><%= waterType %></td>
                            <td data-label="Microplastics Collected"><%= microplasticsCollected %></td>
                            <td data-label="Total Dissolved Solids Ratio"><%= totalDissolvedSolidsRatio %></td>
                            <td data-label="Microplastics Per Volume Sample"><%= microplasticsPerVolumeSample %></td>
                            <td data-label="Total Microplastics in Sample"><%= totalMicroplasticsInSample %></td>
                            <td data-label="Filter Efficiency"><%= filterEfficiency %></td>
                            <td data-label="Effective Filtration Rate"><%= effectiveFiltrationRate %></td>
                            <td data-label="Contaminant Removal Efficiency"><%= contaminantRemovalEfficiency %></td>
                            <td data-label="Total Water Mass"><%= totalWaterMass %></td>
                            <td data-label="Weight of Water After Removal"><%= weightAfterRemoval %></td>
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
</div>

<!-- Back button -->
<a href="module4_enrichment_home_page.html" class="back-button">Back</a>

</body>
</html>
