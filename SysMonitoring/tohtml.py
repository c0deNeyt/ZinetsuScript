import pandas as pd
import sys

# Paths to files
csv_file = '/media/sf_Linux/SOD_EOD/SOD_EOD_System_Monitoring.csv'

# Read the CSV file
df = pd.read_csv(csv_file, encoding='ISO-8859-1')

#Command line argument into a variable
sys_date = sys.argv[1]
overall_status = sys.argv[2]

#HTML Template
htmlHead = """<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>System Monitoring Report</title>
</head>

<body style="margin:0; padding:0; background-color:#f4f6f8; font-family: Arial, Helvetica, sans-serif;">

<!-- ===== WRAPPER TABLE (FULL WIDTH) ===== -->
<table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:#f4f6f8;">
  <tr>
    <td align="center" style="padding:20px 10px;">

      <!-- ===== MAIN EMAIL CONTAINER ===== -->
      <table width="600" cellpadding="0" cellspacing="0" border="0" style="width:100%; max-width:600px; background-color:#ffffff; border-radius:6px; overflow:hidden;">

        <!-- ===== HEADER ===== -->
        <tr>
          <td style="background-color:#2f80ed; color:#ffffff; padding:20px; text-align:center; font-size:20px; font-weight:bold;">
            System Monitoring Report
          </td>
        </tr>

        <!-- ===== GREETING SECTION ===== -->
        <tr>
          <td style="padding:20px; color:#333333; font-size:14px; line-height:1.5;">
            <p style="margin:0;">Hello Team,</p>
            <p style="margin:10px 0;">
              The system monitoring report for <strong>{}</strong> is now available.
            </p>
            <p style="margin:0;">
              Overall Status:
              <span style="color:#2f80ed; font-weight:bold;">{}</span>
            </p>
          </td>
        </tr>

        <!-- ===== TABLE SECTION ===== -->
        <tr>
          <td style="padding:0 20px 20px 20px;">
            <table width="100%" cellpadding="0" cellspacing="0" border="0" style="border-collapse:collapse; font-size:13px;">
              
              <!-- TABLE HEADER -->
              <tr>
                <th style="padding:10px; border:1px solid #dddddd; background-color:#f0f4f8; text-align:left;">Segment</th>
                <th style="padding:10px; border:1px solid #dddddd; text-align:left;">Details</th>
                <th style="padding:10px; border:1px solid #dddddd; text-align:left;">Time</th>
                <th style="padding:10px; border:1px solid #dddddd; text-align:left;">Checked By</th>
                <th style="padding:10px; border:1px solid #dddddd; text-align:left;">Status</th>
              </tr>

""".format(sys_date, overall_status)
htmlTableEnd = """
            </table>
          </td>
        </tr>
"""
htmlNote = """
        <!-- ===== NOTE ===== -->
        <tr>
          <td style="padding:0 20px 20px 20px; font-size:12px; color:#666666;">
            <strong style="color:#cc0000;">Note:</strong>
            This is an automated email. For inquiries, contact
            <a href="mailto:enterprise.server@pds.com.ph" style="color:#2f80ed;">
              enterprise.server@pds.com.ph
            </a>.
          </td>
        </tr>
"""
htmlFooter = """
        <!-- ===== FOOTER ===== -->
        <tr>
          <td style="background-color:#f0f4f8; padding:15px; text-align:center; font-size:12px; color:#888888;">
            Regards,<br>
            ESG Team<br><br>
            © 2026 Your Company. All rights reserved.
          </td>
        </tr>

      </table>
      <!-- END MAIN CONTAINER -->

    </td>
  </tr>
</table>
<!-- END WRAPPER -->

</body>
</html>
<head>
"""
# Combine the variables and insert data
html_content = htmlHead 
for i, row in df.iterrows():
    if i >= 57 and i <= 71:
        html_content += "              <tr>\n" 
        for item in row:
            status = row.iloc[4]
            # Issue Found
            if status != "UP" and item == status:
                html_content += f'                <td style="padding:8px; border:1px solid #dddddd; background-color:#e6f4ea; color:#c62828; font-weight:bold;">{item}</td>\n'
            # No Issue 
            elif item == status:
                html_content += f'                <td style="padding:8px; border:1px solid #dddddd; background-color:#e6f4ea; color:#2e7d32; font-weight:bold;">{item}</td>\n'
            # Default items
            else: 
                html_content += f'                <td style="padding:8px; border:1px solid #dddddd;">{item}</td>\n'
        html_content += "              </tr>\n\n" 
html_content += htmlTableEnd 
html_content += htmlNote
html_content += htmlFooter 

# Save the HTML table to a file
with open('/media/sf_Linux/SOD_EOD/ebody.html', 'w', encoding='ISO-8859-1') as file:
    file.write(html_content)
