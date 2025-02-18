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
    SELECT dss.signSymptom, COUNT(*)
    FROM Dim_Citizen AS dc
        JOIN Fact_PatientSignSymptom AS fpss ON dc.citizenId = fpss.patientId
        JOIN Dim_SignSymptom AS dss ON fpss.signSymptomId = dss.signSymptomId
    GROUP BY 1;
""")
data = cursor.fetchall()
print(f"{data}")

clickhouse_client = clickhouse_connect.get_client(
    host="192.168.157.167",
    port=8123,
    username="default",
    password="",
    database="analytics")
print(f"Connect to ClickHouse Server: {clickhouse_client.ping()}")

clickhouse_client.insert("aggregation_sign_symptom", data=data, column_names=["symptom", "quantity"])