from flask import Flask, render_template, request, redirect, url_for, flash, session
import mysql.connector
from mysql.connector import Error
import os
from dotenv import load_dotenv
from functools import wraps
from werkzeug.security import check_password_hash
from datetime import datetime
import random

import random
from ai_review import process_review

# Setup
load_dotenv()
app = Flask(__name__)
app.secret_key = os.getenv('SECRET_KEY', 'airbnb_clone_secret_key')

# In-memory store for AI review sentiment and toxicity
# Maps booking_id -> AI analysis dict
app.config['review_sentiments'] = {}

DB_CONFIG = {
    'host': os.getenv('DB_HOST', 'localhost'),
    'user': os.getenv('DB_USER', 'root'),
    'password': os.getenv('DB_PASSWORD', ''),
    'database': os.getenv('DB_NAME', 'airbnb_clone'), # Switched to new DB
    'charset': 'utf8mb4',
    'collation': 'utf8mb4_general_ci',
    'use_unicode': True,
    'use_pure': True
}

def get_db():
    return mysql.connector.connect(**DB_CONFIG)

# ─── MIDDLEWARE ───
def login_required(role=None):
    def decorator(f):
        @wraps(f)
        def decorated_function(*args, **kwargs):
            if 'user_id' not in session:
                return redirect(url_for('login'))
            # Admin can access everything
            if session['role'] == 'admin':
                return f(*args, **kwargs)
            # Check specific role
            if role and session['role'] != role:
                flash(f'You need {role} permission to access this area.', 'error')
                return redirect(url_for('index'))
            return f(*args, **kwargs)
        return decorated_function
    return decorator

# ─── ROUTES ───

@app.route('/')
def index():
    q = request.args.get('q', '')
    city = request.args.get('city', '')
    
    db = get_db()
    cur = db.cursor(dictionary=True)
    
    query = """
        SELECT p.*, 
               (SELECT image_url FROM PropertyPhotos WHERE property_id = p.property_id AND is_primary = 1 LIMIT 1) as primary_image,
               (SELECT AVG(rating) FROM Reviews WHERE property_id = p.property_id) as avg_rating
        FROM Properties p
        WHERE p.status = 'active'
    """
    params = []
    if q:
        query += " AND (p.title LIKE %s OR p.description LIKE %s OR p.city LIKE %s OR p.district LIKE %s)"
        params.extend([f'%{q}%', f'%{q}%', f'%{q}%', f'%{q}%'])
    if city:
        query += " AND p.city = %s"
        params.append(city)
        
    cur.execute(query, params)
    properties = cur.fetchall()
    
    # Get cities for filter
    cur.execute("SELECT DISTINCT city FROM Properties WHERE status = 'active'")
    cities = [row['city'] for row in cur.fetchall()]
    
    cur.close()
    db.close()
    return render_template('index.html', properties=properties, cities=cities, search_query=q)

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form.get('email')
        password = request.form.get('password')
        
        db = get_db()
        cur = db.cursor(dictionary=True)
        cur.execute("SELECT * FROM Users WHERE email = %s", (email,))
        user = cur.fetchone()
        cur.close()
        db.close()
        
        if user and check_password_hash(user['password_hash'], password):
            session['user_id'] = user['user_id']
            session['user_name'] = user['full_name']
            session['role'] = user['role']
            flash(f'Welcome back, {user["full_name"]}!', 'success')
            return redirect(url_for('index'))
        else:
            flash('Invalid email or password.', 'error')
            
    return render_template('login.html')

@app.route('/logout')
def logout():
    session.clear()
    flash('You have successfully logged out.', 'success')
    return redirect(url_for('index'))

@app.route('/dashboard')
@login_required()
def dashboard():
    # Simplified dashboard for demo
    db = get_db()
    cur = db.cursor(dictionary=True)
    
    stats = {}
    if session['role'] == 'host':
        cur.execute("SELECT COUNT(*) as c FROM Properties WHERE host_id = %s", (session['user_id'],))
        stats['properties_count'] = cur.fetchone()['c']
        cur.execute("""
            SELECT COUNT(*) as c FROM Bookings b
            JOIN Properties p ON b.property_id = p.property_id
            WHERE p.host_id = %s
        """, (session['user_id'],))
        stats['reservations_count'] = cur.fetchone()['c']
        cur.execute("""
            SELECT SUM(pay.amount) as earnings FROM Payments pay
            JOIN Bookings b ON pay.booking_id = b.booking_id
            JOIN Properties p ON b.property_id = p.property_id
            WHERE p.host_id = %s AND pay.payment_status = 'completed'
        """, (session['user_id'],))
        stats['total_earnings'] = cur.fetchone()['earnings'] or 0
    else:
        cur.execute("SELECT COUNT(*) as c FROM Bookings WHERE guest_id = %s", (session['user_id'],))
        stats['my_bookings_count'] = cur.fetchone()['c']

    cur.close()
    db.close()
    return render_template('dashboard.html', stats=stats)

