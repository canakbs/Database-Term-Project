import mysql.connector
import random
from datetime import datetime, timedelta
import os
from dotenv import load_dotenv

load_dotenv()

DB_CONFIG = {
    'host': os.getenv('DB_HOST', 'localhost'),
    'user': os.getenv('DB_USER', 'root'),
    'password': os.getenv('DB_PASSWORD', ''),
    'database': os.getenv('DB_NAME', 'hotel_management')
}

def get_db():
    return mysql.connector.connect(**DB_CONFIG)

def seed():
    db = get_db()
    cur = db.cursor()

    print("Cleaning existing data...")
    cur.execute("SET FOREIGN_KEY_CHECKS = 0")
    tables = ["INSTALLMENTS", "PAYMENTS", "BOOKING_SERVICES", "REVIEWS", "BOOKING_DETAILS", "BOOKINGS", "ROOMS", "PROPERTIES", "GUESTS", "HOSTS", "USERS", "PAYMENT_METHODS"]
    for t in tables:
        cur.execute(f"TRUNCATE TABLE {t}")
    cur.execute("SET FOREIGN_KEY_CHECKS = 1")
    db.commit()

    # --- USERS ---
    print("Seeding Users...")
    names = ["Ahmet", "Mehmet", "Can", "Elif", "Zeynep", "Selin", "Murat", "Arda", "Ece", "Burat", "Asli", "Deniz", "Emre", "Fatma", "Gizem", "Hakan", "Irem", "Jale", "Kaan", "Leyla"]
    surnames = ["Yilmaz", "Kaya", "Demir", "Sahin", "Celik", "Aras", "Yildiz", "Ozturk", "Aydin", "Oz", "Kilic", "Dogan"]
    
    users = []
    for i in range(1, 61):
        fullname = f"{random.choice(names)} {random.choice(surnames)}"
        email = f"user{i}@{random.choice(['mail.com', 'gmail.com', 'outlook.com'])}"
        phone = f"555-{random.randint(1000, 9999)}"
        cur.execute("INSERT INTO USERS (User_ID, Full_Name, Email, Phone) VALUES (%s, %s, %s, %s)", (i, fullname, email, phone))
        users.append(i)

    # --- HOSTS (5 hosts) ---
    print("Seeding Hosts...")
    hosts = users[:5]
    for uid in hosts:
        since = datetime(2023, 1, 1) + timedelta(days=random.randint(0, 365))
        cur.execute("INSERT INTO HOSTS (User_ID, Host_Since) VALUES (%s, %s)", (uid, since.date()))

    # --- GUESTS (Rest 55 guests) ---
    print("Seeding Guests...")
    guests = users[5:]
    guest_ids = []
    for uid in guests:
        nat = random.choice(["Turkish", "German", "English", "French", "Russian"])
        dob = datetime(1980, 1, 1) + timedelta(days=random.randint(0, 10000))
        cur.execute("INSERT INTO GUESTS (User_ID, Nationality, Date_of_Birth) VALUES (%s, %s, %s)", (uid, nat, dob.date()))
        guest_ids.append(cur.lastrowid)

    # --- PROPERTIES (10 properties) ---
    print("Seeding Properties...")
    prop_names = ["Grand Plaza", "Seaside Resort", "City View Hotel", "Mountain Lodge", "Blue Lagoon", "Garden Inn", "Royal Palace", "Sunset Beach", "Skyline Hotel", "Forest Retreat"]
    cities = ["Istanbul", "Antalya", "Izmir", "Ankara", "Bursa", "Mugla"]
    property_ids = []
    for i in range(10):
        cur.execute("INSERT INTO PROPERTIES (Host_ID, Title, City, Address) VALUES (%s, %s, %s, %s)", 
                    (random.choice([1,2,3,4,5]), prop_names[i], random.choice(cities), f"Street No:{random.randint(1,100)}"))
        property_ids.append(cur.lastrowid)

    # --- ROOMS ---
    print("Seeding Rooms...")
    room_types = ["Single", "Double", "Suite", "Family"]
    room_ids = []
    for pid in property_ids:
        for _ in range(3): # 3 rooms per property
            rtype = random.choice(room_types)
            price = random.randint(80, 500)
            cur.execute("INSERT INTO ROOMS (Property_ID, Room_Type, Base_Price) VALUES (%s, %s, %s)", (pid, rtype, price))
            room_ids.append(cur.lastrowid)

    # --- SERVICES ---
    print("Seeding Services...")
    services = [("Breakfast", 20), ("Spa", 50), ("Airport Transfer", 100), ("Room Service", 35), ("Laundry", 25)]
    service_ids = []
    for s_name, s_price in services:
        cur.execute("INSERT INTO SERVICES (Service_Name, Price) VALUES (%s, %s)", (s_name, s_price))
        service_ids.append(cur.lastrowid)

    # --- BOOKINGS (100 bookings) ---
    print("Seeding Bookings...")
    for i in range(100):
        rid = random.choice(room_ids)
        checkin = datetime(2026, 3, 1) + timedelta(days=random.randint(0, 200))
        checkout = checkin + timedelta(days=random.randint(1, 7))
        cur.execute("INSERT INTO BOOKINGS (Room_ID, CheckIn_Date, CheckOut_Date) VALUES (%s, %s, %s)", (rid, checkin, checkout))
        bid = cur.lastrowid
        
        # Details (1 primary guest)
        gid = random.choice(guest_ids)
        cur.execute("INSERT INTO BOOKING_DETAILS (Booking_ID, Guest_ID, Is_Primary) VALUES (%s, %s, %s)", (bid, gid, True))
        
        # Payment Method
        if random.random() > 0.3: # 70% chance to have a payment record
            cur.execute("SELECT Method_ID FROM PAYMENT_METHODS WHERE Guest_ID=%s", (gid,))
            pm = cur.fetchone()
            if not pm:
                cur.execute("INSERT INTO PAYMENT_METHODS (Guest_ID, Card_Type, Card_Last4, Expiry_Date) VALUES (%s, %s, %s, %s)", 
                            (gid, random.choice(['Visa', 'Mastercard']), str(random.randint(1000, 9999)), '2028-01-01'))
                pm_id = cur.lastrowid
            else:
                pm_id = pm[0]
            
            amt = random.randint(100, 2000)
            cur.execute("INSERT INTO PAYMENTS (Booking_ID, Method_ID, Total_Amount, Payment_Date) VALUES (%s, %s, %s, %s)", 
                        (bid, pm_id, amt, checkin.date()))
            pay_id = cur.lastrowid
            
            # Installments (some have 1, some have 3)
            ins_count = random.choice([1, 1, 3])
            for j in range(ins_count):
                cur.execute("INSERT INTO INSTALLMENTS (Payment_ID, Due_Date, Amount, Status) VALUES (%s, %s, %s, %s)", 
                            (pay_id, (checkin + timedelta(days=30*j)).date(), amt/ins_count, 'Pending'))

        # Services
        if random.random() > 0.5:
            cur.execute("INSERT INTO BOOKING_SERVICES (Booking_ID, Service_ID, Quantity) VALUES (%s, %s, %s)", 
                        (bid, random.choice(service_ids), random.randint(1, 2)))

        # Reviews (for past or current bookings)
        if checkin < datetime.now():
            cur.execute("INSERT INTO REVIEWS (Booking_ID, Guest_ID, Rating, Comment) VALUES (%s, %s, %s, %s)", 
                        (bid, gid, random.randint(3, 5), "Good experience!"))

    db.commit()
    print("Database seeding completed!")
    cur.close()
    db.close()

if __name__ == "__main__":
    seed()
