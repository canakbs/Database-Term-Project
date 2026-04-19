# CSE 204 Spring 2026 - Database Systems Final Project Report
**Group 17: Hotel Management System (HMS) - Rentogram**

## 1. Project Overview
This project is a high-end web application (Rentogram) built using Python/Flask and MySQL. It facilitates property management for hosts and seamless booking experiences for guests, featuring a robust role-based access control system and advanced financial reporting.

---

## 2. Unnormalized Form (UNF)
The project began with a flat dataset containing **49 distinct attributes**, capturing every detail of a typical rental transaction.

**Attributes List:**
`User_ID`, `User_Full_Name`, `User_Email`, `User_Phone`, `User_Role`, `User_Status`, `User_Created_At`, `User_Nationality`, `User_BirthDate`, `Property_ID`, `Property_Title`, `Property_Description`, `Property_Type`, `Room_Type`, `Property_City`, `Property_District`, `Property_Address`, `Property_Base_Price`, `Property_Max_Guests`, `Property_Rating_Avg`, `Property_Created_At`, `Host_ID`, `Host_Since`, `Photo_URL`, `Photo_Is_Primary`, `Amenity_Name`, `Amenity_Icon`, `Booking_ID`, `Booking_CheckIn`, `Booking_CheckOut`, `Booking_Guest_Count`, `Booking_Total_Price`, `Booking_Status`, `Payment_ID`, `Payment_Amount`, `Payment_Method`, `Payment_Status`, `Transaction_Ref`, `Card_Holder`, `Card_Number_Masked`, `Card_Expiry`, etc.

---

## 3. Database Normalization (UNF to 3NF)
The schema was normalized through three distinct phases to ensure data integrity and zero redundancy.

### Phase 1: 1NF (Atomic Values)
- Multi-valued attributes like `Amenities` and `Photos` were extracted into separate child tables.
- Unique identifiers were assigned to every entity.

### Phase 2: 2NF (Functional Dependency)
- Removed partial dependencies. Attributes related purely to Users were moved to a `Users` table, while Property-specific data was moved to `Properties`. 

### Phase 3: 3NF (Transitive Dependency Removal)
- Removed transitive dependencies such as card information linked to bookings. 
- **Final 3NF Schema (9+ Tables):**
  1. `Users` (Superclass for Host/Guest)
  2. `Properties`
  3. `PropertyPhotos`
  4. `Amenities` & `PropertyAmenities` (M:N handler)
  5. `Bookings`
  6. `BookingGuests` (Added for Family Info requirement)
  7. `Payments`
  8. `Installments` (Added for Financial requirement)
  9. `Reviews`
  10. `UserCards`

---

## 4. Normalization SQL Journey (ALTER/DROP)
As part of the academic requirement, the following transformation SQL was documented:
- `ALTER TABLE Properties DROP COLUMN host_full_name;`
- `ALTER TABLE Bookings DROP COLUMN card_number_used;`
- `ALTER TABLE Bookings DROP COLUMN secondary_guest_name;` (Transitioned to `BookingGuests`)

*Reference: `/database/normalization_journey.sql`*

---

## 5. Advanced SQL Analytics (Academic Views)
The system implements complex SQL queries via Views to satisfy advanced database requirements:

1.  **HMS_PropertyAnalytics**: Utilizes `AVG()`, `COUNT()`, and `GROUP BY` to track property performance.
2.  **HMS_CityStatistics**: Uses `HAVING` and `MIN/MAX` for city-based market analysis.
3.  **HMS_SuccessfulHosts**: Implements `Subqueries in WHERE` to identify top-performing hosts.
4.  **HMS_MonthlyGuestTracker**: Real-world monthly guest reporting using `MONTH()` and `JOIN` logic.
5.  **HMS_PropertyBookingSummary**: Comparative host performance tracking.

---

## 6. Functional Capabilities
The user interface supports the following expanded features:
1.  **Multiple Guests Support**: Guests can add family/friend information to a single booking.
2.  **Installment Management**: Payments are split into installments in the backend.
3.  **Dynamic Booking Management**: Guests can change dates for pending/confirmed bookings and perform cancellations.
4.  **Admin Reporting Dashboard**: A specialized UI for viewing all SQL Views in real-time.
5.  **Payment Method Storage**: Users can save/delete credit cards securely.

---

## 7. Conclusion
The HMS project successfully demonstrates the transition from a complex unnormalized dataset to a highly efficient 3NF relational database. It meets all the customer's expansion requirements (taksitli ödeme, aile bilgisi, aylık takip) while maintaining a premium user experience.

---
**Team Group 17**
Spring 2026
