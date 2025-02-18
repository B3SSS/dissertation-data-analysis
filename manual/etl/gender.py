import clickhouse_connect
import psycopg2

postgres_client = psycopg2.connect(
    host="192.168.157.166",
    port="5432",
    database="postgres",
    user="postgres",
    password="1234")
print(f"Connect to Postgres Server: {bool(postgres_client.status)}")

cursor = postgres_client.cursor()
cursor.execute("""
    SELECT dc.gender, COUNT(*)
    FROM Dim_Citizen AS dc
        JOIN Fact_Patient AS fp ON dc.citizenId = fp.patientId
        JOIN Dim_Disease AS dd ON dd.diseaseId = fp.diseaseId
    WHERE dd.diseaseName = 'COVID-19'
    GROUP BY 1
    ORDER BY 1;""")

data = cursor.fetchall()

clickhouse_client = clickhouse_connect.get_client(
    host="192.168.157.167",
    port=8123,
    username="default",
    password="",
    database="analytics")
print(f"Connect to ClickHouse Server: {clickhouse_client.ping()}")

clickhouse_client.insert("aggregation_gender", data=data, column_names=["gender", "quantity"])