# ─── ADMIN ROUTES ───

@app.route('/admin/dashboard')
@login_required(role='admin')
def admin_dashboard():
    db = get_db()
    cur = db.cursor(dictionary=True)
    
    # General Stats
    cur.execute("SELECT COUNT(*) as c FROM Users")
    total_users = cur.fetchone()['c']
    
    cur.execute("SELECT COUNT(*) as c FROM Properties")
    total_properties = cur.fetchone()['c']
    
    cur.execute("SELECT COUNT(*) as c FROM Bookings")
    total_bookings = cur.fetchone()['c']
    
    cur.execute("SELECT SUM(total_price) as total FROM Bookings WHERE status = 'completed'")
    total_revenue = cur.fetchone()['total'] or 0
    
    # Recent Bookings
    cur.execute("""
        SELECT b.*, p.title, u.full_name as guest_name 
        FROM Bookings b
        JOIN Properties p ON b.property_id = p.property_id
        JOIN Users u ON b.guest_id = u.user_id
        ORDER BY b.created_at DESC LIMIT 5
    """)
    recent_bookings = cur.fetchall()
    
    cur.close()
    db.close()
    return render_template('admin_dashboard.html', stats={
        'total_users': total_users,
        'total_properties': total_properties,
        'total_bookings': total_bookings,
        'total_revenue': total_revenue
    }, recent_bookings=recent_bookings)

@app.route('/admin/users')
@login_required(role='admin')
def admin_users():
    db = get_db()
    cur = db.cursor(dictionary=True)
    cur.execute("SELECT * FROM Users ORDER BY created_at DESC")
    users = cur.fetchall()
    cur.close()
    db.close()
    return render_template('admin_users.html', users=users)

@app.route('/admin/update-user/<int:id>', methods=['POST'])
@login_required(role='admin')
def admin_update_user(id):
    role = request.form.get('role')
    status = request.form.get('status')
    
    db = get_db()
    cur = db.cursor()
    cur.execute("UPDATE Users SET role = %s, account_status = %s WHERE user_id = %s", (role, status, id))
    db.commit()
    cur.close()
    db.close()
    flash('User information updated.', 'success')
    return redirect(url_for('admin_users'))

@app.route('/admin/delete-user/<int:id>', methods=['POST'])
@login_required(role='admin')
def admin_delete_user(id):
    db = get_db()
    cur = db.cursor()
    # Prevent admin from deleting themselves
    if id == session['user_id']:
        flash('You cannot delete your own account!', 'error')
    else:
        cur.execute("DELETE FROM Users WHERE user_id = %s", (id,))
        db.commit()
        flash('User successfully deleted.', 'success')
    cur.close()
    db.close()
    return redirect(url_for('admin_users'))

@app.route('/admin/properties')
@login_required(role='admin')
def admin_properties():
    db = get_db()
    cur = db.cursor(dictionary=True)
    cur.execute("""
        SELECT p.*, u.full_name as host_name 
        FROM Properties p
        JOIN Users u ON p.host_id = u.user_id
        ORDER BY p.property_id DESC
    """)
    properties = cur.fetchall()
    cur.close()
    db.close()
    return render_template('admin_properties.html', properties=properties)

@app.route('/admin/amenities', methods=['GET', 'POST'])
@login_required(role='admin')
def admin_amenities():
    db = get_db()
    cur = db.cursor(dictionary=True)
    
    if request.method == 'POST':
        name = request.form.get('name')
        icon = request.form.get('icon')
        cur.execute("INSERT INTO Amenities (name, icon) VALUES (%s, %s)", (name, icon))
        db.commit()
        flash('New amenity added.', 'success')
        
    cur.execute("SELECT * FROM Amenities ORDER BY name")
    amenities = cur.fetchall()
    cur.close()
    db.close()
    return render_template('admin_amenities.html', amenities=amenities)

