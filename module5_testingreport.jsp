<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Testing Results</title>
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

        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
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

        /* Colorful data */
        td:nth-child(5) { background-color: #ffcccc; } /* Microplastics Concentration */
        td:nth-child(6) { background-color: #ccffcc; } /* Organic Substances */
        td:nth-child(7) { background-color: #ffffcc; } /* Global Warming Impact */
        td:nth-child(8) { background-color: #ccccff; } /* Chemical Contaminants */
        td:nth-child(9) { background-color: #ffccff; } /* pH Level */
        td:nth-child(10) { background-color: #ffedcc; } /* Temperature */
        td:nth-child(11) { background-color: #d0e6f0; } /* Dissolved Oxygen */
        td:nth-child(12) { background-color: #ffe6cc; } /* Other Factors */
        td:nth-child(13) { background-color: #dff0d8; } /* Water Purity */

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
    <h1>Testing Results</h1>

    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Employee ID</th>
                <th>Test ID</th>
                <th>Water Body</th>
                <th>Microplastics Concentration</th>
                <th>Organic Substances</th>
                <th>Global Warming Impact</th>
                <th>Chemical Contaminants</th>
                <th>pH Level</th>
                <th>Temperature</th>
                <th>Dissolved Oxygen</th>
                <th>Other Factors</th>
                <th>Water Purity</th>
            </tr>
        </thead>
        <tbody>
            <%
                // Database connection details
                String DB_URL = "jdbc:mysql://localhost:3306/water_filteration"; // Replace with your DB name
                String DB_USER = "root"; // Replace with your DB username
                String DB_PASSWORD = "root"; // Replace with your DB password

                // SQL query to fetch data
                String query = "SELECT * FROM testing_result";

                try {
                    // Establishing a connection
                    Class.forName("com.mysql.jdbc.Driver");
                    Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                    Statement statement = connection.createStatement();
                    ResultSet resultSet = statement.executeQuery(query);

                    // Loop through the result set and populate the table
                    while (resultSet.next()) {
                        int id = resultSet.getInt("id");
                        String employeeId = resultSet.getString("employeeId");
                        String testId = resultSet.getString("testId");
                        String waterBody = resultSet.getString("waterBody");
                        String microplasticsConcentration = resultSet.getString("microplasticsConcentration");
                        String organicSubstances = resultSet.getString("organicSubstances");
                        String globalWarmingImpact = resultSet.getString("globalWarmingImpact");
                        String chemicalContaminants = resultSet.getString("chemicalContaminants");
                        String pHLevel = resultSet.getString("pHLevel");
                        String temperature = resultSet.getString("temperature");
                        String dissolvedOxygen = resultSet.getString("dissolvedOxygen");
                        String otherFactors = resultSet.getString("otherFactors");
                        String waterPurity = resultSet.getString("waterPurity");

            %>
            <tr>
                <td><%= id %></td>
                <td><%= employeeId %></td>
                <td><%= testId %></td>
                <td><%= waterBody %></td>
                <td><%= microplasticsConcentration %></td>
                <td><%= organicSubstances %></td>
                <td><%= globalWarmingImpact %></td>
                <td><%= chemicalContaminants %></td>
                <td><%= pHLevel %></td>
                <td><%= temperature %></td>
                <td><%= dissolvedOxygen %></td>
                <td><%= otherFactors %></td>
                <td><%= waterPurity %></td>
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
                <td colspan="13">Error fetching data: <%= e.getMessage() %></td>
            </tr>
            <%
                }
            %>
        </tbody>
    </table>

    <a href="module5_testing_homepage.html" class="back-button">Back</a>
</body>
</html>
