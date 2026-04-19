# HMS Plus: Advanced Hotel Management System — Comprehensive Project Report

**Academic Course:** CSE 204: Database Systems  
**Project Group:** 17  
**Project Title:** HMS Plus — AI-Integrated Rentogram  
**Academic Year:** Spring 2026

---

## 1. Project Overview & Objectives
HMS Plus is a production-grade accommodation platform developed to demonstrate advanced relational database concepts. The system serves three distinct user roles:
- **Guests:** Searching for properties, booking stays, managing family guests, and leaving AI-verified reviews.
- **Hosts:** Managing property listings and tracking incoming reservations.
- **Admins:** Overseeing system-wide analytics, users, and automated moderation logs.

**Key Goals:**
- Demonstrate transition from **UNF to 3NF**.
- Implement a **Persistent AI Moderation** system.
- Build an **Interactive SQL Reporting** engine with complex Views.

---

## 2. Unnormalized Form (UNF) Analysis
The project originated from a single flat dataset containing **49 primary attributes**. This structure suffered from severe data redundancy and update anomalies.

**Example UNF Row:**
| User_ID | User_Name | Property_Title | Amenities | Photo_URLs | Booking_Dates | Payment_Status | Review_Comment |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 102 | Mehmet Misafir | Luxury Villa | WiFi, Pool | img1.png, img2.png | 2026-05-01..05-05 | Paid | Amazing stay! |

---

## 3. The 3NF Normalization Journey
The schema was normalized through rigorous phases to ensure zero redundancy and data integrity.

### 3.1 1NF (Atomic Values & Unique Identifiers)
- Eliminated multi-valued attributes (`Amenities`, `Photos`) into separate tables.
- Assigned Atomic IDs for all entities.

### 3.2 2NF (Functional Dependencies)
- Removed partial dependencies. We split user-specific data (IDs, Emails) from property-specific data (Title, Price).

### 3.3 3NF (Transitive Dependency Removal)
- Isolated entities that were transitively dependent on `Booking_ID`. For example, `Payment_Status` and `Review_Comment` were moved to their own specialized tables (`Payments`, `Reviews`).

---

## 4. Final Relational Schema (3NF)
The final database consists of **11 normalized tables** and **75 unique attributes**.

### 4.1 Table List & Attribute Counts
| Table Name | Attributes | Description |
| :--- | :---: | :--- |
| **Properties** | 16 | Primary listing data (Title, Location, Price). |
| **Bookings** | 9 | Transactional links between Guests and Properties. |
| **Reviews** | 9 | AI-Enhanced ratings and commentary persistence. |
| **Users** | 8 | Unified identity management (Guest/Host/Admin). |
| **Payments** | 7 | Record of financial transactions. |
| **Installments** | 6 | Ledger for recurring/split payments. |
| **BookingGuests** | 5 | Secondary travelers tracking (Family Info). |
| **UserCards** | 5 | Masked storage of payment methods. |
| **PropertyPhotos** | 5 | Multi-image management (URLs, Sort Order). |
| **Amenities** | 3 | Master list of features (WiFi, Pool, etc.). |
| **PropertyAmenities** | 2 | Many-to-Many relationship connector. |

---

## 5. Advanced SQL Logic & Reporting
The system features an **Interactive SQL Dashboard** powered by complex views. This environment counts over **111 concurrent data points** when view columns are included.

### Academic Highlights:
- **`HMS_PropertyAnalytics`**: Implements 4-table JOIN with `GROUP BY` and `AVG` calculations.
- **`HMS_SuccessfulHosts`**: Demonstrates the use of **Subqueries in the WHERE clause** to filter hosts based on earnings.
- **`HMS_MonthlyGuestTracker`**: A time-series analysis using `MONTH()` and `DATE_FORMAT()` functions.

---

## 6. Real-World AI Integration
Unlike standard database projects, HMS Plus implements **Persistence in AI-Driven Moderation**:
1.  **Sentiment Tiering:** A 3-class distribution (Positive / Neutral / Negative) using a calibrated 0.90 threshold.
2.  **Toxicity Shield:** Automated rejection of reviews containing offensive language using `toxic-bert`.
3.  **Persistence Layer:** AI results are not recalculated on the fly; they are stored in the `Reviews` table's `ai_sentiment` and `ai_status` columns, reducing compute load.

---

## 7. User Interface & Localization
- **Design:** Modern "Rentogram-style" interface using Vanilla CSS and glassmorphism.
- **Localization:** 100% English interface for both code and data (titles, reviews, and amenities).
- **Responsiveness:** Dynamic Chart.js visualizations built into the admin panel.

---

## 8. Conclusion
The HMS Plus project represents a successful merger of **Relational Theory** and **Modern Web Engineering**. By moving from a 49-attribute UNF to a 75-attribute 3NF structure, we ensured a robust, scalable, and anomaly-free system that serves as a high-quality showcase for Database Systems coursework.

---
**Team Group 17**  
*Spring 2026*