@app.route('/admin/delete-amenity/<int:id>', methods=['POST'])
@login_required(role='admin')
def delete_amenity(id):
    db = get_db()
    cur = db.cursor()
    cur.execute("DELETE FROM Amenities WHERE amenity_id = %s", (id,))
    db.commit()
    cur.close()
    db.close()
    flash('Amenity deleted.', 'success')
    return redirect(url_for('admin_amenities'))

@app.route('/admin/update-property/<int:id>', methods=['POST'])
@login_required(role='admin')
def admin_update_property(id):
    status = request.form.get('status')
    
    db = get_db()
    cur = db.cursor()
    cur.execute("UPDATE Properties SET status = %s WHERE property_id = %s", (status, id))
    db.commit()
    cur.close()
    db.close()
    flash('Property status updated.', 'success')
    return redirect(url_for('admin_properties'))

@app.route('/admin/delete-property/<int:id>', methods=['POST'])
@login_required(role='admin')
def admin_delete_property(id):
    db = get_db()
    cur = db.cursor()
    cur.execute("DELETE FROM Properties WHERE property_id = %s", (id,))
    db.commit()
    cur.close()
    db.close()
    flash('Property permanently deleted.', 'success')
    return redirect(url_for('admin_properties'))

@app.route('/admin/reports')
@login_required(role='admin')
def admin_reports():
    db = get_db()
    cur = db.cursor(dictionary=True)
    
    # Executing the Academic Views
    cur.execute("SELECT * FROM HMS_PropertyAnalytics LIMIT 10")
    analytics = cur.fetchall()
    
    cur.execute("SELECT * FROM HMS_CityStatistics")
    cities = cur.fetchall()
    
    cur.execute("SELECT * FROM HMS_SuccessfulHosts")
    hosts = cur.fetchall()
    
    # Requirement: Property/Host Booking Summary
    cur.execute("SELECT * FROM HMS_PropertyBookingSummary")
    booking_summary = cur.fetchall()
    
    # Requirement: Monthly Guest Tracking
    month = request.args.get('month')
    if month:
        cur.execute("SELECT * FROM HMS_MonthlyGuestTracker WHERE stay_month = %s", (month,))
    else:
        cur.execute("SELECT * FROM HMS_MonthlyGuestTracker LIMIT 20")
    guest_tracker = cur.fetchall()
    
    # Read AI sentiment directly from DB (persistent)
    cur.execute("""
        SELECT r.review_id, r.rating, r.comment, r.ai_sentiment, r.ai_status, r.created_at,
               u.full_name as guest_name, p.title as property_title
        FROM Reviews r
        JOIN Bookings b ON r.booking_id = b.booking_id
        JOIN Users u ON b.guest_id = u.user_id
        JOIN Properties p ON b.property_id = p.property_id
        ORDER BY r.created_at DESC
        LIMIT 50
    """)
    all_reviews = cur.fetchall()

    # Chart data: sentiment distribution (3-class: POSITIVE / NEUTRAL / NEGATIVE)
    sentiment_counts = {'POSITIVE': 0, 'NEUTRAL': 0, 'NEGATIVE': 0, 'NOT_ANALYZED': 0}
    rating_dist = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0}
    for rev in all_reviews:
        s = rev.get('ai_sentiment') or 'NOT_ANALYZED'
        sentiment_counts[s] = sentiment_counts.get(s, 0) + 1
        r = rev.get('rating')
        if r and 1 <= int(r) <= 5:
            rating_dist[int(r)] += 1

    # Chart data: monthly revenue (last 6 months)
    cur.execute("""
        SELECT DATE_FORMAT(payment_date, '%Y-%m') as month,
               SUM(amount) as revenue
        FROM Payments
        WHERE payment_status = 'completed'
          AND payment_date >= DATE_SUB(NOW(), INTERVAL 6 MONTH)
        GROUP BY month ORDER BY month
    """)
    monthly_revenue = cur.fetchall()

    # Chart data: bookings by city
    cur.execute("""
        SELECT p.city, COUNT(b.booking_id) as total
        FROM Bookings b
        JOIN Properties p ON b.property_id = p.property_id
        GROUP BY p.city ORDER BY total DESC LIMIT 8
    """)
    city_bookings = cur.fetchall()

    cur.close()
    db.close()
    return render_template('admin_reports.html',
        analytics=analytics,
        cities=cities,
        hosts=hosts,
        booking_summary=booking_summary,
        guest_tracker=guest_tracker,
        ai_reviews=all_reviews,
        sentiment_counts=sentiment_counts,
        rating_dist=rating_dist,
        monthly_revenue=monthly_revenue,
        city_bookings=city_bookings
    )
