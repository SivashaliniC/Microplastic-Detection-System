<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Water Properties</title>
    <style>
        /* Set background image */
        body {
            background-image: url('detec.jpg'); /* Replace with your actual image path */
            background-size: cover;
            background-repeat: no-repeat;
            background-attachment: fixed;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            color: #333; /* Default text color */
        }

        /* Centered and capitalized title */
        h2 {
            text-align: center;
            font-size: 30px;
            text-transform: uppercase; /* Make the text capital letters */
            margin-top: 20px;
            color: #fff; /* White color for the title */
            text-shadow: 2px 2px 5px rgba(0, 0, 0, 0.7); /* Add shadow to the title for a cool effect */
        }

        /* Style for the table */
        table {
            width: 90%;
            margin: 20px auto; /* Center the table */
            border-collapse: collapse;
            background-color: rgba(255, 255, 255, 0.9); /* Add a white background with transparency */
            box-shadow: 0px 4px 15px rgba(0, 0, 0, 0.2); /* Add some box shadow for a raised effect */
            border-radius: 8px; /* Add rounded corners to the table */
            overflow: hidden; /* Prevent overflow for rounded corners */
        }

        table, th, td {
            border: 1px solid #ccc; /* Light gray borders */
        }

        th, td {
            padding: 15px; /* Increase padding for better readability */
            text-align: center;
            font-size: 16px; /* Font size for better readability */
        }

        th {
            background-color: #007BFF; /* Bootstrap primary color */
            color: #fff; /* White text for header */
            font-weight: bold;
            text-transform: uppercase; /* Make header text uppercase */
        }

        tr:nth-child(even) {
            background-color: #f2f2f2; /* Light gray for even rows */
        }

        tr:hover {
            background-color: #d1e7dd; /* Light green for hover effect */
            transition: background-color 0.3s; /* Smooth transition for hover effect */
        }

        /* Style for the back button */
        .back-button {
            position: fixed;
            bottom: 20px;
            right: 20px;
            background-color: #4CAF50; /* Green background */
            color: white;
            padding: 12px 20px;
            text-decoration: none;
            border-radius: 5px;
            font-size: 18px; /* Slightly larger font */
            box-shadow: 2px 2px 8px rgba(0, 0, 0, 0.3);
            transition: background-color 0.3s, transform 0.3s; /* Transition for hover effect */
        }

        .back-button:hover {
            background-color: #45a049; /* Darker green on hover */
            transform: translateY(-2px); /* Slight lift on hover */
        }
    </style>
</head>
<body>

<h2 style="color: white;">Water Properties Data</h2>

<table>
    <tr>
        <th>Client ID</th>
        <th>Property</th>
        <th>Volume (km<sup>3</sup>)</th>
        <th>Density (kg/m<sup>3</sup>)</th>
        <th>Salinity (PSU)</th>
        <th>Dissolved Oxygen (mg/L)</th>
        <th>Major Minerals</th>
        <th>Total Dissolved Solids (mg/L)</th>
        <th>Calculate</th> <!-- New column for the Calculate button -->
    </tr>

    <%
        // JDBC connection details
        String url = "jdbc:mysql://localhost:3306/water_filteration";
        String username = "root";
        String password = "root";

        Connection connection = null;
        Statement statement = null;
        ResultSet resultSet = null;

        try {
            Class.forName("com.mysql.jdbc.Driver"); // Updated Driver name for MySQL Connector
            connection = DriverManager.getConnection(url, username, password);
            statement = connection.createStatement();

            String query = "SELECT * FROM WaterProperties";
            resultSet = statement.executeQuery(query);

            // Display the data in the table
            while (resultSet.next()) {
                String clientId = resultSet.getString("client_id");
                String property = resultSet.getString("Property");
                String volume = resultSet.getString("Volume_km3");
                String density = resultSet.getString("Density_kg_per_m3");
                String salinity = resultSet.getString("Salinity_PSU");
                String dissolvedOxygen = resultSet.getString("Dissolved_Oxygen_mg_per_L");
                String majorMinerals = resultSet.getString("Major_Minerals");
                String totalDissolvedSolids = resultSet.getString("Total_Dissolved_Solids_mg_per_L");

                %>
                <tr>
                    <td><%= clientId %></td>
                    <td><%= property %></td>
                    <td><%= volume %></td>
                    <td><%= density %></td>
                    <td><%= salinity %></td>
                    <td><%= dissolvedOxygen %></td>
                    <td><%= majorMinerals %></td>
                    <td><%= totalDissolvedSolids %></td>
                    <td>
                        <!-- Form for Calculate button to send row data to another page -->
                        <form action="Calculate.jsp" method="POST">
                            <input type="hidden" name="clientId" value="<%= clientId %>">
                            <input type="hidden" name="property" value="<%= property %>">
                            <input type="hidden" name="volume" value="<%= volume %>">
                            <input type="hidden" name="density" value="<%= density %>">
                            <input type="hidden" name="salinity" value="<%= salinity %>">
                            <input type="hidden" name="dissolvedOxygen" value="<%= dissolvedOxygen %>">
                            <input type="hidden" name="majorMinerals" value="<%= majorMinerals %>">
                            <input type="hidden" name="totalDissolvedSolids" value="<%= totalDissolvedSolids %>">
                            <input type="submit" value="Calculate" style="background-color: #007BFF; color: white; border: none; padding: 8px 12px; border-radius: 4px; cursor: pointer; transition: background-color 0.3s;">
                        </form>
                    </td>
                </tr>
                <%
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (resultSet != null) try { resultSet.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (statement != null) try { statement.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (connection != null) try { connection.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    %>

</table>

<!-- Back button -->
<a href="Detectionhomepage.html" class="back-button">Back</a>

</body>
</html>
