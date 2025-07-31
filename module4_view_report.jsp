 <%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Enrichment Calculation Results</title>
    <style>
        body {
            background-image: url('water.jpg'); /* Set the path to your background image */
            background-size: cover;
            background-repeat: no-repeat;
            font-family: Arial, sans-serif;
            color: #333;
            padding: 20px;
            position: relative;
            min-height: 100vh;
            box-sizing: border-box;
        }

        h1 {
            text-align: center;
            color: #fff;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.7);
        }

        .table-container {
            max-height: 400px;
            overflow-y: auto;
            margin: 20px 0;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background-color: rgba(255, 255, 255, 0.9);
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        th {
            background: linear-gradient(90deg, #007bff, #00c6ff);
            color: #fff;
            padding: 12px;
            font-weight: bold;
            text-align: left;
        }

        td {
            padding: 12px;
            text-align: left;
        }

        tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        tr:nth-child(odd) {
            background-color: #ffffff;
        }

        tr:hover {
            background-color: #ddd;
        }

        .back-button {
            position: fixed;
            bottom: 20px;
            right: 20px;
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            font-size: 16px;
            transition: background-color 0.3s;
        }

        .back-button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <h1>Enrichment Calculation Results</h1>

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
                </tr>
            </thead>
            <tbody>
                <%
                    // Database connection details
                    String DB_URL = "jdbc:mysql://localhost:3306/water_filteration";
                    String DB_USER = "root";
                    String DB_PASSWORD = "root";

                    // SQL query to fetch data from enrichment_calculation
                    String query = "SELECT * FROM enrichment_calculation";

                    try {
                        // Establishing a connection
                        Class.forName("com.mysql.jdbc.Driver");
                        Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                        Statement statement = connection.createStatement();
                        ResultSet resultSet = statement.executeQuery(query);

                        // Loop through the result set and populate the table
                        while (resultSet.next()) {
                            String employeeId = resultSet.getString("employee_id");
                            String waterBody = resultSet.getString("water_body");
                            String remainingCalcium = resultSet.getString("remaining_calcium");
                            String remainingMagnesium = resultSet.getString("remaining_magnesium");
                            String remainingSodium = resultSet.getString("remaining_sodium");
                            String remainingPotassium = resultSet.getString("remaining_potassium");
                            String remainingChloride = resultSet.getString("remaining_chloride");
                            String remainingSulfate = resultSet.getString("remaining_sulfate");
                            String remainingNitrate = resultSet.getString("remaining_nitrate");
                            String remainingBicarbonate = resultSet.getString("remaining_bicarbonate");
                            String remainingIron = resultSet.getString("remaining_iron");
                            String remainingTds = resultSet.getString("remaining_tds");
                            String microplasticsPostFiltration = resultSet.getString("microplastics_post_filtration");
                            String totalWaterMass = resultSet.getString("total_water_mass");
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
                    <td><%= remainingTds %></td>
                    <td><%= microplasticsPostFiltration %></td>
                    <td><%= totalWaterMass %></td>
                </tr>
                <%
                        }
                        // Closing the resources
                        resultSet.close();
                        statement.close();
                        connection.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                %>
                <tr>
                    <td colspan="14">Error fetching data: <%= e.getMessage() %></td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>

    <a href="module3_filterationhomepage.html" class="back-button">Back</a>
</body>
</html>
 