@app.route('/property/<int:id>')
def property_detail(id):
    db = get_db()
    cur = db.cursor(dictionary=True)
    
    # Property main info
    cur.execute("""
        SELECT p.*, u.full_name as host_name,
               (SELECT AVG(rating) FROM Reviews WHERE property_id = p.property_id) as avg_rating
        FROM Properties p 
        JOIN Users u ON p.host_id = u.user_id 
        WHERE p.property_id = %s
    """, (id,))
    prop = cur.fetchone()
    
    if not prop:
        flash('Property not found.', 'error')
        return redirect(url_for('index'))
    
    # Photos
    cur.execute("SELECT * FROM PropertyPhotos WHERE property_id = %s ORDER BY sort_order", (id,))
    photos = cur.fetchall()
    
    # Amenities
    cur.execute("""
        SELECT a.* FROM Amenities a
        JOIN PropertyAmenities pa ON a.amenity_id = pa.amenity_id
        WHERE pa.property_id = %s
    """, (id,))
    amenities = cur.fetchall()
    
    # Reviews
    cur.execute("""
        SELECT r.*, u.full_name as guest_name 
        FROM Reviews r 
        JOIN Users u ON r.guest_id = u.user_id 
        WHERE r.property_id = %s
    """, (id,))
    reviews = cur.fetchall()
    
    for review in reviews:
        # Read from DB (persistent), fall back to in-memory cache
        if review.get('ai_sentiment'):
            review['ai_analysis'] = {
                'sentiment': review['ai_sentiment'],
                'status': review.get('ai_status', 'ACCEPTED')
            }
        elif review['booking_id'] in app.config['review_sentiments']:
            review['ai_analysis'] = app.config['review_sentiments'][review['booking_id']]
        else:
            review['ai_analysis'] = None
    
    # Fetch Booked Dates to disable them in UI
    cur.execute("""
        SELECT check_in, check_out FROM Bookings 
        WHERE property_id = %s AND status IN ('confirmed', 'completed')
        AND check_out >= CURDATE()
    """, (id,))
    booked_dates = cur.fetchall()
    
    cur.close()
    db.close()
    return render_template('property.html', property=prop, photos=photos, amenities=amenities, reviews=reviews, booked_dates=booked_dates)


@app.route('/book/<int:id>', methods=['POST'])
@login_required() # Allow both guests and hosts (and admins)
def book_property(id):
    check_in = request.form.get('check_in')
    check_out = request.form.get('check_out')
    guests = request.form.get('guests')
    
    db = get_db()
    cur = db.cursor(dictionary=True)
    
    cur.execute("SELECT base_price, cleaning_fee, host_id FROM Properties WHERE property_id = %s", (id,))
    prop = cur.fetchone()
    
    if prop['host_id'] == session['user_id']:
        flash('You cannot book your own property.', 'error')
        return redirect(url_for('property_detail', id=id))
    
    try:
        d1 = datetime.strptime(check_in, '%Y-%m-%d')
        d2 = datetime.strptime(check_out, '%Y-%m-%d')
        
        if d1.date() < datetime.now().date():
            flash('Cannot book a past date.', 'error')
            return redirect(url_for('property_detail', id=id))
            
        nights = (d2 - d1).days
        if nights <= 0:
            flash('Check-out date must be after check-in date.', 'error')
            return redirect(url_for('property_detail', id=id))
            
        # ─── OVERLAP CHECK ───
        cur.execute("""
            SELECT COUNT(*) as c FROM Bookings 
            WHERE property_id = %s 
              AND status IN ('confirmed', 'completed')
              AND NOT (%s >= check_out OR %s <= check_in)
        """, (id, check_in, check_out))
        if cur.fetchone()['c'] > 0:
            flash('The property is already booked for these dates. Please choose different dates.', 'error')
            return redirect(url_for('property_detail', id=id))
            
        total_price = float(prop['base_price'] * nights)
        
        cur.execute("""
            INSERT INTO Bookings (property_id, guest_id, check_in, check_out, guest_count, total_price, status)
            VALUES (%s, %s, %s, %s, %s, %s, 'pending')
        """, (id, session['user_id'], check_in, check_out, guests, total_price))
        db.commit()
        flash('Booking successfully created!', 'success')
    except Exception as e:
        flash(f'An error occurred: {e}', 'error')
        
    cur.close()
    db.close()
    
    return redirect(url_for('my_bookings'))

