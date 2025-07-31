<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Water Filtration Data</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.5.13/jspdf.plugin.autotable.min.js"></script>
    <style>
        /* Your existing CSS styles */
        html, body {
            height: 100%;
            margin: 0;
            padding: 0;
        }
        body {
            background: linear-gradient(45deg, #49a09d, #5f2c82);
            font-family: sans-serif;
            font-weight: 100;
        }
        .container {
            width: 90%;
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            box-sizing: border-box;
            position: relative;
            min-height: 100vh;
        }
        .heading {
            text-align: center;
            font-size: 2rem;
            font-weight: bold;
            color: #ffffff;
            text-transform: uppercase;
            margin-bottom: 20px;
        }
        .table-container {
            width: 100%;
            overflow-x: auto;
            margin-bottom: 20px;
        }
        table {
            width: 100%;
            min-width: 1200px;
            border-collapse: collapse;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            table-layout: auto;
        }
        th, td {
            padding: 15px;
            background-color: rgba(255, 255, 255, 0.2);
            color: #fff;
            text-align: left;
            border: 1px solid #fff;
            word-wrap: break-word;
        }
        thead th {
            background-color: #55608f;
        }
        tbody tr:hover {
            background-color: rgba(255, 255, 255, 0.3);
        }
        .button-container {
            text-align: center;
            margin-top: 20px;
        }
        .back-button, .approve-button, .pdf-button {
            background-color: #55608f;
            color: #fff;
            border: none;
            padding: 10px 20px;
            font-size: 1rem;
            cursor: pointer;
            border-radius: 5px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            margin: 5px; /* Add some space between buttons */
        }
        .approve-button:disabled {
            background-color: #808080;
            cursor: not-allowed;
        }
        .pdf-button:hover {
            background-color: #4a4a6c;
        }
        .back-button {
            position: absolute;
            right: 20px;
            bottom: 20px;
        }
    </style>
</head>
<body>

<div class="container">
    <h1 class="heading">Water Filtration Data</h1>
    <div class="table-container">
        <table id="data-table">
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
                    // Database connection parameters
                    String jdbcURL = "jdbc:mysql://localhost:3306/water_filteration"; // Update with your database name
                    String dbUser = "root"; // Update with your database username
                    String dbPassword = "root"; // Update with your database password

                    Connection conn = null;
                    Statement stmt = null;
                    ResultSet rs = null;

                    try {
                        Class.forName("com.mysql.jdbc.Driver"); // Load MySQL JDBC Driver
                        conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
                        stmt = conn.createStatement();
                        String sql = "SELECT * FROM filtration_calculation";
                        rs = stmt.executeQuery(sql);

                        while (rs.next()) {
                            out.println("<tr>");
                            out.println("<td>" + rs.getInt("id") + "</td>");
                            out.println("<td>" + rs.getString("customer_id") + "</td>");
                            out.println("<td>" + rs.getString("water_type") + "</td>");
                            out.println("<td>" + rs.getDouble("microplastics_collected") + "</td>");
                            out.println("<td>" + rs.getDouble("total_dissolved_solids_ratio") + "</td>");
                            out.println("<td>" + rs.getDouble("microplastics_per_volume_sample") + "</td>");
                            out.println("<td>" + rs.getDouble("total_microplastics_in_sample") + "</td>");
                            out.println("<td>" + rs.getDouble("filter_efficiency") + "</td>");
                            out.println("<td>" + rs.getDouble("effective_filtration_rate") + "</td>");
                            out.println("<td>" + rs.getDouble("contaminant_removal_efficiency") + "</td>");
                            out.println("<td>" + rs.getDouble("total_water_mass") + "</td>");
                            out.println("<td>" + rs.getDouble("weight_of_water_after_removal") + "</td>");
                            out.println("</tr>");
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        // Close all resources
                        try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                        try { if (stmt != null) stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                        try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                    }
                %>
            </tbody>
        </table>
    </div>

    <div class="button-container">
        <button class="pdf-button" onclick="generatePDF()">Download PDF</button>
        <button class="approve-button" id="approveButton" onclick="approve()">Approve</button>
    </div>
    
    <button class="back-button" onclick="window.location.href='adminhomepage.html'">Back</button> <!-- Replace with your actual page -->

</div>

<script>
    function generatePDF() {
        const { jsPDF } = window.jspdf;
        const doc = new jsPDF({
            orientation: 'landscape',
            unit: 'pt',
            format: 'a4'
        });

        doc.autoTable({
            html: '#data-table',
            theme: 'striped',
            headStyles: {
                fillColor: [85, 96, 143],
                fontSize: 10,
                halign: 'center'
            },
            bodyStyles: {
                fontSize: 8,
                halign: 'center',
                valign: 'middle',
                lineColor: [0, 0, 0],
                lineWidth: 0.1,
                overflow: 'linebreak',
                cellWidth: 'auto'
            },
            margin: { top: 30 },
            startY: 50,
        });

        doc.save('filtration_data.pdf');
    }

    function approve() {
        const approveButton = document.getElementById('approveButton');
        approveButton.innerText = "Approved";
        approveButton.disabled = true;
    }
</script>

</body>
</html>
