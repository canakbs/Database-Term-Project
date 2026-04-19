# HMS Plus — Rentogram Clone | Database Systems Group Project

> A full-stack accommodation management system inspired by Rentogram, developed with Python Flask + MySQL.

---

## 🚀 Features

- **Role-Based Access Control:** Guest, Host, and Admin panels.
- **Full Booking Workflow:** Listing → Booking → Payment → Review.
- **Smart Calendar:** Overlapping date prevention and collision checking using Flatpickr.
- **Dynamic Pricing:** Automatic total price recalculation when dates are updated.
- **AI-Powered Reviews:** Sentiment analysis (DistilBERT) and toxicity detection (Toxic-BERT) to filter comments.
- **Admin Panel:** Management of users, listings, bookings, and interactive SQL analytics reports.

---

## 🗄️ Database Architecture

The project strictly follows the **UNF → 1NF → 2NF → 3NF** normalization process.

**10 Tables:** `Users`, `Properties`, `Amenities`, `PropertyAmenities`, `PropertyPhotos`, `Bookings`, `Payments`, `Reviews`, `UserCards`, `BookingGuests`.

📄 Detailed normalization report: [`docs/HMS_Normalization_Report.md`](docs/HMS_Normalization_Report.md)

---

## ⚙️ Installation & Setup

### 1. Prerequisites
```bash
pip install flask mysql-connector-python werkzeug python-dotenv transformers torch tensorflow deep-translator
```

### 2. Environment Variables
Copy `.env.example` to `.env` and fill in your local credentials:
```bash
cp .env.example .env
```
```env
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=rentogram_clone
SECRET_KEY=your_secret_key
```

### 3. Database Setup (Choose ONE option)

#### Option A: Quick Restore (Recommended for Teammates)
This will set up the exact same database state including all translated reviews and properties.
1. Create the database in MySQL: `CREATE DATABASE rentogram_clone;`
2. Import the final dump:
```bash
mysql -u root -p rentogram_clone < database/final_dump.sql
```

#### Option B: Clean Install
1. Create the database and tables:
```bash
mysql -u root -p < database/setup_rentogram.sql
```
2. Populate data using scripts:
```bash
python scripts/bulk_populate.py
python scripts/translate_reviews.py
python scripts/translate_properties.py
```

### 4. Run the App
```bash
python app.py
```
Visit `http://localhost:5000` in your browser.

---

## 👤 Demo Accounts

All passwords are: **`password123`**

### 🔴 Admin
- **Email:** `admin@example.com`

### 🏠 Hosts
| Name | Email | Portfolio Example |
|------|-------|-------------------|
| Ahmet Host | host@example.com | Luxury Villa, Charming Studio, Modern Loft |
| Can Ozdemir | can@host.com | Bosphorus Mansion, Kas Mediterranean Mansion |

### 🧳 Guests
- **Email:** `guest@example.com`
- **Email:** `selin@example.com`

---

## 📁 Project Structure

```
HotelUI/
├── app.py                    # Main Flask application & routes
├── ai_review.py              # AI Sentiment/Toxicity analysis pipeline
├── database/
│   ├── setup_rentogram.sql      # Schema definition
│   └── final_dump.sql        # Full database dump (data included)
├── docs/
│   ├── Final_Project_Report.md
│   └── HMS_Normalization_Report.md
├── scripts/
│   ├── bulk_populate.py      # Batch data generation
│   └── translate_reviews.py  # AI Analysis & Translation tool
├── static/                   # Styling, images, and brand assets
└── templates/                # Jinja2 HTML views
```

---

## 🛠️ Technology Stack

| Layer | Technology |
|--------|-----------|
| Backend | Python 3.12, Flask |
| Database | MySQL 8.0 |
| AI / ML | Transformers, DistilBERT, Toxic-BERT |
| Frontend | HTML5, Vanilla CSS, JavaScript |
| Components | Flatpickr (Calendar), Chart.js (Analytics) |
| Security | PBKDF2-SHA256 (Hashing) |
