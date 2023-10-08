import boto3
import json
import os
import gspread
import csv


def lambda_handler(event, context):
    bucket_name = os.environ.get('BUCKET_NAME')
    json_file_key = os.environ.get('JSON_FILE_KEY')
    filename = "db.csv"
    gc = gspread.service_account(filename="service_account.json")
    sh = gc.open_by_key("1BcRguk-2-oczkrBZVcfN93eDnaMjAxTu5BJMJ2wyDn0")

    with open(filename, 'w', newline='') as f:
        for ws in sh.worksheets():
            writer = csv.writer(f)
            rows = ws.get_values()
            if len(rows) < 1:
                continue
            # rows = rows[1:]
            for row in rows:
                if row[0] == "":
                    continue
                row[0] = row[1].split(" ")[0]
                writer.writerow(row)
            print(ws)
            print(len(rows))
            # print(rows[-1])

    # with open(filename, newline='') as input:
    #     with open("db_sorted.csv", 'w', newline='') as output:
    #         reader = csv.reader(input)
    #         reader = sorted(reader, key=lambda row: row[0], reverse=False)
    #         writer = csv.writer(output)
    #         for row in reader:
    #             row[0] = row[0].lower()
    #             writer.writerow(row)
    #




    # with open(filename, 'w', newline='') as f:

    # s3 = boto3.client('s3')
    # empty_json_data = {"File": "Content",
    #                    "Some": "Key"}
    #
    # s3.put_object(
    #     Bucket=bucket_name,
    #     Key=json_file_key,
    #     Body=json.dumps(empty_json_data),
    #     ContentType='application/json'
    # )

    return {
        'statusCode': 200,
        'body': json.dumps('Empty JSON file created successfully!')
    }


if __name__ == "__main__":
    lambda_handler([], [])
