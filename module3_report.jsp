<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Filtration Results</title>
    <style>
        body {
            background-image: url('water.jpg'); /* Set the path to your background image */
            background-size: cover;
            background-repeat: no-repeat;
            font-family: Arial, sans-serif;
            color: #333;
            padding: 20px;
            position: relative; /* Added to position the back button */
            min-height: 100vh; /* Ensure body is at least full height of the viewport */
            box-sizing: border-box; /* Include padding in width calculations */
        }

        h1 {
            text-align: center;
            color: #fff;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.7);
        }

        .table-container {
            max-height: 400px; /* Set a maximum height for the table */
            overflow-y: auto; /* Enable vertical scrolling */
            margin: 20px 0;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background-color: rgba(255, 255, 255, 0.9); /* White background with transparency */
            border-radius: 8px; /* Rounded corners */
            overflow: hidden; /* To ensure rounded corners are visible */
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); /* Shadow effect */
        }

        th {
            background: linear-gradient(90deg, #007bff, #00c6ff); /* Gradient background */
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
            background-color: #f9f9f9; /* Light gray for even rows */
        }

        tr:nth-child(odd) {
            background-color: #ffffff; /* White for odd rows */
        }

        tr:hover {
            background-color: #ddd; /* Change background on hover */
        }

        /* Back button styling */
        .back-button {
            position: fixed; /* Use fixed positioning for the back button */
            bottom: 20px; /* Distance from the bottom */
            right: 20px; /* Distance from the right */
            padding: 10px 20px;
            background-color: #007bff; /* Button color */
            color: white; /* Text color */
            border: none;
            border-radius: 5px; /* Rounded corners */
            cursor: pointer;
            text-decoration: none; /* No underline */
            font-size: 16px; /* Font size */
            transition: background-color 0.3s; /* Transition effect */
        }

        .back-button:hover {
            background-color: #0056b3; /* Darker shade on hover */
        }
    </style>
</head>
<body>
    <h1>Filtration Results</h1>

    <div class="table-container">
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Customer ID</th>
                    <th>Water Type</th>
                    <th>Microplastics Collected</th>
                    <th>Total Dissolved Solids Ratio</th>
                    <th>Microplastics per Volume Sample</th>
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
                    // Database connection details
                    String DB_URL = "jdbc:mysql://localhost:3306/water_filteration"; // Replace with your DB name
                    String DB_USER = "root"; // Replace with your DB username
                    String DB_PASSWORD = "root"; // Replace with your DB password

                    // SQL query to fetch data
                    String query = "SELECT * FROM filtration_calculation";

                    try {
                        // Establishing a connection
                        Class.forName("com.mysql.jdbc.Driver"); // Use 'com.mysql.cj.jdbc.Driver' for MySQL Connector/J 8.0+
                        Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                        Statement statement = connection.createStatement();
                        ResultSet resultSet = statement.executeQuery(query);

                        // Loop through the result set and populate the table
                        while (resultSet.next()) {
                            int id = resultSet.getInt("id");
                            String customerId = resultSet.getString("customer_id");
                            String waterType = resultSet.getString("water_type");
                            String microplasticsCollected = resultSet.getString("microplastics_collected");
                            String totalDissolvedSolidsRatio = resultSet.getString("total_dissolved_solids_ratio");
                            String microplasticsPerVolumeSample = resultSet.getString("microplastics_per_volume_sample");
                            String totalMicroplasticsInSample = resultSet.getString("total_microplastics_in_sample");
                            String filterEfficiency = resultSet.getString("filter_efficiency");
                            String effectiveFiltrationRate = resultSet.getString("effective_filtration_rate");
                            String contaminantRemovalEfficiency = resultSet.getString("contaminant_removal_efficiency");
                            String totalWaterMass = resultSet.getString("total_water_mass");
                            String weightOfWaterAfterRemoval = resultSet.getString("weight_of_water_after_removal");

                %>
                <tr>
                    <td><%= id %></td>
                    <td><%= customerId %></td>
                    <td><%= waterType %></td>
                    <td><%= microplasticsCollected %></td>
                    <td><%= totalDissolvedSolidsRatio %></td>
                    <td><%= microplasticsPerVolumeSample %></td>
                    <td><%= totalMicroplasticsInSample %></td>
                    <td><%= filterEfficiency %></td>
                    <td><%= effectiveFiltrationRate %></td>
                    <td><%= contaminantRemovalEfficiency %></td>
                    <td><%= totalWaterMass %></td>
                    <td><%= weightOfWaterAfterRemoval %></td>
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
                    <td colspan="12">Error fetching data: <%= e.getMessage() %></td>
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
