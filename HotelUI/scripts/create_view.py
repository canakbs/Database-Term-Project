import mysql.connector
import os
from dotenv import load_dotenv

load_dotenv()

DB_CONFIG = {
    'host': os.getenv('DB_HOST', 'localhost'),
    'user': os.getenv('DB_USER', 'root'),
    'password': os.getenv('DB_PASSWORD', ''),
    'database': os.getenv('DB_NAME', 'hotel_management')
}

def create_view():
    db = mysql.connector.connect(**DB_CONFIG)
    cur = db.cursor()
    
    ddl = """
    CREATE OR REPLACE VIEW confirmationUsingJoins AS 
    SELECT 
        g.Guest_ID, ug.Full_Name AS Guest_Name, ug.Email AS Guest_Email,
        h.Host_ID, uh.Full_Name AS Host_Name, h.Host_Since,
        p.Property_ID, p.Title, p.City,
        r.Room_ID, r.Room_Type, r.Base_Price,
        b.Booking_ID, b.CheckIn_Date, b.CheckOut_Date, b.Status,
        bd.Is_Primary,
        pm.Method_ID, pm.Card_Type, pm.Card_Last4,
        pay.Payment_ID, pay.Total_Amount, pay.Payment_Date,
        ins.Installment_ID, ins.Due_Date, ins.Amount, ins.Status AS Inst_Status,
        s.Service_ID, s.Service_Name, bs.Quantity,
        rev.Review_ID, rev.Rating, rev.Comment
    FROM GUESTS g
    JOIN USERS ug ON ug.User_ID = g.User_ID
    JOIN BOOKING_DETAILS bd ON bd.Guest_ID = g.Guest_ID
    JOIN BOOKINGS b ON b.Booking_ID = bd.Booking_ID
    JOIN ROOMS r ON r.Room_ID = b.Room_ID
    JOIN PROPERTIES p ON p.Property_ID = r.Property_ID
    JOIN HOSTS h ON h.Host_ID = p.Host_ID
    JOIN USERS uh ON uh.User_ID = h.User_ID
    LEFT JOIN PAYMENT_METHODS pm ON pm.Guest_ID = g.Guest_ID
    LEFT JOIN PAYMENTS pay ON pay.Booking_ID = b.Booking_ID
    LEFT JOIN INSTALLMENTS ins ON ins.Payment_ID = pay.Payment_ID
    LEFT JOIN BOOKING_SERVICES bs ON bs.Booking_ID = b.Booking_ID
    LEFT JOIN SERVICES s ON s.Service_ID = bs.Service_ID
    LEFT JOIN REVIEWS rev ON rev.Booking_ID = b.Booking_ID AND rev.Guest_ID = g.Guest_ID;
    """
    
    cur.execute(ddl)
    db.commit()
    print("View confirmationUsingJoins created successfully.")
    cur.close()
    db.close()

if __name__ == "__main__":
    create_view()
