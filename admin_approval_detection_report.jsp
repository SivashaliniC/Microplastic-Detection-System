<%@ page import="java.sql.*, java.io.*, javax.servlet.*, javax.servlet.http.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detection Calculation Data</title>
    <!-- Include jsPDF and autoTable plugin -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.5.13/jspdf.plugin.autotable.min.js"></script>
    <style>
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

        /* Add a scrollable container */
        .table-container {
            width: 100%;
            overflow-x: auto;
            margin-bottom: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            overflow: hidden;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            min-width: 1000px; /* Ensure table is wide enough for scrolling */
        }

        th, td {
            padding: 15px;
            background-color: rgba(255, 255, 255, 0.2);
            color: #fff;
            text-align: left;
            border: 1px solid #fff;
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
        }

        .back-button {
            position: fixed;
            bottom: 20px;
            right: 120px;
        }

        .approve-button, .pdf-button:hover {
            background-color: #4a4a6c;
        }

        .approve-button:disabled {
            background-color: #4a4a6c;
            cursor: not-allowed;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="heading">Calculated Values</div>

        <!-- Scrollable container for table -->
        <div class="table-container">
            <table id="data-table">
                <thead>
                    <tr>
                        <th>Client ID</th>
                        <th>Property</th>
                        <th>Volume (km³)</th>
                        <th>Density (kg/m³)</th>
                        <th>Salinity (PSU)</th>
                        <th>Dissolved Oxygen (mg/L)</th>
                        <th>Major Minerals</th>
                        <th>Total Dissolved Solids (mg/L)</th>
                        <th>Microplastic Concentration</th>
                        <th>Calculated Microplastics (g)</th>
                        <th>Total Water Mass (kg)</th>
                        <th>Percentage Microplastics in Total Water Mass</th>
                    </tr>
                </thead>
                <tbody>
                    <%
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
                            String query = "SELECT client_id, property, volume_km3, density_kg_m3, salinity_psu, dissolved_oxygen_mg_l, major_minerals, total_dissolved_solids_mg_l, microplastic_concentration, calculated_microplastics_g, total_water_mass_kg, percentage_microplastics_in_total_water_mass FROM detectioncalculation";
                            rs = stmt.executeQuery(query);

                            while (rs.next()) {
                                String clientId = rs.getString("client_id");
                                String property = rs.getString("property");
                                String volume = rs.getString("volume_km3");
                                String density = rs.getString("density_kg_m3");
                                String salinity = rs.getString("salinity_psu");
                                String oxygen = rs.getString("dissolved_oxygen_mg_l");
                                String minerals = rs.getString("major_minerals");
                                String dissolvedSolids = rs.getString("total_dissolved_solids_mg_l");
                                String microConcentration = rs.getString("microplastic_concentration");
                                String microPlastics = rs.getString("calculated_microplastics_g");
                                String totalWaterMass = rs.getString("total_water_mass_kg");
                                String percentageMicroPlastics = rs.getString("percentage_microplastics_in_total_water_mass");

                                out.println("<tr>");
                                out.println("<td>" + clientId + "</td>");
                                out.println("<td>" + property + "</td>");
                                out.println("<td>" + volume + "</td>");
                                out.println("<td>" + density + "</td>");
                                out.println("<td>" + salinity + "</td>");
                                out.println("<td>" + oxygen + "</td>");
                                out.println("<td>" + minerals + "</td>");
                                out.println("<td>" + dissolvedSolids + "</td>");
                                out.println("<td>" + microConcentration + "</td>");
                                out.println("<td>" + microPlastics + "</td>");
                                out.println("<td>" + totalWaterMass + "</td>");
                                out.println("<td>" + percentageMicroPlastics + "</td>");
                                out.println("</tr>");
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

        <div class="button-container">
            <button class="pdf-button" onclick="generatePDF()">Download PDF</button>
            <br>
            <br>

            <!-- Approve button -->
            <button type="button" id="approveButton" class="approve-button" onclick="approve()">Approve</button>

            <a href="adminhomepage.html" class="back-button">Back</a>
        </div>
    </div>

    <script>
    function generatePDF() {
        const { jsPDF } = window.jspdf;
        const doc = new jsPDF();

        // AutoTable plugin handles table formatting
        doc.autoTable({
            html: '#data-table',
            theme: 'grid',
            styles: {
                fontSize: 8,
                halign: 'center', 
                valign: 'middle'
            },
            headStyles: {
                fillColor: [85, 96, 143]
            },
            bodyStyles: {
                fillColor: [255, 255, 255],
                textColor: [0, 0, 0]
            }
        });

        doc.save('detection_calculation_data.pdf');
    }

    function approve() {
        // Change button text to "Approved"
        const approveButton = document.getElementById("approveButton");
        approveButton.textContent = "Approved";
        approveButton.disabled = true;  // Disable the button
    }
    </script>
</body>
</html>
