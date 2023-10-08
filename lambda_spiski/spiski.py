from flask import Flask, render_template, request
import csv
import awsgi


app = Flask(__name__)


def search(query):
    with open("db.csv", newline='') as db:
        reader = csv.DictReader(db)
        results = list(filter(lambda row: row["short"] == query.lower().strip(), list(reader)))
        return results, reader.line_num


@app.route('/')
def main():
    query = request.args['q'] if 'q' in request.args else ''
    results, db_size = search(query)
    data = {"name": query, "results": results, "size": db_size}
    return render_template("index.html", data=data)


def lambda_handler(event, context):
    return awsgi.response(app, event, context, base64_content_types={"image/png"})


if __name__ == '__main__':
    app.run()
