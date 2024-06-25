import csv


def setup_csv_writer(filename: str):
    file = open(f"./data/{filename}.csv", newline="", mode="w", encoding="utf-8")
    writer = csv.writer(file)
    return file, writer
