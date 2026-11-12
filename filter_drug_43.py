"""Collect every row with PDE_DRUG_CD == 43 from the Part D event CSVs.

Reads all 2008_BSA_PartD_Events_PUF_*.csv files in "Unzipped Data" and writes
the matching rows (one header) to drug_43_events.csv next to this script.

Usage:
    python filter_drug_43.py
"""

import csv
from pathlib import Path

DRUG_CODE = "43"
COLUMN = "PDE_DRUG_CD"

ROOT = Path(__file__).resolve().parent
DATA_DIR = ROOT / "Unzipped Data"
OUTPUT = ROOT / f"drug_{DRUG_CODE}_events.csv"


def main():
    inputs = sorted(DATA_DIR.glob("2008_BSA_PartD_Events_PUF_*.csv"))
    if not inputs:
        raise SystemExit(f"No input CSVs found in {DATA_DIR}")

    header = None
    total = 0
    with OUTPUT.open("w", newline="", encoding="utf-8") as out:
        writer = csv.writer(out)
        for path in inputs:
            matched = 0
            with path.open(newline="", encoding="utf-8") as f:
                reader = csv.reader(f)
                file_header = next(reader)
                if header is None:
                    header = file_header
                    writer.writerow(header)
                elif file_header != header:
                    raise SystemExit(f"Column mismatch in {path.name}")
                idx = header.index(COLUMN)

                for row in reader:
                    if row[idx].strip() == DRUG_CODE:
                        writer.writerow(row)
                        matched += 1
            print(f"{path.name}: {matched:,} rows")
            total += matched

    print(f"Total: {total:,} rows written to {OUTPUT.name}")


if __name__ == "__main__":
    main()
