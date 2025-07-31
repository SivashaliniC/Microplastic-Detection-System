<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.Statement, java.sql.ResultSet, java.sql.SQLException" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fixed Table Header</title>
    <style>
        h1 {
            font-size: 30px;
            color: #fff;
            text-transform: uppercase;
            font-weight: 300;
            text-align: center;
            margin-bottom: 15px;
        }
        table {
            width: 100%;
            table-layout: fixed;
        }
        .tbl-header {
            background-color: rgba(255, 255, 255, 0.3);
        }
        .tbl-content {
            height: 300px;
            overflow-x: auto;
            margin-top: 0px;
            border: 1px solid rgba(255, 255, 255, 0.3);
        }
        th {
            padding: 20px 15px;
            text-align: left;
            font-weight: 500;
            font-size: 12px;
            color: #fff;
            text-transform: uppercase;
        }
        td {
            padding: 15px;
            text-align: left;
            vertical-align: middle;
            font-weight: 300;
            font-size: 12px;
            color: #fff;
            border-bottom: solid 1px rgba(255, 255, 255, 0.1);
        }
        /* demo styles */
        @import url('https://fonts.googleapis.com/css?family=Roboto:400,500,300,700');
        body {
            background: linear-gradient(to right, #25c481, #25b7c4);
            font-family: 'Roboto', sans-serif;
        }
        section {
            margin: 50px;
        }
        /* follow me template */
        .made-with-love {
            margin-top: 40px;
            padding: 10px;
            clear: left;
            text-align: center;
            font-size: 10px;
            font-family: Arial, sans-serif;
            color: #fff;
        }
        .made-with-love i {
            font-style: normal;
            color: #F50057;
            font-size: 14px;
            position: relative;
            top: 2px;
        }
        .made-with-love a {
            color: #fff;
            text-decoration: none;
        }
        .made-with-love a:hover {
            text-decoration: underline;
        }
        /* for custom scrollbar for webkit browser */
        ::-webkit-scrollbar {
            width: 6px;
        }
        ::-webkit-scrollbar-track {
            -webkit-box-shadow: inset 0 0 6px rgba(0, 0, 0, 0.3);
        }
        ::-webkit-scrollbar-thumb {
            -webkit-box-shadow: inset 0 0 6px rgba(0, 0, 0, 0.3);
        }
    </style>
</head>
<body>
    <section>
        <!-- For demo wrap -->
        <h1>Fixed Table Header</h1>
        <div class="tbl-header">
            <table cellpadding="0" cellspacing="0" border="0">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Client ID</th>
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
                        <th>Collection Method</th>
                    </tr>
                </thead>
            </table>
        </div>
        <div class="tbl-content">
            <table cellpadding="0" cellspacing="0" border="0">
                <tbody>
                    <%
                        // JDBC setup
                        String url = "jdbc:mysql://localhost:3306/yourdatabase";
                        String user = "yourusername";
                        String password = "yourpassword";
                        Connection conn = null;
                        Statement stmt = null;
                        ResultSet rs = null;

                        try {
                            // Load JDBC driver
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            conn = DriverManager.getConnection(url, user, password);
                            stmt = conn.createStatement();
                            String query = "SELECT * FROM detectioncalculation";
                            rs = stmt.executeQuery(query);

                            while (rs.next()) {
                    %>
                    <tr>
                        <td><%= rs.getInt("id") %></td>
                        <td><%= rs.getString("client_id") %></td>
                        <td><%= rs.getString("property") %></td>
                        <td><%= rs.getString("volume_km3") %></td>
                        <td><%= rs.getString("density_kg_m3") %></td>
                        <td><%= rs.getString("salinity_psu") %></td>
                        <td><%= rs.getString("dissolved_oxygen_mg_l") %></td>
                        <td><%= rs.getString("major_minerals") %></td>
                        <td><%= rs.getString("total_dissolved_solids_mg_l") %></td>
                        <td><%= rs.getString("sample_volume_l") %></td>
                        <td><%= rs.getString("microplastic_concentration") %></td>
                        <td><%= rs.getString("calculated_microplastics_g") %></td>
                        <td><%= rs.getString("total_water_mass_kg") %></td>
                        <td><%= rs.getString("percentage_microplastics_in_total_water_mass") %></td>
                        <td><%= rs.getString("total_dissolved_solids_content_mg") %></td>
                        <td><%= rs.getString("collection_method") %></td>
                    </tr>
                    <%
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        } finally {
                            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                            if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                        }
                    %>
                </tbody>
            </table>
        </div>
    </section>
</body>
</html>
 