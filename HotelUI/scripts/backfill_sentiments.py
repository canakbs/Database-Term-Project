# -*- coding: utf-8 -*-
"""
backfill_sentiments.py
Mevcut tum yorumlara AI sentiment analizi uygular ve veritabanina kaydeder.
"""
import mysql.connector
import sys
import os

# Add parent dir to path to import ai_review
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from ai_review import process_review

DB_CONFIG = {
    'host': 'localhost',
    'user': 'root',
    'password': 'mysql1234',
    'database': 'airbnb_clone',
    'charset': 'utf8mb4'
}

def backfill():
    db = mysql.connector.connect(**DB_CONFIG)
    cur = db.cursor(dictionary=True)
    
    cur.execute("SELECT review_id, comment FROM Reviews WHERE ai_sentiment IS NULL OR ai_sentiment = ''")
    reviews = cur.fetchall()
    
    print(f"[INFO] {len(reviews)} reviews to process...")
    
    updated = 0
    for rev in reviews:
        comment = rev['comment'] or ''
        if not comment.strip():
            sentiment = 'NEUTRAL'
            status = 'ACCEPTED'
        else:
            try:
                result = process_review(comment)
                sentiment = result['sentiment']
                status = result['status']
            except Exception as e:
                print(f"[WARN] Review {rev['review_id']} error: {e}")
                sentiment = 'POSITIVE'
                status = 'ACCEPTED'
        
        cur.execute(
            "UPDATE Reviews SET ai_sentiment = %s, ai_status = %s WHERE review_id = %s",
            (sentiment, status, rev['review_id'])
        )
        updated += 1
        print(f"[OK] Review #{rev['review_id']}: {sentiment} / {status} — \"{comment[:60]}\"")
    
    db.commit()
    cur.close()
    db.close()
    print(f"\n[DONE] {updated} reviews updated with sentiment analysis.")

if __name__ == '__main__':
    backfill()
