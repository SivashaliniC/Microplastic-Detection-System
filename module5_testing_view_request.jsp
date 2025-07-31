<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Enrichment Calculation Data</title>
    <style>
       body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            background-image: url('fil.jpg'); /* Path to your background image */
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            background-repeat: no-repeat;
        }

        .container {
            width: 90%;
            margin: 50px auto;
            background-color: rgba(255, 255, 255, 0.8); /* Slightly transparent container */
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0px 6px 18px rgba(0, 0, 0, 0.1);
        }

        h1 {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
        }

        /* Scrollable container for table */
        .table-container {
            max-height: 400px; /* Adjust this height as needed */
            overflow-y: auto;
            border: 1px solid #ccc;
            background-color: rgba(255, 255, 255, 0.7);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 1em;
        }

        th, td {
            padding: 14px 18px;
            text-align: left;
        }

        th {
            background: linear-gradient(135deg, rgba(111, 159, 255, 0.8), rgba(76, 175, 80, 0.8));
            color: white;
            text-transform: uppercase;
            position: sticky;
            top: 0; /* Keep headers sticky */
            z-index: 1;
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

        /* Mobile adjustments */
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
        }

        @media (max-width: 480px) {
            td {
                font-size: 0.9em;
            }
        }

        .back-button-container {
            position: fixed;
            bottom: 20px;
            right: 20px;
        }

        .back-button {
            background-color: #4CAF50; /* Green background */
            color: white; /* White text */
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 5px;
            font-size: 1em;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            transition: background-color 0.3s ease, box-shadow 0.3s ease;
        }

        .back-button:hover {
            background-color: #45a049; /* Darker green on hover */
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.2);
        }

    </style>
</head>
<body>

<div class="container">
    <h1>Enrichment Calculation Data</h1>

    <div class="table-container">
        <table>
            <thead>
                <tr>
                    <th>Employee ID</th>
                    <th>Water Body</th>
                    <th>Remaining Calcium (mg/L)</th>
                    <th>Remaining Magnesium (mg/L)</th>
                    <th>Remaining Sodium (mg/L)</th>
                    <th>Remaining Potassium (mg/L)</th>
                    <th>Remaining Chloride (mg/L)</th>
                    <th>Remaining Sulfate (mg/L)</th>
                    <th>Remaining Nitrate (mg/L)</th>
                    <th>Remaining Bicarbonate (mg/L)</th>
                    <th>Remaining Iron (mg/L)</th>
                    <th>Remaining TDS (mg/L)</th>
                    <th>Microplastics Post Filtration</th>
                    <th>Total Water Mass (tons)</th>
                </tr>
            </thead>
            <tbody>
                <%
                    // Database connection details
                    String url = "jdbc:mysql://localhost:3306/water_filteration"; // Change to your DB details
                    String username = "root"; // Update with your DB username
                    String password = "root"; // Update with your DB password

                    Connection conn = null;
                    Statement stmt = null;
                    ResultSet rs = null;

                    try {
                        // Load and register JDBC driver
                        Class.forName("com.mysql.jdbc.Driver");
                        // Establish a connection
                        conn = DriverManager.getConnection(url, username, password);
                        // Create SQL query to retrieve data
                        String query = "SELECT * FROM enrichment_calculation";
                        // Create statement
                        stmt = conn.createStatement();
                        // Execute the query and get the result set
                        rs = stmt.executeQuery(query);

                        // Loop through the result set and display the data in the table
                        while (rs.next()) {
                            String employeeId = rs.getString("employee_id");
                            String waterBody = rs.getString("water_body");
                            double remainingCalcium = rs.getDouble("remaining_calcium");
                            double remainingMagnesium = rs.getDouble("remaining_magnesium");
                            double remainingSodium = rs.getDouble("remaining_sodium");
                            double remainingPotassium = rs.getDouble("remaining_potassium");
                            double remainingChloride = rs.getDouble("remaining_chloride");
                            double remainingSulfate = rs.getDouble("remaining_sulfate");
                            double remainingNitrate = rs.getDouble("remaining_nitrate");
                            double remainingBicarbonate = rs.getDouble("remaining_bicarbonate");
                            double remainingIron = rs.getDouble("remaining_iron");
                            double remainingTDS = rs.getDouble("remaining_tds");
                            double microplasticsPostFiltration = rs.getDouble("microplastics_post_filtration");
                            double totalWaterMass = rs.getDouble("total_water_mass");

                            // Display each row of data
                            %>
                            <tr>
                                <td data-label="Employee ID"><%= employeeId %></td>
                                <td data-label="Water Body"><%= waterBody %></td>
                                <td data-label="Remaining Calcium (mg/L)"><%= remainingCalcium %></td>
                                <td data-label="Remaining Magnesium (mg/L)"><%= remainingMagnesium %></td>
                                <td data-label="Remaining Sodium (mg/L)"><%= remainingSodium %></td>
                                <td data-label="Remaining Potassium (mg/L)"><%= remainingPotassium %></td>
                                <td data-label="Remaining Chloride (mg/L)"><%= remainingChloride %></td>
                                <td data-label="Remaining Sulfate (mg/L)"><%= remainingSulfate %></td>
                                <td data-label="Remaining Nitrate (mg/L)"><%= remainingNitrate %></td>
                                <td data-label="Remaining Bicarbonate (mg/L)"><%= remainingBicarbonate %></td>
                                <td data-label="Remaining Iron (mg/L)"><%= remainingIron %></td>
                                <td data-label="Remaining TDS (mg/L)"><%= remainingTDS %></td>
                                <td data-label="Microplastics Post Filtration"><%= microplasticsPostFiltration %></td>
                                <td data-label="Total Water Mass (tons)"><%= totalWaterMass %></td>
                            </tr>
                            <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        // Close the ResultSet, Statement, and Connection to free resources
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
    </div>
</div>

<!-- Back Button -->
<div class="back-button-container">
    <a href="module5_testing_homepage.html" class="back-button">Back</a>
</div>

</body>
</html>
