import pandas as pd
import openpyxl

# Paths to your files
csv_file = '/home/kaizen/Documents/SOD_EOD/SOD_EOD_System_Monitoring.csv'
excel_file = '/home/kaizen/Documents/SOD_EOD/SystemMonitoring.xlsx'

# Read the CSV file
csv_data  = pd.read_csv(csv_file, encoding='ISO-8859-1')

# Load the Excel file
wb = openpyxl.load_workbook(excel_file)
sheet = wb.active

# Update Excel file with data from CSV
for i, row in csv_data.iterrows():
    # Assuming your Excel has headers and you want to start updating from the second row
    sheet[f'C{i + 2}'] = row['Time']
    sheet[f'D{i + 2}'] = row['Checked by']
    sheet[f'E{i + 2}'] = row['Status (Up/Down)']

# Save the updated Excel file
wb.save(excel_file)

