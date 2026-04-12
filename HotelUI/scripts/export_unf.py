import mysql.connector
import csv
import os
from dotenv import load_dotenv

load_dotenv()

DB_CONFIG = {
    'host': os.getenv('DB_HOST', 'localhost'),
    'user': os.getenv('DB_USER', 'root'),
    'password': os.getenv('DB_PASSWORD', ''),
    'database': os.getenv('DB_NAME', 'hotel_management')
}

def export_unf():
    db = mysql.connector.connect(**DB_CONFIG)
    cur = db.cursor()
    
    # UNF verisini Görünümden (View) çekiyoruz
    cur.execute("SELECT * FROM confirmationUsingJoins")
    
    output_path = '../Assignment/Hotel_UNF_Data_Expanded.csv'
    
    with open(output_path, 'w', newline='', encoding='utf-8') as f:
        writer = csv.writer(f)
        writer.writerow([i[0] for i in cur.description]) # Header
        writer.writerows(cur.fetchall()) # Data
        
    print(f"Expanded UNF data exported to {output_path}")
    cur.close()
    db.close()

if __name__ == "__main__":
    export_unf()
