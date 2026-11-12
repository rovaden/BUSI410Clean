"""Replace the numeric codes in drug_43_events.csv with readable labels.

Lookups for drug name, strength, strength units, dose form and drug class come
from the CMS tables in "Data Details". The small fixed code sets (gender, age,
days supply, patient pay, drug type) come from the formats in
"Data Details/BSA_PartD_Events_PUF_2008.sas" and the PUF documentation.

Quantity dispensed and total drug cost are real amounts, not codes, so they
stay numeric.

Writes drug_43_events_decoded.csv next to this script.

Usage:
    python decode_drug_43.py
"""

import csv
from pathlib import Path

ROOT = Path(__file__).resolve().parent
DETAILS_DIR = ROOT / "Data Details"
INPUT = ROOT / "drug_43_events.csv"
OUTPUT = ROOT / "drug_43_events_decoded.csv"

UNKNOWN = "Unknown"

# Fixed code sets (from the SAS formats and PUF documentation).
GENDER = {"1": "Male", "2": "Female"}

AGE = {
    "1": "Under 65",
    "2": "65-69",
    "3": "70-74",
    "4": "75-79",
    "5": "80-84",
    "6": "85 and older",
}

DAYS_SUPPLY = {
    "1": "1-7 days",
    "2": "8-14 days",
    "3": "15-21 days",
    "4": "22-29 days",
    "5": "30-59 days",
    "6": "60-89 days",
    "7": "90 or more days",
}

PATIENT_PAY = {
    "1": "Paid $0 (0% of cost)",
    "2": "Partial payment (between 0% and 100% of cost)",
    "3": "Paid full cost (100% of cost)",
}

DRUG_TYPE = {"0": "Unknown", "1": "Brand name", "2": "Generic"}


def load_table(filename):
    """Read a two-column CMS lookup table into {code: label}."""
    with (DETAILS_DIR / filename).open(newline="", encoding="utf-8") as f:
        reader = csv.reader(f)
        next(reader)  # header
        return {code.strip(): label.strip() or UNKNOWN for code, label in reader}


# (input column, output column, lookup). Columns not listed are copied as-is.
COLUMNS = [
    ("PDE_EVENT_ID", "PDE_EVENT_ID", None),
    ("BENE_SEX_IDENT_CD", "GENDER", GENDER),
    ("BENE_AGE_CAT_CD", "AGE_GROUP", AGE),
    ("PDE_DRUG_CD", "DRUG_NAME", load_table("DRUG_NAME_TABLE.csv")),
    ("PDE_DRUG_STR_CD", "DRUG_STRENGTH", load_table("DRUG_STRENGTH_TABLE.csv")),
    ("PDE_DRUG_STR_UNITS_CD", "DRUG_STRENGTH_UNITS", load_table("DRUG_STRENGTH_UNITS_TABLE.csv")),
    ("PDE_DRUG_DOSE_CD", "DOSE_FORM", load_table("DRUG_DOSEFORM_TABLE.csv")),
    ("PDE_DRUG_CLASS_CD", "DRUG_CLASS", load_table("DRUG_CLASS_TABLE.csv")),
    ("PDE_DRUG_QTY_DIS", "QUANTITY_DISPENSED", None),
    ("PDE_DRUG_DAY_SPLY_CD", "DAYS_SUPPLY", DAYS_SUPPLY),
    ("PDE_DRUG_COST", "TOTAL_DRUG_COST", None),
    ("PDE_DRUG_PAT_PAY_CD", "PATIENT_PAYMENT", PATIENT_PAY),
    ("PDE_DRUG_TYPE_CD", "DRUG_TYPE", DRUG_TYPE),
]


def main():
    unmatched = {}
    rows = 0

    with INPUT.open(newline="", encoding="utf-8") as f_in, \
            OUTPUT.open("w", newline="", encoding="utf-8") as f_out:
        reader = csv.DictReader(f_in)
        missing = [c for c, _, _ in COLUMNS if c not in reader.fieldnames]
        if missing:
            raise SystemExit(f"Missing columns in {INPUT.name}: {missing}")

        writer = csv.writer(f_out)
        writer.writerow([out for _, out, _ in COLUMNS])

        for row in reader:
            decoded = []
            for col, _, lookup in COLUMNS:
                value = row[col].strip()
                if lookup is not None:
                    if value in lookup:
                        value = lookup[value]
                    else:
                        unmatched.setdefault(col, set()).add(value)
                        value = f"{UNKNOWN} (code {value})"
                decoded.append(value)
            writer.writerow(decoded)
            rows += 1

    print(f"{rows:,} rows written to {OUTPUT.name}")
    for col, codes in unmatched.items():
        print(f"Warning: {col} had codes with no label: {sorted(codes)}")


if __name__ == "__main__":
    main()