@app.route('/my-bookings')
@login_required() # Removed role='guest' because Admins should see their bookings too
def my_bookings():
    db = get_db()
    cur = db.cursor(dictionary=True)
    cur.execute("""
        SELECT b.*, p.title, p.city, p.district, p.base_price,
               (SELECT image_url FROM PropertyPhotos WHERE property_id = p.property_id AND is_primary = 1 LIMIT 1) as primary_image,
               pay.payment_status, pay.payment_id,
               rev.rating as my_rating, rev.comment as my_comment
        FROM Bookings b
        JOIN Properties p ON b.property_id = p.property_id
        LEFT JOIN Payments pay ON b.booking_id = pay.booking_id
        LEFT JOIN Reviews rev ON b.booking_id = rev.booking_id
        WHERE b.guest_id = %s
        ORDER BY b.check_in DESC
    """, (session['user_id'],))
    bookings = cur.fetchall()
    
    # Fetch all booked dates for all properties the user has bookings with 
    # (to support the same smart takvim in "Manage Stay")
    property_booked_dates = {}
    if bookings:
        prop_ids = list(set([b['property_id'] for b in bookings]))
        for pid in prop_ids:
            cur.execute("""
                SELECT check_in, check_out FROM Bookings 
                WHERE property_id = %s AND status IN ('confirmed', 'completed')
                AND check_out >= CURDATE()
            """, (pid,))
            property_booked_dates[pid] = cur.fetchall()

    cur.close()
    db.close()
    from datetime import datetime
    today = datetime.now().strftime('%Y-%m-%d')
    return render_template('my_bookings.html', bookings=bookings, today=today, property_booked_dates=property_booked_dates)

@app.route('/checkout/<int:booking_id>', methods=['GET', 'POST'])
@login_required()
def checkout(booking_id):
    db = get_db()
    cur = db.cursor(dictionary=True)
    
    if request.method == 'POST':
        method = request.form.get('payment_method')
        amount = request.form.get('amount')
        card_id = request.form.get('selected_card_id')
        save_card = request.form.get('save_card') == 'on'
        
        # If new card details provided and save_card is checked
        if not card_id or card_id == 'new':
            card_number = request.form.get('card_number')
            card_holder = request.form.get('card_holder')
            expiry = request.form.get('expiry')
            
            if save_card and card_number:
                # Mask card number
                masked = "**** **** **** " + card_number[-4:]
                cur.execute("INSERT INTO UserCards (user_id, card_holder, card_number_masked, expiry_date) VALUES (%s, %s, %s, %s)", 
                           (session['user_id'], card_holder, masked, expiry))
        
        cur.execute("""
            INSERT INTO Payments (booking_id, amount, payment_method, payment_status, transaction_ref)
            VALUES (%s, %s, %s, 'completed', %s)
        """, (booking_id, amount, method, 'TRANS-' + str(booking_id)))
        
        # Update booking status to confirmed if it was confirmed (it should be confirmed to pay)
        # Actually it's already confirmed if host approved.
        
        db.commit()
        flash('Payment received successfully!', 'success')
        return redirect(url_for('my_bookings'))

    cur.execute("""
        SELECT b.*, p.title, p.base_price 
        FROM Bookings b
        JOIN Properties p ON b.property_id = p.property_id
        WHERE b.booking_id = %s AND b.guest_id = %s
    """, (booking_id, session['user_id']))
    booking = cur.fetchone()
    
    cur.execute("SELECT * FROM UserCards WHERE user_id = %s", (session['user_id'],))
    saved_cards = cur.fetchall()
    
    cur.close()
    db.close()
    
    if not booking:
        flash('Booking not found.', 'error')
        return redirect(url_for('my_bookings'))
        
    return render_template('checkout.html', booking=booking, saved_cards=saved_cards)

