import os
import re
from transformers import AutoTokenizer, AutoModelForSequenceClassification, pipeline

# =========================
# MODEL CONFIG
# =========================
TOXIC_MODEL_NAME = "unitary/toxic-bert"
SENTIMENT_MODEL_NAME = "distilbert-base-uncased-finetuned-sst-2-english"

# Paths to save the models locally within the HotelUI module
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
MODELS_DIR = os.path.join(BASE_DIR, "models")
TOXIC_PATH = os.path.join(MODELS_DIR, "toxic_model")
SENTIMENT_PATH = os.path.join(MODELS_DIR, "sentiment_model")

# =========================
# MODEL DOWNLOAD / LOAD
# =========================
def load_or_download_model(model_name, path):
    if not os.path.exists(path):
        print(f"\n[INFO] Downloading model: {model_name}")
        tokenizer = AutoTokenizer.from_pretrained(model_name)
        model = AutoModelForSequenceClassification.from_pretrained(model_name)

        os.makedirs(path, exist_ok=True)
        tokenizer.save_pretrained(path)
        model.save_pretrained(path)

        print(f"[INFO] Model saved to {path}")
    else:
        print(f"[INFO] Loading model from local: {path}")

    return pipeline(
        "text-classification",
        model=path,
        tokenizer=path
    )


# =========================
# TEXT NORMALIZATION
# =========================
def normalize_text(text):
    text = text.lower()

    replacements = {
        "1": "i",
        "3": "e",
        "4": "a",
        "5": "s",
        "0": "o",
        "@": "a",
        "$": "s"
    }

    for old, new in replacements.items():
        text = text.replace(old, new)

    text = re.sub(r'[^a-zA-Z\s]', '', text)
    return text


# =========================
# LOAD MODELS
# =========================
# We load them at module level once when imported
print("\n=== INITIALIZING AI MODELS ===")
os.environ["TF_CPP_MIN_LOG_LEVEL"] = "3" # Suppress tf warnings if installed
toxic_model = load_or_download_model(TOXIC_MODEL_NAME, TOXIC_PATH)
sentiment_model = load_or_download_model(SENTIMENT_MODEL_NAME, SENTIMENT_PATH)
print("\n[INFO] All AI models ready.\n")


# =========================
# TOXIC CHECK
# =========================
def detect_toxicity(text):
    normalized = normalize_text(text)
    result = toxic_model(normalized)[0]

    label = result["label"]
    score = result["score"]

    is_toxic = label.lower() == "toxic" and score > 0.60

    return is_toxic, label, score


# =========================
# SENTIMENT CHECK
# =========================
# Thresholds for 3-class sentiment:
#   score >= 0.90  → confident POSITIVE or NEGATIVE
#   score <  0.90  → borderline confidence → NEUTRAL
# Based on DistilBERT SST-2 score distribution on hotel reviews:
#   Clear positives score 0.99+, clear negatives score 0.95+
#   Ambiguous/mixed reviews score 0.84-0.89 → classified as NEUTRAL
NEUTRAL_THRESHOLD = 0.90

def detect_sentiment(text):
    result = sentiment_model(text)[0]
    label = result["label"]   # 'POSITIVE' or 'NEGATIVE'
    score = result["score"]

    # If the model is not confident enough, classify as NEUTRAL
    if score < NEUTRAL_THRESHOLD:
        return "NEUTRAL", score

    return label, score


# =========================
# MAIN PIPELINE
# =========================
def process_review(text):
    is_toxic, tox_label, tox_score = detect_toxicity(text)

    if is_toxic:
        return {
            "status": "REJECTED",
            "reason": "Offensive language detected",
            "toxicity_score": round(tox_score, 3),
            "sentiment": "NEGATIVE",
            "sentiment_score": 0.0
        }

    sentiment_label, sentiment_score = detect_sentiment(text)

    return {
        "status": "APPROVED",
        "sentiment": sentiment_label,          # POSITIVE / NEUTRAL / NEGATIVE
        "sentiment_score": round(sentiment_score, 3),
        "reason": "Clean",
        "toxicity_score": round(tox_score, 3)
    }

if __name__ == '__main__':
    print("Testing 3-class sentiment pipeline...")
    tests = [
        ("This was an absolutely amazing stay, best vacation ever!", "→ expect POSITIVE"),
        ("Met our expectations, good value for money. Would consider staying again.", "→ expect NEUTRAL"),
        ("Overall nice but we had trouble with parking. Still reasonable.", "→ expect NEUTRAL"),
        ("Terrible place, dirty rooms, rude host, never coming back!", "→ expect NEGATIVE"),
        ("This host is a fucking idiot!", "→ expect REJECTED (toxic)"),
    ]
    for text, hint in tests:
        res = process_review(text)
        print(f"  {hint}  →  {res['sentiment']} ({res['status']}) score={res.get('sentiment_score')}")
        print(f"  Text: {text[:60]}")
        print()
