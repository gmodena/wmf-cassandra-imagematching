import pandas as pd
import sys

header = [
    "page_id",
    "page_title",
    "image_id",
    "confidence_rating",
    "source",
    "dataset_id",
    "creation_time",
    "wiki",
    "found_on",
]

percentiles = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 0.95, 0.99]
cols = ["page_title", "image_id", "found_on"]

if __name__ == "__main__":
    dataset_path = "imagerec_prod/matches.tsv"
    if len(sys.argv) == 2:
        dataset_path = sys.argv[1]
    df = pd.read_csv(dataset_path, sep="\t", error_bad_lines=False, names=header)

    for col in cols:
        print(
            df[col]
            .map(lambda x: len(str(x)))
            .describe(percentiles=percentiles)
            .astype(int)
        )