@app.route('/update-booking/<int:id>', methods=['POST'])
@login_required()
def update_booking(id):
    # Requirement: Change the date for a booking
    check_in = request.form.get('check_in')
    check_out = request.form.get('check_out')
    
    db = get_db()
    cur = db.cursor(dictionary=True)
    cur.execute("""
        SELECT b.status, p.payment_status 
        FROM Bookings b 
        LEFT JOIN Payments p ON b.booking_id = p.booking_id 
        WHERE b.booking_id = %s
    """, (id,))
    booking = cur.fetchone()
    
    if booking and booking['payment_status'] == 'completed':
        flash('Completed reservations cannot be updated.', 'error')
        cur.close()
        db.close()
        return redirect(url_for('my_bookings'))
        
    # Fetch property price to recalculate total
    cur.execute("""
        SELECT p.base_price FROM Properties p
        JOIN Bookings b ON p.property_id = b.property_id
        WHERE b.booking_id = %s
    """, (id,))
    prop = cur.fetchone()
    
    from datetime import datetime
    d1 = datetime.strptime(check_in, '%Y-%m-%d')
    d2 = datetime.strptime(check_out, '%Y-%m-%d')
    nights = (d2 - d1).days
    
    if nights <= 0:
        flash('Check-out date must be after check-in date.', 'error')
        cur.close()
        db.close()
        return redirect(url_for('my_bookings'))
        
    new_total = float(prop['base_price'] * nights)

    # Update dates and price
    cur.execute("""
        UPDATE Bookings SET check_in = %s, check_out = %s, total_price = %s
        WHERE booking_id = %s AND guest_id = %s AND status NOT IN ('completed', 'cancelled')
    """, (check_in, check_out, new_total, id, session['user_id']))
    db.commit()
    cur.close()
    db.close()
    flash('Your booking dates and total amount have been updated.', 'success')
    return redirect(url_for('my_bookings'))

@app.route('/manage-booking-guests/<int:id>', methods=['GET', 'POST'])
@login_required()
def manage_booking_guests(id):
    # Requirement: Track multiple guests (family info)
    db = get_db()
    cur = db.cursor(dictionary=True)
    
    # Verify booking status - only allow management for active bookings
    cur.execute("SELECT status FROM Bookings WHERE booking_id = %s AND guest_id = %s", (id, session['user_id']))
    booking = cur.fetchone()
    
    if not booking:
        flash('Booking not found.', 'error')
        return redirect(url_for('my_bookings'))
        
    if booking['status'] in ['completed', 'cancelled']:
        flash('Guest information cannot be edited for completed or cancelled bookings.', 'warning')
        return redirect(url_for('my_bookings'))

    if request.method == 'POST':
        full_name = request.form.get('full_name')
        rel = request.form.get('relationship')
        age = request.form.get('age')
        
        cur.execute("INSERT INTO BookingGuests (booking_id, full_name, relationship, age) VALUES (%s, %s, %s, %s)",
                   (id, full_name, rel, age))
        db.commit()
        flash('Guest information added.', 'success')
        
    cur.execute("SELECT * FROM BookingGuests WHERE booking_id = %s", (id,))
    guests = cur.fetchall()
    cur.close()
    db.close()
    return render_template('manage_booking_guests.html', guests=guests, booking_id=id)

@app.route('/cancel-booking/<int:id>', methods=['POST'])
@login_required() # Allow anyone with the booking
def cancel_booking(id):
    db = get_db()
    cur = db.cursor()
    # Can only cancel if currently confirmed or pending
    cur.execute("UPDATE Bookings SET status = 'cancelled' WHERE booking_id = %s AND guest_id = %s AND status NOT IN ('completed', 'cancelled')", (id, session['user_id']))
    
    # Check if there was a payment, if so mark as refunded
    cur.execute("UPDATE Payments SET payment_status = 'refunded' WHERE booking_id = %s AND payment_status = 'completed'", (id,))
    
    db.commit()
    cur.close()
    db.close()
    flash('Your booking has been cancelled and any payment refunded.', 'success')
    return redirect(url_for('my_bookings'))

@app.route('/delete-booking/<int:id>', methods=['POST'])
@login_required()
def delete_booking(id):
    db = get_db()
    cur = db.cursor()
    # Users can delete their past bookings from their view
    cur.execute("DELETE FROM Bookings WHERE booking_id = %s AND guest_id = %s", (id, session['user_id']))
    db.commit()
    cur.close()
    db.close()
    flash('Booking removed from your history.', 'success')
    return redirect(url_for('my_bookings'))

