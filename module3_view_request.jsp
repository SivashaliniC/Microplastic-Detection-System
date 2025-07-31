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
            background-color: #f0f0f0;
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

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
            font-size: 1em;
            background-color: rgba(255, 255, 255, 0.7);
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
    </style>
</head>
<body>

<div class="container">
    <h1>Detection Calculation Data</h1>
    <table id="myTable">
        <thead>
            <tr>
                <th onclick="sortTable(0)">ID</th>
                <th onclick="sortTable(1)">Client ID</th>
                <th onclick="sortTable(2)">Property</th>
                <th onclick="sortTable(3)">Volume (km<sup>3</sup>)</th>
                <th onclick="sortTable(4)">Density (kg/m<sup>3</sup>)</th>
                <th onclick="sortTable(5)">Salinity (PSU)</th>
                <th onclick="sortTable(6)">Dissolved Oxygen (mg/L)</th>
                <th onclick="sortTable(7)">Major Minerals</th>
                <th onclick="sortTable(8)">Total Dissolved Solids (mg/L)</th>
                <th onclick="sortTable(9)">Sample Volume (L)</th>
                <th onclick="sortTable(10)">Microplastic Concentration</th>
                <th onclick="sortTable(11)">Calculated Microplastics (g)</th>
                <th onclick="sortTable(12)">Total Water Mass (kg)</th>
                <th onclick="sortTable(13)">% Microplastics in Water Mass</th>
                <th onclick="sortTable(14)">Total Dissolved Solids Content (mg)</th>
                <th onclick="sortTable(15)">Collection Method</th>
            </tr>
        </thead>
        <tbody>
            <%
                // JDBC Connection
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
                    String query = "SELECT * FROM detectioncalculation";
                    rs = stmt.executeQuery(query);

                    while (rs.next()) {
            %>
            <tr>
                <td data-label="ID"><%= rs.getInt("id") %></td>
                <td data-label="Client ID"><%= rs.getString("client_id") %></td>
                <td data-label="Property"><%= rs.getString("property") %></td>
                <td data-label="Volume (km3)"><%= rs.getString("volume_km3") %></td>
                <td data-label="Density (kg/m3)"><%= rs.getString("density_kg_m3") %></td>
                <td data-label="Salinity (PSU)"><%= rs.getString("salinity_psu") %></td>
                <td data-label="Dissolved Oxygen (mg/L)"><%= rs.getString("dissolved_oxygen_mg_l") %></td>
                <td data-label="Major Minerals"><%= rs.getString("major_minerals") %></td>
                <td data-label="Total Dissolved Solids (mg/L)"><%= rs.getString("total_dissolved_solids_mg_l") %></td>
                <td data-label="Sample Volume (L)"><%= rs.getString("sample_volume_l") %></td>
                <td data-label="Microplastic Concentration"><%= rs.getString("microplastic_concentration") %></td>
                <td data-label="Calculated Microplastics (g)"><%= rs.getString("calculated_microplastics_g") %></td>
                <td data-label="Total Water Mass (kg)"><%= rs.getString("total_water_mass_kg") %></td>
                <td data-label="% Microplastics in Water Mass"><%= rs.getString("percentage_microplastics_in_total_water_mass") %></td>
                <td data-label="Total Dissolved Solids Content (mg)"><%= rs.getString("total_dissolved_solids_content_mg") %></td>
                <td data-label="Collection Method"><%= rs.getString("collection_method") %></td>
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

<script>
    function sortTable(n) {
        var table, rows, switching, i, x, y, shouldSwitch, dir, switchcount = 0;
        table = document.getElementById("myTable");
        switching = true;
        dir = "asc"; 
        while (switching) {
            switching = false;
            rows = table.rows;
            for (i = 1; i < (rows.length - 1); i++) {
                shouldSwitch = false;
                x = rows[i].getElementsByTagName("TD")[n];
                y = rows[i + 1].getElementsByTagName("TD")[n];
                if (dir == "asc") {
                    if (x.innerHTML.toLowerCase() > y.innerHTML.toLowerCase()) {
                        shouldSwitch = true;
                        break;
                    }
                } else if (dir == "desc") {
                    if (x.innerHTML.toLowerCase() < y.innerHTML.toLowerCase()) {
                        shouldSwitch = true;
                        break;
                    }
                }
            }
            if (shouldSwitch) {
                rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
                switching = true;
                switchcount++;
            } else {
                if (switchcount == 0 && dir == "asc") {
                    dir = "desc";
                    switching = true;
                }
            }
        }
    }
</script>

</body>
</html>
