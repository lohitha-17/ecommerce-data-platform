import os
import pandas as pd

from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import classification_report, confusion_matrix


# ----------------------------
# Step 5A: Load dataset safely
# ----------------------------
PROJECT_ROOT = os.path.dirname(os.path.dirname(__file__))

# If your folder is named "Data" (capital D), keep this.
# If you rename it to "data", change "Data" -> "data".
DATA_PATH = os.path.join(PROJECT_ROOT, "Data", "repeat_purchase_v1.csv")

df = pd.read_csv(DATA_PATH)

print("Loaded data:")
print(df.head())
print("\nShape:", df.shape)
print("\nDtypes:\n", df.dtypes)


# ---------------------------------------
# Step 5B: Define label and feature matrix
# ---------------------------------------
# Adjust these column names if your CSV uses different ones.
y = df["repeat_30d"]
X = df[["prior_orders_count", "days_since_prior_order"]]

print("\nX shape:", X.shape)
print("y shape:", y.shape)
print("\nLabel distribution:\n", y.value_counts())


# ---------------------------------------
# Step 5C: Train/test split (stratified)
# ---------------------------------------
X_train, X_test, y_train, y_test = train_test_split(
    X,
    y,
    test_size=0.2,
    random_state=42,
    stratify=y
)

print("\nTrain shape:", X_train.shape, y_train.shape)
print("Test shape:", X_test.shape, y_test.shape)


# ---------------------------------------------------------
# Step 5D: Baseline fix for class imbalance + threshold tuning
# ---------------------------------------------------------
# 1) class_weight="balanced" forces the model to care about class 1 (repeat_30d=1)
model = LogisticRegression(max_iter=1000, class_weight="balanced")
model.fit(X_train, y_train)

# 2) use probabilities and a custom threshold (instead of default 0.5)
y_prob = model.predict_proba(X_test)[:, 1]

threshold = 0.30  # try 0.30 first; we'll tune after you see results
y_pred = (y_prob >= threshold).astype(int)

print("\nConfusion Matrix (class_weight=balanced, threshold=0.30):")
print(confusion_matrix(y_test, y_pred))

print("\nClassification Report (class_weight=balanced, threshold=0.30):")
print(classification_report(y_test, y_pred))


# ----------------------------
# Extra: quick threshold sweep
# ----------------------------
# This helps you see how precision/recall trade off.
for t in [0.10, 0.20, 0.30, 0.40, 0.50]:
    pred_t = (y_prob >= t).astype(int)
    cm = confusion_matrix(y_test, pred_t)
    print(f"\nThreshold={t:.2f}  Confusion Matrix:\n{cm}")