@app.route('/submit-review/<int:booking_id>', methods=['POST'])
@login_required()
def submit_review(booking_id):
    rating = request.form.get('rating')
    comment = request.form.get('comment')
    
    db = get_db()
    cur = db.cursor(dictionary=True)
    
    # Verify booking
    cur.execute("SELECT * FROM Bookings WHERE booking_id = %s AND guest_id = %s AND status = 'completed'", (booking_id, session['user_id']))
    booking = cur.fetchone()
    
    if booking:
        ai_result = process_review(comment)
        # Persist AI result in-memory cache AND database
        app.config['review_sentiments'][booking_id] = ai_result
        
        # Use INSERT ... ON DUPLICATE KEY UPDATE since booking_id is UNIQUE
        cur.execute("""
            INSERT INTO Reviews (booking_id, guest_id, property_id, rating, comment, ai_sentiment, ai_status)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
            ON DUPLICATE KEY UPDATE
                rating = VALUES(rating),
                comment = VALUES(comment),
                ai_sentiment = VALUES(ai_sentiment),
                ai_status = VALUES(ai_status)
        """, (booking_id, session['user_id'], booking['property_id'], rating, comment,
               ai_result['sentiment'], ai_result['status']))
        db.commit()
        
        if ai_result['status'] == 'REJECTED':
            flash('Yorumunuz uygunsuz dil içerdiği için reddedildi.', 'error')
        else:
            flash(f'Yorumunuz kaydedildi! Duygu analizi: {ai_result["sentiment"].capitalize()}.', 'success')
        
    cur.close()
    db.close()
    return redirect(url_for('my_bookings'))

@app.route('/host-reservations')
@login_required(role='host')
def host_reservations():
    db = get_db()
    cur = db.cursor(dictionary=True)
    cur.execute("""
        SELECT b.*, p.title, u.full_name as guest_name
        FROM Bookings b
        JOIN Properties p ON b.property_id = p.property_id
        JOIN Users u ON b.guest_id = u.user_id
        WHERE p.host_id = %s
        ORDER BY b.check_in DESC
    """, (session['user_id'],))
    reservations = cur.fetchall()
    cur.close()
    db.close()
    return render_template('host_reservations.html', reservations=reservations)

@app.route('/host-update-booking/<int:id>', methods=['POST'])
@login_required(role='host')
def host_update_booking(id):
    new_status = request.form.get('status') # 'confirmed' or 'cancelled'
    
    db = get_db()
    cur = db.cursor()
    # Ensure this booking belongs to a property owned by the current host
    cur.execute("""
        UPDATE Bookings b
        JOIN Properties p ON b.property_id = p.property_id
        SET b.status = %s
        WHERE b.booking_id = %s AND p.host_id = %s
    """, (new_status, id, session['user_id']))
    if new_status == 'cancelled':
        cur.execute("UPDATE Payments SET payment_status = 'refunded' WHERE booking_id = %s AND payment_status = 'completed'", (id,))
        
    db.commit()
    cur.close()
    db.close()
    
    status_text = "approved" if new_status == 'confirmed' else "rejected/cancelled"
    flash(f'Booking successfully {status_text}.', 'success')
    return redirect(url_for('host_reservations'))

@app.route('/host-properties')
@login_required(role='host')
def host_properties():
    db = get_db()
    cur = db.cursor(dictionary=True)
    cur.execute("""
        SELECT p.*, 
               (SELECT image_url FROM PropertyPhotos WHERE property_id = p.property_id AND is_primary = 1 LIMIT 1) as primary_image,
               (SELECT COUNT(*) FROM Bookings WHERE property_id = p.property_id) as total_bookings
        FROM Properties p
        WHERE p.host_id = %s
    """, (session['user_id'],))
    properties = cur.fetchall()
    cur.close()
    db.close()
    return render_template('host_properties.html', properties=properties)

import random

