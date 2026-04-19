# HMS Plus: Advanced Hotel Management System — Final Project Report

**Course:** Database Systems Introduction  
**Team:** Group 17  
**Project:** HMS Plus — AI-Powered Rentogram  
**Academic Term:** Spring 2026

---

## 1. Executive Summary
HMS Plus is a comprehensive web-based hotel and property management system designed to simulate the robust functionality of modern platforms like Rentogram. The project emphasizes advanced database design (3NF normalization), complex SQL query logic (JOINs, Views, Subqueries), and front-end excellence. A unique selling point is its **Dual-Model AI Sentiment Pipeline**, which filters and classifies guest reviews in real-time.

---

## 2. Requirements & Expansion Scope
Beyond standard CRUD operations, the project successfully implements the following advanced requirements:
1.  **Normalization Mastery:** Complete transition from a flat 50-attribute UNF dataset to a normalized 3NF schema with 11 core tables.
2.  **AI Integration:** Real-time Toxicity Filtering (Toxic-BERT) and Sentiment Analysis (DistilBERT) with a 3-tier classification (Positive, Neutral, Negative) implementation.
3.  **Complex SQL Logic:** 5+ Academic SQL Views utilizing `GROUP BY`, `HAVING`, `SUBQUERIES`, and multiple `JOIN` operations.
4.  **Financial Systems:** Payment processing with installment logic and secure payment method (card) storage.
5.  **Multi-Guest Tracking:** Management of additional guests (Family/Friends) for a single booking.
6.  **Interactive Analytics:** Real-time data visualization using Chart.js on the administrative dashboard.

---

## 3. Database Architecture (3NF)

The system consists of **11 core tables** and **5 complex views**, totaling over **110 attributes** (including calculated fields in views).

### Core Entity-Relationship (Tables):
1.  **Users:** Stores identity, roles (Guest/Host/Admin), and encrypted credentials.
2.  **Properties:** 26 curated listings with detailed attributes (city, price, max guests).
3.  **Amenities & PropertyAmenities:** Many-to-Many relationship handler for features like WiFi, Pool, and AC.
4.  **PropertyPhotos:** Management of multiple URLs per listing.
5.  **Bookings:** Central transaction log linking guests, properties, and dates.
6.  **Payments:** Financial records with status tracking.
7.  **Installments:** Secondary ledger for split-payment tracking.
8.  **Reviews:** AI-enhanced commentary storage including persistent sentiment scores.
9.  **UserCards:** Secure storage for tokenized/masked payment methods.
10. **BookingGuests:** Normalized tracking of secondary travelers.

---

## 4. AI Sentiment Pipeline
A critical feature of HMS Plus is its automated review moderation system:
- **Toxicity Filter:** Utilizes a `bert-base-multilingual-cased-toxicity` model to reject comments with offensive language (Status: REJECTED).
- **Sentiment Tiering:** A 3-class classification system based on model confidence scoring (Threshold: 0.90).
    - **Positive (Score >= 0.90):** Clear enthusiast feedback.
    - **Neutral (Score < 0.90):** Borderline reviews or mixed feedback (e.g., "Good location but noisy").
    - **Negative (Score >= 0.90 + Negative Label):** Clear complaints.
- **Persistence:** AI results are saved directly to the MySQL database, ensuring reports are generated instantly without re-processing.

---

## 5. Advanced SQL Queries (Academic Views)
The Administrative Reporting page is powered by 5 main SQL Views:

| View Name | Key SQL Concepts Used | Purpose |
| :--- | :--- | :--- |
| `HMS_PropertyAnalytics` | `AVG`, `COUNT`, `GROUP BY`, `LEFT JOIN` | Track average ratings and total stays per property. |
| `HMS_CityStatistics` | `MIN`, `MAX`, `HAVING`, `GROUP BY` | Market analysis across different Turkish cities. |
| `HMS_SuccessfulHosts` | `Subqueries in WHERE`, `SUM` | Identification of top-earning hosts. |
| `HMS_MonthlyGuestTracker` | `DATE_FORMAT`, `JOIN (3-way)` | Monthly breakdown of guest traffic. |
| `HMS_DetailedReservations` | Multiple `JOIN`, `CASE` logic | Full audit trail of all platform bookings. |

---

## 6. System Implementation Details
- **Backend:** Python + Flask with a focus on Role-Based Access Control (RBAC).
- **Frontend:** Vanilla CSS for a premium "Glassmorphism" design, fully translated into English for international presentation quality.
- **Responsiveness:** Dynamic Chart.js containers that adapt to various high-resolution displays without overflow.
- **Database:** Local MySQL Server with a provided `final_dump.sql` for easy reproduction.

---

## 7. Conclusion
HMS Plus proves that a standard university database project can reach production-level quality by combining rigorous relational theory with modern engineering practices. The inclusion of AI-driven data persistence and interactive reporting provides a level of depth that goes well beyond traditional 3NF normalization requirements.

---
**Prepared by Group 17**  
*Spring 2026 Graduation Project Phase*