@app.route('/add-property', methods=['GET', 'POST'])
@login_required(role='host')
def add_property():
    db = get_db()
    cur = db.cursor(dictionary=True)
    
    if request.method == 'POST':
        title = request.form.get('title')
        description = request.form.get('description')
        city = request.form.get('city')
        district = request.form.get('district')
        base_price = request.form.get('base_price')
        property_type = request.form.get('property_type')
        max_guests = request.form.get('max_guests')
        
        # Insert New Property
        cur.execute("""
            INSERT INTO Properties (host_id, title, description, city, district, base_price, property_type, max_guests)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
        """, (session['user_id'], title, description, city, district, base_price, property_type, max_guests))
        
        property_id = cur.lastrowid
        
        # Pick a random default image from our pool
        demo_images = ['luxurious_villa_istanbul.png', 'cozy_studio_beach.png', 'loft_ext.png', 'villa_int_1.png', 'studio_int_1.png', 'loft_int_1.png']
        random_img = random.choice(demo_images)
        
        cur.execute("INSERT INTO PropertyPhotos (property_id, image_url, is_primary) VALUES (%s, %s, 1)", (property_id, random_img))
        
        db.commit()
        cur.close()
        db.close()
        flash('Your listing has been successfully created!', 'success')
        return redirect(url_for('host_properties'))
        
    cur.close()
    db.close()
    return render_template('add_property.html')

@app.route('/edit-property/<int:id>', methods=['GET', 'POST'])
@login_required(role='host')
def edit_property(id):
    db = get_db()
    cur = db.cursor(dictionary=True)
    
    if request.method == 'POST':
        title = request.form.get('title')
        description = request.form.get('description')
        base_price = request.form.get('base_price')
        selected_amenities = request.form.getlist('amenities')
        
        # 1. Update Property Details
        cur.execute("""
            UPDATE Properties 
            SET title = %s, description = %s, base_price = %s 
            WHERE property_id = %s AND host_id = %s
        """, (title, description, base_price, id, session['user_id']))
        
        # 2. Update Amenities (Sync process)
        # First remove all
        cur.execute("DELETE FROM PropertyAmenities WHERE property_id = %s", (id,))
        # Then add selected ones
        for am_id in selected_amenities:
            cur.execute("INSERT INTO PropertyAmenities (property_id, amenity_id) VALUES (%s, %s)", (id, am_id))
            
        db.commit()
        flash('Listing and amenities successfully updated.', 'success')
        return redirect(url_for('host_properties'))
        
    # GET: Fetch property, all amenities, and current amenities
    cur.execute("SELECT * FROM Properties WHERE property_id = %s AND host_id = %s", (id, session['user_id']))
    prop = cur.fetchone()
    
    if not prop:
        cur.close()
        db.close()
        flash('Listing not found.', 'error')
        return redirect(url_for('host_properties'))
        
    cur.execute("SELECT * FROM Amenities ORDER BY name")
    all_amenities = cur.fetchall()
    
    cur.execute("SELECT amenity_id FROM PropertyAmenities WHERE property_id = %s", (id,))
    current_amenity_ids = [row['amenity_id'] for row in cur.fetchall()]
    
    cur.close()
    db.close()
    return render_template('edit_property.html', property=prop, all_amenities=all_amenities, current_amenity_ids=current_amenity_ids)

@app.route('/manage-cards', methods=['GET', 'POST'])
@login_required()
def manage_cards():
    db = get_db()
    cur = db.cursor(dictionary=True)
    
    if request.method == 'POST':
        card_holder = request.form.get('card_holder')
        card_number = request.form.get('card_number')
        expiry = request.form.get('expiry')
        
        if card_number:
            masked = "**** **** **** " + card_number[-4:]
            cur.execute("INSERT INTO UserCards (user_id, card_holder, card_number_masked, expiry_date) VALUES (%s, %s, %s, %s)", 
                       (session['user_id'], card_holder, masked, expiry))
            db.commit()
            flash('New payment method added.', 'success')
            return redirect(url_for('manage_cards'))
            
    cur.execute("SELECT * FROM UserCards WHERE user_id = %s", (session['user_id'],))
    cards = cur.fetchall()
    cur.close()
    db.close()
    return render_template('manage_cards.html', cards=cards)

@app.route('/delete-card/<int:id>', methods=['POST'])
@login_required()
def delete_card(id):
    db = get_db()
    cur = db.cursor()
    cur.execute("DELETE FROM UserCards WHERE card_id = %s AND user_id = %s", (id, session['user_id']))
    db.commit()
    cur.close()
    db.close()
    flash('Payment method deleted.', 'success')
    return redirect(url_for('manage_cards'))

if __name__ == '__main__':
    app.run(debug=True, port=5000)
